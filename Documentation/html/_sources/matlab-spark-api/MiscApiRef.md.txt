# MATLAB Interface *for Apache Spark* (matlab.sparkutils & app/functions) - API Reference

This document includes API reference information for the following namespaces or functions:

* [matlab.sparkutils](#matlabsparkutils)
* Software/MATLAB/app/functions/*.m

Classes, methods and functions that include the terms `private` or `internal` in their namespace should not be used directly.
They are subject to change or removal without notice.

## Index

* MATLAB&reg; Interface *for Apache&reg; Spark&trade;* (matlab.sparkutils & app/functions)
  * [matlab.sparkutils](#matlabsparkutils)
    * [matlab.sparkutils.internal](#matlabsparkutilsinternal)
      * [matlab.sparkutils.internal.genExpressionEncoders](#matlabsparkutilsinternalgenexpressionencoders)
      * [matlab.sparkutils.internal.hasSparkEnvironment](#matlabsparkutilsinternalhassparkenvironment)
      * [matlab.sparkutils.internal.yamldecode](#matlabsparkutilsinternalyamldecode)
      * [matlab.sparkutils.internal.yamlencode](#matlabsparkutilsinternalyamlencode)
    * [matlab.sparkutils.FileWriter](#matlabsparkutilsfilewriter)
      * [matlab.sparkutils.FileWriter.FileWriter](#matlabsparkutilsfilewriterfilewriter)
      * [matlab.sparkutils.FileWriter.addBlockFromFile](#matlabsparkutilsfilewriteraddblockfromfile)
      * [matlab.sparkutils.FileWriter.addImport](#matlabsparkutilsfilewriteraddimport)
      * [matlab.sparkutils.FileWriter.addMethod](#matlabsparkutilsfilewriteraddmethod)
      * [matlab.sparkutils.FileWriter.addPostClass](#matlabsparkutilsfilewriteraddpostclass)
      * [matlab.sparkutils.FileWriter.addVariable](#matlabsparkutilsfilewriteraddvariable)
      * [matlab.sparkutils.FileWriter.escape](#matlabsparkutilsfilewriterescape)
      * [matlab.sparkutils.FileWriter.getFileName](#matlabsparkutilsfilewritergetfilename)
      * [matlab.sparkutils.FileWriter.isPython](#matlabsparkutilsfilewriterispython)
      * [matlab.sparkutils.FileWriter.lastPackageLevel](#matlabsparkutilsfilewriterlastpackagelevel)
      * [matlab.sparkutils.FileWriter.newMethod](#matlabsparkutilsfilewriternewmethod)
      * [matlab.sparkutils.FileWriter.plainFileName](#matlabsparkutilsfilewriterplainfilename)
      * [matlab.sparkutils.FileWriter.writeFile](#matlabsparkutilsfilewriterwritefile)
    * [matlab.sparkutils.JavaWriter](#matlabsparkutilsjavawriter)
      * [matlab.sparkutils.JavaWriter.JavaWriter](#matlabsparkutilsjavawriterjavawriter)
      * [matlab.sparkutils.JavaWriter.addEncoder](#matlabsparkutilsjavawriteraddencoder)
      * [matlab.sparkutils.JavaWriter.addVariable](#matlabsparkutilsjavawriteraddvariable)
      * [matlab.sparkutils.JavaWriter.delete](#matlabsparkutilsjavawriterdelete)
      * [matlab.sparkutils.JavaWriter.getFileName](#matlabsparkutilsjavawritergetfilename)
      * [matlab.sparkutils.JavaWriter.getMCRFactoryName](#matlabsparkutilsjavawritergetmcrfactoryname)
      * [matlab.sparkutils.JavaWriter.writeFile](#matlabsparkutilsjavawriterwritefile)
    * [matlab.sparkutils.MATLABWriter](#matlabsparkutilsmatlabwriter)
      * [matlab.sparkutils.MATLABWriter.MATLABWriter](#matlabsparkutilsmatlabwritermatlabwriter)
      * [matlab.sparkutils.MATLABWriter.addSubFun](#matlabsparkutilsmatlabwriteraddsubfun)
      * [matlab.sparkutils.MATLABWriter.delete](#matlabsparkutilsmatlabwriterdelete)
    * [matlab.sparkutils.NotebookWriter](#matlabsparkutilsnotebookwriter)
      * [matlab.sparkutils.NotebookWriter.NotebookWriter](#matlabsparkutilsnotebookwriternotebookwriter)
      * [matlab.sparkutils.NotebookWriter.addHeader](#matlabsparkutilsnotebookwriteraddheader)
      * [matlab.sparkutils.NotebookWriter.comment](#matlabsparkutilsnotebookwritercomment)
      * [matlab.sparkutils.NotebookWriter.magic](#matlabsparkutilsnotebookwritermagic)
    * [matlab.sparkutils.PythonWriter](#matlabsparkutilspythonwriter)
      * [matlab.sparkutils.PythonWriter.PythonWriter](#matlabsparkutilspythonwriterpythonwriter)
      * [matlab.sparkutils.PythonWriter.addBulk](#matlabsparkutilspythonwriteraddbulk)
      * [matlab.sparkutils.PythonWriter.delete](#matlabsparkutilspythonwriterdelete)
      * [matlab.sparkutils.PythonWriter.getFileName](#matlabsparkutilspythonwritergetfilename)
      * [matlab.sparkutils.PythonWriter.writeFile](#matlabsparkutilspythonwriterwritefile)
    * [matlab.sparkutils.SparkDataframeDatastore](#matlabsparkutilssparkdataframedatastore)
      * [matlab.sparkutils.SparkDataframeDatastore.SparkDataframeDatastore](#matlabsparkutilssparkdataframedatastoresparkdataframedatastore)
      * [matlab.sparkutils.SparkDataframeDatastore.hasdata](#matlabsparkutilssparkdataframedatastorehasdata)
      * [matlab.sparkutils.SparkDataframeDatastore.preview](#matlabsparkutilssparkdataframedatastorepreview)
      * [matlab.sparkutils.SparkDataframeDatastore.progress](#matlabsparkutilssparkdataframedatastoreprogress)
      * [matlab.sparkutils.SparkDataframeDatastore.read](#matlabsparkutilssparkdataframedatastoreread)
      * [matlab.sparkutils.SparkDataframeDatastore.reset](#matlabsparkutilssparkdataframedatastorereset)
    * [matlab.sparkutils.SparkSessionHandler](#matlabsparkutilssparksessionhandler)
      * [matlab.sparkutils.SparkSessionHandler.SparkSessionHandler](#matlabsparkutilssparksessionhandlersparksessionhandler)
      * [matlab.sparkutils.SparkSessionHandler.addSession](#matlabsparkutilssparksessionhandleraddsession)
      * [matlab.sparkutils.SparkSessionHandler.deleteOneSession](#matlabsparkutilssparksessionhandlerdeleteonesession)
      * [matlab.sparkutils.SparkSessionHandler.deleteSession](#matlabsparkutilssparksessionhandlerdeletesession)
      * [matlab.sparkutils.SparkSessionHandler.deleteSessions](#matlabsparkutilssparksessionhandlerdeletesessions)
      * [matlab.sparkutils.SparkSessionHandler.findSession](#matlabsparkutilssparksessionhandlerfindsession)
      * [matlab.sparkutils.SparkSessionHandler.getSession](#matlabsparkutilssparksessionhandlergetsession)
      * [matlab.sparkutils.SparkSessionHandler.getSessionHandler](#matlabsparkutilssparksessionhandlergetsessionhandler)
      * [matlab.sparkutils.SparkSessionHandler.listSessions](#matlabsparkutilssparksessionhandlerlistsessions)
    * [matlab.sparkutils.StringWriter](#matlabsparkutilsstringwriter)
      * [matlab.sparkutils.StringWriter.StringWriter](#matlabsparkutilsstringwriterstringwriter)
      * [matlab.sparkutils.StringWriter.closeFile](#matlabsparkutilsstringwriterclosefile)
      * [matlab.sparkutils.StringWriter.delete](#matlabsparkutilsstringwriterdelete)
      * [matlab.sparkutils.StringWriter.getLines](#matlabsparkutilsstringwritergetlines)
      * [matlab.sparkutils.StringWriter.getProtectString](#matlabsparkutilsstringwritergetprotectstring)
      * [matlab.sparkutils.StringWriter.getString](#matlabsparkutilsstringwritergetstring)
      * [matlab.sparkutils.StringWriter.indent](#matlabsparkutilsstringwriterindent)
      * [matlab.sparkutils.StringWriter.insertFile](#matlabsparkutilsstringwriterinsertfile)
      * [matlab.sparkutils.StringWriter.insertLines](#matlabsparkutilsstringwriterinsertlines)
      * [matlab.sparkutils.StringWriter.nl](#matlabsparkutilsstringwriternl)
      * [matlab.sparkutils.StringWriter.pf](#matlabsparkutilsstringwriterpf)
      * [matlab.sparkutils.StringWriter.tab](#matlabsparkutilsstringwritertab)
      * [matlab.sparkutils.StringWriter.unindent](#matlabsparkutilsstringwriterunindent)
    * [matlab.sparkutils.datatypeMapper](#matlabsparkutilsdatatypemapper)
    * [matlab.sparkutils.getJavaBuilderPath](#matlabsparkutilsgetjavabuilderpath)
    * [matlab.sparkutils.getMatlabSparkUtilityVersion](#matlabsparkutilsgetmatlabsparkutilityversion)
    * [matlab.sparkutils.isApacheSpark](#matlabsparkutilsisapachespark)
    * [matlab.sparkutils.table2dataset](#matlabsparkutilstable2dataset)
  * [addFileProtocol](#addfileprotocol)
  * [assertUniformClass](#assertuniformclass)
  * [createSparkSchemaFromMatlabType](#createsparkschemafrommatlabtype)
  * [findFileRecursively](#findfilerecursively)
  * [generateFunctionSchema](#generatefunctionschema)
  * [getSparkApiRoot](#getsparkapiroot)
  * [getSparkEnvironmentType](#getsparkenvironmenttype)
  * [isDatabricksEnvironment](#isdatabricksenvironment)
  * [sparkApiPackageVersion](#sparkapipackageversion)
  * [stripJavaError](#stripjavaerror)
  * [table2dataset](#table2dataset)

## Help

### matlab.sparkutils

### matlab.sparkutils.internal

### matlab.sparkutils.internal.genExpressionEncoders

```text
genExpressionEncoders Generate expression encoders Scala code
 
  Shipping Spark only supports up to 5 return arguments for a tuple.
  This function generates additional code, to be inserted into
  SparkUtilityHelper.scala, that will have more versions.
```

### matlab.sparkutils.internal.hasSparkEnvironment

```text
hasSparkEnvironment Check if this is run in a Spark context
 
  Many tests with the matlab-spark-api can only be performed when a
  Spark Session can be created. This can be available with Apache
  Spark, Databricks or other custom environments.
 
  This function is used to decide to filter certain tests, to enable a
  testing of the pure Spark package too. To make sure that a test class
  only runs if a Spark session is available, add this lines as a first
  line in the TestClassSetup method:
 
    testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), 'Ensure Spark Session is available');
 
  If no Spark session is available (by this criteria), the test will
  not fail, but will be marked as "Filtered out", or in the return
  values of runtests as "Incomplete".
```

### matlab.sparkutils.internal.yamldecode

```text
yamldecode Convert YAML to MATLAB data 
 
  Converts YAML encoding to a MATLAB variable. The output can either be
  returned or written to a file.
 
  Examples:
  Convert a YAML string
 
   out = matlab.sparkutils.internal.yamldecode('string', 'a: [3, 4, ''hello'']')
      out =
        struct with fields:
 
          a: {[3]  [4]  'hello'}
 
  Convert from YAML in a file
  out = matlab.sparkutils.internal.yamldecode('file', 'mini.yml')
      out =
        struct with fields:
 
          a: [1x1 struct]
          m: 'pancakes'
 
  Not all MATLAB types are currently supported by this converter.
```

### matlab.sparkutils.internal.yamlencode

```text
yamlencode Convert MATLAB variable to YAML
 
  Converts a MATLAB variable to YAML encoding. The output can either be
  returned or written to a file.
 
  Examples:
  Return YAML as a string
 
   out = matlab.sparkutils.internal.yamlencode(struct('a', pi, 'b', 'Hello'), 'string')
      out =
          'a: 3.1415926535897931
           b: Hello'
 
  Write YAML to a file
  matlab.sparkutils.internal.yamlencode(struct('a', pi, 'b', 'Hello'), 'file', 'myfile.yaml')
 
  Not all MATLAB types are currently supported by this converter.
```

### matlab.sparkutils.FileWriter

Superclass: handle

```text
FileWriter - Helper class for creating a File
  
  This is inherited in two other classes, JavaWriter and PythonWriter.
 
  These are not generic utilities, but targeted at the needs of this project.
```

#### matlab.sparkutils.FileWriter.FileWriter

```text
FileWriter - Helper class for creating a File
  
  This is inherited in two other classes, JavaWriter and PythonWriter.
 
  These are not generic utilities, but targeted at the needs of this project.

    Documentation for matlab.sparkutils.FileWriter
```

#### matlab.sparkutils.FileWriter.addBlockFromFile

```text
matlab.sparkutils.FileWriter/addBlockFromFile is a function.
    addBlockFromFile(obj, fileName)
```

#### matlab.sparkutils.FileWriter.addImport

```text
addImport Adds an import string
  addImport("my.fine.Class")
  will produce the line
  import my.fine.Class;
```

#### matlab.sparkutils.FileWriter.addMethod

```text
matlab.sparkutils.FileWriter/addMethod is a function.
    addMethod(obj, str, atStart)
```

#### matlab.sparkutils.FileWriter.addPostClass

```text
matlab.sparkutils.FileWriter/addPostClass is a function.
    addPostClass(obj, str)
```

#### matlab.sparkutils.FileWriter.addVariable

```text
addVariable Adds a member variable to the class
  JW.addVariable("public int num");
  printf arguments can also be used, i.e.
  JW.addVariable("public %s %s", typeName, memberName);
```

#### matlab.sparkutils.FileWriter.escape

```text
matlab.sparkutils.FileWriter/escape is a function.
    str = escape(~, str)
```

#### matlab.sparkutils.FileWriter.getFileName

```text
matlab.sparkutils.FileWriter/getFileName is a function.
    obj = matlab.sparkutils.FileWriter
```

#### matlab.sparkutils.FileWriter.isPython

```text
matlab.sparkutils.FileWriter/isPython is a function.
    ret = isPython(obj)
```

#### matlab.sparkutils.FileWriter.lastPackageLevel

```text
matlab.sparkutils.FileWriter/lastPackageLevel is a function.
    name = lastPackageLevel(obj)
```

#### matlab.sparkutils.FileWriter.newMethod

```text
newMethod Return a StringWriter for a method
```

#### matlab.sparkutils.FileWriter.plainFileName

```text
matlab.sparkutils.FileWriter/plainFileName is a function.
    pfn = plainFileName(obj)
```

#### matlab.sparkutils.FileWriter.writeFile

```text
matlab.sparkutils.FileWriter/writeFile is a function.
    obj = matlab.sparkutils.FileWriter
```

### matlab.sparkutils.JavaWriter

Superclass: matlab.sparkutils.FileWriter

```text
JavaWriter - Helper class for creating a Java file
```

#### matlab.sparkutils.JavaWriter.JavaWriter

```text
JavaWriter - Helper class for creating a Java file

    Documentation for matlab.sparkutils.JavaWriter
```

#### matlab.sparkutils.JavaWriter.addEncoder

```text
addEncoder Adds an encoder. 
 
  The encoder info is created by a method in the File class,
```

#### matlab.sparkutils.JavaWriter.addVariable

```text
addVariable Adds a member variable to the class
  JW.addVariable("public int num");
  printf arguments can also be used, i.e.
  JW.addVariable("public %s %s", typeName, memberName);
```

#### matlab.sparkutils.JavaWriter.delete

```text
delete - files or objects

    <strong>Syntax</strong>
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-filename">filename</a> - Name of file to delete
        string array | character vector | cell array of character vectors
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-h">obj</a> - Object
        single object | array of objects
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#mw_5b772dbd-a426-4b57-8167-1077a1b02460">tf</a> - Remove target of symbolic link
        false or 0 (default) | true or 1

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/DeleteFilesInFolderExample')">Delete Files in Folder</a>
      <a href="matlab:openExample('matlab/DeleteGraphicsObjectsExample')">Delete Graphics Objects</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help dir -displayBanner">dir</a>, <a href="matlab:help recycle -displayBanner">recycle</a>, <a href="matlab:help rmdir -displayBanner">rmdir</a>, <a href="matlab:help handle.delete -displayBanner">delete</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc delete">Documentation for delete</a>
```

#### matlab.sparkutils.JavaWriter.getFileName

```text
matlab.sparkutils.JavaWriter/getFileName is a function.
    fileName = getFileName(obj)
```

#### matlab.sparkutils.JavaWriter.getMCRFactoryName

```text
matlab.sparkutils.JavaWriter/getMCRFactoryName is a function.
    name = getMCRFactoryName(obj)
```

#### matlab.sparkutils.JavaWriter.writeFile

```text
matlab.sparkutils.JavaWriter/writeFile is a function.
    writeFile(obj)
```

### matlab.sparkutils.MATLABWriter

Superclass: matlab.sparkutils.StringWriter

```text
MATLABWriter A class for writing a MATLAB function
 
  This function is based on the general StringWriter class, but has some
  additional methods for handling sub-functions in consistent manner.
```

#### matlab.sparkutils.MATLABWriter.MATLABWriter

```text
MATLABWriter A class for writing a MATLAB function
 
  This function is based on the general StringWriter class, but has some
  additional methods for handling sub-functions in consistent manner.

    Documentation for matlab.sparkutils.MATLABWriter
```

#### matlab.sparkutils.MATLABWriter.addSubFun

```text
matlab.sparkutils.MATLABWriter/addSubFun is a function.
    addSubFun(obj, subfun)
```

#### matlab.sparkutils.MATLABWriter.delete

```text
delete - files or objects

    <strong>Syntax</strong>
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-filename">filename</a> - Name of file to delete
        string array | character vector | cell array of character vectors
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-h">obj</a> - Object
        single object | array of objects
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#mw_5b772dbd-a426-4b57-8167-1077a1b02460">tf</a> - Remove target of symbolic link
        false or 0 (default) | true or 1

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/DeleteFilesInFolderExample')">Delete Files in Folder</a>
      <a href="matlab:openExample('matlab/DeleteGraphicsObjectsExample')">Delete Graphics Objects</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help dir -displayBanner">dir</a>, <a href="matlab:help recycle -displayBanner">recycle</a>, <a href="matlab:help rmdir -displayBanner">rmdir</a>, <a href="matlab:help handle.delete -displayBanner">delete</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc delete">Documentation for delete</a>
```

### matlab.sparkutils.NotebookWriter

Superclass: matlab.sparkutils.StringWriter

```text
NotebookWriter - Helper class for writing Databricks Notebooks
```

#### matlab.sparkutils.NotebookWriter.NotebookWriter

```text
NotebookWriter - Helper class for writing Databricks Notebooks

    Documentation for matlab.sparkutils.NotebookWriter
```

#### matlab.sparkutils.NotebookWriter.addHeader

```text
matlab.sparkutils.NotebookWriter/addHeader is a function.
    addHeader(obj, sectionTitle)
```

#### matlab.sparkutils.NotebookWriter.comment

```text
matlab.sparkutils.NotebookWriter/comment is a function.
    comment(obj, commentStr, varargin)
```

#### matlab.sparkutils.NotebookWriter.magic

```text
magic - square

    <strong>Syntax</strong>
      M = magic(n)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/magic.html#d127e1053460">n</a> - Matrix order
        scalar integer

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/ThirdOrderMagicSquareExample')">Third-Order Magic Square</a>
      <a href="matlab:openExample('matlab/MagicSquareExample')">Magic Square Visualization</a>

    <strong>See also</strong> <a href="matlab:help ones -displayBanner">ones</a>, <a href="matlab:help rand -displayBanner">rand</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc magic">Documentation for magic</a>
```

### matlab.sparkutils.PythonWriter

Superclass: matlab.sparkutils.FileWriter

```text
PythonWriter A class for writing a Python file
 
  This function is based on the general StringWriter class, but has some
  additional methods for handling sub-functions in consistent manner.
```

#### matlab.sparkutils.PythonWriter.PythonWriter

```text
PythonWriter A class for writing a Python file
 
  This function is based on the general StringWriter class, but has some
  additional methods for handling sub-functions in consistent manner.

    Documentation for matlab.sparkutils.PythonWriter
```

#### matlab.sparkutils.PythonWriter.addBulk

```text
matlab.sparkutils.PythonWriter/addBulk is a function.
    addBulk(obj, bulk)
```

#### matlab.sparkutils.PythonWriter.delete

```text
delete - files or objects

    <strong>Syntax</strong>
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-filename">filename</a> - Name of file to delete
        string array | character vector | cell array of character vectors
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-h">obj</a> - Object
        single object | array of objects
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#mw_5b772dbd-a426-4b57-8167-1077a1b02460">tf</a> - Remove target of symbolic link
        false or 0 (default) | true or 1

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/DeleteFilesInFolderExample')">Delete Files in Folder</a>
      <a href="matlab:openExample('matlab/DeleteGraphicsObjectsExample')">Delete Graphics Objects</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help dir -displayBanner">dir</a>, <a href="matlab:help recycle -displayBanner">recycle</a>, <a href="matlab:help rmdir -displayBanner">rmdir</a>, <a href="matlab:help handle.delete -displayBanner">delete</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc delete">Documentation for delete</a>
```

#### matlab.sparkutils.PythonWriter.getFileName

```text
matlab.sparkutils.PythonWriter/getFileName is a function.
    fileName = getFileName(obj)
```

#### matlab.sparkutils.PythonWriter.writeFile

```text
matlab.sparkutils.PythonWriter/writeFile is a function.
    writeFile(obj)
```

### matlab.sparkutils.SparkDataframeDatastore

Superclass: matlab.io.Datastore

```text
SparkDataframeDatastore Class to help build the javaclasspath necessary for Spark
```

#### matlab.sparkutils.SparkDataframeDatastore.SparkDataframeDatastore

```text
SparkDataframeDatastore Class to help build the javaclasspath necessary for Spark

    Documentation for matlab.sparkutils.SparkDataframeDatastore
```

#### matlab.sparkutils.SparkDataframeDatastore.hasdata

```text
HASDATA   Returns true if more data is available.
    Return logical scalar indicating availability of data. This
    method should be called before calling read. This is an
    abstract method and must be implemented by the subclasses.
    hasdata is used in conjunction with read to read all the data
    within the datastore. Following is an example usage:
 
    ds = myDatastore(...);
    while hasdata(ds)
        [data, info] = read(ds);
    end
 
    % reset to read from start of the data
    reset(ds);
    [data, info] = read(ds);
 
    See also matlab.sparkutils.SparkDataframeDatastore, read, reset, readall, preview,
    progress.

Help for matlab.sparkutils.SparkDataframeDatastore/hasdata is inherited from superclass matlab.io.Datastore
```

#### matlab.sparkutils.SparkDataframeDatastore.preview

```text
PREVIEW   Preview the data contained in the datastore.
    Returns a small amount of data from the start of the datastore.
    This is the default implementation of the preview method,
    subclasses can implement an efficient version of this method
    by returning a smaller subset of the data directly from the
    read method. Subclasses should also consider implementing a
    more efficient version of this method for improved tall
    array construction performance. The datatype of the output
    should be the same as that of the read method. In the
    provided default implementation, a copy of the datastore is
    first reset. The read method is called on this copied
    datastore. The first 8 rows in the output from the read
    method call are returned as output of the preview method.
 
    See also matlab.io.Datastore, read, hasdata, reset, readall,
    progress.
```

#### matlab.sparkutils.SparkDataframeDatastore.progress

```text
Determine percentage of data read from datastore
```

#### matlab.sparkutils.SparkDataframeDatastore.read

```text
READ   Read data and information about the extracted data.
    Return the data extracted from the datastore in the
    appropriate form for this datastore. Also return
    information about where the data was extracted from in
    the datastore. Both the outputs are required to be
    returned from the read method, and can be of any type.
    info is recommended to be a struct with information
    about the chunk of data read. data represents the
    underlying class of tall, if tall is created on top of
    this datastore. This is an abstract method and must be
    implemented by the subclasses.
 
    See also matlab.sparkutils.SparkDataframeDatastore, hasdata, reset, readall, preview,
    progress.

Help for matlab.sparkutils.SparkDataframeDatastore/read is inherited from superclass matlab.io.Datastore
```

#### matlab.sparkutils.SparkDataframeDatastore.reset

```text
RESET   Reset to the start of the data.
    Reset the datastore to the state where no data has been
    read from it. This is an abstract method and must be
    implemented by the subclasses.
    In the provided example, the datastore is reset to point to the
    first file (and first partition) in the datastore.
 
    See also matlab.sparkutils.SparkDataframeDatastore, read, hasdata, readall, preview,
    progress.

Help for matlab.sparkutils.SparkDataframeDatastore/reset is inherited from superclass matlab.io.Datastore
```

### matlab.sparkutils.SparkSessionHandler

Superclass: handle

```text
SparkSessionHandler Class to handle Spark sessions
 
  This class will make it easier to reuse different Spark sessions,
  without always recreating them.
```

#### matlab.sparkutils.SparkSessionHandler.SparkSessionHandler

```text
SparkSessionHandler Class to handle Spark sessions
 
  This class will make it easier to reuse different Spark sessions,
  without always recreating them.

    Documentation for matlab.sparkutils.SparkSessionHandler
```

#### matlab.sparkutils.SparkSessionHandler.addSession

```text
matlab.sparkutils.SparkSessionHandler/addSession is a function.
    idx = addSession(obj, sparkMaster, sparkSession)
```

#### matlab.sparkutils.SparkSessionHandler.deleteOneSession

```text
matlab.sparkutils.SparkSessionHandler/deleteOneSession is a function.
    deleteOneSession(obj, sparkMaster)
```

#### matlab.sparkutils.SparkSessionHandler.deleteSession

```text
matlab.sparkutils.SparkSessionHandler.deleteSession is a function.
    matlab.sparkutils.SparkSessionHandler.deleteSession(sparkMaster)
```

#### matlab.sparkutils.SparkSessionHandler.deleteSessions

```text
matlab.sparkutils.SparkSessionHandler.deleteSessions is a function.
```

#### matlab.sparkutils.SparkSessionHandler.findSession

```text
matlab.sparkutils.SparkSessionHandler/findSession is a function.
    idx = findSession(obj, sparkMaster)
```

#### matlab.sparkutils.SparkSessionHandler.getSession

```text
matlab.sparkutils.SparkSessionHandler.getSession is a function.
    spark = matlab.sparkutils.SparkSessionHandler.getSession(sparkMaster)
```

#### matlab.sparkutils.SparkSessionHandler.getSessionHandler

```text
matlab.sparkutils.SparkSessionHandler.getSessionHandler is a function.
    SH = matlab.sparkutils.SparkSessionHandler.getSessionHandler
```

#### matlab.sparkutils.SparkSessionHandler.listSessions

```text
matlab.sparkutils.SparkSessionHandler.listSessions is a function.
    sessions = matlab.sparkutils.SparkSessionHandler.listSessions
```

### matlab.sparkutils.StringWriter

Superclass: handle

```text
StringWriter - Helper class for writing to files or temporary strings
```

#### matlab.sparkutils.StringWriter.StringWriter

```text
StringWriter - Helper class for writing to files or temporary strings

    Documentation for matlab.sparkutils.StringWriter
```

#### matlab.sparkutils.StringWriter.closeFile

```text
matlab.sparkutils.StringWriter/closeFile is a function.
    closeFile(this)
```

#### matlab.sparkutils.StringWriter.delete

```text
delete - files or objects

    <strong>Syntax</strong>
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    <strong>Input Arguments</strong>
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-filename">filename</a> - Name of file to delete
        string array | character vector | cell array of character vectors
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#f71-847380-h">obj</a> - Object
        single object | array of objects
      <a href="matlab:web /usr/local/MATLAB/R2026a/help/matlab/ref/delete.html#mw_5b772dbd-a426-4b57-8167-1077a1b02460">tf</a> - Remove target of symbolic link
        false or 0 (default) | true or 1

    <strong>Examples</strong>
      <a href="matlab:openExample('matlab/DeleteFilesInFolderExample')">Delete Files in Folder</a>
      <a href="matlab:openExample('matlab/DeleteGraphicsObjectsExample')">Delete Graphics Objects</a>

    <strong>See also</strong> <a href="matlab:help clear -displayBanner">clear</a>, <a href="matlab:help dir -displayBanner">dir</a>, <a href="matlab:help recycle -displayBanner">recycle</a>, <a href="matlab:help rmdir -displayBanner">rmdir</a>, <a href="matlab:help handle.delete -displayBanner">delete</a>

    Introduced in MATLAB before R2006a
    <a href="matlab:doc delete">Documentation for delete</a>
```

#### matlab.sparkutils.StringWriter.getLines

```text
matlab.sparkutils.StringWriter/getLines is a function.
    lines = getLines(this)
```

#### matlab.sparkutils.StringWriter.getProtectString

```text
matlab.sparkutils.StringWriter/getProtectString is a function.
    str = getProtectString(this)
```

#### matlab.sparkutils.StringWriter.getString

```text
matlab.sparkutils.StringWriter/getString is a function.
    str = getString(this)
```

#### matlab.sparkutils.StringWriter.indent

```text
matlab.sparkutils.StringWriter/indent is a function.
    indent(this)
```

#### matlab.sparkutils.StringWriter.insertFile

```text
matlab.sparkutils.StringWriter/insertFile is a function.
    insertFile(this, fileName)
```

#### matlab.sparkutils.StringWriter.insertLines

```text
insertLines Splits on \n and inserts lines
  The strings argument can be one or more actual strings
```

#### matlab.sparkutils.StringWriter.nl

```text
matlab.sparkutils.StringWriter/nl is a function.
    nl(this)
```

#### matlab.sparkutils.StringWriter.pf

```text
Short-hand for printf
```

#### matlab.sparkutils.StringWriter.tab

```text
matlab.sparkutils.StringWriter/tab is a function.
    tab(this, num)
```

#### matlab.sparkutils.StringWriter.unindent

```text
matlab.sparkutils.StringWriter/unindent is a function.
    unindent(this)
```

### matlab.sparkutils.datatypeMapper

```text
datatypeMapper Do mappings of datatypes
 
  This helps with mapping of datatypes between matlab, Java and Spark.
  entry = matlab.sparkutils.datatypeMapper(from, name)
  returns the types for matlab, java and spark (values for from) for
  the datatype named 'name'.
  entry = matlab.sparkutils.datatypeMapper('matlab', 'single')
  entry =
    struct with fields:
 
      MATLABType: "single"
        JavaType: "Float"
       SparkType: "FloatType"
  entry = matlab.sparkutils.datatypeMapper('java', 'String')
  entry =
    struct with fields:
 
      MATLABType: "string"
        JavaType: "String"
       SparkType: "StringType"
 
  Call without arguments to see what types are supported.
```

### matlab.sparkutils.getJavaBuilderPath

```text
getJavaBuilderPath Return the MATLAB Runtime javabuilder.jar path
  First try the MATLAB Java Builder toolbox dir, then check for a local runtime
  Check MCRROOT env. var. then default paths
  If the silent argument is set to logical true then an error will not be thrown
  if the file cannot be found, the default is false, throw the error.
```

### matlab.sparkutils.getMatlabSparkUtilityVersion

```text
getMatlabSparkUtilityVersion Retrieve version from pom-file
```

### matlab.sparkutils.isApacheSpark

```text
isApacheSpark Returns true if this is 'normal Spark'
 
  This function will return true for Apache Spark, and false otherwise.
  The only other Spark supported currently is Databricks
```

### matlab.sparkutils.table2dataset

```text
TABLE2DATASET Function to create Spark dataset from MATLAB table
 
  It takes as arguments a MATLAB table, the spark session reference, and
  an optional schema object, and converts the table into a Dataset object.
 
  This function should be used for tests, not for large tables.
 
  To use it, at least a table and a spark session are needed:
 
    dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession);
 
  When the optional third input argument (schema) is not provided, the
  Column data types are automatically mapped as follows (also see the 
  createSparkSchemaFromMatlabType in the functions folder):
 
    MATLAB            Spark     Notes
    ======            ======    =====
    char              String    converting back to MATLAB results in string, not char
    string            String    <missing> value interpreted as the String \0
    double            Double
    single            Float
    int8              Byte
    int16             Short
    int32             Integer
    int64             Long
    logical           Boolean
    struct            Struct
    table             Struct    converting back to MATLAB results in struct, not table
    containers.Map    Map
    cell              WrappedArray
    datetime          Timestamp
    duration          CalendarInterval
    (any other type)  *** NOT SUPPORTED ***
 
  An optional third argument (schema) can also be specified. This is useful
  when a schema object is already available, for example the schema of a
  pre-existing Spark dataset.
 
    dataset = spark.read.format("parquet").load("/my/files")
    T = table(dataset);
    T = runAlgorithm(T);
    schema = dataset.schema;
    dataset = matlab.sparkutils.table2dataset(matlabTable, sparkSession, schema);
 
  The optional schema argument can also be specified as a cell-array of
  chars or a string array, representing case-insensitive column data types.
  Only the following basic data types are supported:
 
    string or char, double, single or float, int8 or byte, int16 or short,
    int32 or int or integer, int64 or long, logical or boolean, duration,
    datetime or timestamp.
 
  This list does not include complex data types such as struct, map,
  or table. If your data contains such data types, either use the 2-inputs
  variant of this function in order to auto-generate the schema, or use a
  schema-object from a pre-existing dataset object.
```

### addFileProtocol

```text
addFileProtocol Add 'file://' to local paths for Unix
 
  For Windows, this function doesn't change anything.
 
  Example:
  fn = '/my/file.csv'
  fpfn = addFileProtocol(fn)
  fpfn =
      'file:///my/file.csv'
  sn = "/tmp/another/file.parquet"
  fpsn = addFileProtocol(sn)
  fpsn = 
      "file:///tmp/another/file.parquet"
```

### assertUniformClass

```text
ASSERTUNIFORMCLASS Assert cell array elements are of same type
 
  All elements of cell array must be of the same type
  Example:
   assertUniformClass('double', {3,4,5});
   => Will work
   assertUniformClass('double', {3,4,'hello'});
   => Will throw an error
```

### createSparkSchemaFromMatlabType

```text
createSparkSchemaFromMatlabType Create StructType from value
```

### findFileRecursively

```text
findFileRecursively Search directories recursively for a file
 
  filesFound = findFileRecursively(startDir, rxName)
  will recursively search for a file with name 'rxName' in the
  directory 'startDir'. The 'rxName' is a regular expression.
```

### generateFunctionSchema

```text
generateFunctionSchema Generate schema file for a function
 
  This function creates a schema file that provides the SparkBuilder
  with additional information when compiling functions that should run
  on Spark clusters.
 
  This function acts as a convenience functions for:
    compiler.build.spark.schema.mathworks.generateFunctionSchema
 
  For help see: compiler.build.spark.schema.mathworks.generateFunctionSchema
```

### getSparkApiRoot

```text
getSparkApiRoot Return root of MATLAB Spark API project
  getSparkApiRoot alone will return the root for the MATLAB code in the
  project.
 
  getSparkApiRoot with additional arguments will add these to the path
  
   funDir = getSparkApiRoot('app', 'functions')
 
   The special argument of a negative number will move up folders, e.g.
   the following call will move up two folders, and then into
   Documentation.
 
   docDir = getSparkApiRoot(-2, 'Documentation')
```

### getSparkEnvironmentType

```text
getSparkEnvironmentType Get the environment type of Spark
 
  Spark can be used in either 'Apache Spark' or 'Databricks'
  environment. This function will return either "ApacheSpark" or
  "Databricks", depending on what environment is currently used.
```

### isDatabricksEnvironment

```text
isDatabricksEnvironment Check if this is run in Databricks context
 
  Spark can be used in either 'Apache Spark' or 'Databricks'
  environment. This function will return either true if this is a
  Databricks environment.
```

### sparkApiPackageVersion

```text
sparkApiPackageVersion Return version of the matlab-spark-api package
```

### stripJavaError

```text
stripJavaError Attempt to convert a stack trace into something prettier.
  (adapted from sendmail.m)
```

### table2dataset

```text
TABLE2DATASET Function to create Spark dataset from MATLAB table
 
  For help, please refer to matlab.sparkutils.table2dataset
```

------

**Copyright 2020-2026 The MathWorks Inc.**

[//]: # (Documentation generation settings: )
[//]: # (* Including class level help text )
[//]: # (* Including constructor help text )
[//]: # (* Excluding inherited methods )
[//]: # (* Excluding default MATLAB classes )
[//]: # (* Generated: 07-May-2026 09:57:51 )
