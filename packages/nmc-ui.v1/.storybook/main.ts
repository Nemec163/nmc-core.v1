import type { StorybookConfig } from '@storybook/react-vite';
import { join, dirname } from 'path';
import type { InlineConfig } from 'vite';

/**
 * This function is used to resolve the absolute path of a package.
 * It is needed in projects that use Yarn PnP or are set up within a monorepo.
 */
function getAbsolutePath(value: string): string {
  return dirname(require.resolve(join(value, 'package.json')));
}

const config: StorybookConfig = {
  stories: [
    '../src/**/*.mdx',
    '../src/**/*.stories.@(js|jsx|mjs|ts|tsx)',
  ],
  addons: [
    getAbsolutePath('@storybook/addon-essentials'),
    getAbsolutePath('@storybook/addon-onboarding'),
    getAbsolutePath('@chromatic-com/storybook'),
  ],
  framework: {
    name: getAbsolutePath('@storybook/react-vite'),
    options: {},
  },
  viteFinal: async (config): Promise<InlineConfig> => {
    return {
      ...config,
      base: '/ui/',
      server: {
        ...config.server,
        host: '0.0.0.0',
        strictPort: false,
        hmr: {
          clientPort: 443,
        },
        origin: 'https://nemec.app',
      },
    };
  },
};

export default config;
