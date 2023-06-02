import { test, expect } from '@playwright/test';
import * as fs from 'fs';

const chromeDebugPort = 8041;

test('performance report', async ({ page, browserName }) => {
  if (browserName === 'chromium') {
    const lighthouse = require('lighthouse/core/index.cjs');

    // visit the home page
    // 1) the URL for this page will be used by lighthouse
    // 2) simulate a warm server (requests have already been made)
    await page.goto('/');

    const lighthouseOptions = {
      logLevel: 'info',
      output: 'html',
      port: chromeDebugPort,
    };

    const runnerResult = await lighthouse(page.url(), lighthouseOptions as any);

    // `.report` is the HTML report as a string
    const reportHtml = runnerResult!.report;

    await fs.promises.writeFile('./lighthouse-report.html', reportHtml);
  }

  // a single assertion to ensure the test go this far
  // and that test runners don't complain about an empty test
  expect(true).toBe(true);
});
