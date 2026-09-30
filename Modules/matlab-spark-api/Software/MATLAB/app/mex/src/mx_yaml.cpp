/**
 * @file mx_yaml.cpp
 * @author mwlab@mathworks.com
 * @brief
 * @version 0.1
 * @date 2022-02-20
 *
 * @copyright Copyright (c) 2022 The MathWorks, Inc.
 *
 * This function relies on the YAML library found here: https://github.com/jbeder/yaml-cpp
 * This library is not part of this package. If you want to use this mex function, you need
 * to download and install the package on your own, if you agree to the license under which
 * that package is licensed.
 */

#ifdef __cplusplus
extern "C"
{
#endif

#include "mex.h"
#include <stdarg.h>
#ifdef __cplusplus
}
#endif

#include <string.h>
#include <iostream>
#include <fstream>
#include <sstream>

#include "mx_yaml.h"

static char errorBuf[2048];
static char tabString[200] = "\0";

static char *getStringFromParam(const mxArray *P);

static bool verbose = false;
static int depth = 0;

static void descend();
static void ascend();
static void usage();

#define infof(...)                      \
    {                                   \
        if (verbose)                    \
        {                               \
            mexPrintf("%s", tabString); \
            mexPrintf(__VA_ARGS__);     \
        }                               \
    }

void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs)
{

    if (nrhs < 3)
    {
        mw_yaml_error("YAML:TOO_FEW_ARGUMENTS", "Too few arguments.\n");
    }

    char cmd[20];
    if (mxGetString(prhs[0], cmd, 19))
    {
        mw_yaml_error("YAML:ARGUMENT_ERROR", "First argument must be a string (max 20 characters)\n");
    }

    if (strcmp(cmd, "encode") == 0)
    {
        encode(nlhs, plhs, nrhs, prhs);
        return;
    }

    if (strcmp(cmd, "decode") == 0)
    {
        decode(nlhs, plhs, nrhs, prhs);
        return;
    }

    mw_yaml_error("YAML:UNKNOWN_COMMAND", "This command is not supported.\n");
    return;
}

void encode(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs)
{
    infof("Encoding\n");
    const mxArray *data = prhs[1];
    bool toFile = isFileArgument(prhs[2]);

    if (toFile)
    {
        if (nrhs < 4)
        {
            mw_yaml_error("YAML:MISSING_ARGUMENT",
                          "When writing YAML to a file, a file argument must be provided");
        }
    }

    YAML::Node node = mxToYamlNode(data);

    infof("node address: 0x%08X\n", node);

    if (toFile)
    {
        // char * yamlFile = getStringFromParam(prhs[3]);
        const char *yamlFile = const_cast<const char *>(getStringFromParam(prhs[3]));
        infof("Writing to file %s\n", yamlFile);
        std::ofstream fout;
        fout.open(yamlFile, std::ofstream::out);
        fout << node;
        fout.close();
    }
    else
    {
        std::stringstream ss;
        ss << node;
        std::string s = ss.str();
        const char *outYaml = const_cast<const char *>(s.c_str());
        plhs[0] = mxCreateString(outYaml);
    }

    // std::cout << node << std::endl;
}

void decode(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs)
{
    infof("Decoding\n");
    bool fromFile = isFileArgument(prhs[1]);

    YAML::Node node;
    if (fromFile)
    {
        char *yamlFile = getStringFromParam(prhs[2]);
        infof("yamlFile: %s\n", yamlFile);
        node = YAML::LoadFile(yamlFile);
    }
    else
    {
        char *yamlStr = getStringFromParam(prhs[2]);
        infof("yamlStr: %s\n", yamlStr);
        node = YAML::Load(yamlStr);
    }

    plhs[0] = yamlNodeToMX(node);

    // mexPrintf("Some YAML's been read\n");
}

YAML::Node mxToYamlNode(const mxArray *mxVal)
{

    mxClassID id = mxGetClassID(mxVal);
    infof("mxClassID: %d\n", id);
    switch (id)
    {
    case mxCELL_CLASS:
        return mxCellToYamlNode(mxVal);
        break;
    case mxSTRUCT_CLASS:
        return mxStructToYamlNode(mxVal);
        break;
    case mxLOGICAL_CLASS:
        return mxLogicalToYamlNode(mxVal);
        break;
    case mxCHAR_CLASS:
        return mxCharToYamlNode(mxVal);
        break;
    case mxDOUBLE_CLASS:
        return mxDoubleToYamlNode(mxVal);
        break;
    case mxSINGLE_CLASS:
        break;
    case mxINT8_CLASS:
        break;
    case mxUINT8_CLASS:
        break;
    case mxINT16_CLASS:
        break;
    case mxUINT16_CLASS:
        break;
    case mxINT32_CLASS:
        break;
    case mxUINT32_CLASS:
        break;
    case mxINT64_CLASS:
        break;
    case mxUINT64_CLASS:
        break;
    case mxVOID_CLASS:
    case mxFUNCTION_CLASS:
    case mxUNKNOWN_CLASS:
    default:
        mw_yaml_error("YAML:ADD_CLASSID_ERROR", "Unknown or unsupported type\n");
    }
    YAML::Node node("This datatype hasn't been implemented yet.");
    return node;
}

