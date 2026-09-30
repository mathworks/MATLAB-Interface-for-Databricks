#!/bin/bash
#
# MATLAB runtime installation Databricks init script
#
#   *********************************************************************
#   * The use of init script based MATLAB runtime clusters is no longer *
#   * recommended. Docker images are preferred and are required in the  *
#   * following cases:                                                  *
#   *   * When using Databricks runtime 17 and greater                  *
#   *   * On clusters without internet access                           *
#   *   * When using compiled Simulink on clusters without internet     *
#   *     access.                                                       *
#   *                                                                   *
#   * The MATLAB runtime and desktop docker files can be found in the   *
#   * MATLAB on Databricks Reference Architecture repository:           *
#   *   https://github.com/mathworks-ref-arch/matlab-on-databricks      *
#   *                                                                   *
#   *********************************************************************
#
# The script requires that two environment variables are defined, e.g:
#   MW_RUNTIME_ZIP=/Volumes/mycatalog/myschema/myvolume/MathWorks/Runtimes/MATLAB_Runtime_R2024a_Update_5_glnxa64.zip
#
#   LD_LIBRARY_PATH=/MATLAB_Runtime/runtime/glnxa64:
#                   /MATLAB_Runtime/bin/glnxa64:
#                   /MATLAB_Runtime/sys/os/glnxa64:
#                   /MATLAB_Runtime/extern/bin/glnxa64:
#                   /MATLAB_Runtime/sys/opengl/lib/glnxa64
#
# MW_RUNTIME_ZIP provides the path or HTTP url from which to copy the .zip form of
# the MATLAB runtime. Download locations for the runtime .zip file can be specified
# as a POSIX style path corresponding to the volume or a HTTP(S) URL.
#
# The version of the MATLAB runtime used MUST match the version of MATLAB used
# to compile MATLAB code to be executed on a Databricks cluster as a library.
#
# MATLAB runtimes can be downloaded from:
#    https://www.mathworks.com/products/compiler/matlab-runtime.html
# Note that only the Linux version can be used on a Databricks cluster
# For supported versions see: Documentation/SupportMatrix.md
#
# If the installation otherwise fails a non zero value is returned which will be
# interpreted by Databricks as a failure to initialize the cluster.
#
# If init scripts are not the preferred way to provision a MATLAB enabled cluster,
# Docker can be used see: Documentation/DockerRuntimes.md
# See also: Documentation/InitScripts.md
#
# The runtime .zip file is large, > 4GB, and should be located in a cloud storage
# environment that is fast and close to the cluster deployment location. Otherwise
# cluster deployment will be slow and can timeout.
#
# Invocation of this script to install a runtime assumes agreement to the terms
# of the runtime's license.
#
# See also: https://docs.databricks.com/en/init-scripts/index.html
#
# (c) 2021-2026 The MathWorks, Inc.
#
# Last updated in version 6.1.9
#
#--------------------------------------------------------------------------

