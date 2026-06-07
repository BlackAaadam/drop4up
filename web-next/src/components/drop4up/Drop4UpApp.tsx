"use client";

import { useMemo, useRef, useState, type ChangeEvent, type RefObject } from "react";
import {
  CalendarDays,
  Camera,
  Check,
  ChevronsUpDown,
  Download,
  FileUp,
  Filter,
  Image as ImageIcon,
  Info,
  Mic,
  PenLine,
  Plus,
  Search,
  Settings,
  Shuffle,
  SlidersHorizontal,
  Trash2,
  Upload,
  User,
  X,
  Bookmark,
  BookmarkCheck,
  type LucideIcon,
} from "lucide-react";
import { toPng } from "html-to-image";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Switch } from "@/components/ui/switch";
import {
  Drop4UpScaffold,
  Drop4UpTagChip,
  PrimaryDropButton,
  ScreenHeader,
  SoftIconButton,
  SoftSurface,
} from "@/components/drop4up/drop4up-ui";
import {
  dateInputValue,
  formatEntryDate,
  homeTagStats,
  matchesJournalFilter,
  matchesJournalQuery,
  normalizeTag,
  parseReflectionEntryDocument,
  reflectionCandidates,
  reflectionSourceOptions,
  reflectionSuggestedTags,
  sortEntriesByCreatedAt,
  taxonomyStats,
  todayInputValue,
} from "@/lib/drop4up-data";
import { useDrop4UpStore, type Drop4UpStore } from "@/lib/use-drop4up-store";
import { cn } from "@/lib/utils";
import type {
  Drop4UpTab,
  JournalFilter,
  ReflectionEntry,
  ReflectionEntryDocument,
} from "@/types/drop4up";

type DraftState = {
  text: string;
  source: string;
  tags: string[];
  manualTags: string[];
  dateValue: string;
  hasCustomDate: boolean;
};

const emptyFilter: JournalFilter = { kind: "all" };

export function Drop4UpApp() {
  const store = useDrop4UpStore();
  const [tab, setTab] = useState<Drop4UpTab>("home");
  const [journalFilter, setJournalFilter] = useState<JournalFilter>(emptyFilter);
  const [draft, setDraft] = useState<DraftState>(() => ({
    text: "",
    source: reflectionSourceOptions[0],
    tags: [],
    manualTags: [...reflectionSuggestedTags],
    dateValue: todayInputValue(),
    hasCustomDate: false,
  }));

  function openJournal(filter: JournalFilter = emptyFilter) {
    setJournalFilter(filter);
    setTab("journal");
  }

  return (
    <Drop4UpScaffold
      currentTab={tab}
      onTabChange={setTab}
      largeText={store.preferences.largeText}
    >
      {tab === "home" && (
        <HomeScreen
          entries={store.entries}
          onOpenProfile={() => setTab("profile")}
          onOpenJournal={openJournal}
        />
      )}
      {tab === "drop" && (
        <DropScreen
          draft={draft}
          setDraft={setDraft}
          store={store}
          onOpenProfile={() => setTab("profile")}
        />
      )}
      {tab === "journal" && (
        <JournalScreen
          store={store}
          filter={journalFilter}
          setFilter={setJournalFilter}
        />
      )}
      {tab === "profile" && <ProfileScreen store={store} />}
      {store.status && (
        <button
          type="button"
          className="fixed left-1/2 top-4 z-50 w-[min(330px,calc(100vw-32px))] -translate-x-1/2 rounded-[22px] bg-[color:var(--drop-card)] px-4 py-3 text-left text-sm text-[color:var(--drop-primary)] shadow-xl"
          onClick={store.clearStatus}
        >
          {store.status}
        </button>
      )}
    </Drop4UpScaffold>
  );
}

