import type {
  Drop4UpPreferences,
  JournalFilter,
  ReflectionEntry,
  ReflectionEntryDocument,
} from "@/types/drop4up";

export const ENTRY_DOCUMENT_SCHEMA_VERSION = 1;

export const STORAGE_KEYS = {
  entries: "drop4up.reflectionEntries.v1",
  preferences: "drop4up.preferences.v1",
} as const;

export const reflectionSourceOptions = [
  "講道",
  "禱告",
  "靈修",
  "閱讀",
  "其他",
] as const;

export const reflectionSuggestedTags = ["平安", "信心", "感恩", "愛"] as const;

export const defaultPreferences: Drop4UpPreferences = { largeText: false };

export function createEmptyDocument(now = new Date()): ReflectionEntryDocument {
  return {
    schemaVersion: ENTRY_DOCUMENT_SCHEMA_VERSION,
    exportedAt: now.toISOString(),
    entries: [],
  };
}

export function createDocument(
  entries: ReflectionEntry[],
  now = new Date(),
): ReflectionEntryDocument {
  return {
    schemaVersion: ENTRY_DOCUMENT_SCHEMA_VERSION,
    exportedAt: now.toISOString(),
    entries,
  };
}

export function parseReflectionEntryDocument(
  rawText: string,
): ReflectionEntryDocument {
  let decoded: unknown;
  try {
    decoded = JSON.parse(rawText);
  } catch (error) {
    throw new Error(`Reflection entries JSON is malformed: ${String(error)}`);
  }
  return readReflectionEntryDocument(decoded);
}

export function readReflectionEntryDocument(
  value: unknown,
): ReflectionEntryDocument {
  const object = readObject(value, "document");
  const schemaVersion = object.schemaVersion;
  if (schemaVersion !== ENTRY_DOCUMENT_SCHEMA_VERSION) {
    throw new Error(`Unsupported schemaVersion: ${String(schemaVersion)}`);
  }
  const exportedAt = readIsoString(object.exportedAt, "exportedAt");
  if (!Array.isArray(object.entries)) {
    throw new Error("entries must be a list.");
  }
  return {
    schemaVersion: ENTRY_DOCUMENT_SCHEMA_VERSION,
    exportedAt,
    entries: object.entries.map(readReflectionEntry),
  };
}

export function readReflectionEntry(value: unknown): ReflectionEntry {
  const object = readObject(value, "entry");
  const entry = {
    id: readString(object.id, "id"),
    text: readString(object.text, "text"),
    source: readString(object.source, "source"),
    tags: readStringList(object.tags, "tags"),
    createdAt: readIsoString(object.createdAt, "createdAt"),
    updatedAt: readIsoString(object.updatedAt, "updatedAt"),
    isFavorite: readBoolean(object.isFavorite, "isFavorite"),
  };
  return entry;
}

export function readPreferences(value: unknown): Drop4UpPreferences {
  const object = readObject(value, "preferences");
  return { largeText: readBoolean(object.largeText, "largeText") };
}

export function parsePreferences(rawText: string): Drop4UpPreferences {
  return readPreferences(JSON.parse(rawText));
}

export function mergeDocuments(
  localEntries: ReflectionEntry[],
  incomingDocument: ReflectionEntryDocument,
): ReflectionEntry[] {
  const existingIds = new Set(localEntries.map((entry) => entry.id));
  return sortEntriesByCreatedAt([
    ...localEntries,
    ...incomingDocument.entries.filter((entry) => !existingIds.has(entry.id)),
  ]);
}

export function sortEntriesByCreatedAt(
  entries: ReflectionEntry[],
): ReflectionEntry[] {
  return [...entries].sort((a, b) => {
    const createdCompare =
      new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    if (createdCompare !== 0) {
      return createdCompare;
    }
    return new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime();
  });
}

export function reflectionCandidates(
  entries: ReflectionEntry[],
  selectedTag: string | null,
): ReflectionEntry[] {
  const source =
    selectedTag == null
      ? entries
      : entries.filter(
          (entry) =>
            entry.source === selectedTag || entry.tags.includes(selectedTag),
        );
  return [...(source.length > 0 ? source : entries)]
    .sort((a, b) => {
      if (a.isFavorite !== b.isFavorite) {
        return a.isFavorite ? -1 : 1;
      }
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    })
    .slice(0, 3);
}

