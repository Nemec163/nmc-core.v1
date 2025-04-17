import type { Meta, StoryFn } from '@storybook/react';
import styles from './sandbox.module.scss';
import '@nmc/ui/styles/index.scss';

import { Button } from '../../nmc-ui.v1/src/components/Button';
import React from 'react';

const meta: Meta = {
  title: 'DEV/Sandbox'
};

export default meta;

export const Sandbox: StoryFn = (args, context) => {
  const theme = context?.globals?.theme;
  const isNeumorphic = theme?.includes('neumorphic') || false;
  const commonCategories = [
    {
      title: 'Spacing',
      variables: [
        { name: 'spacing-xs', type: 'square' },
        { name: 'spacing-sm', type: 'square' },
        { name: 'spacing-md', type: 'square' },
        { name: 'spacing-lg', type: 'square' },
        { name: 'spacing-xl', type: 'square' },
      ]
    },
    {
      title: 'Border Radius',
      variables: [
        { name: 'border-radius-sm', type: 'radius' },
        { name: 'border-radius-md', type: 'radius' },
        { name: 'border-radius-lg', type: 'radius' },
        { name: 'border-radius-xl', type: 'radius' },
      ]
    },
    {
      title: 'Typography',
      grid: 'typography',
      variables: [
        { name: 'font-size-xs', type: 'font', text: 'Text XS' },
        { name: 'font-size-sm', type: 'font', text: 'Text SM' },
        { name: 'font-size-md', type: 'font', text: 'Text MD' },
        { name: 'font-size-lg', type: 'font', text: 'Text LG' },
        { name: 'heading-sm', type: 'font', text: 'Heading SM' },
        { name: 'heading-md', type: 'font', text: 'Heading MD' },
        { name: 'heading-lg', type: 'font', text: 'Heading LG' },
      ]
    },
    {
      title: 'Line Heights',
      variables: [
        { name: 'line-height-sm', type: 'lineHeight', value: '20px' },
        { name: 'line-height-md', type: 'lineHeight', value: '24px' },
        { name: 'line-height-lg', type: 'lineHeight', value: '32px' },
        { name: 'line-height-xl', type: 'lineHeight', value: '36px' },
      ]
    }
  ];
  
  const flatTheme = [
    ...commonCategories,
    {
      title: 'Colors',
      variables: [
        { name: 'background', type: 'color' },
        { name: 'border-color', type: 'color' },
        { name: 'text-primary', type: 'color' },
        { name: 'text-secondary', type: 'color' },
      ]
    },
    {
      title: 'Animations',
      grid: 'animations',
      variables: [
        { name: 'rotate', type: 'animation', animationType: 'rotate', text: '↻' },
        { name: 'breathe', type: 'animation', animationType: 'breathe', text: '●' },
        { name: 'blink', type: 'animation', animationType: 'blink', text: '■' }
      ]
    }
  ];
  
  const neumorphicTheme = [
    ...commonCategories,
    {
      title: 'Colors',
      variables: [
        { name: 'background', type: 'color' },
        { name: 'background-in', type: 'color' },
        { name: 'background-out', type: 'color' },
        { name: 'border-color', type: 'color' },
        { name: 'text-primary', type: 'color' },
        { name: 'text-secondary', type: 'color' },
        { name: 'text-glow', type: 'color' },
        { name: 'text-glow-bright', type: 'color' },
        { name: 'text-glow-brightest', type: 'color' },
      ]
    },
    {
      title: 'Shadows',
      variables: [
        { name: 'shadow', type: 'shadow' },
        { name: 'shadow-in', type: 'shadow-in' },
        { name: 'shadow-glow', type: 'shadow-glow' },
      ]
    },
    {
      title: 'Animations',
      grid: 'animations',
      variables: [
        { name: 'glow-text', type: 'animation', animationType: 'glowText', text: 'Glow Text' },
        { name: 'glow-element', type: 'animation', animationType: 'glowElement' },
        { name: 'rotate', type: 'animation', animationType: 'rotate', text: '↻' },
        { name: 'breathe', type: 'animation', animationType: 'breathe', text: '●' },
        { name: 'blink', type: 'animation', animationType: 'blink', text: '■' }
      ]
    }
  ];

  const themeCategories = isNeumorphic ? neumorphicTheme : flatTheme;
  const renderVariablePreview = (variable) => {
    switch (variable.type) {
      case 'square':
        return <div className={`${styles.square} ${styles[`size${variable.name.split('-')[1].toUpperCase()}`]}`} />;
      
      case 'radius':
        return <div className={`${styles.radius} ${styles[`radius${variable.name.split('-')[2].toUpperCase()}`]}`} />;
      
      case 'color':
        return <div className={`${styles.color} ${styles[variable.name.replace(/-([a-z])/g, g => g[1].toUpperCase())]}`} />;
      
      case 'shadow':
        return <div className={`${styles.shadowExample} ${styles.shadowNormal}`} />;
      
      case 'shadow-in':
        return <div className={`${styles.shadowExample} ${styles.shadowIn}`} />;
      
      case 'shadow-glow':
        return <div className={`${styles.shadowExample} ${styles.shadowGlow}`} />;
      
      case 'font':
        return <span className={`${styles.font} ${styles[variable.name.replace(/-([a-z])/g, g => g[1].toUpperCase())]}`}>{variable.text}</span>;
      
      case 'animation':
        if (variable.animationType === 'glowElement') {
          return (
            <div className={`${styles.animation} ${styles[`${variable.animationType}Active`]}`}>
              <div className={styles.glowElementBox}></div>
            </div>
          );
        }
        return (
          <div className={`${styles.animation} ${styles[`${variable.animationType}Active`]}`}>
            <span className={styles.animationContent}>{variable.text}</span>
          </div>
        );
      
      case 'lineHeight':
        return (
          <div className={`${styles.lineHeight} ${styles[variable.name.replace(/-([a-z])/g, g => g[1].toUpperCase())]}`}>
            <span className={styles.lineHeightValue}>{variable.value}</span>
          </div>
        );
      
      default:
        return null;
    }
  };

  return (
    <div className={`nmc-ui ${theme ?? ''} ${styles.page}`}>
      <Button>Click Me</Button>
      <div className={styles.docs}>
        <h2>Theme Variables Cheat Sheet</h2>
        
        {themeCategories.map((category) => (
          <section key={category.title} className={styles.category}>
            <h3>{category.title}</h3>
            <div className={`${styles.variables} ${category.grid ? styles[`${category.grid}Grid`] : ''}`}>
              {category.variables.map((variable) => (
                <div key={variable.name} className={styles.variable}>
                  {renderVariablePreview(variable)}
                  <code>--{variable.name}</code>
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>
    </div>
  );
};