function HomeScreen({
  entries,
  onOpenProfile,
  onOpenJournal,
}: {
  entries: ReflectionEntry[];
  onOpenProfile: () => void;
  onOpenJournal: (filter?: JournalFilter) => void;
}) {
  const [selectedTag, setSelectedTag] = useState<string | null>(null);
  const [page, setPage] = useState(0);
  const tags = homeTagStats(entries);
  const reflections = reflectionCandidates(entries, selectedTag);
  const selectedEntry = reflections[page] ?? null;
  const pageCount = Math.max(reflections.length, 1);

  function selectTag(label: string) {
    setSelectedTag((current) => (current === label ? null : label));
    setPage(0);
  }

  return (
    <section>
      <ScreenHeader
        action={<SoftIconButton icon={User} label="個人設定" onClick={onOpenProfile} />}
      />
      <div className="mt-8">
        <h1 className="screen-title whitespace-pre-line">
          {"安靜下來，\n記得祂的同在。"}
        </h1>
        <p className="screen-subtitle mt-2">
          用一點時間回望今天心裡被觸動的地方。
        </p>
      </div>

      <SoftSurface variant="prominent" className="mt-5 p-5">
        <div className="flex items-center">
          <h2 className="text-lg font-semibold text-[color:var(--drop-text)]">
            今日回望
          </h2>
          <button
            type="button"
            aria-label="換一筆回望"
            disabled={pageCount <= 1}
            className="ml-auto text-[color:var(--drop-muted)] disabled:opacity-40"
            onClick={() => setPage((current) => (current + 1) % pageCount)}
          >
            <Shuffle className="h-5 w-5" />
          </button>
        </div>
        <div className="reflection-canvas mt-4">
          <div className="relative z-10 flex h-full min-h-[172px] flex-col p-6">
            <p
              className="line-clamp-2 text-[1.35rem] font-semibold leading-[1.28] text-[color:var(--drop-text)]"
              data-testid="home-reflection-text"
            >
              {selectedEntry?.text ??
                "儲存一滴後，這裡會成為安靜回看的地方。"}
            </p>
            <p className="mt-3 text-sm text-[color:var(--drop-muted)]">
              {selectedEntry
                ? `${formatEntryDate(selectedEntry.createdAt)} ・ ${
                    selectedTag ?? selectedEntry.tags[0] ?? selectedEntry.source
                  }`
                : "本機保存 ・ 無雲端同步"}
            </p>
          </div>
        </div>
        <div className="mt-3 flex justify-center gap-2">
          {Array.from({ length: pageCount }).map((_, index) => (
            <button
              key={index}
              type="button"
              aria-label={`第 ${index + 1} 筆回望`}
              className={cn(
                "h-[18px] w-[18px] rounded-full",
                page === index
                  ? "bg-[radial-gradient(circle,var(--drop-primary)_0_4px,transparent_5px)]"
                  : "bg-[radial-gradient(circle,rgb(154_163_173_/_38%)_0_3px,transparent_4px)]",
              )}
              onClick={() => setPage(index)}
            />
          ))}
        </div>
      </SoftSurface>

      <div className="mt-5 flex items-center">
        <h2 className="text-lg font-semibold">Explore Tags</h2>
        <button
          type="button"
          className="ml-auto text-sm font-semibold text-[color:var(--drop-primary)]"
          onClick={() =>
            onOpenJournal(
              selectedTag ? { kind: "taxonomy", label: selectedTag } : emptyFilter,
            )
          }
        >
          查看全部
        </button>
      </div>
      <div className="mt-3 flex flex-wrap gap-2.5">
        {tags.map((tag) => (
          <Drop4UpTagChip
            key={tag.label}
            label={tag.label}
            count={tag.count}
            selected={selectedTag === tag.label}
            onClick={() => selectTag(tag.label)}
          />
        ))}
      </div>
    </section>
  );
}

function DropScreen({
  draft,
  setDraft,
  store,
  onOpenProfile,
}: {
  draft: DraftState;
  setDraft: (draft: DraftState | ((current: DraftState) => DraftState)) => void;
  store: Drop4UpStore;
  onOpenProfile: () => void;
}) {
  const [message, setMessage] = useState<string | null>(null);
  const [addTagOpen, setAddTagOpen] = useState(false);
  const [tagText, setTagText] = useState("");

  function updateDraft(patch: Partial<DraftState>) {
    setDraft((current) => ({ ...current, ...patch }));
  }

  function toggleTag(tag: string) {
    updateDraft({
      tags: draft.tags.includes(tag)
        ? draft.tags.filter((item) => item !== tag)
        : [...draft.tags, tag],
    });
  }

  function addManualTag() {
    const normalized = normalizeTag(tagText);
    if (!normalized) {
      return;
    }
    setDraft((current) => ({
      ...current,
      manualTags: current.manualTags.includes(normalized)
        ? current.manualTags
        : [...current.manualTags, normalized],
      tags: current.tags.includes(normalized)
        ? current.tags
        : [...current.tags, normalized],
    }));
    setTagText("");
    setAddTagOpen(false);
  }

  function saveDrop() {
    if (!draft.text) {
      setMessage("請先寫下一點內容。");
      return;
    }
    store.addEntry({
      text: draft.text,
      source: draft.source,
      tags: draft.tags,
      dateValue: draft.hasCustomDate ? draft.dateValue : undefined,
    });
    setDraft({
      text: "",
      source: reflectionSourceOptions[0],
      tags: [],
      manualTags: [...reflectionSuggestedTags],
      dateValue: todayInputValue(),
      hasCustomDate: false,
    });
    setMessage("已儲存在本機。");
  }

  return (
    <section>
      <ScreenHeader
        action={<SoftIconButton icon={User} label="個人設定" onClick={onOpenProfile} />}
      />
      <div className="relative mt-8 min-h-[118px]">
        <h1 className="screen-title whitespace-pre-line">
          {"記下一滴\n心裡的回響。"}
        </h1>
        <p className="screen-subtitle mt-2">一句話就夠了。</p>
        <QuietLeaf />
      </div>
      <SoftSurface variant="prominent" className="mt-3 p-[18px]">
        <div className="flex items-center">
          <h2 className="text-lg font-semibold">心裡想記下什麼？</h2>
          <SoftIconButton
            icon={X}
            label="清空"
            size="sm"
            onClick={() => updateDraft({ text: "" })}
          />
        </div>
        <SoftSurface variant="inset" className="mt-3 h-[122px] rounded-[27px] p-4">
          <textarea
            aria-label="Drop text"
            data-testid="drop-text-input"
            className="quiet-field h-full resize-none text-[0.98rem] leading-relaxed"
            maxLength={300}
            placeholder="Drop something here..."
            value={draft.text}
            onChange={(event) => updateDraft({ text: event.target.value })}
          />
        </SoftSurface>
        <div className="mt-3 flex items-center gap-2">
          <SoftSurface variant="inset" className="rounded-full px-3 py-2">
            <label className="flex items-center gap-2 text-sm font-semibold">
              <CalendarDays className="h-4 w-4 text-[color:var(--drop-primary)]" />
              <input
                aria-label="日期"
                type="date"
                max={todayInputValue()}
                value={draft.dateValue}
                className="bg-transparent text-[color:var(--drop-text)] outline-none"
                onChange={(event) =>
                  updateDraft({
                    dateValue: event.target.value,
                    hasCustomDate: true,
                  })
                }
              />
            </label>
          </SoftSurface>
        </div>
        <div className="mt-3 flex gap-2 overflow-x-auto pb-1">
          {reflectionSourceOptions.map((source) => (
            <Drop4UpTagChip
              key={source}
              label={source}
              selected={draft.source === source}
              onClick={() => updateDraft({ source })}
            />
          ))}
        </div>
        <div className="mt-2 flex gap-2 overflow-x-auto pb-1">
          {draft.manualTags.map((tag) => (
            <Drop4UpTagChip
              key={tag}
              label={`#${tag}`}
              selected={draft.tags.includes(tag)}
              onClick={() => toggleTag(tag)}
            />
          ))}
          <button
            type="button"
            aria-label="新增標籤"
            className="tag-chip h-[34px] w-[36px] justify-center px-0"
            onClick={() => setAddTagOpen(true)}
          >
            <Plus className="h-4 w-4" />
          </button>
        </div>
        <div className="mt-4 flex items-center gap-2">
          <SoftIconButton
            icon={Mic}
            label="語音輸入"
            onClick={() => setMessage("語音輸入是未來功能，這版先保留文字。")}
          />
          <SoftIconButton
            icon={Camera}
            label="相機輸入"
            onClick={() => setMessage("相機輸入是未來功能，這版先保留文字。")}
          />
          <PrimaryDropButton className="ml-auto w-[174px]" label="Save Drop" onClick={saveDrop} />
        </div>
        {message && (
          <p className="mt-3 text-sm font-medium text-[color:var(--drop-primary)]">
            {message}
          </p>
        )}
      </SoftSurface>

      <Dialog open={addTagOpen} onOpenChange={setAddTagOpen}>
        <DialogContent className="dialog-panel">
          <SoftSurface variant="prominent" className="p-5">
            <DialogHeader>
              <DialogTitle>新增標籤</DialogTitle>
              <DialogDescription>標籤只用來整理，不會改寫內容。</DialogDescription>
            </DialogHeader>
            <SoftSurface variant="inset" className="mt-4 rounded-full px-4 py-3">
              <input
                autoFocus
                className="quiet-field"
                placeholder="#標籤"
                value={tagText}
                onChange={(event) => setTagText(event.target.value)}
                onKeyDown={(event) => {
                  if (event.key === "Enter") {
                    addManualTag();
                  }
                }}
              />
            </SoftSurface>
            <div className="mt-4 flex gap-3">
              <button className="tag-chip flex-1 justify-center" onClick={() => setAddTagOpen(false)}>
                取消
              </button>
              <PrimaryDropButton className="flex-1" label="加入" icon={Plus} onClick={addManualTag} />
            </div>
          </SoftSurface>
        </DialogContent>
      </Dialog>
    </section>
  );
}

