import { StorybookConfig } from '@storybook/react-vite';
import tsconfigPaths from 'vite-tsconfig-paths';
import path from 'path';

const config: StorybookConfig = {
  stories: ['../stories/**/*.stories.@(ts|tsx|js|jsx|mdx)'],
  addons: [
    '@storybook/addon-essentials',
    '@storybook/addon-onboarding',
    '@chromatic-com/storybook'
  ],
  framework: {
    name: '@storybook/react-vite',
    options: {}
  },
  viteFinal: async (config, { configType }) => {
    config.plugins = config.plugins || [];
    config.plugins.push(tsconfigPaths());

    config.resolve = config.resolve || {};
    config.resolve.alias = {
      ...config.resolve.alias,
      '@nmc/ui': path.resolve(__dirname, '../../../packages/nmc-ui.v1/src'),
      '@nmc-ui.v1/src': path.resolve(__dirname, '../../../packages/nmc-ui.v1/src')
    };

    config.base = '/ui/';

    return config;
  }
};

export default config;
