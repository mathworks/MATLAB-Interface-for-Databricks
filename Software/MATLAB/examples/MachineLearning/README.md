# Deploy a MATLAB based Machine Learning Model to Databricks

This example demonstrates the main steps you should consider for developing
a machine learning model in MATLAB&reg; and shows how you could use this model
for inference work with data on Databricks&reg;.

The [Statistics and Machine Learning Toolbox&trade;](https://www.mathworks.com/products/statistics.html)
is required to run this example.

From a workflow perspective, there are 3 main things to consider:

1. Building and validating a model (which is typically done on your local
machine and involves lots of iteration, exploration, etc.). To find out
more about building AI models with MATLAB, check out
[Deep Learning Tutorials and Examples with MATLAB](https://www.mathworks.com/solutions/deep-learning/tutorials-examples.html).

2. Using your model for inference.  While it may seem trivial, learning
how to wrap your model in a function that can be called with external data
is key to enabling the 3rd and final step.

3. Using or deploying the model on a platform like Databricks. This is
where you would likely want to pass data from a Dataframe through your
model and take action against the predicted values. Often times the
language you will invoke your MATLAB model from will be Python&reg;.
In this part of the example we show you how could compile your MATLAB code
for use in a Python notebook that is then run on Databricks.

## This demo should be navigated in the following order

1. Driver_TrainModel.m
2. Driver_predict_w_TrainedModelFcn.m
3. Driver_RunModelOnDatabricks.m

Detailed comments about each step are included below.

### Source data

The source data for the example can be found here:
[https://www.kaggle.com/andrewmvd/early-diabetes-classification](https://www.kaggle.com/andrewmvd/early-diabetes-classification).
The file "diabetes_data.csv" needs to be downloaded and placed in the folder
called `data`. Failure to do this will result in the first script not running
(i.e., no input data).

### Citation

Islam M.M.F., Ferdousi R., Rahman S., Bushra H.Y. (2020) Likelihood Prediction of
Diabetes at Early Stage Using Data Mining Techniques. In: Gupta M., Konar D.,
Bhattacharyya S., Biswas S. (eds) Computer Vision and Machine Intelligence in
Medical Image Analysis. Advances in Intelligent Systems and Computing, vol 992.
Springer, Singapore. [https://doi.org/10.1007/978-981-13-8798-2_12](https://doi.org/10.1007/978-981-13-8798-2_12)

### Script summary

#### 1. `Driver_TrainModel.m`

This script shows how to load data into a MATLAB table and use the Classification
Learner app (part of the Statistics and Machine Learning toolbox) to train several
models and then select one based on whatever criteria you need - accuracy,
ROC curve, confusion matrix, etc.  Once you select a model, you can have the
app generate a MATLAB function that contains the code you need to train
the model type you select (see `+model/trainClassifier.m` for details).

After we train the model, we use it to predict results on (new) data.
Just training a model is not enough. You need to be able to invoke it to
create predicted values based in input data.

#### 2. `Driver_predict_w_TrainedModelFcn.m`

This script shows how to take in data and use the model we trained in
script 1 to predict. This is important because this is what we will
essentially be doing on Databricks.

The key thing to note about this script is the use of the function called
`predOutcomes.m`. When we go to deploy the trained model on Databricks we
have to deploy a wrapper function that invokes our trained model.  This is
achieved in this demo by means of the function called `predOutcomes.m`.

#### 3. `Driver_RunModelOnDatabricks.m`

This script covers a 5 step workflow to demonstrate how you could run a
MATLAB based AI algorithm from a Scala&reg; or Python notebook on Databricks.
The high level overview includes the following steps:

1. Create compiled artifacts for Python

2. Upload compiled artifacts to `/Volumes`

3. Upload notebooks to the Databricks Workspace

4. Run notebooks as notebook tasks from a Databricks job

5. Check / verify the results

The basic idea is to create a dataset - either from a set of one or more
files or a pre-existing table then run that data through your MATLAB
function to that.

In this example an [m x 17] dataset goes into the MATLAB function, and a
[m x 5] dataset is the result.

This demo was specifically set up so you could develop your work in MATLAB,
using MATLAB tables and then seamlessly transfer that work to Databricks
where (mentally) DataSets replace Tables.

## Demo Logistics

### Getting started

Begin by copying the example to a temporary working directory:

```matlab
workDir = fullfile(tempdir, "MachineLearning");
copyfile(databricksRoot("examples", "MachineLearning"), workDir)
cd(workDir)
```

For the purposes of this demo, we put the `.csv` file (source data for the
demo) on `/Volumes` so the notebooks could access it and for the sake of
expediency.

In a real world project, the source data could come from an (existing)
table or another source (i.e., an s3 bucket or Azure&reg; blob storage,
 etc.). Datasets can be created from those sources but that is outside
the scope of this demo.

The data is assumed to be located in: `/Volumes/main/default/myvolume/Examples/MachineLearning/diabetes_data.csv`.
You can put the data wherever it makes sense on your system but please update the
notebook to point to that location. Use of DBFS may not be supported and is discouraged.


Step through: `Driver_TrainModel.m`.

Step through: `Driver_predict_w_TrainedModelFcn.m`.

Step through: `Driver_RunModelOnDatabricks.m`.