function JournalScreen({
  store,
  filter,
  setFilter,
}: {
  store: Drop4UpStore;
  filter: JournalFilter;
  setFilter: (filter: JournalFilter) => void;
}) {
  const [query, setQuery] = useState("");
  const [showAll, setShowAll] = useState(false);
  const [filterOpen, setFilterOpen] = useState(false);
  const [editingEntry, setEditingEntry] = useState<ReflectionEntry | null>(null);
  const [visualEntry, setVisualEntry] = useState<ReflectionEntry | null>(null);

  const visibleEntries = useMemo(
    () =>
      store.entries.filter(
        (entry) => matchesJournalQuery(entry, query) && matchesJournalFilter(entry, filter),
      ),
    [filter, query, store.entries],
  );
  const displayedEntries = showAll ? visibleEntries : visibleEntries.slice(0, 3);
  const canToggleAll = visibleEntries.length > 3;

  function selectFilter(nextFilter: JournalFilter) {
    setFilter(nextFilter);
    setShowAll(false);
    setFilterOpen(false);
  }

  return (
    <section className="flex min-h-full flex-col">
      <ScreenHeader
        action={<SoftIconButton icon={SlidersHorizontal} label="篩選" onClick={() => setFilterOpen(true)} />}
      />
      <div className="mt-7">
        <h1 className="screen-title">Journal</h1>
        <p className="screen-subtitle mt-2">搜尋、整理，安靜回看每一滴。</p>
      </div>
      <div className="mt-4 flex items-center gap-3">
        <SoftSurface variant="inset" className="flex h-11 flex-1 items-center gap-2 rounded-full px-4">
          <Search className="h-5 w-5 text-[color:var(--drop-muted)]" />
          <input
            aria-label="搜尋 drops"
            data-testid="journal-search-input"
            className="quiet-field text-sm"
            placeholder="搜尋 drops"
            value={query}
            onChange={(event) => {
              setQuery(event.target.value);
              setShowAll(false);
            }}
          />
        </SoftSurface>
        <SoftIconButton icon={Filter} label="篩選" onClick={() => setFilterOpen(true)} />
      </div>
      {filter.kind !== "all" && (
        <button
          type="button"
          className="tag-chip tag-chip-selected mt-3 self-start"
          onClick={() => setFilter(emptyFilter)}
        >
          篩選：{filter.kind === "favorites" ? "收藏" : `#${filter.label}`}
          <X className="h-3.5 w-3.5" />
        </button>
      )}
      <div className="mt-4 flex items-center">
        <h2 className="text-lg font-semibold">Recent Drops</h2>
        {canToggleAll && (
          <button
            type="button"
            className="ml-auto text-sm font-semibold text-[color:var(--drop-primary)]"
            onClick={() => setShowAll((current) => !current)}
          >
            {showAll ? "收合" : "查看全部"}
          </button>
        )}
      </div>
      <div className="mt-3 flex flex-1 flex-col gap-3">
        {!store.isLoaded && <JournalState message="正在讀取本機紀錄..." />}
        {store.isLoaded && store.entries.length === 0 && (
          <JournalState message="還沒有儲存的紀錄。" />
        )}
        {store.isLoaded && store.entries.length > 0 && displayedEntries.length === 0 && (
          <JournalState message="找不到符合的紀錄。" />
        )}
        {displayedEntries.map((entry) => (
          <JournalEntryCard
            key={entry.id}
            entry={entry}
            onEdit={() => setEditingEntry(entry)}
            onFavorite={() => store.toggleFavorite(entry.id)}
          />
        ))}
      </div>
      <PrimaryDropButton
        className="mt-4 w-full"
        icon={ImageIcon}
        label="Create Visual Card"
        onClick={() => setVisualEntry(displayedEntries[0] ?? null)}
      />

      <FilterDialog
        open={filterOpen}
        onOpenChange={setFilterOpen}
        entries={store.entries}
        selectedFilter={filter}
        onSelect={selectFilter}
      />
      {editingEntry && (
        <EntryDetailDialog
          entry={editingEntry}
          store={store}
          onOpenChange={(open) => {
            if (!open) {
              setEditingEntry(null);
            }
          }}
          onVisualCard={(entry) => setVisualEntry(entry)}
        />
      )}
      <VisualCardDialog
        entry={visualEntry}
        open={visualEntry !== null}
        onOpenChange={(open) => {
          if (!open) {
            setVisualEntry(null);
          }
        }}
      />
    </section>
  );
}

