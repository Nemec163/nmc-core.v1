import tsconfigPaths from 'vite-tsconfig-paths';
import path from 'path';

/** @type { import('@storybook/react-vite').StorybookConfig } */
const config = {
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
  viteFinal: async (config) => {
    config.plugins = config.plugins || [];
    config.plugins.push(tsconfigPaths());
    config.resolve = config.resolve || {};
    config.resolve.alias = {
      ...config.resolve.alias,
      '@nmc/ui': path.resolve(__dirname, '../../../packages/nmc-ui.v1/src'),
      '@nmc-ui.v1/src': path.resolve(__dirname, '../../../packages/nmc-ui.v1/src')
    };
    
    return config;
  }
};

export default config;
