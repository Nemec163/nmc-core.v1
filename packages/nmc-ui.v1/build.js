const { build } = require('esbuild');
const { execSync } = require('child_process');
const fs = require('fs');

// Убедимся, что директория dist существует
if (!fs.existsSync('./dist')) {
  fs.mkdirSync('./dist');
}

// Функция для сборки с указанным форматом
async function buildBundle(format, outfile) {
  console.log(`Сборка ${format} бандла...`);
  try {
    await build({
      entryPoints: ['src/index.ts'],
      bundle: true,
      minify: true,
      sourcemap: true,
      platform: 'neutral',
      format: format,
      outfile: outfile,
      external: ['react', 'react-dom'],
      // Настройка для обработки SCSS файлов (пустая обработка, т.к. мы компилируем SCSS отдельно)
      loader: { 
        '.scss': 'empty' 
      },
      define: {
        'process.env.NODE_ENV': '"production"'
      }
    });
    console.log(`✅ ${format.toUpperCase()} сборка успешно завершена`);
  } catch (error) {
    console.error(`❌ Ошибка при сборке ${format}:`, error);
    process.exit(1);
  }
}

// Запуск сборки
async function runBuild() {
  try {
    // Создаем директорию dist, если она не существует
    if (!fs.existsSync('./dist')) {
      fs.mkdirSync('./dist');
    }
    
    // Создаем директорию для стилей
    if (!fs.existsSync('./dist/styles')) {
      fs.mkdirSync('./dist/styles', { recursive: true });
    }

    // Очистка директории dist сохраняя саму директорию
    console.log('Очистка директории dist...');
    const files = fs.readdirSync('./dist');
    for (const file of files) {
      const path = `./dist/${file}`;
      if (fs.lstatSync(path).isDirectory()) {
        fs.rmSync(path, { recursive: true, force: true });
      } else {
        fs.unlinkSync(path);
      }
    }
    console.log('✅ Директория dist очищена');

    // Генерация TypeScript деклараций
    console.log('Генерация TypeScript деклараций...');
    execSync('tsc --emitDeclarationOnly');
    console.log('✅ TypeScript декларации сгенерированы');

    // Запуск esbuild для CJS и ESM версий
    await buildBundle('cjs', 'dist/index.js');
    await buildBundle('esm', 'dist/index.esm.js');

    // Компиляция SCSS
    console.log('Компиляция SCSS...');
    execSync('sass src/styles/index.scss dist/styles/index.css');
    console.log('✅ SCSS скомпилированы');

    // Копирование SCSS файлов
    console.log('Копирование SCSS файлов...');
    execSync('cpx "src/**/*.scss" dist');
    console.log('✅ SCSS файлы скопированы');

    console.log('🎉 Сборка успешно завершена!');
  } catch (error) {
    console.error('❌ Ошибка при сборке:', error);
    process.exit(1);
  }
}

runBuild();