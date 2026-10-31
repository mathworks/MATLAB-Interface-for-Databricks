import os
import unittest

import mlflow
import numpy


class TestMATLABModels(unittest.TestCase):
    path_ = os.path.dirname(os.path.abspath(__file__))
    modelpath_ = os.path.abspath(
        os.path.join(
            path_,
            "..",
            "..",
            "MATLAB",
            "examples",
            "DeepLearningMLflowModels",
            "models",
        )
    )

    def getModelPath_(self, name):
        return os.path.join(self.modelpath_, name)

    def test_squeeze(self):
        from PIL import Image

        # Load the model
        m = mlflow.pyfunc.load_model(self.getModelPath_("squeeze"))
        # Load testing images
        path_ = os.path.dirname(os.path.abspath(__file__))
        image1 = Image.open(
            os.path.join(
                os.path.abspath(
                    os.path.join(
                        path_,
                        "..",
                        "..",
                        "MATLAB",
                        "examples",
                        "DeepLearningMLflowModels",
                        "resources",
                        "peppers.png",
                    )
                )
            )
        )
        image2 = Image.open(
            os.path.join(
                os.path.abspath(
                    os.path.join(
                        path_,
                        "..",
                        "..",
                        "MATLAB",
                        "examples",
                        "DeepLearningMLflowModels",
                        "resources",
                        "corn.png",
                    )
                )
            )
        )
        # Wrangle images into correct numpy numerical format
        data1 = numpy.asarray(image1, dtype="float32").transpose()
        data2 = numpy.asarray(image2, dtype="float32").transpose()
        data = numpy.array([data1, data2])

        # Run the predictions
        r = m.predict(data)

        # The model actually returns all probabilities for all classes, determine which classes
        # have the highest probabilities for each image
        r = numpy.argmax(r["prob"], axis=1)

        # Verify that the images were classified correctly (945='bell pepper', 987='corn')
        # Note: correct in this test means "same prediction as in MATLAB" and not necessarily
        # "correctly classified the picture" (although in these examples that is the case as well)
        numpy.testing.assert_equal(r, [945, 987])
