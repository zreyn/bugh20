from src import handler

import pytest
import logging
from aws_lambda_context import LambdaContext
from botocore.stub import Stubber, ANY

logger = logging.getLogger()

lambda_context = LambdaContext()
lambda_context.function_name = "unit-test-lambda"
lambda_context.memory_limit_in_mb = 256
lambda_context.invoked_function_arn = "arn:unit:::test/tests"
lambda_context.aws_request_id = "12345"

valid_event = {}


@pytest.fixture(autouse=True)
def mock_env(monkeypatch):
    monkeypatch.setenv("S3_BUCKET", "bug-h20-data")
    monkeypatch.setenv("PDF_PREFIX", "pages")
    monkeypatch.setenv("EXTRACT_PREFIX", "metadata")


@pytest.fixture(autouse=True, scope="function")
def s3_client_stub():
    with Stubber(handler.s3_client) as s3_stubber:
        yield s3_stubber
        s3_stubber.assert_no_pending_responses()


@pytest.mark.parametrize(
    "event,context,expected_response",
    [
        (
            valid_event,
            lambda_context,
            None,
        ),
    ],
)
def test_handler_valid_event(event, context, expected_response, s3_client_stub):
    result = handler.lambda_handler(event, context)
    assert result == expected_response
