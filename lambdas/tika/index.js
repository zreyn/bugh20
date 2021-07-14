const bunyan = require('bunyan');
const AWS = require('aws-sdk');
const tte = require('tika-text-extract');

const downloadFromS3 = async (key) => {
  const s3 = new AWS.S3();
  const s3Params = {
    Bucket: process.env.S3_BUCKET,
    Key: key,
  };

  const { Body } = await s3.getObject(s3Params).promise();
  return Body;
};

exports.handler = async (event, context) => {
  const logger = bunyan.createLogger({
    name: 'tika',
    level: (process.env.LOG_LEVEL || 'info').toLowerCase(),
  });

  logger.info('handling event', event);
  logger.info('event context', context);

  logger.info(`downloading ${event.pdf_key}`);
  const pdf = await downloadFromS3(event.pdf_key);

  logger.info('starting tika');
  await tte.startServer('/tmp/tika-server-1.14.jar');

  logger.info('extracting text');
  const extractedText = await tte.extract(pdf);
  logger.info(`${extractedText}`);

  return 'success';
};
