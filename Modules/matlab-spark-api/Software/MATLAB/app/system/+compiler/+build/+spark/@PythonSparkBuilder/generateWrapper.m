function generateWrapper(obj)
    % generateWrapper Wrapper for easier handling of Python library
    
    % Copyright 2022-2025 The MathWorks, Inc.
    
    here = fileparts(mfilename('fullpath'));

    copyfile(fullfile(here, "converters.py"), fullfile(obj.SrcDir, "converters.py"));
    wrapperName = "wrapper.py";
    wrapperFile = fullfile(obj.SrcDir, wrapperName);
    obj.WrapperClassName = "Wrapper";
    wrapperInstance = "instance";
    wrapperInstanceFullName = obj.WrapperClassName + "." + wrapperInstance;
    
    PyW = matlab.sparkutils.PythonWriter(obj.PkgName, obj.WrapperClassName, pathPrepend=obj.OutputDir);
    obj.setPythonWriter(PyW);
   
    PyW.addImport("from __future__ import print_function");
    PyW.addImport(sprintf("import %s\n", obj.PkgName));
    PyW.addImport("import numpy");
    PyW.addImport("import matlab");
    PyW.addImport("import threading");
    PyW.addImport("import pandas as pd");
    PyW.addImport("import datetime");
    PyW.addImport("import inspect");
    PyW.addImport("import os");
    PyW.addImport("import queue");

    PyW.addImport("from pyspark.sql.types import Row, DayTimeIntervalType");
    PyW.addImport("from decimal import Decimal, getcontext as dgc");

    if obj.Metrics
        PyW.addImport("import pyspark");
    end
    PyW.addImport("from pyspark.sql.functions import udf, pandas_udf, PandasUDFType");
    PyW.addImport("from .converters import *")

    PyW.addVariable("dtit = DayTimeIntervalType()\n");

    % Import the RuntimePool implementation    
    PyW.addBlockFromFile(fullfile(here, 'runtimepool.py'));
    PyW.addBlockFromFile(fullfile(here, 'psb_utils.py'));

    if obj.Debug
        PyW.addBlockFromFile(fullfile(here, 'dbgvar.py'));
    end
    
    generatePoolWrapper(obj, PyW);
    
    for k=1:length(obj.Files)
        fileObj = obj.Files(k);
        % Clean the API, in case this was a rebuild
        fileObj.API = struct;
        
        SW = PyW.newMethod();
        SW.pf("# ==================================\n")
        SW.pf("# ========= %s =========\n", fileObj.funcName);
        SW.pf("# ==================================\n")
        PyW.addMethod(SW);

        if ismember(compiler.build.spark.MethodType.mapInPandas, fileObj.MethodTypes)
            pt = compiler.build.spark.transformers.PandasTransformer(fileObj);
            pt.generate();
        end
        
        implementedMTs = [...
            compiler.build.spark.MethodType.inputNames, ...
            compiler.build.spark.MethodType.outputNames, ...
            compiler.build.spark.MethodType.plain, ...
            compiler.build.spark.MethodType.map, ...
            compiler.build.spark.MethodType.rowIterator, ...
            compiler.build.spark.MethodType.colsIterator, ...
            compiler.build.spark.MethodType.mapPartitions, ...
            compiler.build.spark.MethodType.mapPartitionsTable, ...
            compiler.build.spark.MethodType.pandasToColumns, ...
            compiler.build.spark.MethodType.columnsToPandas, ...
            compiler.build.spark.MethodType.pandasToColumns, ...
            compiler.build.spark.MethodType.applyInPandas, ...
            compiler.build.spark.MethodType.mapInPandas, ...
            compiler.build.spark.MethodType.pandasSeries, ...
            ];
        for mt=fileObj.MethodTypes
            if ismember(mt, implementedMTs)
                mtf = string(mt) + "_PythonWrapper";
                feval(mtf, fileObj);
            end
        end
        
    end

    obj.clearPythonWriter();
    
end

