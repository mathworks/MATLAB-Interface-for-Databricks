function varargout = log_assessment(varargin)
    %LOG_ASSESSMENT Logs an assessment to a Trace. The assessment can be an expectation or a feedback.
    % - Expectation: A label that represents the expected value for a particular operation.
    %     For example, an expected answer for a user question from a chatbot.
    % - Feedback: A label that represents the feedback on the quality of the operation.
    %     Feedback can come from different sources, such as human judges, heuristic scorers,
    %     or LLM-as-a-Judge.
    % The following code annotates a trace with a feedback provided by LLM-as-a-Judge.
    % .. code-block:: python
    %     import mlflow
    %     from mlflow.entities import Feedback
    %     feedback = Feedback(
    %         name="faithfulness",
    %         value=0.9,
    %         rationale="The model is faithful to the input.",
    %         metadata={"model": "gpt-4o-mini"},
    %     )
    %     mlflow.log_assessment(trace_id="1234", assessment=feedback)
    % The following code annotates a trace with human-provided ground truth with source information.
    % When the source is not provided, the default source is set to "default" with type "HUMAN"
    % .. code-block:: python
    %     import mlflow
    %     from mlflow.entities import AssessmentSource, AssessmentSourceType, Expectation
    %     # Specify the annotator information as a source.
    %     source = AssessmentSource(
    %         source_type=AssessmentSourceType.HUMAN,
    %         source_id="john@example.com",
    %     )
    %     expectation = Expectation(
    %         name="expected_answer",
    %         value=42,
    %         source=source,
    %     )
    %     mlflow.log_assessment(trace_id="1234", assessment=expectation)
    % The expectation value can be any JSON-serializable value. For example, you may
    %  record the full LLM message as the expectation value.
    % .. code-block:: python
    %     import mlflow
    %     from mlflow.entities.assessment import Expectation
    %     expectation = Expectation(
    %         name="expected_message",
    %         # Full LLM message including expected tool calls
    %         value={
    %             "role": "assistant",
    %             "content": "The answer is 42.",
    %             "tool_calls": [
    %                 {
    %                     "id": "1234",
    %                     "type": "function",
    %                     "function": {"name": "add", "arguments": "40 + 2"},
    %                 }
    %             ],
    %         },
    %     )
    %     mlflow.log_assessment(trace_id="1234", assessment=expectation)
    % You can also log an error information during the feedback generation process. To do so,
    % provide an instance of :py:class:`~mlflow.entities.AssessmentError` to the `error`
    % parameter, and leave the `value` parameter as `None`.
    % .. code-block:: python
    %     import mlflow
    %     from mlflow.entities import AssessmentError, Feedback
    %     error = AssessmentError(
    %         error_code="RATE_LIMIT_EXCEEDED",
    %         error_message="Rate limit for the judge exceeded.",
    %     )
    %     feedback = Feedback(
    %         trace_id="1234",
    %         name="faithfulness",
    %         error=error,
    %     )
    %     mlflow.log_assessment(trace_id="1234", assessment=feedback)
    %
    %
    % Input arguments:
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["trace_id","assessment"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_assessment(varargin{1:i},pyargs(varargin{i+1:end}));
