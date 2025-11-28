import {fileURLToPath, URL} from 'url';

import {defineConfig} from "vite";
import vue from "@vitejs/plugin-vue";
import vueJsx from "@vitejs/plugin-vue-jsx";

// https://vitejs.dev/config/ss
export default defineConfig({
    base: "",
    plugins: [
        vue(),
        vueJsx(),
    ],
    build: {
        target: 'modules',
        outDir: 'dist',
        assetsDir: 'assets',
    },
    resolve: {
        alias: {
            "@": fileURLToPath(new URL("./src", import.meta.url)),
        },
        extensions: [".mjs", ".js", ".ts", ".jsx", ".tsx", ".json", ".vue"],
    },
    server: {
        proxy: {
            '/api': {
                // target: "http://172.31.2.224:9090",
                // target: "http://47.97.254.66:9090",
                target: "http://localhost:9090",
                ws: true,
                changeOrigin: true,
                rewrite: (path) => path.replace(/^\/api/, ""),
            },
        },
    },
});
