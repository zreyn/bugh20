import os
import boto3
from aws_lambda_powertools import Logger
import pdfplumber
import io

logger = Logger(service="tika", level="INFO")

s3_bucket_name = os.environ.get("S3_BUCKET", "bug-h20-data")
s3_resource = boto3.resource("s3", region_name=os.environ.get("S3_REGION", "us-east-2"))
s3_client = s3_resource.meta.client
s3_extract_prefix = os.environ.get("EXTRACT_PREFIX", "metadata/")


def extract_text(page):
    raw_text = page.extract_text()


@logger.inject_lambda_context(log_event=True)
def lambda_handler(event, context):
    logger.info(f"Handling event: {event}")

    pdf_key = event.get("pdf_key")
    if not pdf_key:
        logger.info(f"Missing required field 'pdf_key' in event. Exiting")
        return

    logger.info(f"Getting {pdf_key} from S3...")
    try:
        pdf_file = io.BytesIO(
            s3_client.get_object(Key=pdf_key, Bucket=s3_bucket_name)["Body"].read()
        )
    except Exception as e:
        logger.info(f"Error getting file: {e}")
        return

    logger.info(f"Opening with pdfplumber...")
    try:
        with pdfplumber.open(pdf_file) as pdf:
            logger.info(f"I see {len(pdf.pages)} pages")
            for i, page in enumerate(pdf.pages):
                logger.info(f"Page {i}")
                text = extract_text(page)
                logger.info(f"{text}")
        return "Done"
    except Exception as e:
        logger.info(f"Error extracting text from file: {e}")
        return
