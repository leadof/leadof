const { exec } = require("child_process");
const waitOn = require("wait-on");

const port = 4200;
const url = `http://localhost:${port}/`;

const webServerProcess = exec(`pnpm ng serve --port ${port}`);

webServerProcess.stdout.pipe(process.stdout);
webServerProcess.stderr.pipe(process.stderr);

console.debug("Waiting for site to start...");

const waitOnOptions = {
  resources: [url],
  delay: 1000, // initial delay in ms, default 0
  interval: 100, // poll interval in ms, default 250ms
  simultaneous: 1, // limit to 1 connection per resource at a time
  timeout: 30000, // timeout in ms, default Infinity
  tcpTimeout: 1000, // tcp timeout in ms, default 300ms
  window: 1000, // stabilization time in ms, default 750ms
  proxy: false,
  strictSSL: false,
  followRedirect: true,
  validateStatus: function (status) {
    return status >= 200 && status < 300; // default if not provided
  },
};

waitOn(waitOnOptions, function (err) {
  if (err) {
    console.error("ERROR: failed to wait for website to start.");
    console.error(`ERROR: ${err.message}`);
    process.exit(1);
  }

  const lighthouseProcess = exec(
    `pnpm lighthouse ${url} --chrome-flags="--headless" --output=html --output-path=./performance-report.html --save-assets --disable-full-page-screenshot=false`,
  );

  lighthouseProcess.stdout.pipe(process.stdout);
  lighthouseProcess.stderr.pipe(process.stderr);

  lighthouseProcess.on("exit", function () {
    console.info("Lighthouse report successfully generated");

    if (webServerProcess && webServerProcess.exitCode === null) {
      webServerProcess.kill();
    }

    process.exit(0);
  });
});
