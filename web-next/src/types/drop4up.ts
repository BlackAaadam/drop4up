export type ReflectionEntry = {
  id: string;
  text: string;
  source: string;
  tags: string[];
  createdAt: string;
  updatedAt: string;
  isFavorite: boolean;
};

export type ReflectionEntryDocument = {
  schemaVersion: 1;
  exportedAt: string;
  entries: ReflectionEntry[];
};

export type Drop4UpPreferences = {
  largeText: boolean;
};

export type Drop4UpTab = "home" | "drop" | "journal" | "profile";

export type JournalFilter =
  | { kind: "all" }
  | { kind: "favorites" }
  | { kind: "taxonomy"; label: string };
