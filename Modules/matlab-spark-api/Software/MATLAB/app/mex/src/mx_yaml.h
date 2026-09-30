

#ifdef __cplusplus
extern "C"
{
#endif

#include "matrix.h"

#ifdef __cplusplus
}
#endif

#include "yaml-cpp/yaml.h"

int getMWSize(const mxArray *mxVal);
bool isFileArgument(const mxArray *mx);

mxArray *yamlNodeToMX(YAML::Node ref);
mxArray *yamlNodeScalarToMX(YAML::Node node);
mxArray *yamlNodeStructToMX(YAML::Node node);
mxArray *yamlNodeSequenceToMX(YAML::Node node);
YAML::Node mxToYamlNode(const mxArray *mxVal);
YAML::Node mxCellToYamlNode(const mxArray *mxVal);
YAML::Node mxStructToYamlNode(const mxArray *mxVal);
YAML::Node mxOneStructToYamlNode(const mxArray *mxVal, int idx);
YAML::Node mxCharToYamlNode(const mxArray *mxVal);
YAML::Node mxDoubleToYamlNode(const mxArray *mxVal);
YAML::Node mxLogicalToYamlNode(const mxArray *mxVal);

mxArray * cellToTypedArray(mxArray * mxVal);
bool cellIsSingleType(mxArray *mxVal);

void mw_yaml_error(const char *id, const char *msg);

void encode(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs);
void decode(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs);
