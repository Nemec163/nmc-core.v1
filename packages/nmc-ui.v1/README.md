# 🌟 NMC UI Component Library v1

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="Version" />
  <img src="https://img.shields.io/badge/react-19.1.0-61DAFB" alt="React" />
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License" />
</p>

> Modern, themeable React component library with advanced styling features. Includes neumorphic design with light/dark variants and flat design alternatives.

## ✨ Features

- 🎨 Multiple theming options (neumorphic and flat designs)
- 🌓 Dark and light mode support
- 📱 Responsive design with mobile adaptations
- 💅 SCSS modules with advanced styling
- ✨ Animation and glow effects
- 🚀 Easy to integrate in any React project

## 📦 Installation & Setup

### 🌐 From NPM Registry

```bash
# Using npm
npm install nmc-ui.v1

# Using yarn
yarn add nmc-ui.v1

# Using pnpm
pnpm add nmc-ui.v1
```

After installation, import the styles and start using the components:

```jsx
// Import styles in your main entry file (e.g., index.js, App.js)
import 'nmc-ui.v1/dist/styles/index.css';

// Import and use components in your React components
import { Button } from 'nmc-ui.v1';

function MyComponent() {
  return (
    <div className="nmc-ui neumorphic-light">
      <Button onClick={() => alert('Hello!')}>Click me</Button>
    </div>
  );
}
```

### 🔧 Local Development (Monorepo)

When using this package locally within the nmc-core.v1 monorepo:

1. **Link the package:**

```bash
# From the root of the monorepo
pnpm install

# Build the UI package
cd packages/nmc-ui.v1
pnpm run build
```

2. **Configure in consuming project:**

For Next.js applications (like nmc-site.v1):

```ts
// In next.config.ts
import path from "path";

const nextConfig = {
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      "@nmc/ui": path.resolve(__dirname, "../../packages/nmc-ui.v1/src"),
    };
    return config;
  },
};

export default nextConfig;
```

For Vite/Storybook (like nmc-storybook.v1):

```js
// In vite.config.js
import path from 'path';

export default {
  resolve: {
    alias: {
      '@nmc/ui': path.resolve(__dirname, '../../packages/nmc-ui.v1/src')
    }
  }
}
```

3. **Import and use:**

```jsx
// Import styles in your main app component or entry file
import '@nmc/ui/styles/index.scss';

// Import and use components
import { Button } from '@nmc/ui';

export default function MyComponent() {
  return (
    <div className="nmc-ui neumorphic-light">
      <Button>Local Development</Button>
    </div>
  );
}
```

## 🎭 Theming System

Apply one of the theme classes to your container element to set the theme:

```jsx
// Neumorphic themes with soft shadows and 3D-like effects
<div className="nmc-ui neumorphic-light">...</div>
<div className="nmc-ui neumorphic-dark">...</div>

// Flat themes with clean, minimal design
<div className="nmc-ui flat-light">...</div>
<div className="nmc-ui flat-dark">...</div>
```

## 🧩 Components

### Button

```jsx
import { Button } from 'nmc-ui.v1';  // from npm
// OR
import { Button } from '@nmc/ui';    // for local development

// Basic usage
<Button onClick={() => console.log('Clicked!')}>Click me</Button>

// Size variants
<Button size="sm">Small</Button>
<Button size="md">Medium</Button> // default
<Button size="lg">Large</Button>

// Template variants
<Button template="primary">Primary</Button>

// States
<Button disabled>Disabled</Button>
<Button isActive>Active</Button>
<Button loading>Loading</Button>

// With prefix/suffix
<Button 
  prefix={<span>→</span>}
  suffix={<span>✓</span>}
>
  With Icons
</Button>

// As a link
<Button href="https://example.com" target="_blank">
  External Link
</Button>
```

## 📋 Publishing to NPM

To publish this package to the NPM registry:

```bash
# Navigate to the package directory
cd packages/nmc-ui.v1

# Build the package
pnpm run build

# Login to npm (if not already)
npm login

# Publish to npm
npm publish
```

Make sure to update the version in `package.json` before publishing a new version.

## 🔄 Using in CI/CD Pipeline

Include the build step in your CI/CD workflow:

```yaml
# Example GitHub Actions workflow step
- name: Build UI Library
  run: |
    cd packages/nmc-ui.v1
    pnpm install
    pnpm run build
```

## 📝 License

MIT © [NMC](https://github.com/Nemec163)