# Function signatures

> **Note:** Function signatures have been deprecated, in favour of function schemas.
> The functionality will be in a future release.
> Please see [the Function Schemas](./FunctionSchemas.md) for a reference.

This section refers to defining function signatures, when running the `PythonSparkBuilder`.

## Rationale

When compiling MATLAB&reg; functions for running on a Spark&trade; cluster, certain information
must be added, to enable the compile process to generate the correct wrapper functions.

The wrapper functions have to act as methods working on e.g. *Rows* and *Iterators*,
which have no direct counterpart in MATLAB&reg;, and therefore the data must be marshalled
between MATLAB&reg; and Spark. By adding information about input arguments and return values,
this is made possible.

This can be done by hand if necessary, but the recommended way is to keep this information
in a JSON file (or as JSON text), which will help the compiler to configure the underlying
objects correctly.

As an example, the following MATLAB&reg; function, `simplecalc.m`:

```matlab
function [a,b] = simplecalc(x,y,z)
    a = x + y;
    b = y - z;
end
```

will have this JSON content (or similar, depending on types and sizes):

```json
{
  "InTypes": [
    "double",
    "double",
    "double"
  ],
  "OutTypes": [
    "double",
    "double"
  ]
}
```

## Providing the information to the compiler

For the SparkBuilder to use this information, there is 1 option (there used to be 3):
1. Create a JSON file with this content, and the name `simplecalc_signature.json`
   (for the MATLAB&reg; function `simplecalc.m`), and place it in the same folder as the
   file that should be compiled.
2. **Deprecated** If existing code uses this method, please change the code to use
a signature file (option 1). This option will be removed in the next release!
Add this information in the help text of the function, between the tokens
`@SB-Start@` and `@SB-End@`.
3. **Avoid** Manually setting types, by providing the correct arguments to the `File` constructor.
This is a very manual, and error prone process. Instead use utility functions and example data
to have the JSON signature file created automatically, as described above (option 1).

Either option can be chosen, but it should be noted that the JSON files/content can
easily be large, several hundred lines, and may take the focus away from the real help
for a file if using option 2. Using option 1, it will only be a file next to the original
file, and not visible to users not looking for it.

> Note: It should be noted that having this information in place, either in the help text or as
a separate file, has an additional benefit. When users wants to compile a function to use
on a Spark cluster, they don't have to provide this information, as it's already there.
This makes it easier, particularly if they are not the author of the function, to compile
and run files that other users have written.

## Creating the JSON content

The easiest way to create the JSON signature file, is by using a helper function,
`compiler.build.spark.types.generateFunctionSignature`.
This function takes as argument:

* The name of a function (without `.m` extension)
* A cell array of input arguments
* [Optional] A cell array of output arguments

It will create the file with ending `_signature.json` as described above.

```matlab
    exampleFile = "example_data.csv";
    Tin = readtable(exampleFile);
    
    compiler.build.spark.types.generateFunctionSignature("gaussianFilter", {Tin, 1.5})
```

If, as in this example, the third argument is omitted, the function will call the
function (first argument) with the input data (second argument), and use the results
as the third argument.

[//]: #  (Copyright 2022-2025 The MathWorks, Inc.)