YAML::Node mxCellToYamlNode(const mxArray *mxVal)
{

    int sz = getMWSize(mxVal);

    YAML::Node node;

    infof("sz for cell is %d\n", sz);
    descend();
    for (int k = 0; k < sz; k++)
    {
        const mxArray *mxElem = mxGetCell(mxVal, k);
        node.push_back(mxToYamlNode(mxElem));
    }
    ascend();
    return node;
}

YAML::Node mxStructToYamlNode(const mxArray *mxVal)
{
    infof("Converting struct\n");
    int sz = getMWSize(mxVal);
    infof("sz for struct is %d\n", sz);

    if (sz == 1)
    {
        return mxOneStructToYamlNode(mxVal, 0);
    }
    else
    {
        YAML::Node node;
        descend();
        for (int k = 0; k < sz; k++)
        {
            node.push_back(mxOneStructToYamlNode(mxVal, k));
        }
        ascend();

        return node;
    }
}

YAML::Node mxOneStructToYamlNode(const mxArray *mxVal, int idx)
{
    infof("onestruct \n");

    int numFields = mxGetNumberOfFields(mxVal);

    YAML::Node node;
    descend();
    for (int fieldNumber = 0; fieldNumber < numFields; fieldNumber++)
    {
        const char *key = mxGetFieldNameByNumber(mxVal, fieldNumber);
        infof("Key #%d: %s\n", fieldNumber, key);
        const mxArray *mxElem = mxGetFieldByNumber(mxVal, idx, fieldNumber);
        node[key] = mxToYamlNode(mxElem);
    }
    ascend();

    return node;
}

YAML::Node mxCharToYamlNode(const mxArray *mxVal)
{

    infof("Converting char\n");
    int sz = getMWSize(mxVal);
    infof("sz for char is %d\n", sz);

    char *str = getStringFromParam(mxVal);

    YAML::Node node(str);

    return node;
}

YAML::Node mxDoubleToYamlNode(const mxArray *mxVal)
{

    infof("Converting double\n");
    int sz = getMWSize(mxVal);
    infof("sz for double is %d\n", sz);

    double *data = mxGetDoubles(mxVal);
    if (sz == 1)
    {
        YAML::Node node(data[0]);
        return node;
    }
    else
    {
        YAML::Node node;
        descend();
        for (int k = 0; k < sz; k++)
        {
            node.push_back(data[k]);
        }
        ascend();

        return node;
    }
}

YAML::Node mxLogicalToYamlNode(const mxArray *mxVal)
{

    infof("Converting logical\n");
    int sz = getMWSize(mxVal);
    infof("sz for logical is %d\n", sz);

    bool *data = mxGetLogicals(mxVal);
    if (sz == 1)
    {
        YAML::Node node(data[0]);
        return node;
    }
    else
    {
        YAML::Node node;
        descend();
        for (int k = 0; k < sz; k++)
        {
            node.push_back(data[k]);
        }
        ascend();

        return node;
    }
}

mxArray *yamlNodeToMX(YAML::Node node)
{

    mxArray *ret = NULL;
    switch (node.Type())
    {
    case YAML::NodeType::Null:
        ret = mxCreateDoubleMatrix(0, 0, mxREAL);
        break;
    case YAML::NodeType::Scalar:
        ret = yamlNodeScalarToMX(node);
        break;
    case YAML::NodeType::Sequence:
        ret = yamlNodeSequenceToMX(node);
        break;
    case YAML::NodeType::Map:
        ret = yamlNodeStructToMX(node);
        break;
    case YAML::NodeType::Undefined:
        mexPrintf("NodeType: Undefined\n");
        break;
    }

    return ret;
}

