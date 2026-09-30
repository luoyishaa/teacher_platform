import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/auth": "http://localhost:8088",
      "/courses": "http://localhost:8088",
      "/resources": "http://localhost:8088",
    },
  },
});
