const hasKey = (key) => {
  return key in process.env;
};

const assertRequired = (key) => {
  if (!hasKey(key)) {
    throw new Error(`Missing required environment variable "${key}"`);
  }
};

const get = (key) => {
  return process.env[key];
};

const getAsBoolean = (key) => {
  return process.env[key] ? JSON.parse(process.env[key]) : false;
};

const getRequired = (key) => {
  assertRequired(key);
  return process.env[key];
};

const isContinuousIntegrationMode = () => {
  return getAsBoolean("CI") === true;
};

module.exports = {
  assertRequired,
  get,
  getAsBoolean,
  getRequired,
  hasKey,
  isContinuousIntegrationMode,
};
