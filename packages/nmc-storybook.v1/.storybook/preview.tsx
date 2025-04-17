import '@nmc/ui/styles/index.scss';

import React from 'react';
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
  decorators: [
    (Story, context) => {
      const theme = context.globals.theme;
      document.body.classList.remove('flat-light', 'flat-dark', 'neumorphic-light', 'neumorphic-dark');
      document.body.classList.add(theme);

      return <div className={`nmc-ui ${theme}`}><Story /></div>;
    }
  ]
};

export default preview;
