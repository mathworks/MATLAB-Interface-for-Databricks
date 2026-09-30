"""
Python tests to test the MATLAB flavor mlflow models generated with the
example from the Software/MATLAB/examples/ModelLogging directory.
"""

# Copyright 2023 MathWorks, Inc.

import os
import unittest

import mlflow
import numpy
import pandas


class TestMATLABModels(unittest.TestCase):
    path_ = os.path.dirname(os.path.abspath(__file__))
    modelpath_ = os.path.abspath(
        os.path.join(
            path_, "..", "..", "MATLAB", "examples", "MATLABMLflowModels", "models"
        )
    )

    def getModelPath_(self, name):
        return os.path.join(self.modelpath_, name)

    def test_singleInAndOutput(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("singleInAndOutput"))
        ex = m.metadata.load_input_example(self.getModelPath_("singleInAndOutput"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict({"x": numpy.float64([[21.0]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0]]))
        # Vector
        r = m.predict({"x": numpy.float64([[21.0, 42.0]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0, 84.0]]))

    def test_multipleInAndOutputs(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("multipleInAndOutputs"))
        ex = m.metadata.load_input_example(self.getModelPath_("multipleInAndOutputs"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict({"a": numpy.float64([[21.0]]), "b": numpy.float64([[42.0]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["x"], numpy.float64([[63.0]]))
        numpy.testing.assert_equal(r["y"], numpy.float64([[-21.0]]))
        # Vector
        r = m.predict(
            {"a": numpy.float64([[21.0, 42.0]]), "b": numpy.float64([[42.0, 84.0]])}
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["x"], numpy.float64([[63.0, 126.0]]))
        numpy.testing.assert_equal(r["y"], numpy.float64([[-21.0, -42.0]]))

    def test_withDatetime(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("withDatetime"))
        ex = m.metadata.load_input_example(self.getModelPath_("withDatetime"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict(
            {
                "dtIn": numpy.array(
                    [["1983-09-30T20:00:00.000+02:00"]], "datetime64[ns]"
                ),
                "x": numpy.float64([[21.0]]),
            }
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(
            r["dtOut"], numpy.array([["1983-09-30T18:00:00.000Z"]], "datetime64[ns]")
        )
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0]]))
        # Vector
        r = m.predict(
            {
                "dtIn": numpy.array([["1983-09-30", "2023-05-26"]], "datetime64[ns]"),
                "x": numpy.float64([[21.0, 42.0]]),
            }
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(
            r["dtOut"], numpy.array([["1983-09-30", "2023-05-26"]], "datetime64[ns]")
        )
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0, 84.0]]))

    def test_tableInAndOutput(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("tableInAndOutput"))
        ex = m.metadata.load_input_example(self.getModelPath_("tableInAndOutput"))
        # Included example
        r = m.predict(ex)
        # Single row
        r = m.predict(pandas.DataFrame([{"a": 21.0, "b": 42.0}]))
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r, pandas.DataFrame([{"x": 63.0, "y": -21.0}])
        )
        # Multi row
        r = m.predict(
            pandas.DataFrame([{"a": 21.0, "b": 42.0}, {"a": 3.14, "b": 2.7183}])
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r, pandas.DataFrame([{"x": 63.0, "y": -21.0}, {"x": 5.8583, "y": 0.4217}])
        )

    def test_withDatetimeTable(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("withDatetimeTable"))
        ex = m.metadata.load_input_example(self.getModelPath_("withDatetimeTable"))
        # Included example
        r = m.predict(ex)
        # Single row
        r = m.predict(
            pandas.DataFrame(
                [{"dt": numpy.datetime64("1983-09-30"), "a": 21.0, "b": 42.0}]
            )
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r,
            pandas.DataFrame(
                [{"dt": numpy.datetime64("1983-09-30"), "x": 63.0, "y": -21.0}]
            ),
        )
        # Multi row
        r = m.predict(
            pandas.DataFrame(
                [
                    {"dt": numpy.datetime64("1983-09-30"), "a": 21.0, "b": 42.0},
                    {"dt": numpy.datetime64("2023-05-26"), "a": 3.14, "b": 2.7183},
                ]
            )
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r,
            pandas.DataFrame(
                [
                    {"dt": numpy.datetime64("1983-09-30"), "x": 63.0, "y": -21.0},
                    {"dt": numpy.datetime64("2023-05-26"), "x": 5.8583, "y": 0.4217},
                ]
            ),
        )

    def test_stringsAndChars(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("stringsAndChars"))
        ex = m.metadata.load_input_example(self.getModelPath_("stringsAndChars"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict({"s": numpy.array(["s"]), "c": numpy.array(["c"])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["us"], numpy.array(["S"]))
        numpy.testing.assert_equal(r["uc"], numpy.array(["C"]))
        # Vector
        r = m.predict({"s": numpy.array(["s1", "s2"]), "c": numpy.array(["c1", "c2"])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["us"], numpy.array(["S1", "S2"]))
        numpy.testing.assert_equal(r["uc"], numpy.array(["C1", "C2"]))

    def test_stringsAndCharsWithTable(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("stringsAndCharsWithTable"))
        ex = m.metadata.load_input_example(
            self.getModelPath_("stringsAndCharsWithTable")
        )
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict(pandas.DataFrame([{"s": "s", "c": "c"}]))
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r, pandas.DataFrame([{"c": "c", "s": "s", "uc": "C", "us": "S"}])
        )
        # Vector
        r = m.predict(
            pandas.DataFrame([{"s": "s1", "c": "c1"}, {"s": "s2", "c": "c2"}])
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r,
            pandas.DataFrame(
                [
                    {"c": "c1", "s": "s1", "uc": "C1", "us": "S1"},
                    {"c": "c2", "s": "s2", "uc": "C2", "us": "S2"},
                ]
            ),
        )

    def test_variousInts(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("variousInts"))
        ex = m.metadata.load_input_example(self.getModelPath_("variousInts"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict(
            {
                "ui8": numpy.uint8([[8]]),
                "i8": numpy.int8([[8]]),
                "ui16": numpy.uint16([[16]]),
                "i16": numpy.int16([[16]]),
                "ui32": numpy.uint32([[32]]),
                "i32": numpy.int32([[32]]),
                "ui64": numpy.uint64([[64]]),
                "i64": numpy.int64([[64]]),
            }
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["ui8"], numpy.uint8([[8]]))
        numpy.testing.assert_equal(r["i8"], numpy.int8([[8]]))
        numpy.testing.assert_equal(r["ui16"], numpy.uint16([[16]]))
        numpy.testing.assert_equal(r["i16"], numpy.int16([[16]]))
        numpy.testing.assert_equal(r["ui32"], numpy.uint32([[32]]))
        numpy.testing.assert_equal(r["i32"], numpy.int32([[32]]))
        numpy.testing.assert_equal(r["ui64"], numpy.uint64([[64]]))
        numpy.testing.assert_equal(r["i64"], numpy.int64([[64]]))
        # Vector
        r = m.predict(
            {
                "ui8": numpy.uint8([[8, 8]]),
                "i8": numpy.int8([[8, -8]]),
                "ui16": numpy.uint16([[16, 16]]),
                "i16": numpy.int16([[16, -16]]),
                "ui32": numpy.uint32([[32, 32]]),
                "i32": numpy.int32([[32, -32]]),
                "ui64": numpy.uint64([[64, 64]]),
                "i64": numpy.int64([[64, -64]]),
            }
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["ui8"], numpy.uint8([[8, 8]]))
        numpy.testing.assert_equal(r["i8"], numpy.int8([[8, -8]]))
        numpy.testing.assert_equal(r["ui16"], numpy.uint16([[16, 16]]))
        numpy.testing.assert_equal(r["i16"], numpy.int16([[16, -16]]))
        numpy.testing.assert_equal(r["ui32"], numpy.uint32([[32, 32]]))
        numpy.testing.assert_equal(r["i32"], numpy.int32([[32, -32]]))
        numpy.testing.assert_equal(r["ui64"], numpy.uint64([[64, 64]]))
        numpy.testing.assert_equal(r["i64"], numpy.int64([[64, -64]]))

    def test_variousIntsWithTable(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("variousIntsWithTable"))
        ex = m.metadata.load_input_example(self.getModelPath_("variousIntsWithTable"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict(
            pandas.DataFrame(
                [
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(64),
                    }
                ]
            )
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r,
            pandas.DataFrame(
                [
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(64),
                    }
                ]
            ),
        )
        # Vector
        r = m.predict(
            pandas.DataFrame(
                [
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(64),
                    },
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(-8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(-16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(-32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(-64),
                    },
                ]
            )
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r,
            pandas.DataFrame(
                [
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(64),
                    },
                    {
                        "ui8": numpy.int32(8),
                        "i8": numpy.int32(-8),
                        "ui16": numpy.int32(16),
                        "i16": numpy.int32(-16),
                        "ui32": numpy.int64(32),
                        "i32": numpy.int32(-32),
                        "ui64": numpy.int64(64),
                        "i64": numpy.int64(-64),
                    },
                ]
            ),
        )

    def test_logic(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("logic"))
        ex = m.metadata.load_input_example(self.getModelPath_("logic"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict({"x": numpy.bool_([[True]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["x"], numpy.bool_([[False]]))
        # Vector
        r = m.predict({"x": numpy.bool_([[True, False]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["x"], numpy.bool_([[False, True]]))

    def test_logicWithTable(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("logicWithTable"))
        ex = m.metadata.load_input_example(self.getModelPath_("logicWithTable"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict(pandas.DataFrame([{"x": True}]))
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r, pandas.DataFrame([{"x": True, "y": False}])
        )
        # Vector
        r = m.predict(pandas.DataFrame([{"x": True}, {"x": False}]))
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(
            r, pandas.DataFrame([{"x": True, "y": False}, {"x": False, "y": True}])
        )

    def test_singlePrecision(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("singlePrecision"))
        ex = m.metadata.load_input_example(self.getModelPath_("singlePrecision"))
        # Included example
        r = m.predict(ex)
        # Scalar
        r = m.predict({"x": numpy.float32([[21.0]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0]]))
        # Vector
        r = m.predict({"x": numpy.float32([[21.0, 42.0]])})
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float32([[42.0, 84.0]]))

    def test_vectorWithParams(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("vectorWithParams"))
        ex = m.metadata.load_input_example(self.getModelPath_("vectorWithParams"))
        params = m.metadata.load_input_example_params(
            self.getModelPath_("vectorWithParams")
        )
        # Included example
        r = m.predict(ex, params=params)
        ## Scalar
        r = m.predict(
            {"a": numpy.float64([[1.0]]), "b": numpy.float64([[2.0]])},
            params={"x": 15, "y": 3.0},
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0]]))

    def test_vectorWithVectorParams(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("vectorWithVectorParams"))
        ex = m.metadata.load_input_example(self.getModelPath_("vectorWithVectorParams"))
        params = m.metadata.load_input_example_params(
            self.getModelPath_("vectorWithVectorParams")
        )
        # Included example
        r = m.predict(ex, params=params)
        ## Vector
        r = m.predict(
            {"a": numpy.float64([[1.0, 2.0]]), "b": numpy.float64([[2.0, 3.0]])},
            params={"x": [15, 16], "y": [3.0, 4.0]},
        )
        self.assertIsInstance(r, dict)
        numpy.testing.assert_equal(r["y"], numpy.float64([[42.0, 76.0]]))

    def test_tableWithParams(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("tableWithParams"))
        ex = m.metadata.load_input_example(self.getModelPath_("tableWithParams"))
        params = m.metadata.load_input_example_params(
            self.getModelPath_("tableWithParams")
        )
        # Included example
        r = m.predict(ex)
        # Single row
        r = m.predict(
            pandas.DataFrame([{"a": 40.0, "b": 21.0}]), params={"x": 2, "y": 21}
        )
        self.assertIsInstance(r, pandas.DataFrame)
        pandas.testing.assert_frame_equal(r, pandas.DataFrame([{"a": 42.0, "b": 42.0}]))

    def test_vectorWithDatetimeParams(self):
        m = mlflow.pyfunc.load_model(self.getModelPath_("vectorWithDatetimeParams"))
        ex = m.metadata.load_input_example(
            self.getModelPath_("vectorWithDatetimeParams")
        )
        params = m.metadata.load_input_example_params(
            self.getModelPath_("vectorWithDatetimeParams")
        )
        # Included example
        r = m.predict(ex, params=params)
