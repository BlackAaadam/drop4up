"use client";

import type { ButtonHTMLAttributes, ReactNode } from "react";
import {
  BookOpen,
  Droplet,
  Home,
  User,
  type LucideIcon,
} from "lucide-react";
import { cn } from "@/lib/utils";
import type { Drop4UpTab } from "@/types/drop4up";

export const drop4UpTabs: Array<{
  id: Drop4UpTab;
  label: "Home" | "Drop" | "Journal" | "Profile";
  icon: LucideIcon;
}> = [
  { id: "home", label: "Home", icon: Home },
  { id: "drop", label: "Drop", icon: Droplet },
  { id: "journal", label: "Journal", icon: BookOpen },
  { id: "profile", label: "Profile", icon: User },
];

type SoftSurfaceProps = {
  children: ReactNode;
  className?: string;
  variant?: "raised" | "prominent" | "inset" | "pressed";
  as?: "div" | "section";
};

export function SoftSurface({
  children,
  className,
  variant = "raised",
  as = "div",
}: SoftSurfaceProps) {
  const Component = as;
  return (
    <Component
      className={cn(
        "soft-surface",
        variant === "prominent" && "soft-surface-prominent",
        variant === "inset" && "soft-surface-inset",
        variant === "pressed" && "soft-surface-pressed",
        className,
      )}
    >
      {children}
    </Component>
  );
}

type SoftIconButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  icon: LucideIcon;
  label: string;
  size?: "sm" | "md";
};

export function SoftIconButton({
  icon: Icon,
  label,
  className,
  size = "md",
  ...props
}: SoftIconButtonProps) {
  return (
    <button
      type="button"
      aria-label={label}
      title={label}
      className={cn(
        "soft-icon-button",
        size === "sm" ? "h-10 w-10" : "h-11 w-11",
        className,
      )}
      {...props}
    >
      <Icon aria-hidden="true" className="h-[1.15rem] w-[1.15rem]" />
    </button>
  );
}

type Drop4UpTagChipProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  label: string;
  count?: number | null;
  selected?: boolean;
};

export function Drop4UpTagChip({
  label,
  count,
  selected,
  className,
  ...props
}: Drop4UpTagChipProps) {
  return (
    <button
      type="button"
      className={cn("tag-chip", selected && "tag-chip-selected", className)}
      {...props}
    >
      <span>{label}</span>
      {count != null && <span className="tag-chip-count">{count}</span>}
    </button>
  );
}

type PrimaryDropButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  icon?: LucideIcon;
  label: string;
};

export function PrimaryDropButton({
  icon: Icon = Droplet,
  label,
  className,
  ...props
}: PrimaryDropButtonProps) {
  return (
    <button type="button" className={cn("primary-drop-button", className)} {...props}>
      <Icon aria-hidden="true" className="h-5 w-5" />
      <span>{label}</span>
    </button>
  );
}

type Drop4UpBottomNavProps = {
  currentTab: Drop4UpTab;
  onTabChange: (tab: Drop4UpTab) => void;
};

export function Drop4UpBottomNav({
  currentTab,
  onTabChange,
}: Drop4UpBottomNavProps) {
  return (
    <nav aria-label="Drop4Up tabs" className="bottom-nav">
      {drop4UpTabs.map((tab) => {
        const Icon = tab.icon;
        const active = tab.id === currentTab;
        return (
          <button
            key={tab.id}
            type="button"
            aria-current={active ? "page" : undefined}
            className={cn("bottom-nav-item", active && "bottom-nav-item-active")}
            onClick={() => onTabChange(tab.id)}
          >
            <Icon aria-hidden="true" className="h-[1.1rem] w-[1.1rem]" />
            <span>{tab.label}</span>
          </button>
        );
      })}
    </nav>
  );
}

type Drop4UpScaffoldProps = {
  currentTab: Drop4UpTab;
  onTabChange: (tab: Drop4UpTab) => void;
  children: ReactNode;
  largeText?: boolean;
};

export function Drop4UpScaffold({
  currentTab,
  onTabChange,
  children,
  largeText,
}: Drop4UpScaffoldProps) {
  return (
    <main className={cn("app-frame", largeText && "large-text-mode")}>
      <div className="app-scroll">{children}</div>
      <div className="app-nav-wrap">
        <Drop4UpBottomNav currentTab={currentTab} onTabChange={onTabChange} />
      </div>
    </main>
  );
}

export function ScreenHeader({
  action,
}: {
  action?: ReactNode;
}) {
  return (
    <header className="flex items-center">
      <div className="brand-wordmark">Drop4Up</div>
      <div className="ml-auto">{action}</div>
    </header>
  );
}
