/**
 * Parse site, date, and slug from a content collection entry's id.
 * id format: "its-just-shell/2026/02-15-what-is-a-tool.md"
 * or in Astro 5: "its-just-shell/2026/02-15-what-is-a-tool" (no extension)
 */
export function parseMeta(id: string) {
  const clean = id.replace(/\.md$/, "");
  const parts = clean.split("/");
  const site = parts[0];
  const year = parts[1];
  const filename = parts[parts.length - 1];
  const match = filename.match(/^(\d{2})-(\d{2})-(.+)$/);
  if (!match) {
    throw new Error(`Invalid content filename format: ${filename}`);
  }
  const [, month, day, slug] = match;
  const date = new Date(`${year}-${month}-${day}T00:00:00`);
  return { site, date, slug };
}

/**
 * Format a Date as "Month DD, YYYY" (e.g., "February 15, 2026")
 */
export function formatDate(date: Date): string {
  return date.toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}
