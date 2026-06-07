"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import {
  STORAGE_KEYS,
  createDocument,
  createEntryId,
  dateOnlyIso,
  defaultPreferences,
  mergeDocuments,
  parsePreferences,
  parseReflectionEntryDocument,
  readReflectionEntryDocument,
  sortEntriesByCreatedAt,
} from "@/lib/drop4up-data";
import type {
  Drop4UpPreferences,
  ReflectionEntry,
  ReflectionEntryDocument,
} from "@/types/drop4up";

type AddEntryInput = {
  text: string;
  source: string;
  tags: string[];
  dateValue?: string;
};

type UpdateEntryInput = {
  id: string;
  text: string;
  source: string;
  tags: string[];
  dateValue: string;
};

export type Drop4UpStore = {
  entries: ReflectionEntry[];
  preferences: Drop4UpPreferences;
  isLoaded: boolean;
  status: string | null;
  addEntry: (input: AddEntryInput) => void;
  updateEntry: (input: UpdateEntryInput) => void;
  toggleFavorite: (id: string) => void;
  deleteEntry: (id: string) => void;
  exportDocument: () => ReflectionEntryDocument;
  restoreDocument: (document: ReflectionEntryDocument) => void;
  mergeDocument: (document: ReflectionEntryDocument) => void;
  restoreFromText: (rawText: string, strategy: "merge" | "replace") => void;
  setLargeText: (largeText: boolean) => void;
  clearStatus: () => void;
};

export function useDrop4UpStore(): Drop4UpStore {
  const [entries, setEntries] = useState<ReflectionEntry[]>([]);
  const [preferences, setPreferences] =
    useState<Drop4UpPreferences>(defaultPreferences);
  const [isLoaded, setIsLoaded] = useState(false);
  const [status, setStatus] = useState<string | null>(null);

  useEffect(() => {
    queueMicrotask(() => {
      try {
        const entriesRaw = localStorage.getItem(STORAGE_KEYS.entries);
        if (entriesRaw) {
          setEntries(
            sortEntriesByCreatedAt(
              parseReflectionEntryDocument(entriesRaw).entries,
            ),
          );
        }

        const preferencesRaw = localStorage.getItem(STORAGE_KEYS.preferences);
        if (preferencesRaw) {
          setPreferences(parsePreferences(preferencesRaw));
        }
      } catch {
        setStatus("Local data could not be read. Restore from backup if needed.");
      } finally {
        setIsLoaded(true);
      }
    });
  }, []);

  const persistEntries = useCallback((nextEntries: ReflectionEntry[]) => {
    const sorted = sortEntriesByCreatedAt(nextEntries);
    localStorage.setItem(
      STORAGE_KEYS.entries,
      JSON.stringify(createDocument(sorted), null, 2),
    );
    setEntries(sorted);
  }, []);

  const persistPreferences = useCallback(
    (nextPreferences: Drop4UpPreferences) => {
      localStorage.setItem(
        STORAGE_KEYS.preferences,
        JSON.stringify(nextPreferences, null, 2),
      );
      setPreferences(nextPreferences);
    },
    [],
  );

  const addEntry = useCallback(
    ({ text, source, tags, dateValue }: AddEntryInput) => {
      const now = new Date();
      const createdAt = dateValue ? dateOnlyIso(dateValue) : now.toISOString();
      persistEntries([
        {
          id: createEntryId(),
          text,
          source,
          tags,
          createdAt,
          updatedAt: now.toISOString(),
          isFavorite: false,
        },
        ...entries,
      ]);
      setStatus("已儲存在本機。");
    },
    [entries, persistEntries],
  );

  const updateEntry = useCallback(
    ({ id, text, source, tags, dateValue }: UpdateEntryInput) => {
      const updatedAt = new Date().toISOString();
      persistEntries(
        entries.map((entry) =>
          entry.id === id
            ? {
                ...entry,
                text,
                source,
                tags,
                createdAt: dateOnlyIso(dateValue),
                updatedAt,
              }
            : entry,
        ),
      );
      setStatus("這一滴已更新。");
    },
    [entries, persistEntries],
  );

  const toggleFavorite = useCallback(
    (id: string) => {
      persistEntries(
        entries.map((entry) =>
          entry.id === id
            ? { ...entry, isFavorite: !entry.isFavorite }
            : entry,
        ),
      );
    },
    [entries, persistEntries],
  );

  const deleteEntry = useCallback(
    (id: string) => {
      persistEntries(entries.filter((entry) => entry.id !== id));
      setStatus("這一滴已刪除。");
    },
    [entries, persistEntries],
  );

  const exportDocument = useCallback(() => createDocument(entries), [entries]);

  const restoreDocument = useCallback(
    (document: ReflectionEntryDocument) => {
      persistEntries(document.entries);
      setStatus("本機紀錄已取代為備份內容。");
    },
    [persistEntries],
  );

  const mergeDocument = useCallback(
    (document: ReflectionEntryDocument) => {
      persistEntries(mergeDocuments(entries, document));
      setStatus("備份紀錄已合併到本機。");
    },
    [entries, persistEntries],
  );

  const restoreFromText = useCallback(
    (rawText: string, strategy: "merge" | "replace") => {
      const document = readReflectionEntryDocument(
        parseReflectionEntryDocument(rawText),
      );
      if (strategy === "merge") {
        persistEntries(mergeDocuments(entries, document));
        setStatus("備份紀錄已合併到本機。");
      } else {
        persistEntries(document.entries);
        setStatus("本機紀錄已取代為備份內容。");
      }
    },
    [entries, persistEntries],
  );

  const setLargeText = useCallback(
    (largeText: boolean) => {
      persistPreferences({ largeText });
      setStatus(largeText ? "已開啟大字體模式。" : "已恢復標準文字大小。");
    },
    [persistPreferences],
  );

  return useMemo(
    () => ({
      entries,
      preferences,
      isLoaded,
      status,
      addEntry,
      updateEntry,
      toggleFavorite,
      deleteEntry,
      exportDocument,
      restoreDocument,
      mergeDocument,
      restoreFromText,
      setLargeText,
      clearStatus: () => setStatus(null),
    }),
    [
      addEntry,
      deleteEntry,
      entries,
      exportDocument,
      isLoaded,
      mergeDocument,
      preferences,
      restoreDocument,
      restoreFromText,
      setLargeText,
      status,
      toggleFavorite,
      updateEntry,
    ],
  );
}
