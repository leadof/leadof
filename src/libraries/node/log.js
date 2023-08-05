const winston = require("winston");
const path = require("path");

const env = require("./env");
const host = require("./host");

let logger;

const log = (level, message, metadata) => {
  if (!logger) {
    throw new Error(
      "Missing registered logger singleton. Did you forget to call `registerNamedLoggerSingleton`?",
    );
  }

  const winstonMetadata = Array.isArray(metadata)
    ? metadata.length === 0
      ? {}
      : metadata.length === 1
      ? metadata[0]
      : { argv: metadata }
    : metadata;

  logger.log(level, message, winstonMetadata);
};

const debug = (message, ...args) => log("debug", message, args);
const info = (message, ...args) => log("info", message, args);
const warn = (message, ...args) => log("warn", message, args);
const error = (message, ...args) => log("error", message, args);

const registerLoggerSingleton = (scriptFilePath) => {
  const scriptRelativeFilePath = host.getRelativeToRootPath(scriptFilePath);
  const outputDirectoryPath = host.getTaskOutputDirectoryPath(scriptFilePath);
  const cleanId = scriptRelativeFilePath.replace(/[\\.]/gi, "-");
  const logFileName = `${outputDirectoryPath}output.log`;
  const errorLogFileName = `${outputDirectoryPath}error.log`;

  if (logger) {
    return logger;
  }

  logger = winston.createLogger({
    level: process.env["DEBUG"] ? "debug" : "info",
    format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.json(),
    ),
    defaultMeta: { id: cleanId },
    transports: [
      //
      // - Write all logs with importance level of `error` or less to `error.log`
      // - Write all logs with importance level of `info` or less to `output.log`
      //
      new winston.transports.File({
        filename: errorLogFileName,
        level: "error",
      }),
      new winston.transports.File({ filename: logFileName }),
    ],
  });

  if (env.get("NODE_ENV") !== "production") {
    logger.add(
      new winston.transports.Console({
        format: winston.format.simple(),
      }),
    );
  }

  return logger;
};

module.exports = {
  debug,
  default: log,
  error,
  info,
  log,
  registerLoggerSingleton,
  warn,
};
