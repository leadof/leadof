const fs = require("fs");
const path = require("path");
const dotenv = require("dotenv");

const ansiRegex = ({ onlyFirst = false } = {}) => {
  const pattern = [
    "[\\u001B\\u009B][[\\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]+)*|[a-zA-Z\\d]+(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)",
    "(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-nq-uy=><~]))",
  ].join("|");

  return new RegExp(pattern, onlyFirst ? undefined : "g");
};

const escapeAnsiRegex = ansiRegex();

const sleep = (ms) => {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
};

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

const writeFile = async (
  hostPath,
  content,
  { cleanAnsiCharacters = true } = {},
) => {
  const cleanContent = cleanAnsiCharacters
    ? content.replace(escapeAnsiRegex, "")
    : content;

  return fs.promises.writeFile(hostPath, cleanContent, { encoding: "utf-8" });
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
  sleep,
  writeFile,
  writeJson,
};