export function taxonomyStats(entries: ReflectionEntry[]) {
  const counts = new Map<string, number>();
  for (const entry of entries) {
    if (entry.source) {
      counts.set(entry.source, (counts.get(entry.source) ?? 0) + 1);
    }
    for (const tag of entry.tags) {
      if (tag) {
        counts.set(tag, (counts.get(tag) ?? 0) + 1);
      }
    }
  }
  return [...counts.entries()]
    .map(([label, count]) => ({ label, count }))
    .sort((a, b) => b.count - a.count || a.label.localeCompare(b.label, "zh-Hant"));
}

export function homeTagStats(entries: ReflectionEntry[]) {
  const stats = taxonomyStats(entries);
  if (stats.length > 0) {
    return stats.slice(0, 6);
  }
  return ["平安", "信心", "感恩", "愛", "禱告", "閱讀"].map((label) => ({
    label,
    count: null,
  }));
}

export function matchesJournalQuery(
  entry: ReflectionEntry,
  rawQuery: string,
): boolean {
  const query = rawQuery.trim().toLocaleLowerCase();
  if (!query) {
    return true;
  }
  if (query.startsWith("#")) {
    const taxonomy = query.slice(1);
    return [entry.source, ...entry.tags].some((value) =>
      value.toLocaleLowerCase().includes(taxonomy),
    );
  }
  return [entry.text, entry.source, ...entry.tags].some((value) =>
    value.toLocaleLowerCase().includes(query),
  );
}

export function matchesJournalFilter(
  entry: ReflectionEntry,
  filter: JournalFilter,
): boolean {
  if (filter.kind === "all") {
    return true;
  }
  if (filter.kind === "favorites") {
    return entry.isFavorite;
  }
  return entry.source === filter.label || entry.tags.includes(filter.label);
}

export function formatEntryDate(isoDate: string): string {
  const date = new Date(isoDate);
  return `${date.getFullYear()}.${twoDigits(date.getMonth() + 1)}.${twoDigits(
    date.getDate(),
  )}`;
}

export function dateInputValue(isoDate: string): string {
  const date = new Date(isoDate);
  return `${date.getFullYear()}-${twoDigits(date.getMonth() + 1)}-${twoDigits(
    date.getDate(),
  )}`;
}

export function dateOnlyIso(dateValue: string): string {
  const [year, month, day] = dateValue.split("-").map(Number);
  return new Date(Date.UTC(year, month - 1, day)).toISOString();
}

export function todayInputValue(now = new Date()): string {
  return `${now.getFullYear()}-${twoDigits(now.getMonth() + 1)}-${twoDigits(
    now.getDate(),
  )}`;
}

export function normalizeTag(value: string): string {
  const trimmed = value.trim();
  return trimmed.startsWith("#") ? trimmed.slice(1).trim() : trimmed;
}

export function createEntryId(): string {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return `entry-${crypto.randomUUID()}`;
  }
  return `entry-${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

function readObject(value: unknown, label: string): Record<string, unknown> {
  if (value !== null && typeof value === "object" && !Array.isArray(value)) {
    return value as Record<string, unknown>;
  }
  throw new Error(`${label} must be an object.`);
}

function readString(value: unknown, label: string): string {
  if (typeof value === "string") {
    return value;
  }
  throw new Error(`${label} must be a string.`);
}

function readIsoString(value: unknown, label: string): string {
  const text = readString(value, label);
  if (Number.isNaN(new Date(text).getTime())) {
    throw new Error(`${label} must be an ISO-8601 date.`);
  }
  return text;
}

function readBoolean(value: unknown, label: string): boolean {
  if (typeof value === "boolean") {
    return value;
  }
  throw new Error(`${label} must be a boolean.`);
}

function readStringList(value: unknown, label: string): string[] {
  if (!Array.isArray(value)) {
    throw new Error(`${label} must be a list.`);
  }
  return value.map((item) => readString(item, label));
}

function twoDigits(value: number): string {
  return value.toString().padStart(2, "0");
}
