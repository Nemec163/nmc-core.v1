import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      '@nmc/ui': path.resolve(__dirname, '../../nmc-ui.v1/src'),
      '@nmc-ui.v1/src': path.resolve(__dirname, '../../nmc-ui.v1/src')
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        importers: [{
          canonicalize(url) {
            if (url.startsWith('@nmc/ui/') || url.startsWith('@nmc-ui.v1/src/')) {
              return new URL(`custom:${url}`);
            }
            return null;
          },
          load(canonicalUrl) {
            const url = canonicalUrl.toString();
            
            if (url.startsWith('custom:')) {
              const originalUrl = url.substring(7);
              let filePath = originalUrl;
              
              if (filePath.startsWith('@nmc/ui/')) filePath = filePath.replace('@nmc/ui/', '');
              else if (filePath.startsWith('@nmc-ui.v1/src/')) filePath = filePath.replace('@nmc-ui.v1/src/', '');
              
              const fullPath = path.resolve(__dirname, `../../nmc-ui.v1/src/${filePath}`);
              
              return {
                contents: '',
                syntax: 'scss',
                sourceMapUrl: canonicalUrl,
                resolvedUrl: new URL(`file://${fullPath}`)
              };
            }
            return null;
          }
        }]
      }
    }
  }
});