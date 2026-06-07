import { beforeEach, describe, expect, it } from "vitest";
import { fireEvent, render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Drop4UpApp } from "./Drop4UpApp";
import { STORAGE_KEYS, createDocument } from "@/lib/drop4up-data";
import type { ReflectionEntry } from "@/types/drop4up";

describe("Drop4UpApp", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it("saves a Drop exactly and finds it in Journal", async () => {
    const user = userEvent.setup();
    render(<Drop4UpApp />);

    await user.click(screen.getByRole("button", { name: "Drop" }));
    const text = "  神的平安，今日仍然同在。\n\n「不要害怕。」\n\t阿們。  ";
    await user.type(screen.getByTestId("drop-text-input"), text);
    await user.click(screen.getByRole("button", { name: /Save Drop/i }));

    const saved = JSON.parse(localStorage.getItem(STORAGE_KEYS.entries) ?? "");
    expect(saved.entries[0].text).toBe(text);

    await user.click(screen.getByRole("button", { name: "Journal" }));
    expect(screen.getByText(/神的平安/)).toBeInTheDocument();

    await user.type(screen.getByTestId("journal-search-input"), "不要害怕");
    expect(screen.getByText(/神的平安/)).toBeInTheDocument();
  });

  it("restores by merge without overwriting local text and toggles preferences", async () => {
    localStorage.setItem(
      STORAGE_KEYS.entries,
      JSON.stringify(
        createDocument([
          entryFixture({ id: "local-entry", text: "  Local exact text.  " }),
        ]),
      ),
    );
    const user = userEvent.setup();
    render(<Drop4UpApp />);

    await user.click(screen.getByRole("button", { name: "Profile" }));
    await user.click(screen.getByRole("button", { name: /Restore JSON/i }));
    fireEvent.change(screen.getByPlaceholderText("貼上備份 JSON"), {
      target: {
        value: JSON.stringify(
        createDocument([
          entryFixture({ id: "local-entry", text: "Do not overwrite." }),
          entryFixture({ id: "restored-entry", text: "Restored exact text." }),
        ]),
      ),
      },
    });
    await user.click(screen.getByRole("button", { name: "還原" }));

    const saved = JSON.parse(localStorage.getItem(STORAGE_KEYS.entries) ?? "");
    expect(saved.entries).toHaveLength(2);
    expect(
      saved.entries.find((entry: ReflectionEntry) => entry.id === "local-entry").text,
    ).toBe("  Local exact text.  ");

    await user.click(screen.getByRole("button", { name: /Preferences/i }));
    await user.click(screen.getByRole("switch", { name: "大字體模式" }));
    expect(JSON.parse(localStorage.getItem(STORAGE_KEYS.preferences) ?? "")).toEqual({
      largeText: true,
    });
  });

  it("opens entry detail, edits without rewriting, favorites, and deletes", async () => {
    localStorage.setItem(
      STORAGE_KEYS.entries,
      JSON.stringify(createDocument([entryFixture({ text: "原本的文字。" })])),
    );
    const user = userEvent.setup();
    render(<Drop4UpApp />);

    await user.click(screen.getByRole("button", { name: "Journal" }));
    await user.click(screen.getByRole("button", { name: "編輯" }));
    await user.clear(screen.getByTestId("entry-detail-text-input"));
    await user.type(
      screen.getByTestId("entry-detail-text-input"),
      "  編輯後仍保留空白。\n阿們。  ",
    );
    await user.click(screen.getByRole("button", { name: "儲存" }));

    let saved = JSON.parse(localStorage.getItem(STORAGE_KEYS.entries) ?? "");
    expect(saved.entries[0].text).toBe("  編輯後仍保留空白。\n阿們。  ");

    await user.click(screen.getByRole("button", { name: "收藏" }));
    saved = JSON.parse(localStorage.getItem(STORAGE_KEYS.entries) ?? "");
    expect(saved.entries[0].isFavorite).toBe(true);

    await user.click(screen.getByRole("button", { name: "編輯" }));
    await user.click(screen.getByRole("button", { name: "刪除" }));
    await user.click(screen.getByRole("button", { name: "確認刪除" }));
    saved = JSON.parse(localStorage.getItem(STORAGE_KEYS.entries) ?? "");
    expect(saved.entries).toEqual([]);
  });
});

function entryFixture(overrides: Partial<ReflectionEntry> = {}): ReflectionEntry {
  return {
    id: "entry-1",
    text: "主啊，求你保守我的心。",
    source: "講道",
    tags: ["平安"],
    createdAt: "2026-05-07T08:00:00.000Z",
    updatedAt: "2026-05-07T08:00:00.000Z",
    isFavorite: false,
    ...overrides,
  };
}
