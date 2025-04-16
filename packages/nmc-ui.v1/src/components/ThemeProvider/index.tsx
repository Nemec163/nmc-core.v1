import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

type ThemeType = 'light' | 'dark' | string;

interface ThemeContextType {
  theme: ThemeType;
  setTheme: (theme: ThemeType) => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

interface ThemeProviderProps {
  children?: ReactNode;
  defaultTheme?: ThemeType;
  storageKey?: string;
  customThemes?: string[];
}

export const ThemeProvider: React.FC<ThemeProviderProps> = ({
  children,
  defaultTheme = 'dark',
  storageKey = 'nmc-ui-theme',
  customThemes = [],
}) => {
  const [theme, setTheme] = useState<ThemeType>(() => {
    if (typeof window !== 'undefined') {
      const storedTheme = localStorage.getItem(storageKey);
      return storedTheme || defaultTheme;
    }
    return defaultTheme;
  });

  useEffect(() => {
    const root = window.document.documentElement;
    
    // Remove all existing theme classes
    root.classList.remove('nmc-theme-light', 'nmc-theme-dark', 'light', 'dark');
    customThemes.forEach(theme => root.classList.remove(theme));
    
    // Add the current theme class
    if (theme === 'light' || theme === 'dark') {
      root.classList.add(`nmc-theme-${theme}`);
      root.classList.add(theme); // For backward compatibility
    } else {
      // For custom themes
      root.classList.add(theme);
    }
    
    // Store the current theme
    if (typeof window !== 'undefined') {
      localStorage.setItem(storageKey, theme);
    }
  }, [theme, storageKey, customThemes]);

  const contextValue = {
    theme,
    setTheme,
  };

  return (
    <ThemeContext.Provider value={contextValue}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  
  return context;
};

export default ThemeProvider;