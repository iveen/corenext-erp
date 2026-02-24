import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        global: {
          statements: 85,
          branches: 85,
          functions: 85,
          lines: 85
        }
      }
    },
    environment: 'jsdom',
    include: ['src/**/*.{test,spec}.{js,ts,jsx,tsx,vue}']
  }
})
