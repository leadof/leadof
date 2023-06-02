import { test, expect } from '@playwright/test';
import * as fs from 'fs';

test('performance report', async ({ page, browserName }) => {
  await page.goto('/');

  if (browserName === 'chromium') {
    const lighthouseOptions = {
      logLevel: 'info',
      output: 'html',
      onlyCategories: ['performance'],
      port: 8041,
    };

    const lighthouse = require('lighthouse/core/index.cjs');

    const runnerResult = await lighthouse(page.url(), lighthouseOptions as any);

    // `.report` is the HTML report as a string
    const reportHtml = runnerResult!.report;
    fs.writeFileSync('./lighthouse-report.html', reportHtml);
  }

  expect(true).toBe(true);
});
