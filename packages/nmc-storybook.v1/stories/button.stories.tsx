import { Button } from '../../nmc-ui.v1/src/components/Button';

import React from 'react';

export default {
  title: 'DEV/Button',
  component: Button,
};

export const Sandbox = () => (
  <Button
    onClick={() => console.log('clicked')}
  >
    Click Me
  </Button>
);

