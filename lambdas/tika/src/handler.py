import os
import boto3
from aws_lambda_powertools import Logger

logger = Logger(service="tika", level="INFO")

s3_resource = boto3.resource(
    "s3", region_name=os.environ.get("S3_REGION", "us-east-2")
)
s3_client = s3_resource.meta.client
s3_bucket = s3_resource.Bucket(os.environ.get("S3_BUCKET", "bug-h20-data"))


@logger.inject_lambda_context(log_event=True)
def lambda_handler(event, context):
    logger.info(f"Handling event: {event}")
