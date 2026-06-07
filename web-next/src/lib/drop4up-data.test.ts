import { describe, expect, it } from "vitest";
import {
  createDocument,
  matchesJournalFilter,
  matchesJournalQuery,
  mergeDocuments,
  parseReflectionEntryDocument,
  readPreferences,
  sortEntriesByCreatedAt,
} from "./drop4up-data";
import type { ReflectionEntry } from "@/types/drop4up";

describe("Drop4Up data model", () => {
  it("round trips entries and preserves exact text", () => {
    const text = "  神的平安，今日仍然同在。\n\n「不要害怕。」\n\t阿們。  ";
    const entry = entryFixture({ text });
    const document = createDocument([entry], new Date("2026-05-07T10:00:00Z"));

    const restored = parseReflectionEntryDocument(JSON.stringify(document));

    expect(restored.entries[0].text).toBe(text);
    expect([...restored.entries[0].text].join("")).toBe([...text].join(""));
    expect(restored.entries[0]).toEqual(entry);
  });

  it("rejects malformed or unsupported restore documents", () => {
    expect(() => parseReflectionEntryDocument("{ nope")).toThrow();
    expect(() =>
      parseReflectionEntryDocument(
        JSON.stringify({ schemaVersion: 99, exportedAt: "2026-05-07T00:00:00Z", entries: [] }),
      ),
    ).toThrow(/Unsupported schemaVersion/);
  });

  it("merges without overwriting duplicate local entries", () => {
    const localText = "  Local text remains exact.\nAmen.  ";
    const restoredText = "  Restored text stays exact.\nSecond line.  ";
    const local = entryFixture({ id: "local-entry", text: localText });
    const incoming = createDocument([
      entryFixture({ id: "local-entry", text: "Do not overwrite." }),
      entryFixture({ id: "restored-entry", text: restoredText }),
    ]);

    const merged = mergeDocuments([local], incoming);

    expect(merged).toHaveLength(2);
    expect(merged.find((entry) => entry.id === "local-entry")?.text).toBe(
      localText,
    );
    expect(merged.find((entry) => entry.id === "restored-entry")?.text).toBe(
      restoredText,
    );
  });

  it("matches Traditional Chinese text, hashtags, source, and filters", () => {
    const favorite = entryFixture({
      text: "在安靜裡尋見平安。",
      source: "禱告",
      tags: ["平安"],
      isFavorite: true,
    });
    const plain = entryFixture({ id: "plain", text: "只留下安靜。" });

    expect(matchesJournalQuery(favorite, "平安")).toBe(true);
    expect(matchesJournalQuery(favorite, "#禱告")).toBe(true);
    expect(matchesJournalQuery(favorite, "#平安")).toBe(true);
    expect(matchesJournalQuery(plain, "不存在")).toBe(false);
    expect(matchesJournalFilter(favorite, { kind: "favorites" })).toBe(true);
    expect(matchesJournalFilter(plain, { kind: "favorites" })).toBe(false);
    expect(matchesJournalFilter(favorite, { kind: "taxonomy", label: "平安" })).toBe(true);
  });

  it("sorts entries by created date", () => {
    const older = entryFixture({
      id: "older",
      createdAt: "2026-05-06T00:00:00.000Z",
    });
    const newer = entryFixture({
      id: "newer",
      createdAt: "2026-05-07T00:00:00.000Z",
    });

    expect(sortEntriesByCreatedAt([older, newer]).map((entry) => entry.id)).toEqual([
      "newer",
      "older",
    ]);
  });

  it("reads preferences", () => {
    expect(readPreferences({ largeText: true })).toEqual({ largeText: true });
    expect(() => readPreferences({ largeText: "yes" })).toThrow();
  });
});

function entryFixture(overrides: Partial<ReflectionEntry> = {}): ReflectionEntry {
  return {
    id: "entry-1",
    text: "主啊，求你保守我的心。",
    source: "講道",
    tags: [],
    createdAt: "2026-05-07T08:00:00.000Z",
    updatedAt: "2026-05-07T08:00:00.000Z",
    isFavorite: false,
    ...overrides,
  };
}
