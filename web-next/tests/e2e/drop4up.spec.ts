import { expect, test } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.goto("/");
  await page.evaluate(() => localStorage.clear());
  await page.reload();
});

test("navigates four tabs and saves a local drop", async ({ page }) => {
  await expect(page.getByText("Drop4Up").first()).toBeVisible();

  await page.getByRole("button", { name: "Drop" }).click();
  await page.getByTestId("drop-text-input").fill("今天安靜記下一句，不改寫。");
  await page.getByRole("button", { name: /Save Drop/i }).click();

  await page.getByRole("button", { name: "Journal" }).click();
  await expect(page.getByText("今天安靜記下一句，不改寫。")).toBeVisible();

  await page.getByRole("button", { name: "Profile" }).click();
  await expect(page.getByText("本機紀錄")).toBeVisible();

  await page.getByRole("button", { name: "Home" }).click();
  await expect(page.getByTestId("home-reflection-text")).toContainText(
    "今天安靜記下一句，不改寫。",
  );
});

test("Journal search, favorite, edit, and delete", async ({ page }) => {
  await page.evaluate(() => {
    localStorage.setItem(
      "drop4up.reflectionEntries.v1",
      JSON.stringify({
        schemaVersion: 1,
        exportedAt: "2026-05-07T10:00:00.000Z",
        entries: [
          {
            id: "entry-e2e",
            text: "在安靜裡尋見平安。",
            source: "禱告",
            tags: ["平安"],
            createdAt: "2026-05-07T08:00:00.000Z",
            updatedAt: "2026-05-07T08:00:00.000Z",
            isFavorite: false,
          },
        ],
      }),
    );
  });
  await page.reload();
  await page.getByRole("button", { name: "Journal" }).click();
  await page.getByTestId("journal-search-input").fill("#平安");
  await expect(page.getByText("在安靜裡尋見平安。")).toBeVisible();

  await page.getByRole("button", { name: "收藏" }).click();
  await page.getByRole("button", { name: "編輯" }).click();
  await page.getByTestId("entry-detail-text-input").fill("  修改後保留空白。\n阿們。  ");
  await page.getByRole("button", { name: "儲存" }).click();
  await expect(page.getByText("修改後保留空白。")).toBeVisible();

  await page.getByRole("button", { name: "編輯" }).click();
  await page.getByRole("button", { name: "刪除" }).click();
  await page.getByRole("button", { name: "確認刪除" }).click();
  await expect(page.getByText("還沒有儲存的紀錄。")).toBeVisible();
});
