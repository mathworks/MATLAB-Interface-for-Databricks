# mw_prefs
# This module contains some methods and classes to help setting up a suitable
# MATLAB Context for MATLAB running in a Databricks environment.
# This may include things like MATLAB Preferences, project folders, custom
# MATLAB libraries, etc.

# Copyright 2025 MathWorks, Inc.

import json
import os
import time
import shutil
from pathlib import Path
import tempfile
import tarfile
from abc import ABC, abstractmethod

import xml.etree.ElementTree as ET

def _get_matlab_release_from_xml(xml_file_path):
    """Extract the MATLAB release from versioninfo.xml"""
    tree = ET.parse(xml_file_path)
    root = tree.getroot()
    release = root.find('release').text
    return release

def _get_matlab_dir() -> str:
    """Find the directory where MATLAB is installed.
    It returns the MATLAB Root as a string, and throws
    an error if now matlab was found on the PATH."""
    exe = shutil.which("matlab")
    if exe is None:
        raise FileNotFoundError("matlab not found on PATH")
  
    real_path = Path(exe).resolve()
    matlab_root = real_path.parents[1]
    return str(matlab_root)


def get_matlab_release():
    """Get the MATLAB release version from the system."""
    try:
        xml_path = os.path.join(_get_matlab_dir(), 'VersionInfo.xml')
        return _get_matlab_release_from_xml(xml_path)
    except Exception:
        pass
    return None

def _get_wsc():
    """Get a Databricks workspace client"""
    from databricks.sdk import WorkspaceClient
    return WorkspaceClient()

def default_config_filename(write_config_if_none=True, verbose=False, linux_user_name=None):
    """Return the default configuration file name used for the
    feature of setting up and saving the user environment.
    If the write_config_if_none is True (default), it will create a file
    with default content if it doesn't yet exist."""

    (cfg_file_name, default_config) = _default_startup_config(linux_user_name=linux_user_name)
    if not os.path.isfile(cfg_file_name):
        _log(f"No default configuration file exists {cfg_file_name}", verbose)
        if write_config_if_none:
            _log(f"Creating default configuration file '{cfg_file_name}'", verbose)
            cfg_dir_name = os.path.dirname(cfg_file_name)
            if not os.path.isdir(cfg_dir_name):
                _log(f"Creating configuration directory file '{cfg_dir_name}'", verbose)
                os.makedirs(cfg_dir_name, exist_ok=True)
            write_prefs(default_config, cfg_file_name)
        else:
            _log("Skipping creation of default configuration file", verbose)
    else:
        _log(f"Configuration file exists {cfg_file_name}", verbose)

    return cfg_file_name


def _default_startup_config(linux_user_name=None):
    """Generate a default startup configuration dictionary.
    This function returns a tuple with the
    (default_cfg_file, default_configuration_dictionary)"""
    ml_release = get_matlab_release()
    wsc = _get_wsc()
    dbx_user_name = wsc.current_user.me().user_name
    if linux_user_name is None:
        linux_user_name = dbx_user_name.split('@')[0]
    ctx_dir = f'/Workspace/Users/{dbx_user_name}/MathWorks/Context'
    cfg_file_name = f'{ctx_dir}/{ml_release}/mw_prefs.json'
    s = {
        "type": "Context",
        "username": f"{linux_user_name}",
        "operations": [
            {
                "type": "Copy",
                "src_location": f"/home/{linux_user_name}/.ssh",
                "zip_location": ctx_dir,
                "exclude_list": None,
                "context": "python"
            },
            {
                "type": "Copy",
                "src_location": f"/home/{linux_user_name}/.gitconfig",
                "zip_location": ctx_dir,
                "exclude_list": None,
                "context": "python"
            },
            {
                "type": "Copy",
                "src_location": f"/home/{linux_user_name}/.matlab",
                "zip_location": f'{ctx_dir}/{ml_release}',
                "exclude_list": ["MWI", "__mw_resources_mw__"],
                "context": "python"
            }
        ]
    }
    return (cfg_file_name, s)

def _log(message, verbose=True):
    """Simple logging function with optional verbosity control."""
    if verbose:
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {message}")

def human_readable_bytes(num, suffix='B'):
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < 1024.0:
            return f"{num:3.1f}{unit}{suffix}"
        num /= 1024.0
    return f"{num:.1f}Y{suffix}"

def exclude_filter(exclude_list):
    """Will return a function for excluding entries containing any of the
    strings found in the exclude_list.
    """
    if not exclude_list:
        return None

    def my_filter(tarinfo):
        for ex in exclude_list:
            if tarinfo.name.find(ex) != -1:
                print(f'Excluding {tarinfo.name}')
                return None
        return tarinfo
    return my_filter


def tar_gz_folder(folder_path, output_file_path, exclude_list=None):
    """Create a tar.gz archive of a folder with optional exclusions.
    Create it in temporary file that is then copied to final location."""
    base_name = os.path.basename(folder_path)
    fd, tmp_file_path = tempfile.mkstemp(suffix='.tar.gz', prefix='susd_')
    os.close(fd)  # Close and we can now use the path
    # print(f'Writing tar.gz to {tmp_file_path}')
    with tarfile.open(tmp_file_path, "w:gz") as tar:
        tar.add(folder_path,
                filter=exclude_filter(exclude_list),
                arcname=base_name)
    # print(f'Moving {tmp_file_path} to {output_file_path}')
    shutil.move(tmp_file_path, output_file_path)


def untar_gz_file(tar_path, target_path):
    """Extract a tar.gz archive to a target directory."""
    with tarfile.open(tar_path, 'r:gz') as tar_ref:
        tar_ref.extractall(target_path)


