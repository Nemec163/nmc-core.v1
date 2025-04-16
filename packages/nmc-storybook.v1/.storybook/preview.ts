/** @type { import('@storybook/react').Preview } */
const preview = {
  parameters: {
    controls: {
      expanded: true,
      matchers: {
       color: /(background|color)$/i,
       date: /Date$/i,
      },
    },
    actions: { argTypesRegex: '^on[A-Z].*' }
  },
};

export default preview;