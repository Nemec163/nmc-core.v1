const { build } = require('esbuild');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const DIST_DIR = path.resolve(__dirname, 'dist');
const STYLE_SRC = 'src/styles/index.scss';
const STYLE_OUT = 'dist/styles/index.css';

const clean = () => {
  if (fs.existsSync(DIST_DIR)) fs.rmSync(DIST_DIR, { recursive: true, force: true });
  fs.mkdirSync(path.join(DIST_DIR, 'styles'), { recursive: true });
};

const buildTypes = () => {
  console.log('📄 Type generation...');
  execSync('tsc --emitDeclarationOnly');
};

const buildSCSS = () => {
  console.log('🎨 SCSS Compilation...');
  execSync(`sass ${STYLE_SRC} ${STYLE_OUT}`);
};

const buildBundle = async (format, outfile) => {
  console.log(`📦 Bundling ${format}...`);
  await build({
    entryPoints: ['src/index.ts'],
    bundle: true,
    minify: true,
    sourcemap: true,
    platform: 'neutral',
    format,
    outfile,
    external: ['react', 'react-dom', 'lucide-react'],
    loader: { '.scss': 'empty' },
    define: {
      'process.env.NODE_ENV': '"production"'
    }
  });
};

(async () => {
  try {
    clean();
    buildTypes();
    await buildBundle('cjs', 'dist/index.js');
    await buildBundle('esm', 'dist/index.esm.js');
    buildSCSS();
    console.log('✅ Build completed successfully!');
  } catch (e) {
    console.error('❌ Build error', e);
    process.exit(1);
  }
})();
