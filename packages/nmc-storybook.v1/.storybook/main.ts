import { join, dirname } from "path"

/**
* This function is used to resolve the absolute path of a package.
* It is needed in projects that use Yarn PnP or are set up within a monorepo.
*/
function getAbsolutePath(value: string): string {
  return dirname(require.resolve(join(value, 'package.json')))
}

/** @type { import('@storybook/react-webpack5').StorybookConfig } */
const config = {
  stories: [
    "../stories/**/*.mdx",
    "../stories/**/*.stories.@(js|jsx|mjs|ts|tsx)"
  ],
  addons: [
    getAbsolutePath('@storybook/addon-webpack5-compiler-swc'),
    getAbsolutePath('@storybook/addon-essentials'),
    getAbsolutePath('@storybook/addon-onboarding'),
    getAbsolutePath('@storybook/addon-interactions'),
    getAbsolutePath('@storybook/addon-a11y')
  ],
  framework: {
    name: getAbsolutePath('@storybook/react-webpack5'),
    options: {}
  },
  webpackFinal: async (config: any) => {
    // Regular SCSS files (global)
    config.module.rules.push({
      test: /(?<!\.module)\.scss$/,
      use: [
        'style-loader',
        'css-loader',
        {
          loader: 'sass-loader',
          options: {
            sassOptions: {
              includePaths: [
                join(__dirname, '../../', 'nmc-ui.v1', 'src', 'styles'),
              ],
            },
          },
        },
      ],
    });

    // SCSS modules
    config.module.rules.push({
      test: /\.module\.scss$/,
      use: [
        'style-loader',
        {
          loader: 'css-loader',
          options: {
            modules: {
              localIdentName: '[name]__[local]--[hash:base64:5]',
              exportLocalsConvention: 'camelCase',
            },
            importLoaders: 1,
            sourceMap: true,
          },
        },
        {
          loader: 'sass-loader',
          options: {
            sourceMap: true,
            sassOptions: {
              includePaths: [
                join(__dirname, '../../', 'nmc-ui.v1', 'src', 'styles'),
              ],
            },
          },
        },
      ],
    });

    // Add path resolver for easier imports
    if (config.resolve) {
      config.resolve.alias = {
        ...config.resolve.alias,
        '@nmc-ui': join(__dirname, '../../', 'nmc-ui.v1', 'src'),
      };
    }

    return config;
  },
  docs: {
    autodocs: true,
  },
};

export default config;
