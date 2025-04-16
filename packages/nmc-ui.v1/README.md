# NMC UI Kit

Современная библиотека React-компонентов с поддержкой тем для проектов NMC.

## Установка

В рамках монорепозитория:

```bash
# Использование компонентов из другого пакета монорепозитория
# package.json вашего проекта
{
  "dependencies": {
    "nmc-ui.v1": "workspace:^"
  }
}
```

При использовании вне монорепозитория (после публикации в npm):

```bash
# Использование npm
npm install nmc-ui.v1

# Использование yarn
yarn add nmc-ui.v1

# Использование pnpm
pnpm add nmc-ui.v1
```

## Использование

### Импорт стилей

Сначала импортируйте основные стили в главном файле вашего приложения:

```jsx
// В вашем _app.jsx или основном файле входа
import 'nmc-ui.v1/dist/styles/index.css';
```

### Использование компонентов

Импортируйте и используйте компоненты в вашем React-приложении:

```jsx
import { Button, ThemeProvider } from 'nmc-ui.v1';

function App() {
  return (
    <ThemeProvider defaultTheme="nmc-theme-dark">
      <div>
        <Button template="red" size="md">Нажми меня</Button>
      </div>
    </ThemeProvider>
  );
}
```

## Темизация

### Встроенные темы

UI кит поставляется с двумя встроенными темами:

- `nmc-theme-light` - Светлая тема с оранжевыми акцентами
- `nmc-theme-dark` - Темная тема с зелеными акцентами

### Использование ThemeProvider

Оберните ваше приложение в `ThemeProvider` для активации поддержки тем:

```jsx
import { ThemeProvider } from 'nmc-ui.v1';

function App() {
  return (
    <ThemeProvider defaultTheme="nmc-theme-dark">
      <YourAppComponents />
    </ThemeProvider>
  );
}
```

### Переключение тем

```jsx
import { useTheme, Button } from 'nmc-ui.v1';

function ThemeSwitcher() {
  const { theme, setTheme } = useTheme();
  
  return (
    <Button onClick={() => setTheme(
      theme === 'nmc-theme-dark' ? 'nmc-theme-light' : 'nmc-theme-dark'
    )}>
      Переключить на {theme === 'nmc-theme-dark' ? 'светлую' : 'темную'} тему
    </Button>
  );
}
```

Или используйте готовый компонент для переключения тем:

```jsx
import { ThemeSwitcher } from 'nmc-ui.v1';

function YourApp() {
  return (
    <div>
      <ThemeSwitcher 
        themes={['nmc-theme-light', 'nmc-theme-dark']}
        label="Тема:"
      />
      {/* Остальное содержимое приложения */}
    </div>
  );
}
```

### Пользовательские темы

Вы можете создать свои собственные темы:

1. Определите переменные вашей темы в CSS/SCSS файле:

```scss
.my-custom-theme {
  --border-color: #3a3a3a;
  --text-primary: #ffffff;
  --text-secondary: #cccccc;
  --text-glow: #ff00ff;
  --shadow-glow: 0 0 3px var(--text-glow), 0 0 10px var(--text-glow);
  --background: #222222;
  --background-in: linear-gradient(145deg, #1e1e1e, #2a2a2a);
  --background-out: linear-gradient(145deg, #2a2a2a, #1e1e1e);
  --shadow: 6px 6px 12px #1a1a1a, -6px -6px 12px #2a2a2a;
  --shadow-in: inset 6px 6px 12px #1a1a1a, inset -6px -6px 12px #2a2a2a;
}
```

2. Зарегистрируйте вашу пользовательскую тему в ThemeProvider:

```jsx
import { ThemeProvider } from 'nmc-ui.v1';
import './my-custom-theme.scss'; // Импортируйте ваши стили темы

function App() {
  return (
    <ThemeProvider 
      defaultTheme="my-custom-theme" 
      customThemes={['my-custom-theme']}
    >
      <YourApp />
    </ThemeProvider>
  );
}
```

## Компоненты

### Button

```jsx
<Button 
  template="red"   // red, blue, green
  size="md"        // sm, md, lg
  disabled={false}
  onClick={() => alert('Клик!')}
  prefix={<Icon />}
  suffix={<Icon />}
>
  Текст кнопки
</Button>
```

### ThemeSwitcher

```jsx
<ThemeSwitcher 
  themes={['nmc-theme-light', 'nmc-theme-dark', 'my-theme']}
  label="Выберите тему:"
/>
```

## Лучшие практики

1. Всегда оборачивайте ваше приложение в `ThemeProvider` для обеспечения согласованной темизации
2. Используйте предоставленные CSS-переменные для кастомных стилей, чтобы сохранять консистентность темы
3. Импортируйте стили на корневом уровне приложения, чтобы они были доступны глобально
4. При расширении UI кита собственными компонентами, следуйте той же схеме оформления с использованием CSS-переменных