function ProfileScreen({ store }: { store: Drop4UpStore }) {
  const [dialog, setDialog] = useState<"backup" | "restore" | "preferences" | "about" | null>(null);
  const favoriteCount = store.entries.filter((entry) => entry.isFavorite).length;
  const sourceCount = new Set(store.entries.map((entry) => entry.source).filter(Boolean)).size;
  const tagCount = new Set(store.entries.flatMap((entry) => entry.tags)).size;
  const latest = sortEntriesByCreatedAt(store.entries)[0]?.createdAt;

  return (
    <section>
      <ScreenHeader
        action={<SoftIconButton icon={Settings} label="偏好設定" onClick={() => setDialog("preferences")} />}
      />
      <div className="mt-7">
        <h1 className="screen-title">Profile</h1>
        <p className="screen-subtitle mt-2">管理本機資料，保留安靜回看的空間。</p>
      </div>
      <SoftSurface variant="prominent" className="mt-4 p-4">
        <div className="flex gap-4">
          <IconBadge icon={User} />
          <div>
            <h2 className="text-lg font-semibold">本機紀錄</h2>
            <p className="mt-1 text-sm text-[color:var(--drop-muted)]">
              Saved locally on this device.
            </p>
          </div>
        </div>
        <div className="mt-4 flex flex-wrap gap-2">
          <Metric label="Drops" value={store.entries.length} />
          <Metric label="Favorites" value={favoriteCount} />
          <Metric label="Sources" value={sourceCount} />
          <Metric label="Tags" value={tagCount} />
        </div>
        <p className="mt-4 text-sm text-[color:var(--drop-muted)]">
          {latest ? `Latest save: ${formatEntryDate(latest)}` : "尚未儲存任何紀錄。"}
        </p>
      </SoftSurface>
      <div className="mt-3 space-y-2.5">
        <ProfileAction icon={Download} title="Backup JSON" subtitle="Copy a local prototype backup." onClick={() => setDialog("backup")} />
        <ProfileAction icon={Upload} title="Restore JSON" subtitle="Paste a backup to merge or replace local drops." onClick={() => setDialog("restore")} />
        <ProfileAction icon={SlidersHorizontal} title="Preferences" subtitle="Quiet local options for readability." onClick={() => setDialog("preferences")} />
        <ProfileAction icon={Info} title="About Drop4Up" subtitle="Version, prototype scope, and data notes." onClick={() => setDialog("about")} />
      </div>
      <SoftSurface variant="inset" className="mt-4 flex items-center gap-3 rounded-[22px] px-4 py-3">
        <DropletMini />
        <p className="line-clamp-1 text-sm text-[color:var(--drop-muted)]">
          Prototype data stays local unless you export it.
        </p>
      </SoftSurface>

      <ProfileDialog open={dialog !== null} onOpenChange={(open) => !open && setDialog(null)}>
        {dialog === "backup" && <BackupPanel store={store} />}
        {dialog === "restore" && (
          <RestorePanel store={store} onDone={() => setDialog(null)} />
        )}
        {dialog === "preferences" && <PreferencesPanel store={store} />}
        {dialog === "about" && <AboutPanel />}
      </ProfileDialog>
    </section>
  );
}

