'use strict';

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  console.error(`[ERROR] ${err.stack || err.message}`);

  const statusCode = err.statusCode || err.status || 500;

  res.status(statusCode).json({
    status: 'error',
    message:
      process.env.NODE_ENV === 'production' && statusCode === 500
        ? 'Internal Server Error'
        : err.message || 'Something went wrong',
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
  });
};

module.exports = errorHandler;
