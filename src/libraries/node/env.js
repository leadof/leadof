const assertRequired = (key) => {
  if (!key in process.env) {
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
  isContinuousIntegrationMode,
};
