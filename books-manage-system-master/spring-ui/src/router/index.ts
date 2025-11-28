import { createRouter, createWebHashHistory } from 'vue-router'

const modules = import.meta.glob("../views/**/**.vue");

const children: any = [];
const routes = [
    {
        path: '/',
        name: 'login',
        component: () => import('../views/LoginView.vue'),
    }, {
        path: '/main',
        name: 'layout',
        component: () => import('../views/LayoutView.vue'),
        redirect: '/home',
        children: children
    },
]

// 修复：先获取localStorage的值，判断非null后再解析
const storedUserInfo = localStorage.getItem("userInfo");
let userInfo = null;
if (storedUserInfo) { // 只有当storedUserInfo是string时，才执行parse
    userInfo = JSON.parse(storedUserInfo);
}

if (userInfo !== null) {
    for (let i = 0; i < userInfo.menuList.length; i++) {
        const item = userInfo.menuList[i];
        const menuItem = {
            path: item.m_path,
            name: item.m_id.toString(), // 补充：name需为string类型（item.m_id是number的话要转string）
            component: modules[`../views/pages/${item.m_component}View.vue`],
        };
        children.push(menuItem);
    }
}

const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes,
})

export default router