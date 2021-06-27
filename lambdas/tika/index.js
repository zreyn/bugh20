const bunyan = require('bunyan');

exports.handler = async (event, context) => {
  const logger = bunyan.createLogger({
    name: 'tika',
    level: (process.env.LOG_LEVEL || 'info').toLowerCase(),
  });

  logger.info('handling event', event);
  logger.info('event context', context);

  return 'success';
};
