import type { StorybookConfig } from '@storybook/react-vite';
import { join, dirname } from 'path';

/**
 * This function is used to resolve the absolute path of a package.
 * It is needed in projects that use Yarn PnP or are set up within a monorepo.
 */
function getAbsolutePath(value: string): any {
  return dirname(require.resolve(join(value, 'package.json')));
}

const config: StorybookConfig = {
  stories: [
    "../src/**/*.mdx",
    "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"
  ],
  addons: [
    getAbsolutePath('@storybook/addon-essentials'),
    getAbsolutePath('@storybook/addon-onboarding'),
    getAbsolutePath('@chromatic-com/storybook')
  ],
  framework: {
    name: getAbsolutePath('@storybook/react-vite'),
    options: {}
  },

  // 🛠️ Вот это добавляем:
  viteFinal: async (viteConfig, { configType }) => {
    viteConfig.server = {
      ...viteConfig.server,
      host: '0.0.0.0', // чтобы принимать внешний доступ
      strictPort: false,
      hmr: {
        clientPort: 443, // WebSocket через HTTPS
      },
      origin: 'https://nemec.app', // явно указываем внешний хост
    };
    return viteConfig;
  }
};

export default config;
