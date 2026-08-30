import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'onyx': '#0a0a0a',
        'onyx-light': '#1a1a1a',
        'gold': '#d4af37',
        'amber': '#ffd700',
        'dark-bg': '#0f0f0f',
      },
      backdropFilter: {
        'glass': 'blur(10px)',
      },
      backgroundImage: {
        'gradient-gold': 'linear-gradient(135deg, #d4af37 0%, #ffd700 100%)',
      },
    },
  },
  plugins: [],
};

export default config;
