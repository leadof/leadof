const fs = require("fs");
const path = require("path");
const dotenv = require("dotenv");

const pathExists = async (hostPath) => {
  try {
    await fs.promises.access(hostPath, fs.constants.F_OK);
    return true;
  } catch (e) {
    return false;
  }
};

const getPathName = (hostPath) => {
  return path.basename(hostPath).replace(path.extname(hostPath), "");
};

const getCurrentWorkingDirectoryPath = () => {
  return __dirname;
};

const getRelativePath = (...args) => {
  return path.join(...args);
};

const getRelativeToRootPath = (hostPath) => {
  return path.relative(
    path.join(getCurrentWorkingDirectoryPath(), "../../../"),
    hostPath,
  );
};

const deletePath = async (hostPath) => {
  return fs.promises.unlink(hostPath);
};

const writeFile = async (hostPath, content) => {
  return fs.promises.writeFile(hostPath, content, { encoding: "utf-8" });
};

const loadDotenv = async () => {
  dotenv.config();
};

module.exports = {
  deletePath,
  pathExists,
  getCurrentWorkingDirectoryPath,
  getPathName,
  getRelativePath,
  getRelativeToRootPath,
  loadDotenv,
  writeFile,
};
