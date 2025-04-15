import React from 'react';
import { Button } from '@nmc/ui';

export default {
  title: 'Components/Button',
  component: Button,
};

export const Default = () => (
  <Button onClick={() => alert('Clicked!')}>Click Me</Button>
);
