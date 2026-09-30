#Copyright 2015-2020 MathWorks, Inc.

import os.path
import sys
import weakref
from matlab_pysdk.runtime.deployablefunc import DeployableFunc 
from matlab_pysdk.runtime.deployableworkspace import DeployableWorkspace
import zipimport

class DeployablePackageZip(object):
    """ Class used to execute deployed MATLAB functions. """
    def __init__(self, path_initializer_handle, name, module_path):
        """ Initialize object used to execute deployed MATLAB functions. """
        self.__package_opened = False
        self.__path_initializer_handle = weakref.ref(path_initializer_handle)
        self.__name = name
        self.__module_path = module_path
        self.__cppext_handle = self.__path_initializer_handle().cppext_handle

        full_dir_name = os.path.dirname(os.path.realpath(self.__module_path))
        bare_dir_name = os.path.basename(full_dir_name)
        full_zip_zame = os.path.dirname(full_dir_name)
        zipDir = os.path.dirname(full_zip_zame)

        pkgParts = name.split('.')
        pkgPath = os.path.join(*pkgParts)

        zipfile = full_dir_name
        for _ in pkgParts:
            zipfile = os.path.dirname(zipfile)

        zip_dir = os.path.dirname(zipfile)

        zi = zipimport.zipimporter(zipfile)

        ctf_name = pkgParts[-1] + '.ctf'
        ctf_path = os.path.join(pkgPath, ctf_name)
        print(f'ctf_path: {ctf_path}')
        d = zi.get_data(ctf_path)
        tmpCtfFile = os.path.join(zip_dir, ctf_name)
        print(f'tmpCtfFile: {tmpCtfFile}')

        with open(tmpCtfFile, 'bw') as f:
            f.write(d)
        self.__ctf_path = tmpCtfFile
        # self.__ctf_path = os.path.join(full_dir_name, '{0}.ctf'.format(bare_dir_name))
        if sys.version_info.major == 2:
           encoding = sys.getfilesystemencoding()
           self.__ctf_path = self.__ctf_path.decode(encoding)
        self.__mcr_handle = None

    @property
    def name(self):
        """
        name of this package
        """
        return self.__name

    def initialize(self):
        """
        Associate this package with a new instance of the MATLAB Runtime.
        """
        mcr_handle = self.__cppext_handle.startMatlabRuntimeInstance(self.__ctf_path)
        self.__mcr_handle = mcr_handle
        self.__package_opened = True
       
    def __del__(self):
        """
        Terminate this package when it goes out of scope.
        """
        self.terminate()
        
    def __getattr__(self, name):
        """
        Retrieve deployable MATLAB function name as a dynamic attribute of the package.
        """
        # Note that MATLAB function names never start with an underscore, so
        # it's safe to assume that an attribute that starts with one is 
        # not a function.
        if name.startswith("__"):
            return self.name
        elif not self.__package_opened:
            raise RuntimeError('{0}() cannot be called after terminate() has been called on the package {1}'.format(
                name, self.__name))
        else:
            return DeployableFunc(self, name, self.__cppext_handle, self.__mcr_handle)

    def wait_for_figures_to_close(self):
        """
        Pause until all graphical figures opened by deployed MATLAB functions are closed.
        """
        if self.__package_opened:
            try:
                self.__cppext_handle.waitForFiguresToClose(self.__mcr_handle)
            except Exception as e:
                raise e

    def terminate(self):
        """
        Close the package and terminate the associated instance of the MATLAB Runtime.
        """
        if self.__package_opened:
            try:
                self.__cppext_handle.shutdownMatlabRuntimeInstance(self.__mcr_handle)
                self.__package_opened = False
            except:
                pass
        if self.__path_initializer_handle():
            if self in self.__path_initializer_handle().instances_of_this_package:
                self.__path_initializer_handle().instances_of_this_package.discard(self)

    def exit(self):
        """
        Equivalent to terminate().
        """
        self.terminate()

    def quit(self):
        """
        Equivalent to terminate().
        """
        self.terminate()
