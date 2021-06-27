const bunyan = require('bunyan');

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
    process.env.S3_REGION = '';
    process.env.S3_BUCKET = '';
    process.env.PDF_PREFIX = '';
    process.env.EXTRACT_PREFIX = '';
  });
});
