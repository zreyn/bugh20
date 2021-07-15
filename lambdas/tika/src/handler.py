import os
import boto3
from aws_lambda_powertools import Logger
import pdfplumber

logger = Logger(service="tika", level="INFO")

s3_bucket_name = os.environ.get("S3_BUCKET", "bug-h20-data")
s3_resource = boto3.resource("s3", region_name=os.environ.get("S3_REGION", "us-east-2"))
s3_client = s3_resource.meta.client


@logger.inject_lambda_context(log_event=True)
def lambda_handler(event, context):
    logger.info(f"Handling event: {event}")

    pdf_key = event.get("pdf_key")
    if not pdf_key:
        logger.info(f"Missing required field 'pdf_key' in event. Exiting")
        return

    logger.info(f"Getting {pdf_key} from S3...")
    pdf_file = s3_client.get_object(Key=pdf_key, Bucket=s3_bucket_name)["Body"].read()
    logger.info(f"Got file")
