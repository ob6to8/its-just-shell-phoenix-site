export interface SiteTheme {
  bg: string;
  text: string;
  accent: string;
  "accent-hover": string;
  "gradient-from": string;
  "gradient-to": string;
  border: string;
  surface: string;
  "text-secondary": string;
  "prose-bg": string;
  "code-color": string;
}

export interface Site {
  slug: string;
  name: string;
  titleSuffix: string;
  domains: string[];
  theme: SiteTheme;
  logoPath: string;
  aboutText: string;
  isDark: boolean;
}

const sites: Site[] = [
  {
    slug: "its-just-shell",
    name: "its-just-shell",
    titleSuffix: " - its just shell",
    domains: ["itsjustshell.dev", "www.itsjustshell.dev"],
    theme: {
      bg: "#282a36",
      text: "#d4d4d8",
      accent: "#60a5fa",
      "accent-hover": "#93c5fd",
      "gradient-from": "#60a5fa",
      "gradient-to": "#c084fc",
      border: "#27272a",
      surface: "#1e1f29",
      "text-secondary": "#71717a",
      "prose-bg": "#18181b",
      "code-color": "#4ade80",
    },
    logoPath: "/images/logo.png",
    aboutText: "its just shell",
    isDark: true,
  },
  {
    slug: "its-just-beam",
    name: "its-just-beam",
    titleSuffix: " - its just beam",
    domains: ["itsjustbeam.dev", "www.itsjustbeam.dev"],
    theme: {
      bg: "#f0ead6",
      text: "#1b2a4a",
      accent: "#1b2a4a",
      "accent-hover": "#2d4a7a",
      "gradient-from": "#1b2a4a",
      "gradient-to": "#4a6fa5",
      border: "#c8c0aa",
      surface: "#e8e2cc",
      "text-secondary": "#5a6e8a",
      "prose-bg": "#e8e2cc",
      "code-color": "#6a5acd",
    },
    logoPath: "/images/its-just-beam/logo.svg",
    aboutText:
      "its just beam — exploring Elixir, OTP, and the BEAM virtual machine.",
    isDark: false,
  },
  {
    slug: "its-just-sound",
    name: "its-just-sound",
    titleSuffix: " - its just sound",
    domains: ["itsjustsound.dev", "www.itsjustsound.dev"],
    theme: {
      bg: "#0f0f1a",
      text: "#d4d4e0",
      accent: "#a855f7",
      "accent-hover": "#c084fc",
      "gradient-from": "#a855f7",
      "gradient-to": "#ec4899",
      border: "#1e1e2e",
      surface: "#161625",
      "text-secondary": "#7a7a9a",
      "prose-bg": "#12121e",
      "code-color": "#c084fc",
    },
    logoPath: "/images/its-just-sound/logo.svg",
    aboutText:
      "its just sound — sonification, music, and observability through audio.",
    isDark: true,
  },
];

export function getCurrentSite(): Site {
  const slug = import.meta.env.SITE || "its-just-shell";
  return sites.find((s) => s.slug === slug)!;
}

export function themeStyle(theme: SiteTheme): string {
  return Object.entries(theme)
    .map(([k, v]) => `--${k}:${v}`)
    .join(";");
}