function generatePoolWrapper(obj, PyW)
    SW = PyW.newMethod();
    SW.pf("class %s:\n", obj.WrapperClassName);
    SW.indent();
    SW.pf('"""This class implements a Wrapper for running certain\n')
    SW.pf('compiled MATLAB functions more easily in a Spark environment."""\n\n');
    SW.pf("# Static variables\n")
    
    SW.pf("pool = None\n");
    SW.pf("poolSize = 4\n\n");
    
    
    SW.pf("def __init__(self):\n");
    SW.indent();
    SW.pf('"""This method initiates the package by instantiating (or reusing)\n')
    SW.pf('the MATLAB Runtime"""\n\n')
    SW.pf("super().__init__()\n");
    SW.pf("print('### Initializing MATLAB Runtime')\n");
    SW.pf("self.RT = %s.initialize()\n\n", obj.PkgName);
    SW.unindent();
    
    
    SW.pf("@staticmethod\n");
    SW.pf("def showStats(str):\n");
    SW.indent();
    SW.pf('"""Outputs some metrics on the pool. Only used if metrics are turned on.\n');
    SW.pf('   The str argument is printed for clarification."""\n');
    SW.pf('if Wrapper.pool is None:\n');
    SW.indent();
    SW.pf("print(f'### Pool not initialized {str}.')\n", obj.PkgName);
    SW.unindent();
    SW.pf("else:\n")
    SW.indent();
    SW.pf('Wrapper.pool.showRuntimeStats(str)\n\n')
    SW.unindent();
    SW.unindent();
    
    
    % SW.pf("@synchronized\n");
    SW.pf("@staticmethod\n");
    SW.pf("def getPool():\n");
    SW.indent();
    SW.pf('"""Return a pool object, that will deal with the MATLAB runtimes"""\n');
    % if obj.Metrics
    %     SW.pf("Wrapper.showStats('getPool')\n")
    % end
    SW.pf('if Wrapper.pool is None:\n');
    SW.indent();
    SW.pf("Wrapper.pool = RuntimePool(%s.initialize_runtime)\n\n", obj.PkgName);
    SW.unindent();
    
    SW.pf('return Wrapper.pool\n\n');
    SW.unindent();
    
    SW.pf("@staticmethod\n");
    SW.pf("def getInstance():\n");
    SW.indent();
    SW.pf('"""This static method returns a singleton handle to this class.\n');
    if obj.Metrics
        SW.pf("Wrapper.showStats('getInstance - pre')\n")
    end
    
    SW.pf('If no pool resources are available, the function is blocking."""\n\n');
    SW.pf('the_pool = Wrapper.getPool()\n\n');
    SW.pf('# The next call is possibly blocking\n')
    SW.pf('wrapper = the_pool.get()\n\n');
    if obj.Metrics
        SW.pf("Wrapper.showStats('getInstance - post')\n")
    end
    SW.pf('return wrapper\n\n');
    SW.unindent();
    
    SW.pf("@staticmethod\n");
    SW.pf("def releaseInstance(wrapper):\n");
    SW.indent();
    SW.pf('"""This static returns a Wrapper instance, and its runtime, to the pool.\n');
    SW.pf('This is necessary to ensure resource sharing."""\n\n');
    if obj.Metrics
        SW.pf("Wrapper.showStats('releaseInstance - pre')\n")
    end
    
    SW.pf('the_pool = Wrapper.getPool()\n\n');
    SW.pf('# The next call is possibly blocking\n')
    SW.pf('the_pool.put(wrapper)\n\n');
    if obj.Metrics
        SW.pf("Wrapper.showStats('releaseInstance - post')\n")
    end
    SW.unindent();
    
    SW.pf("# Methods for pickling:\n");
    SW.pf("def __getstate__(self):\n");
    SW.indent();
    SW.pf('"""Method to return state, as used by pickling.\n');
    SW.pf('It overrides the shipping method, and excludes some non-serializable\n')
    SW.pf('elements from the __dict__ entries."""\n\n');
    SW.pf("state = self.__dict__.copy()\n");
    SW.pf("del state['pool']\n");
    SW.pf("return state\n\n");
    SW.unindent();
    
    SW.pf("def __setstate__(self, state):\n");
    SW.indent();
    SW.pf('"""Method to initialize a class after reading in the serialization.\n');
    SW.pf('It handles non-serializable elements specifically."""\n')
    SW.pf("self.__dict__.update(state)\n");
    SW.unindent();
    
    SW.unindent();
    SW.pf('### End of Wrapper class\n\n');
    
    PyW.addMethod(SW);
end