const bunyan = require('bunyan');

const aws = require('aws-sdk');

aws.config.update({ region: 'us-east-1' });

jest.createMockFromModule('bunyan');
jest.mock('bunyan');
const mockBunyanLogger = {
  trace: jest.fn(),
  info: jest.fn(),
  debug: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
};
bunyan.createLogger.mockImplementation(() => mockBunyanLogger);
bunyan.mockImplementation(() => mockBunyanLogger);

const index = require('./index');

let context = {};
let event = {};

describe('handler', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    context = {};
    event = {};
    process.env.S3_REGION = 'us-east-2';
    process.env.S3_BUCKET = 'bukkit';
    process.env.EXTRACT_PREFIX = 'metadata';

    const s3 = jest.fn();
    aws.S3 = s3;
    const s3Mock = jest.fn();
    s3Mock.getObject = jest.fn().mockReturnValue({
      promise: jest.fn().mockReturnValue(Promise.resolve(true)),
    });
    aws.S3.mockImplementation(() => s3Mock);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should log', async () => {
    event = {
      pdf_key: 'pages/test.pdf',
    };
    await index.handler(event, context);
    expect(mockBunyanLogger.info).toHaveBeenCalledTimes(6);
  });
});
