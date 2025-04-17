export const globalTypes = {
  theme: {
    name: 'Theme',
    description: 'Component theme',
    defaultValue: 'neumorphic-light',
    toolbar: {
      icon: 'paintbrush',
      items: [
        { value: 'neumorphic-light', title: 'Neu Light' },
        { value: 'neumorphic-dark', title: 'Neu Dark' },
        { value: 'flat-light', title: 'Flat Light' },
        { value: 'flat-dark', title: 'Flat Dark' }
      ],
      showName: true,
      dynamicTitle: true
    }
  }
};

const preview = {
  parameters: {
    layout: 'fullscreen'
  },
  decorators: []
};

export default preview;