function JournalEntryCard({
  entry,
  onEdit,
  onFavorite,
}: {
  entry: ReflectionEntry;
  onEdit: () => void;
  onFavorite: () => void;
}) {
  return (
    <SoftSurface className="rounded-[24px] px-4 py-3">
      <div className="flex items-center">
        <p className="text-sm text-[color:var(--drop-muted)]">{formatEntryDate(entry.createdAt)}</p>
        <button
          type="button"
          aria-label={entry.isFavorite ? "取消收藏" : "收藏"}
          className="ml-auto text-[color:var(--drop-primary)]"
          onClick={onFavorite}
        >
          {entry.isFavorite ? <BookmarkCheck className="h-5 w-5" /> : <Bookmark className="h-5 w-5 text-[color:var(--drop-muted)]" />}
        </button>
        <button
          type="button"
          aria-label="編輯"
          className="ml-3 text-[color:var(--drop-muted)]"
          onClick={onEdit}
        >
          <PenLine className="h-5 w-5" />
        </button>
      </div>
      <button type="button" className="mt-2 block w-full text-left" onClick={onEdit}>
        <p className="line-clamp-2 whitespace-pre-wrap text-[0.95rem] leading-relaxed">
          {entry.text}
        </p>
      </button>
      {(entry.source || entry.tags.length > 0) && (
        <div className="mt-2 flex flex-wrap gap-2">
          {entry.source && <MiniTag label={`#${entry.source}`} />}
          {entry.tags.map((tag) => (
            <MiniTag key={tag} label={`#${tag}`} />
          ))}
        </div>
      )}
    </SoftSurface>
  );
}

function EntryDetailDialog({
  entry,
  store,
  onOpenChange,
  onVisualCard,
}: {
  entry: ReflectionEntry;
  store: Drop4UpStore;
  onOpenChange: (open: boolean) => void;
  onVisualCard: (entry: ReflectionEntry) => void;
}) {
  const [text, setText] = useState(entry.text);
  const [source, setSource] = useState(entry.source || reflectionSourceOptions[0]);
  const [tags, setTags] = useState<string[]>(entry.tags);
  const [manualTags, setManualTags] = useState<string[]>([
    ...new Set([...reflectionSuggestedTags, ...entry.tags]),
  ]);
  const [dateValue, setDateValue] = useState(dateInputValue(entry.createdAt));
  const [addTagOpen, setAddTagOpen] = useState(false);
  const [tagText, setTagText] = useState("");
  const [confirmDelete, setConfirmDelete] = useState(false);

  function save() {
    store.updateEntry({ id: entry.id, text, source, tags, dateValue });
    onOpenChange(false);
  }

  function addTag() {
    const normalized = normalizeTag(tagText);
    if (!normalized) {
      return;
    }
    setManualTags((current) =>
      current.includes(normalized) ? current : [...current, normalized],
    );
    setTags((current) =>
      current.includes(normalized) ? current : [...current, normalized],
    );
    setTagText("");
    setAddTagOpen(false);
  }

  return (
    <>
      <Dialog open onOpenChange={onOpenChange}>
        <DialogContent className="dialog-panel">
          <SoftSurface variant="prominent" className="p-5">
            <div className="flex items-center">
              <DialogTitle>編輯 Drop</DialogTitle>
              <DialogDescription className="sr-only">
                Edit the saved local drop without rewriting the original text.
              </DialogDescription>
              <SoftIconButton className="ml-auto" icon={X} label="關閉" size="sm" onClick={() => onOpenChange(false)} />
            </div>
            <SoftSurface variant="inset" className="mt-4 h-[148px] rounded-[22px] p-4">
              <textarea
                data-testid="entry-detail-text-input"
                className="quiet-field h-full resize-none leading-relaxed"
                value={text}
                onChange={(event) => setText(event.target.value)}
              />
            </SoftSurface>
            <div className="mt-3">
              <SoftSurface variant="inset" className="inline-flex rounded-full px-3 py-2">
                <label className="flex items-center gap-2 text-sm font-semibold">
                  <CalendarDays className="h-4 w-4 text-[color:var(--drop-primary)]" />
                  <input
                    aria-label="編輯日期"
                    type="date"
                    max={todayInputValue()}
                    value={dateValue}
                    className="bg-transparent outline-none"
                    onChange={(event) => setDateValue(event.target.value)}
                  />
                </label>
              </SoftSurface>
            </div>
            <div className="mt-3 flex gap-2 overflow-x-auto pb-1">
              {reflectionSourceOptions.map((option) => (
                <Drop4UpTagChip
                  key={option}
                  label={option}
                  selected={source === option}
                  onClick={() => setSource(option)}
                />
              ))}
            </div>
            <div className="mt-2 flex gap-2 overflow-x-auto pb-1">
              {manualTags.map((tag) => (
                <Drop4UpTagChip
                  key={tag}
                  label={`#${tag}`}
                  selected={tags.includes(tag)}
                  onClick={() =>
                    setTags((current) =>
                      current.includes(tag)
                        ? current.filter((item) => item !== tag)
                        : [...current, tag],
                    )
                  }
                />
              ))}
              <button type="button" className="tag-chip" onClick={() => setAddTagOpen(true)}>
                <Plus className="h-4 w-4" />
              </button>
            </div>
            {addTagOpen && (
              <SoftSurface variant="inset" className="mt-3 flex items-center rounded-full px-3 py-2">
                <input
                  autoFocus
                  className="quiet-field"
                  placeholder="#標籤"
                  value={tagText}
                  onChange={(event) => setTagText(event.target.value)}
                  onKeyDown={(event) => {
                    if (event.key === "Enter") {
                      addTag();
                    }
                  }}
                />
                <button className="text-[color:var(--drop-primary)]" onClick={addTag}>
                  <Check className="h-5 w-5" />
                </button>
              </SoftSurface>
            )}
            <div className="mt-5 flex flex-wrap gap-3">
              <button className="tag-chip" onClick={() => onVisualCard({ ...entry, text, source, tags, createdAt: new Date(dateValue).toISOString() })}>
                <ImageIcon className="h-4 w-4" />
                視覺卡片
              </button>
              <button className="tag-chip" onClick={() => setConfirmDelete(true)}>
                <Trash2 className="h-4 w-4" />
                刪除
              </button>
              <PrimaryDropButton className="ml-auto min-w-[122px]" label="儲存" icon={Check} onClick={save} />
            </div>
          </SoftSurface>
        </DialogContent>
      </Dialog>
      <AlertDialog open={confirmDelete} onOpenChange={setConfirmDelete}>
        <AlertDialogContent className="dialog-panel">
          <SoftSurface variant="prominent" className="p-5">
            <AlertDialogHeader>
              <AlertDialogTitle>刪除這一滴？</AlertDialogTitle>
              <AlertDialogDescription>
                這會從本機資料移除，不會影響已匯出的備份。
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter className="mt-5 flex-row gap-3">
              <AlertDialogCancel className="tag-chip flex-1 border-0 bg-transparent shadow-none">
                取消
              </AlertDialogCancel>
              <AlertDialogAction
                className="primary-drop-button flex-1 border-0"
                onClick={() => {
                  store.deleteEntry(entry.id);
                  setConfirmDelete(false);
                  onOpenChange(false);
                }}
              >
                確認刪除
              </AlertDialogAction>
            </AlertDialogFooter>
          </SoftSurface>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}

function FilterDialog({
  open,
  onOpenChange,
  entries,
  selectedFilter,
  onSelect,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  entries: ReflectionEntry[];
  selectedFilter: JournalFilter;
  onSelect: (filter: JournalFilter) => void;
}) {
  const stats = taxonomyStats(entries);
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="dialog-panel">
        <SoftSurface variant="prominent" className="p-5">
          <DialogHeader>
            <DialogTitle>篩選 Journal</DialogTitle>
            <DialogDescription>依收藏、來源或標籤安靜整理。</DialogDescription>
          </DialogHeader>
          <div className="mt-4 flex flex-wrap gap-2">
            <Drop4UpTagChip
              label="全部"
              selected={selectedFilter.kind === "all"}
              onClick={() => onSelect(emptyFilter)}
            />
            <Drop4UpTagChip
              label="收藏"
              selected={selectedFilter.kind === "favorites"}
              onClick={() => onSelect({ kind: "favorites" })}
            />
            {stats.map((stat) => (
              <Drop4UpTagChip
                key={stat.label}
                label={`#${stat.label}`}
                count={stat.count}
                selected={
                  selectedFilter.kind === "taxonomy" &&
                  selectedFilter.label === stat.label
                }
                onClick={() => onSelect({ kind: "taxonomy", label: stat.label })}
              />
            ))}
          </div>
        </SoftSurface>
      </DialogContent>
    </Dialog>
  );
}

