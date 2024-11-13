import type { Config } from 'tailwindcss';
import * as defaultTheme from 'tailwindcss/defaultTheme';
import colors from 'tailwindcss/colors';
import aspectRatio from '@tailwindcss/aspect-ratio';
import containerQueries from '@tailwindcss/container-queries';
import forms from '@tailwindcss/forms';
import displayModes from 'tailwindcss-displaymodes';

export default {
  content: ['./app/**/*.{slim,rb}', './app/javascript/**/*.{js,ts}'],

  darkMode: 'selector',

  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },

      screens: {
        '3xl': '1920px',

        tall: { raw: '(min-height: 860px)' },
      },

      aspectRatio: {
        square: '1 / 1',
      },

      containers: {
        c0: '10rem',
        c1: '12rem',
        c2: '15rem',
        c3: '18rem',
        c4: '21rem',
      },

      spacing: {
        '192': '48rem',
      },

      transitionProperty: {
        'max-height': 'max-height',
      },

      colors: {
        green: colors.emerald,
        yellow: colors.amber,
        purple: colors.violet,
      },

      gridTemplateColumns: {
        'auto-fit': 'repeat(auto-fit, minmax(0, 1fr))',
      },
    },
  },

  plugins: [aspectRatio, containerQueries, forms, displayModes],
} satisfies Config;