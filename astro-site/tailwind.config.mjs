/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        mono: ['"JetBrains Mono"', '"Fira Code"', '"Cascadia Code"', "monospace"],
        sans: ['"Inter"', "system-ui", "sans-serif"],
      },
      colors: {
        brand: "#22c55e",
        terminal: {
          green: "#4ade80",
          dim: "#22c55e",
        },
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
