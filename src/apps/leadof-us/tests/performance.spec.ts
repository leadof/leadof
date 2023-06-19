import { test, expect } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';

const chromeDebugPort = 8041;

test('performance report', async ({ page, browserName }) => {
  if (browserName === 'chromium') {
    const testResultsDirectoryPath = path.join(
      process.cwd(),
      './test-results/'
    );
    const e2eTestResultsDirectoryPath = path.join(
      testResultsDirectoryPath,
      './e2e/'
    );
    const lighthouseReportFilePath = path.join(
      e2eTestResultsDirectoryPath,
      './lighthouse.html'
    );

    if (!fs.existsSync(testResultsDirectoryPath)) {
      fs.mkdirSync(testResultsDirectoryPath);
    }

    if (!fs.existsSync(e2eTestResultsDirectoryPath)) {
      fs.mkdirSync(e2eTestResultsDirectoryPath);
    }

    try {
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

      const runnerResult = await lighthouse(
        page.url(),
        lighthouseOptions as any
      );

      // `.report` is the HTML report as a string
      const reportHtml = runnerResult!.report;

      // write lighthouse report to file
      await fs.promises.writeFile(lighthouseReportFilePath, reportHtml, {
        encoding: 'utf-8',
      });

      console.info(
        `Lighthouse report written to file`,
        lighthouseReportFilePath
      );
    } catch (e: any) {
      // write lighthouse report to file
      await fs.promises.writeFile(
        lighthouseReportFilePath,
        `Unexpected error: ${e.message}`,
        { encoding: 'utf-8' }
      );

      console.error(
        `Lighthouse error report written to file`,
        lighthouseReportFilePath
      );

      expect(false, `Unexpected error: ${e.message}`).toBe(true);
    }
  }

  // a single assertion to ensure the test go this far
  // and that test runners don't complain about an empty test
  expect(true).toBe(true);
});