function offlineLibInstall () {
  # Install a deb from a the same /Volumes path as is used for the runtime zip
  # Assumes that <lib name>*.deb will match the stored .deb

  DEBIAN_FRONTEND="noninteractive" # Stops apt asking interactive questions

  MW_RUNTIME_ZIP="${1}"
  LIBNAME="${2}"
  
  if [[ ${#MW_RUNTIME_ZIP} -eq 0 ]]; then
    echo "Runtime zip path is not set." >&2
    return 1
  fi

  if [[ ${#LIBNAME} -eq 0 ]]; then
    echo "Library name is not set." >&2
    return 1
  fi

  # If the is no /Volumes path for the zip file the there is nowhere to get the .deb
  # from so error - a custom init script is likely to be required
  if [[ "$MW_RUNTIME_ZIP" == http* ]]; then
    echo "HTTP based zip file, no /Volumes directory available, library installation not supported." >&2
    return 1
  fi

  # Get the /Volumes path from the runtime .zip file path
  ZIPDIR="$(dirname ${MW_RUNTIME_ZIP})"
  
  # If there is more than one .deb sorting may be an issue pick the first one and warn
  # If there is none error
  FILES=(${ZIPDIR}/deps/${LIBNAME}*.deb)
  
  if [ ${#FILES[@]} -lt 1 ]; then
    echo "No .deb file found for: ${LIBNAME} in: ${ZIPDIR}" >&2
    return 1
  fi
  DEBFILE="${FILES[0]}"
  if [ ${#FILES[@]} -gt 1 ]; then
    echo "More than one .deb file found for: ${LIBNAME} in: ${ZIPDIR}, using: ${DEBFILE}"
  fi

  # Install the file from the local path
  echo "Installing: ${DEBFILE}" 
  apt-get install -y "${DEBFILE}"
  APTRETURN=$?

  if [ "$APTRETURN" -ne 0 ]; then
    echo "apt-get install failed for: ${DEBFILE}" >&2
    return "$APTRETURN"
  else
    echo "Installed: ${DEBFILE}"
    return 0 
  fi
}

function R2025aV16Deps () {
  echo "Downloading & installing MATLAB runtime R2025a dependencies"
  curl -Lo /tmp/deps.txt "https://raw.githubusercontent.com/mathworks-ref-arch/container-images/refs/heads/main/matlab-runtime-deps/r2025a/ubuntu24.04/base-dependencies.txt" && \
    apt-get update && \
    apt-get install --no-install-recommends -y `cat /tmp/deps.txt` && \
    rm -rf /var/lib/apt/lists/*
  DEPSRETURN=$?
  
  if [ "$DEPSRETURN" -ne 0 ]; then
    echo "MATLAB dependencies apt-get install failed for R2025a & DBR 16.x" >&2
    echo "Migrate from init scripts to docker for full support" >&2
    echo "See: Documentation/ContainerServices.md & https://github.com/mathworks-ref-arch/matlab-on-databricks" >&2
    return "$DEPSRETURN"
  else
    echo "Installed dependencies for R2025a & DBR 16.x"
    return 0 
  fi
}

# Install the MATLAB Runtime using the silent installation method
echo "MATLAB runtime installation"
echo "==========================="

echo "Reporting environment:"
printenv | sort | sed "s/token=.*$/token=<REDACTED>/"

echo "    MW_RUNTIME_ZIP: $MW_RUNTIME_ZIP"
if [[ $MW_RUNTIME_ZIP =~ *glnxa64.zip ]]; then
    echo "Warning, runtime .zip filename does not end with the expected glnxa64.zip value" >&2
fi

# By default do not accept the runtime(s) license(s) this may be updated to yes
# during the installation process prior to uploading to Databricks
agreeToLicense=yes
echo "    agreeToLicense: $agreeToLicense"

unset LD_LIBRARY_PATH
export MW_CONNECTOR_CONNECTION_PROFILES=noop

# From 17 onwards docker is required for the runtime
if [[ $DATABRICKS_RUNTIME_VERSION == 17* ]] || [[ $DATABRICKS_RUNTIME_VERSION == 18* ]]; then
  echo "Databricks runtime 17.x and later is not supported using init scripts, use a Docker image instead: $DATABRICKS_RUNTIME_VERSION" >&2
  echo "See: Documentation/ContainerServices.md & https://github.com/mathworks-ref-arch/matlab-on-databricks" >&2
  exit 17
fi

if [ -z ${MW_RUNTIME_RELEASE+x} ]; then
  echo "MW_RUNTIME_RELEASE is not set as a Spark environment variable" >&2
else
  if [[ $MW_RUNTIME_RELEASE == "R2025a" || $MW_RUNTIME_RELEASE == "R2025b" ]] && [[ $DATABRICKS_RUNTIME_VERSION == 16* ]]; then
    R2025aV16Deps
    DEPSRETURN=$?
    if [[ DEPSRETURN -ne 0 ]]; then
      echo "Currently MATLAB R2025a and Databricks Runtimes 16.x require the" >&2
      echo "Installation of additional dependencies from the internet using apt-get." >&2
      echo "This step has failed, most probably because of restricted internet access." >&2
      echo "Starting the cluster from Docker a prebuilt Docker image is an alternative" >&2
      echo "approach which can be used instead of an init script." >&2
      echo "See: Documentation/ContainerServices.md & https://github.com/mathworks-ref-arch/matlab-on-databricks" >&2
      exit $DEPSRETURN
    fi
  fi
fi

# First install libgbm1 and libnss3, which are needed for Simulink Compiler
DEBIAN_FRONTEND="noninteractive" # Stops apt asking interactive questions
apt-get update -q -o APT::Update::Error-Mode=any -o Dir::Etc::SourceParts=/tmp/nonexistantDir
if [[ $? -ne 0 ]]; then
    echo "Error apt-get update failed, check internet access" >&2
    echo "libgbm1 libnss3 cannot be automatically installed" >&2
    echo "These libraries are required by compiled Simulink code" >&2
    echo "See Documentation/InitScripts.md for details" >&2
    echo "Attempting installation from interface directory" >&2
    
    offlineLibInstall $MW_RUNTIME_ZIP libgbm1
    INSTALLRETURN=$?
    if [[ INSTALLRETURN -ne 0 ]]; then
      echo "libgbm1 offline install failed, compiled Simulink will not be support on this cluster"
      echo "Migrate from init scripts to docker for full support"
      echo "See: Documentation/ContainerServices.md & https://github.com/mathworks-ref-arch/matlab-on-databricks"
      # Prevent the failure to allow MATLAB, the only robust approach is migration
      #  to docker from this point on.
      # exit $INSTALLRETURN
    else
      echo "libgbm1 offline install complete"
    fi

    offlineLibInstall $MW_RUNTIME_ZIP libnss3
    INSTALLRETURN=$?
    if [[ INSTALLRETURN -ne 0 ]]; then
      echo "libnss3 offline install failed, compiled Simulink will not be support on this cluster"
      echo "Migrate from init scripts to docker for full support"
      echo "See: Documentation/ContainerServices.md & https://github.com/mathworks-ref-arch/matlab-on-databricks"
      # Prevent the failure to allow MATLAB, the only robust approach is migration
      #  to docker from this point on.
      # exit $INSTALLRETURN
    else
      echo "libnss3 offline install complete"
    fi
else
    apt-get -q install -y libgbm1
    if [[ $? -ne 0 ]]; then
        echo "Could not install libgbm1" >&2
        echo "This library is required by the MATLAB runtime" >&2
        echo "See Documentation/InitScripts.md for details" >&2
    fi
    apt-get -q install -y libnss3
    if [[ $? -ne 0 ]]; then
        echo "Could not install libnss3" >&2
        echo "This library is required by the MATLAB runtime" >&2
        echo "See Documentation/InitScripts.md for details" >&2
    fi
fi

# Print the type of the node
if [[ $DB_IS_DRIVER == "TRUE" ]]; then
    echo "Running on Driver node"
else
    echo "Running on Worker node"
fi

# If the zip location string is a http url
# Split based on a ? e.g. to strip off a SAS after the file
# Get the zeroth field, i.e. the file part of the url
# Use basename to extract the file from that
# Build a destination path and download with curl to that
if [[ "$MW_RUNTIME_ZIP" == http* ]]; then
    IFS='?'
    read -a STRARRAY <<< "$MW_RUNTIME_ZIP"
    BASEURL="${STRARRAY[0]}"
    RUNTIMEFILE=$(basename $BASEURL)
    RUNTIMEPATH=/tmp/${RUNTIMEFILE}
    curl -o /tmp/matlab_runtime.zip "${MW_RUNTIME_ZIP}"
else
    # MW_RUNTIME_ZIP is location of where the zip file can be found
    cp ${MW_RUNTIME_ZIP} /tmp/matlab_runtime.zip
fi
CPRETURN=$?;
if [ "$CPRETURN" -ne 0 ]; then
  echo "Copy of MATLAB runtime failed, returned: ${CPRETURN}" >&2
  exit "$CPRETURN"
fi 

# Unzip to a clean temporary location
echo "Unzipping runtime"
unzip -q  /tmp/matlab_runtime.zip -d /tmp/MATLAB_installer
ZIPRETURN=$?;
if [ "$ZIPRETURN" -ne 0 ]; then
  echo "unzip of MATLAB runtime failed, returned: ${ZIPRETURN}" >&2
  exit "$ZIPRETURN"
fi
echo "Deleting /tmp/matlab_runtime.zip"
rm /tmp/matlab_runtime.zip

# Install the MATLAB Runtime
echo "Installing runtime"
sudo /tmp/MATLAB_installer/install -mode silent -agreeToLicense ${agreeToLicense} -destinationFolder /MATLAB_Runtime_tmp
INSTALLRETURN=$?
if [ "$INSTALLRETURN" -ne 0 ]; then
  echo "Install of MATLAB runtime failed, returned: ${INSTALLRETURN}" >&2
  exit "$INSTALLRETURN"
fi
echo "MATLAB runtime installation complete"

# Clean up
echo "Removing runtime installer"
rm -rf /tmp/MATLAB_installer
RMRETURN=$?;
if [ "$RMRETURN" -ne 0 ]; then
  echo "Removal of runtime installer failed, returned: ${RMRETURN}" >&2
  exit "$RMRETURN"
fi

# Report the version actually installed
RUNTIME_VERSION=$(ls /MATLAB_Runtime_tmp/);
echo "MATLAB Runtime Release: ${RUNTIME_VERSION}"
mv /MATLAB_Runtime_tmp/${RUNTIME_VERSION} /MATLAB_Runtime

# Report the version configured in the MW_RUNTIME_RELEASE variable
if [ -z ${MW_RUNTIME_RELEASE+x} ]; then
  echo "MW_RUNTIME_RELEASE is not set as a Spark environment variable" >&2
else
  echo "MW_RUNTIME_RELEASE: ${MW_RUNTIME_RELEASE}"
fi

# Flag to stderr if they do not match
if [[ "$RUNTIME_VERSION" != "$MW_RUNTIME_RELEASE" ]]; then
  echo "The MATLAB runtime version deployed on the cluster does not match the value of MW_RUNTIME_RELEASE variable" >&2
else
  echo "Installed MATLAB runtime and MW_RUNTIME_RELEASE match"
fi

echo "Deleting libstdc++ .so - required by Databricks ML runtimes"
rm /MATLAB_Runtime/sys/os/glnxa64/libstdc++.so.6
# R2024b libstdc++.so.6.0.30
# R2022b-R2024a libstdc++.so.6.0.28
rm /MATLAB_Runtime/sys/os/glnxa64/libstdc++.so.6.0.*

exit 0 # Exit cleanly
