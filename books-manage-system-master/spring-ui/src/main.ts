import {createApp} from "vue";
import {createPinia} from "pinia";

import App from "./App.vue";
import router from "./router";
import Antd from "ant-design-vue";
import "ant-design-vue/dist/reset.css";
import "@ant-design/icons-vue";
import ECharts from "vue-echarts";
import "echarts";

const app = createApp(App);

app.use(router)
    .use(createPinia())
    .use(Antd)
    .component("v-chart", ECharts)
    .mount("#app");