function VisualCardDialog({
  entry,
  open,
  onOpenChange,
}: {
  entry: ReflectionEntry | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const cardRef = useRef<HTMLDivElement>(null);
  const [error, setError] = useState<string | null>(null);
  const [isSaving, setIsSaving] = useState(false);

  async function downloadCard() {
    if (!entry || !cardRef.current || isSaving) {
      return;
    }
    setIsSaving(true);
    setError(null);
    try {
      const dataUrl = await toPng(cardRef.current, {
        cacheBust: true,
        pixelRatio: 3,
        backgroundColor: "#FBFBFA",
      });
      const link = document.createElement("a");
      link.download = `Drop4Up_Visual_${dateInputValue(entry.createdAt)}.png`;
      link.href = dataUrl;
      link.click();
    } catch {
      setError("視覺卡片暫時無法建立，請稍後再試。");
    } finally {
      setIsSaving(false);
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="dialog-panel">
        <SoftSurface variant="prominent" className="p-5">
          <DialogHeader>
            <DialogTitle>視覺卡片預覽</DialogTitle>
            <DialogDescription>下載前會保留這一滴的原文。</DialogDescription>
          </DialogHeader>
          {entry ? (
            <VisualCardPreview entry={entry} refObject={cardRef} />
          ) : (
            <p className="mt-4 text-sm text-[color:var(--drop-muted)]">
              請先選擇或儲存一滴，再建立視覺卡片。
            </p>
          )}
          {error && <p className="mt-3 text-sm text-[color:var(--drop-primary)]">{error}</p>}
          <div className="mt-5 flex justify-end gap-3">
            <button className="tag-chip" onClick={() => onOpenChange(false)}>
              完成
            </button>
            {entry && (
              <PrimaryDropButton
                label={isSaving ? "建立中" : "下載 PNG"}
                icon={Download}
                onClick={downloadCard}
              />
            )}
          </div>
        </SoftSurface>
      </DialogContent>
    </Dialog>
  );
}

function VisualCardPreview({
  entry,
  refObject,
}: {
  entry: ReflectionEntry;
  refObject: RefObject<HTMLDivElement | null>;
}) {
  const tags = [entry.source, ...entry.tags].filter(Boolean).slice(0, 3);
  return (
    <div
      ref={refObject}
      className="reflection-canvas mt-4 flex h-[236px] w-full flex-col p-6"
    >
      <p className="relative z-10 text-sm font-semibold text-[color:var(--drop-primary)]">
        Drop4Up
      </p>
      <div className="relative z-10 mt-auto">
        <p className="line-clamp-4 whitespace-pre-wrap text-lg font-semibold leading-snug">
          {entry.text}
        </p>
        <div className="mt-4 flex flex-wrap gap-2 text-xs text-[color:var(--drop-muted)]">
          <span>{formatEntryDate(entry.createdAt)}</span>
          {tags.map((tag) => (
            <span key={tag} className="rounded-full bg-white/55 px-2 py-1">
              #{tag}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

function ProfileDialog({
  open,
  onOpenChange,
  children,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  children: React.ReactNode;
}) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="dialog-panel">
        <SoftSurface variant="prominent" className="p-5">
          <DialogDescription className="sr-only">
            Drop4Up profile action dialog
          </DialogDescription>
          {children}
        </SoftSurface>
      </DialogContent>
    </Dialog>
  );
}

function BackupPanel({ store }: { store: Drop4UpStore }) {
  function downloadBackup() {
    const document = store.exportDocument();
    const blob = new Blob([`${JSON.stringify(document, null, 2)}\n`], {
      type: "application/json;charset=utf-8",
    });
    const url = URL.createObjectURL(blob);
    const link = documentElement("a");
    link.href = url;
    link.download = `Drop4Up_Backup_${todayInputValue()}.drop4up`;
    link.click();
    URL.revokeObjectURL(url);
  }

  return (
    <>
      <PanelTitle icon={Download} title="備份資料" />
      <p className="mt-4 text-sm leading-relaxed text-[color:var(--drop-muted)]">
        儲存一份 Drop4Up 本機備份檔。這版不直接暴露原始資料區塊，只下載檔案。
      </p>
      <SoftSurface variant="inset" className="mt-4 flex items-center gap-3 rounded-[22px] p-4">
        <Download className="h-5 w-5 text-[color:var(--drop-primary)]" />
        <p className="text-sm text-[color:var(--drop-muted)]">
          檔名會以 Drop4Up_Backup 開頭，方便日後還原。
        </p>
      </SoftSurface>
      <PrimaryDropButton className="mt-5 w-full" label="儲存備份檔" icon={Download} onClick={downloadBackup} />
    </>
  );
}

function RestorePanel({
  store,
  onDone,
}: {
  store: Drop4UpStore;
  onDone: () => void;
}) {
  const [strategy, setStrategy] = useState<"merge" | "replace">("merge");
  const [rawText, setRawText] = useState("");
  const [pendingDocument, setPendingDocument] =
    useState<ReflectionEntryDocument | null>(null);
  const [error, setError] = useState<string | null>(null);

  function restore(document: ReflectionEntryDocument | null = pendingDocument) {
    setError(null);
    try {
      const parsed = document ?? parseReflectionEntryDocument(rawText);
      if (strategy === "merge") {
        store.mergeDocument(parsed);
      } else {
        store.restoreDocument(parsed);
      }
      onDone();
    } catch {
      setError("備份格式不正確，沒有覆蓋本機資料。");
    }
  }

  async function readFile(event: ChangeEvent<HTMLInputElement>) {
    setError(null);
    const file = event.target.files?.[0];
    if (!file) {
      return;
    }
    try {
      const text = await file.text();
      const document = parseReflectionEntryDocument(text);
      setPendingDocument(document);
      setRawText(text);
    } catch {
      setPendingDocument(null);
      setError("這個檔案不是可用的 Drop4Up 備份。");
    }
  }

  return (
    <>
      <PanelTitle icon={FileUp} title="還原資料" />
      <p className="mt-4 text-sm leading-relaxed text-[color:var(--drop-muted)]">
        預設合併備份；同 id 的本機紀錄不會被覆蓋。選取代全部才會替換本機資料。
      </p>
      <div className="mt-4 grid grid-cols-2 gap-3">
        <button
          className={cn("tag-chip justify-center", strategy === "merge" && "tag-chip-selected")}
          onClick={() => setStrategy("merge")}
        >
          合併
        </button>
        <button
          className={cn("tag-chip justify-center", strategy === "replace" && "tag-chip-selected")}
          onClick={() => setStrategy("replace")}
        >
          取代全部
        </button>
      </div>
      <label className="primary-drop-button mt-4 w-full cursor-pointer">
        <Upload className="h-5 w-5" />
        選擇備份檔
        <input className="sr-only" type="file" accept=".drop4up,application/json,.json" onChange={readFile} />
      </label>
      {pendingDocument && (
        <SoftSurface variant="inset" className="mt-3 rounded-[22px] p-4">
          <p className="text-sm font-semibold text-[color:var(--drop-primary)]">
            還原預覽
          </p>
          <p className="mt-1 text-sm text-[color:var(--drop-muted)]">
            包含 {pendingDocument.entries.length} 筆紀錄。
          </p>
          {pendingDocument.entries[0] && (
            <p className="mt-2 line-clamp-3 whitespace-pre-wrap text-sm">
              {pendingDocument.entries[0].text}
            </p>
          )}
        </SoftSurface>
      )}
      <SoftSurface variant="inset" className="mt-4 rounded-[22px] p-3">
        <textarea
          className="quiet-field min-h-[132px] resize-none font-mono text-[0.82rem] leading-relaxed"
          placeholder="貼上備份 JSON"
          value={rawText}
          onChange={(event) => {
            setRawText(event.target.value);
            setPendingDocument(null);
          }}
        />
      </SoftSurface>
      {error && <p className="mt-3 text-sm text-[color:var(--drop-primary)]">{error}</p>}
      <PrimaryDropButton className="mt-5 w-full" label={pendingDocument ? "確認還原" : "還原"} icon={Check} onClick={() => restore()} />
    </>
  );
}

function PreferencesPanel({ store }: { store: Drop4UpStore }) {
  return (
    <>
      <PanelTitle icon={SlidersHorizontal} title="偏好設定" />
      <p className="mt-4 text-sm leading-relaxed text-[color:var(--drop-muted)]">
        偏好設定只存在本機瀏覽器，用來調整 prototype 的閱讀感。
      </p>
      <SoftSurface variant={store.preferences.largeText ? "inset" : "raised"} className="mt-4 flex items-center gap-4 rounded-[24px] p-4">
        <div className="flex-1">
          <p className="font-semibold">大字體模式</p>
          <p className="mt-1 text-sm text-[color:var(--drop-muted)]">
            {store.preferences.largeText ? "目前使用較大的文字。" : "目前使用標準文字大小。"}
          </p>
        </div>
        <Switch
          checked={store.preferences.largeText}
          onCheckedChange={store.setLargeText}
          aria-label="大字體模式"
        />
      </SoftSurface>
    </>
  );
}

function AboutPanel() {
  return (
    <>
      <PanelTitle icon={Info} title="關於 Drop4Up" />
      <p className="mt-4 text-sm leading-relaxed text-[color:var(--drop-muted)]">
        Drop4Up 是安靜、反 dopamine 的屬靈生命成長 journal prototype。這個網頁版只做本機 UI 與資料保存，不包含登入、雲端同步、AI、OCR、語音轉文字或付款。
      </p>
    </>
  );
}

function PanelTitle({ icon: Icon, title }: { icon: LucideIcon; title: string }) {
  return (
    <div className="flex items-center gap-3">
      <IconBadge icon={Icon} />
      <DialogTitle>{title}</DialogTitle>
    </div>
  );
}

function ProfileAction({
  icon: Icon,
  title,
  subtitle,
  onClick,
}: {
  icon: LucideIcon;
  title: string;
  subtitle: string;
  onClick: () => void;
}) {
  return (
    <button type="button" className="soft-surface flex h-[58px] w-full items-center gap-3 rounded-[24px] px-4 text-left" onClick={onClick}>
      <IconBadge icon={Icon} size="sm" />
      <span className="min-w-0 flex-1">
        <span className="block truncate font-semibold">{title}</span>
        <span className="mt-0.5 block truncate text-sm text-[color:var(--drop-muted)]">
          {subtitle}
        </span>
      </span>
      <ChevronsUpDown className="h-4 w-4 rotate-90 text-[color:var(--drop-muted)]" />
    </button>
  );
}

function Metric({ label, value }: { label: string; value: number }) {
  return (
    <SoftSurface variant="inset" className="rounded-full px-3 py-2">
      <span className="font-semibold text-[color:var(--drop-primary)]">{value}</span>
      <span className="ml-1.5 text-sm text-[color:var(--drop-muted)]">{label}</span>
    </SoftSurface>
  );
}

function IconBadge({
  icon: Icon,
  size = "md",
}: {
  icon: LucideIcon;
  size?: "sm" | "md";
}) {
  return (
    <span
      aria-hidden="true"
      className={cn(
        "soft-icon-button pointer-events-none",
        size === "sm" ? "h-10 w-10" : "h-11 w-11",
      )}
    >
      <Icon className="h-[1.15rem] w-[1.15rem]" />
    </span>
  );
}

function MiniTag({ label }: { label: string }) {
  return (
    <span className="rounded-full bg-[color:var(--drop-card)] px-2.5 py-1.5 text-xs text-[color:var(--drop-muted)] shadow-[inset_1px_1px_2px_rgb(255_255_255_/_75%),0_5px_10px_-9px_rgb(47_52_56_/_22%)]">
      {label}
    </span>
  );
}

function JournalState({ message }: { message: string }) {
  return (
    <SoftSurface variant="prominent" className="rounded-[26px] p-4">
      <p className="text-sm text-[color:var(--drop-muted)]">{message}</p>
    </SoftSurface>
  );
}

function QuietLeaf() {
  return (
    <svg
      aria-hidden="true"
      className="absolute right-0 top-1 h-[112px] w-[108px] text-[color:var(--drop-primary)] opacity-40"
      viewBox="0 0 108 112"
      fill="none"
    >
      <path d="M45 108C31 82 62 60 43 10" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" />
      <path d="M36 30C17 42 20 66 43 72C53 52 52 38 36 30Z" fill="#BFD1E3" fillOpacity=".28" stroke="currentColor" />
      <path d="M60 47C45 56 50 77 72 78C79 61 75 50 60 47Z" fill="#BFD1E3" fillOpacity=".22" stroke="currentColor" />
      <path d="M81 66C67 82 72 96 82 96C92 96 95 82 81 66Z" stroke="currentColor" strokeWidth="1.4" />
    </svg>
  );
}

function DropletMini() {
  return (
    <span className="grid h-7 w-7 place-items-center rounded-full text-[color:var(--drop-primary)]">
      <svg aria-hidden="true" viewBox="0 0 24 24" className="h-5 w-5" fill="none">
        <path d="M12 3C8 8 6 11.2 6 14.6A6 6 0 0 0 18 14.6C18 11.2 16 8 12 3Z" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round" />
      </svg>
    </span>
  );
}

function documentElement(tag: "a") {
  return document.createElement(tag);
}