class Serializable(ABC):
    """The abstract superclass for the serializable objects to use for startup
    and shutdown for the MATLAB Desktop on Databricks.

    It has the following abstract methods

    serialize - create a dict from an object
    deserialize - create an object from a dict
    startup - the code to execute at startup
    shutdown - the code to execute on shutdown
    """
    registry = {}

    # Overriding the __init_subclass__ from abc, to enable classes self-registering
    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        Serializable.registry[cls.__name__] = cls  # Register the subclass
        # print(f"Registered: {cls.__name__}")

    @abstractmethod
    def serialize(self) -> dict:
        pass

    @classmethod
    @abstractmethod
    def deserialize(cls, data: dict):
        pass

    @abstractmethod
    def startup(self):
        pass

    @abstractmethod
    def shutdown(self):
        pass


class Context(Serializable):
    """Context - manage context of Databricks startup."""

    def __init__(self, username: str, operations=[]):
        self.username = username
        self.operations = operations

    def serialize(self) -> dict:
        return {
            "type": "Context",
            "username": self.username,
            "operations": [obj.serialize() for obj in self.operations]
        }

    @classmethod
    def deserialize(cls, data: dict):
        """Deserialize a Context object from a dictionary."""
        type_map = Serializable.registry
        ops = []
        for item in data['operations']:
            obj_type = item["type"]
            if obj_type in type_map:
                ops.append(type_map[obj_type].deserialize(item))
            else:
                _log(f"No class for {obj_type} for Python", True)

        return cls(username=data["username"],
                   operations=ops)

    def startup(self, verbose=False):
        """Run all the startup functions in operations
        """
        for op in self.operations:
            if op.context == 'python':
                _log(f"Running startup for {op.info()}", verbose)
                op.startup(verbose=verbose)

    def shutdown(self, verbose=False):
        """Run all the shutdown functions in operations in"""
        for op in self.operations:
            if op.context == 'python':
                op.shutdown(verbose=verbose)

    def add_op(self, obj: Serializable):
        """Add an operation to the list"""
        self.operations.append(obj)


class Copy(Serializable):
    """Copy - copy a folder or a file. It must provide the src_location, zip_location
    and context.
    It will always be stored as a tar.gz file.
    """

    def __init__(self, src_location: str,
                 zip_location: str = None,
                 exclude_list: list = None,
                 context: str = 'python'):
        self.src_location = src_location
        self.zip_location = zip_location
        self.exclude_list = exclude_list
        self.context = context

    def serialize(self) -> dict:
        return {
            "type": "Copy",
            "src_location": self.src_location,
            "zip_location": self.zip_location,
            "exclude_list": self.exclude_list,
            "context": self.context
        }
        
    def info(self):
        """Return a string representation of the Copy operation."""
        return f"Copy: {self.src_location} -> {self.zip_location}"

    def get_zip_name(self):
        """Generate the full path for the zip file."""
        # if self.zip_location:
        zip_path = self.zip_location
        base_name = os.path.basename(self.src_location)
        zip_name = f"{base_name}.tar.gz"
        return os.path.join(zip_path, zip_name)

    @classmethod
    def deserialize(cls, data: dict):
        return cls(src_location=data["src_location"],
                   zip_location=data["zip_location"],
                   exclude_list=data.get("exclude_list"),
                   context=data["context"])

    def shutdown(self, verbose=False):
        if os.path.exists(self.src_location):
            zip_name = self.get_zip_name()
            print(f'Compressing {self.src_location} into {zip_name} ... ', end='')
            start_time = time.time()
            tar_gz_folder(self.src_location, zip_name,
                          exclude_list=self.exclude_list)
            end_time = time.time()
            elapsed_time = end_time - start_time
            output_file_size = os.path.getsize(zip_name)
            print(f' in {elapsed_time:.1f} seconds for {human_readable_bytes(output_file_size)}')

        else:
            print(
                f'Directory/File currently not present, skipping. {self.src_location}')

    def startup(self, verbose=False):
        zip_name = self.get_zip_name()
        if os.path.exists(zip_name):
            _log(f'Unpacking: {zip_name}', verbose=verbose)
            dir_name = os.path.dirname(self.src_location)
            untar_gz_file(zip_name, target_path=dir_name)
        else:
            _log(f'No such file, skipping: {zip_name}', verbose=verbose)


def get_pref(pref, file_loc):
    with open(file_loc) as f:
        data = json.load(f)
    return data[pref]


def write_prefs(prefs, file_loc):
    """Convert the preferences to JSON and write to file."""
    with open(file_loc, 'w') as f:
        json.dump(prefs, f, indent=4)


def load_prefs(file_loc):
    """Load the preferences and convert JSON to Python data"""
    if os.path.exists(file_loc):
        with open(file_loc) as f:
            data = json.load(f)
            return data
    else:
        return {}


def has_pref(pref, file_loc):
    """Check if a preference exists"""
    prefs = load_prefs(file_loc=file_loc)
    return pref in prefs

def startup(file_loc, verbose=False):
    """Load preferences and startup operations."""
    _log("Loading preferences from: " + file_loc, verbose)
    prefs = load_prefs(file_loc)
    _log("Loaded preferences: " + str(prefs), verbose)
    if prefs:
        ctx = Context.deserialize(prefs)
        ctx.startup(verbose=verbose)


def shutdown(file_loc, verbose=False):
    """Load preferences and shutdown operations."""
    prefs = load_prefs(file_loc)
    if prefs:
        ctx = Context.deserialize(prefs)
        ctx.shutdown(verbose=verbose)
