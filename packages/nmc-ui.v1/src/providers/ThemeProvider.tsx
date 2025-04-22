import React, { ReactNode } from 'react';

export type ThemeName =
  | 'flat-light'
  | 'flat-dark'
  | 'neumorphic-light'
  | 'neumorphic-dark';

interface ThemeProviderProps {
  theme?: ThemeName | string | Array<ThemeName | string>;
  className?: string;
  children: ReactNode;
}

export const ThemeProvider = ({
  theme = 'flat-light',
  className = '',
  children,
}: ThemeProviderProps) => {
  const themes = Array.isArray(theme) ? theme : [theme];

  const allClasses = [
    'nmc-ui',
    ...themes,
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return <div className={allClasses}>{children}</div>;
};