mxArray *yamlNodeStructToMX(YAML::Node node)
{

    infof("Decoding struct (map)\n");
    int entries = node.size();
    infof("map has %x entries\n", entries);

    mxArray *ret = mxCreateStructMatrix(1, 1, 0, NULL);

    descend();
    for (YAML::const_iterator it = node.begin(); it != node.end(); ++it)
    {
        std::string key = it->first.as<std::string>();
        const char *keyStr = const_cast<const char *>(key.c_str());
        infof("Key name: %s\n", keyStr);

        YAML::Node value = it->second;
        mxArray *mxValue = yamlNodeToMX(value);
        infof("Hex value of %s is 0x%X\n", keyStr, mxValue);

        int fieldNum = mxAddField(ret, keyStr);
        if (fieldNum == -1)
        {
            mw_yaml_error("YAML:ADD_FIELD_ERROR", "Couldn't add a field to struct.\n");
        }
        mxSetFieldByNumber(ret, 0, fieldNum, mxValue);
    }
    ascend();

    return ret;
}

mxArray *yamlNodeSequenceToMX(YAML::Node node)
{
    infof("Decoding sequence\n");

    int sz = node.size();
    descend();
    mxArray *ret = mxCreateCellMatrix(sz, 1);
    if (ret == NULL)
    {
        mw_yaml_error("YAML:CREATE_CELL_ERROR", "Problems creating a cell matrix.\n");
    }
    for (std::size_t i = 0; i < sz; i++)
    {
        infof("Adding element [%d]\n", i)
            mxArray *elem = yamlNodeToMX(node[i]);
        mxSetCell(ret, i, elem);
    }
    ascend();

    return cellToTypedArray(ret);
}

mxArray *yamlNodeScalarToMX(YAML::Node node)
{

    infof("Decoding scalar\n");

    mxArray *ret = NULL;

    try
    {
        double d = node.as<double>();
        // If this worked, it was a number
        ret = mxCreateDoubleScalar(d);
        infof("number is %f\n", d);

        return ret;
    }
    catch (...)
    {
        infof("Scalar can not convert to double\n");
    }
    std::string scalarStr = node.as<std::string>();
    const char *c = const_cast<const char *>(scalarStr.c_str());
    infof("String is %s\n", c);
    if (strcmp(c, "true") == 0)
    {
        ret = mxCreateLogicalScalar(true);
    }
    else if (strcmp(c, "false") == 0)
    {
        ret = mxCreateLogicalScalar(false);
    }
    else
    {
        ret = mxCreateString(c);
    }

    return ret;
}

mxArray *cellToTypedArray(mxArray *mxVal)
{
    /* If this cell array has all elements of the same type
     * it should be converted to a typed array. Only numerical
     * types will be converted.
     *
     * If the cell array has different types, it's just returned
     * as is.
     */

    int N = mxGetNumberOfElements(mxVal);
    if (N == 0)
    {
        return mxVal;
    }

    if (!cellIsSingleType(mxVal))
    {
        return mxVal;
    }

    mxArray *firstElem = mxGetCell(mxVal, 0);
    mxClassID firstId = mxGetClassID(firstElem);

    switch (firstId)
    {
    case mxCELL_CLASS:
    case mxSTRUCT_CLASS:
    case mxCHAR_CLASS:
    case mxVOID_CLASS:
    case mxFUNCTION_CLASS:
    case mxUNKNOWN_CLASS:
        return mxVal;
        break;
    case mxLOGICAL_CLASS:
    {
        mxArray *typedVal = mxCreateLogicalMatrix(N, 1);
        // In a mex-function, the previous call will return to MATLAB prompt
        // with an error message, so no checking is necessary.
        bool *typedData = mxGetLogicals(typedVal);
        for (int k = 0; k < N; k++) {
            mxArray *elem = mxGetCell(mxVal, k);
            bool *elemData = mxGetLogicals(elem);
            typedData[k] = elemData[0];
        }
        return typedVal;
    }
    break;
    case mxDOUBLE_CLASS:
    {
        mxArray *typedVal = mxCreateDoubleMatrix(N, 1, mxREAL);
        // In a mex-function, the previous call will return to MATLAB prompt
        // with an error message, so no checking is necessary.
        double *typedData = mxGetDoubles(typedVal);
        for (int k = 0; k < N; k++) {
            mxArray *elem = mxGetCell(mxVal, k);
            double *elemData = mxGetDoubles(elem);
            typedData[k] = elemData[0];
        }
        return typedVal;
    }
    break;
    case mxSINGLE_CLASS:
    case mxINT8_CLASS:
    case mxUINT8_CLASS:
    case mxINT16_CLASS:
    case mxUINT16_CLASS:
    case mxINT32_CLASS:
    case mxUINT32_CLASS:
    case mxINT64_CLASS:
    case mxUINT64_CLASS:
    default:
        return mxVal;
    }
}

