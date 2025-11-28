<template>
  <a-layout>
    <a-layout-sider v-model:collapsed="collapsed" :trigger="null" collapsible>
      <a-menu v-model:selectedKeys="selectedKeys" theme="dark" mode="inline">
        <div
          style="
            width: 96%;
            height: 40px;
            line-height: 40px;
            text-align: center;
            background-color: #1677ff;
            margin: 10px auto;
            border-radius: 8px;
            font-size: 16px;
            color: #eee;
            font-weight: bold;
          "
        >
          {{ collapsed == true ? "图书" : "悦读图书管理系统" }}
        </div>
        <a-menu-item
          v-for="item in menuList"
          :key="item.label"
          @click="clickMenuItem(item.path, item.label)"
        >
          <Icon :icon="item.icon"></Icon>
          <span>{{ item.label }}</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <a-layout-header style="background: #fff; padding: 0">
        <div
          style="
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
          "
        >
          <div>
            <menu-unfold-outlined
              v-if="collapsed"
              class="trigger"
              @click="() => (collapsed = !collapsed)"
            />
            <menu-fold-outlined
              v-else
              class="trigger"
              @click="() => (collapsed = !collapsed)"
            />
          </div>
          <div>
            <a-button @click="showConfirm">退出登录</a-button>
          </div>
        </div>
      </a-layout-header>
      <a-layout-content
        :style="{
          margin: '16px 16px',
          padding: '14px',
          background: '#fff',
          minHeight: '280px',
        }"
      >
        <RouterView />
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>
<script lang="ts" setup>
import { ref, reactive, onMounted, h, createVNode } from "vue";
import { Icon } from "../config/Icon";
import {
  MenuUnfoldOutlined,
  MenuFoldOutlined,
  ExclamationCircleOutlined,
} from "@ant-design/icons-vue";
import router from "@/router";
import { Modal } from "ant-design-vue";

const selectedKeys: any = ref<string[]>([""]);
const collapsed = ref<boolean>(false);

const menuList: any = reactive([]);
onMounted(() => {
  const userTemp: any = localStorage.getItem("userInfo");
  const user = JSON.parse(userTemp);
  const menu = user.menuList;
  menu.map((item: any) => {
    const menuItem = {
      id: item.m_id,
      icon: item.m_icon,
      label: item.m_name,
      path: item.m_path,
    };
    menuList.push(menuItem);
    const m_name = localStorage.getItem("m_name");
    if (m_name == null) {
      selectedKeys.value = ["首页"];
    } else {
      selectedKeys.value = [localStorage.getItem("m_name")];
    }
  });
});

const showConfirm = () => {
  setTimeout(() => {
    Modal.confirm({
      content: "确认退出",
      icon: createVNode(ExclamationCircleOutlined),
      okText: "确认",
      onOk() {
        return new Promise((resolve, reject) => {
          setTimeout(Math.random() > 0.5 ? resolve : reject, 100);
          router.push("/");
          localStorage.clear();
        }).catch(() => console.log("Oops errors!"));
      },
      cancelText: "取消",
      onCancel() {
        Modal.destroyAll();
      },
    });
  }, 0);
};

const clickMenuItem = (path: any, name: any) => {
  router.push(path);
  localStorage.setItem("m_name", name);
};
</script>

<style scoped>
.ant-layout-sider {
  height: 100vh;
}
.trigger {
  transform: scale(1.5);
}
</style>
