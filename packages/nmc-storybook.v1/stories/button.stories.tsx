import React from 'react';
import { Button, ThemeProvider } from 'nmc-ui.v1';
import { Meta, StoryObj } from '@storybook/react';

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    size: {
      control: 'select', 
      options: ['sm', 'md', 'lg'],
      description: 'Button size'
    },
  },
  decorators: [
    (Story) => (
      <ThemeProvider>
        <div style={{ padding: '2rem' }}>
          <Story />
        </div>
      </ThemeProvider>
    ),
  ],
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Default: Story = {
  args: {
    children: 'Button',
    size: 'md',
  },
};

export const WithPrefix: Story = {
  args: {
    children: 'With Prefix',
    prefix: <span style={{ marginRight: '0.5rem' }}>→</span>,
    size: 'md',
  },
};

export const WithSuffix: Story = {
  args: {
    children: 'With Suffix',
    suffix: <span style={{ marginLeft: '0.5rem' }}>←</span>,
    size: 'md',
  },
};

export const Disabled: Story = {
  args: {
    children: 'Disabled Button',
    disabled: true,
  },
};

export const SmallSize: Story = {
  args: {
    children: 'Small Button',
    size: 'sm',
  },
};

export const LargeSize: Story = {
  args: {
    children: 'Large Button',
    size: 'lg',
  },
};

// Showing multiple themes in single story
export const ThemeComparison: Story = {
  render: (args) => (
    <div style={{ display: 'flex', gap: '2rem' }}>
      <div className="nmc-theme-light" style={{ padding: '2rem', background: 'var(--background)' }}>
        <Button {...args} children="Light Theme" />
      </div>
      <div className="nmc-theme-dark" style={{ padding: '2rem', background: 'var(--background)' }}>
        <Button {...args} children="Dark Theme" />
      </div>
    </div>
  ),
};