bool cellIsSingleType(mxArray *mxVal)
{
    /* This function should only be called after checking that is not
     * empty, but just in case, check here too.
     */
    int N = mxGetNumberOfElements(mxVal);
    if (N==0) {
        return false;
    }

    /* We check that all types are the same, but also that the length
     * of each array is exactly 1
     */
    mxArray *firstElem = mxGetCell(mxVal, 0);
    mxClassID firstId = mxGetClassID(firstElem);
    int firstNum = mxGetNumberOfElements(firstElem);

    if (firstNum != 1) {
        return false;
    }

    bool ret = true;

    for (int k=1; k<N; k++) {
        mxArray *elem = mxGetCell(mxVal, k);
        mxClassID id = mxGetClassID(elem);
        int elemNum = mxGetNumberOfElements(elem);
        if (id != firstId || elemNum != 1) {
            ret = false;
            break;
        }
    }

    return ret;
}

void mw_yaml_error(const char *id, const char *msg)
{
    usage();
    mexErrMsgIdAndTxt(id, "Error in mx_yaml:\n%s\n", msg);
}

static char *getStringFromParam(const mxArray *P)
{
    static char gsfpErr[1024];

    if (mxGetClassID(P) != mxCHAR_CLASS)
    {
        mw_yaml_error("YAML:NOT_A_STRING", "This argument must be a character array.\n");
    }

    mwSize N = 1 + mxGetNumberOfElements(P);
    char *newStr = new char[N];
    if (newStr == NULL)
    {
        mw_yaml_error("YAML:MEMORY_ALLOCATION_ISSUE", "Couldn't allocate memory for a string.\n");
    }
    if (mxGetString(P, newStr, N))
    {
        delete[] newStr;
        mw_yaml_error("YAML:STRING_READING_ERROR", "Coudln't read string from mxArray\n");
    }
    return newStr;
}

static void setTabString()
{
    for (int k = 0; k < depth; k++)
    {
        tabString[k] = ' ';
    }
    tabString[depth] = 0;
    infof("============== depth: %d\n", depth);
}
static void descend()
{
    if (!verbose)
        return;
    depth += 4;
    setTabString();
}

static void ascend()
{
    if (!verbose)
        return;
    depth -= 4;
    if (depth < 0)
    {
        depth = 0;
    }
    setTabString();
}

bool isFileArgument(const mxArray *mx)
{

    bool fromFile;
    char source[20];
    if (mxGetString(mx, source, 19))
    {
        mw_yaml_error("YAML:ARGUMENT_ERROR", "Second argument must be a string (max 20 characters)\n");
    }

    if (strcmp(source, "file") == 0)
    {
        fromFile = true;
    }
    else if (strcmp(source, "string") == 0)
    {
        fromFile = false;
    }
    else
    {
        mw_yaml_error("YAML:ARGUMENT_ERROR", "Second argument must be file or string.\n");
    }
    return fromFile;
}

int getMWSize(const mxArray *mxVal)
{

    int sz;
    int rows = mxGetM(mxVal);
    int cols = mxGetN(mxVal);

    if (rows > 1 && cols > 1)
    {
        mw_yaml_error("YAML:MATRIX_NOT_SUPPORTED_ERROR", "Matrices are not supported, only scalars and vectors.\n");
    }

    sz = rows * cols;

    return sz;
}

static void usage()
{
    mexPrintf("mx_yaml : converting data between MATLAB and YAML\n\n");
    mexPrintf("USAGE\n");
    mexPrintf("Decoding YAML data to MATLAB:\n");
    mexPrintf("1. Convert a string of YAML to a MATLAB variable\n");
    mexPrintf("data = mx_yaml('decode', 'string', 'a : [3,4,''hello'']'\n\n");
    mexPrintf("2. Convert a YAML file to a MATLAB variable\n");
    mexPrintf("data = mx_yaml('decode', 'file', 'config.yml'\n\n");
    mexPrintf("Encoding MATLAB data to YAML\n");
    mexPrintf("1. Convert a MATLAB variable to a YAML string\n");
    mexPrintf("yamlStr = mx_yaml('encode', data, 'string')\n\n");
    mexPrintf("2. Convert a MATLAB variable to a YAML file\n");
    mexPrintf("mx_yaml('encode', data, 'file', 'config.yml')\n\n");
    mexPrintf("There are currently a few restrictions:\n");
    mexPrintf("* Currently only double is the only supported numerical type\n");
    mexPrintf("* Scalars and vectors are allowed, but not matrices.\n");
    mexPrintf("* MATLAB char arrays are allowed, but not MATLAB Strings.\n");
    mexPrintf("* A struct array will be converted to a sequence of structs\n\n");
    mexPrintf("There may be other restrictions.\n\n");
    mexPrintf("The very nature of these conversions may cause a conversion back\n");
    mexPrintf("and forth to not be exactly equal.\n\n");
}