import { test, expect } from '@playwright/test';
import * as fs from 'fs';

test('performance report', async ({ page, browserName }) => {
  await page.goto('/');

  if (browserName === 'chromium') {
    await page.goto('http://127.0.0.1:8041/json/version');

    console.log('content', await page.content());

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
