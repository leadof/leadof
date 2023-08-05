const fs = require("fs");
const path = require("path");
const dotenv = require("dotenv");

const pathExists = async (hostPath) => {
  try {
    fs.accessSync(hostPath, fs.constants.F_OK);
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

const readFile = async (hostPath) => {
  return fs.promises.readFile(hostPath, { encoding: "utf-8" });
};

const readJson = async (hostPath) => {
  const content = await readFile(hostPath);
  return JSON.parse(content);
};

const writeFile = async (hostPath, content) => {
  return fs.promises.writeFile(hostPath, content, { encoding: "utf-8" });
};

const writeJson = async (hostPath, value) => {
  const content = JSON.stringify(value);
  return await writeFile(hostPath, content);
};

const loadDotenv = async () => {
  dotenv.config();
};

const getTaskOutputDirectoryPath = (scriptFilePath) => {
  const scriptName = path.basename(scriptFilePath);
  return `./.task-output/${scriptName}/`;
};

const getTaskOutputFilePath = (scriptFilePath, relativeFilePath) => {
  const scriptName = path.basename(scriptFilePath);
  return path.join(
    getTaskOutputDirectoryPath(scriptFilePath),
    `./${relativeFilePath}`,
  );
};

const mkdir = async (directoryPath, isRecursive) => {
  if (!(await pathExists(directoryPath))) {
    await fs.promises.mkdir(directoryPath, { recursive: isRecursive });
  }
};

module.exports = {
  deletePath,
  pathExists,
  getCurrentWorkingDirectoryPath,
  getPathName,
  getRelativePath,
  getRelativeToRootPath,
  getTaskOutputDirectoryPath,
  getTaskOutputFilePath,
  loadDotenv,
  mkdir,
  readFile,
  readJson,
  writeFile,
  writeJson,
};
