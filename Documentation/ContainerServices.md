# Using Databricks Container Services / Docker

## MATLAB Runtime using Docker

To execute compiled MATLAB code on a Databricks&reg; cluster the MATLAB runtime corresponding
to the version of the MATLAB&reg; Compiler SDK&trade; used to create the `.whl` file containing
the compiled code must be installed on the cluster. Installing the MATLAB Runtime on a
cluster can be done in two ways:

* Using an [`init` script](InitScripts.md), which is a Bash script that installs
the appropriate MATLAB runtime version during the creation of a cluster. Using
docker rather than init scripts is strongly the recommended approach and is required
in some circumstances, e.g. Databricks runtimes 17 and greater and clusters without
internet access.

* A docker image can be created to initialize cluster nodes. The use of docker
is is described in the MATLAB on Databricks Reference Architecture see:

  * [Installing MATLAB Runtime guide](https://github.com/mathworks-ref-arch/matlab-on-databricks/blob/main/guides/PSP%20docs/InstallMATLABRuntime.md)
  * [MATLAB Runtime docker file](https://github.com/mathworks-ref-arch/matlab-on-databricks/tree/main/resources/dockerfiles/runtime)

For more details on using Databricks Container Services see: [https://docs.databricks.com/en/compute/custom-containers.html](https://docs.databricks.com/en/compute/custom-containers.html).

For more details on the MATLAB runtime see: [https://www.mathworks.com/products/compiler/matlab-runtime.html](https://www.mathworks.com/products/compiler/matlab-runtime.html).

## Building Dockerfile variants

It may be required to have a number of Docker&reg; images for different combinations of
the MATLAB and Databricks runtimes. The function `Software/MATLABDocker/Runtime/generateBuildscript.m`
can be used to generate a build script for multiple images that supports local docker
builds (default) and Azure&reg; Container Registry based builds.

In the azure case this uses the Azure CLI to build the images remotely on Azure.
Thus avoiding locally storing and transferring a potentially large number of relatively
big images. Note the `nowait` optional argument can be used to allow the build to
proceed in the background on Azure. Testing with a sample file is recommended first.

For example the resulting Azure script will consist of repeating Azure CLI commands similar to:

```bash
# Build docker image for MATLAB R2025b and Databricks 17.3
az acr build \
    --registry $REPO \
    --image "matlab/databricks/runtime:r2025b-dbx17.3" \
    --build-arg MATLAB_RELEASE=R2025b \
    --build-arg DATABRICKS_RUNTIME_VERSION="17.3" \
    --build-arg MATLAB_DEPS_URL="https://raw.githubusercontent.com/mathworks-ref-arch/container-images/refs/heads/main/matlab-runtime-deps/r2025b/ubuntu24.04/base-dependencies.txt" \
    --build-arg MATLAB_RUNTIME_URL="https://ssd.mathworks.com/supportfiles/downloads/R2025b/Release/3/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2025b_Update_3_glnxa64.zip" \
    --build-arg UBUNTU_VERSION="24.04" \
    -f Dockerfile .
```

Building all possible images will take quite some time and not all may be required
based on an organization's MATLAB and Databricks version usage policy.
Comment out unneeded combinations or adjust the input arguments.

> The Dockerfiles should be periodically regenerated to along with the resulting
> images to receive updated MATLAB & Databricks runtimes.

## Using an existing image with Azure Container Registry (ACR)

The following commands show how an image can be pulled locally, verified, tagged
and then pushed to ACR using the Azure `az` CLI tool and `docker`.
The ACR repository should be in the same Azure region as the Databricks
Workspace which will use the image(s).

```bash
# Log into a repo named myacrrepo
az acr login -n myacrrepo

# Pull the required image locally
myregistry.mathworks.com/matlab/databricks/runtime:r2025b-dbx17.3
docker pull myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3

# Start the image locally for optional sanity checking or testing
docker run -it --rm myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3

# Tag the image
docker tag myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3 myacrrepo.azurecr.io/matlab/databricks/runtime:r2025b-dbx17.3

# Push the image to myacrrepo.azurecr.io
docker push myacrrepo.azurecr.io/matlab/databricks/runtime:r2025b-dbx17.3
```

## Using an existing image with AWS

The following commands show how an image can be pulled locally, verified, tagged
and then pushed to an AWS&reg; Elastic Container Registry (ECR) using the
AWS `aws` CLI tool and `docker`.
The ECR repository should be in the same AWS region as the Databricks
Workspace which will use the image(s).

```bash
# First, ensure AWS credentials stored in the ~/.aws/credentials file are current.

# Make a variable for the registry
export DOCKER_REGISTRY=<REDACTED>.dkr.ecr.<aws-region>.amazonaws.com

# Login to the registry
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $DOCKER_REGISTRY

# Pull the required image locally
docker pull  myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3

# Start the image locally for optional sanity checking or testing
docker run -it --rm myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3

# Tag the image
docker tag myregistry.example.com/matlab/databricks/runtime:r2025b-dbx17.3 $DOCKER_REGISTRY/matlab/databricks/runtime:r2025b-dbx17.3

# Push the image to repository
docker push $DOCKER_REGISTRY/matlab/databricks/runtime:r2025b-dbx17.3
```

### Repository permissions

The repository that was created for this example, was given the following permissions to allow
for pushing and pulling images. Please consult with local AWS administrators.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow push",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<REDACTED>:root"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
        "ecr:PutImage",
        "ecr:TagResource",
        "ecr:UntagResource",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
```

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
