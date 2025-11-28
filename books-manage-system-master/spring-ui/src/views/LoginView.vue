<template>
  <!-- 全屏背景容器 -->
  <div class="login-container">
    <!-- 背景层（半透明渐变+图书相关背景图） -->
    <div class="login-bg">
      <div class="bg-overlay"></div>
    </div>

    <!-- 登录卡片（居中显示） -->
    <div class="login-card">
      <!-- 系统Logo/标题区域 -->
      <div class="login-header">
        <div class="logo-icon">📚</div>
        <h1 class="system-title">悦读图书管理系统</h1>
        <p class="system-desc">智能数字化的图书管理方案，让知识照亮彼此</p>
      </div>

      <!-- 登录表单：添加 requiredMark="none" 隐藏必填项星号（无需样式穿透） -->
      <a-form
          :model="formState"
          name="basic"
          :label-col="{ span: 7 }"
          :wrapper-col="{ span: 17 }"
          autocomplete="off"
          @finish="onFinish"
          @finishFailed="onFinishFailed"
          class="login-form"
          requiredMark="none"
      ><!-- 官方属性：隐藏所有必填项的红色星号 -->
        <a-form-item
            label="账号"
            name="username"
            :rules="[{ required: true, message: '请输入账号!' }]"
        >
          <a-input
              v-model:value="formState.username"
              placeholder="请输入账号"
              class="custom-input"
          >
            <template #prefix><UserOutlined class="input-icon" /></template>
          </a-input>
        </a-form-item>

        <a-form-item
            label="密码"
            name="password"
            :rules="[{ required: true, message: '请输入密码!' }]"
        >
          <a-input-password
              v-model:value="formState.password"
              placeholder="请输入密码"
              class="custom-input"
          >
            <template #prefix><LockOutlined class="input-icon" /></template>
          </a-input-password>
        </a-form-item>

        <a-form-item
            label="验证码"
            name="code"
            :rules="[{ required: true, message: '请输入验证码!' }]"
        >
          <a-row gutter="8" class="code-group">
            <a-col :span="15">
              <a-input
                  v-model:value="formState.code"
                  placeholder="请输入验证码"
                  class="custom-input"
              >
                <template #prefix><CodeOutlined class="input-icon" /></template>
              </a-input>
            </a-col>
            <a-col :span="9">
              <img
                  :src="codeSrc"
                  alt="验证码"
                  @click="getUserCode"
                  class="code-img"
                  title="点击刷新验证码"
              />
            </a-col>
          </a-row>
        </a-form-item>

        <a-form-item :wrapper-col="{ offset: 7, span: 17 }">
          <a-button
              type="primary"
              html-type="submit"
              class="login-btn"
          >
            登录系统
          </a-button>
        </a-form-item>
      </a-form>

      <!-- 底部版权信息 -->
      <div class="login-footer">
        <p>© 2025 悦读图书管理系统 - 版权所有</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from "vue";
import {$login, $getUserCode} from "@/api";
import router from "@/router";
import { message } from "ant-design-vue";
// 导入存在的图标（无兼容性问题）
import { UserOutlined, LockOutlined, CodeOutlined } from '@ant-design/icons-vue';

interface FormState {
  username: string;
  password: string;
  code: string;
}

const formState = reactive<FormState>({
  username: "",
  password: "",
  code: "",
});

const codeSrc: any = ref("");
onMounted(() => {
  getUserCode();
});

const getUserCode = () => {
  $getUserCode().then((res: any) => {
    const bufferUrl = btoa(
        new Uint8Array(res).reduce(
            (data, byte) => data + String.fromCharCode(byte),
            ""
        )
    );
    codeSrc.value = "data:image/png;base64," + bufferUrl;
  });
};

const onFinish = (values: any) => {
  $login(values).then((res) => {
    localStorage.setItem("userInfo", JSON.stringify(res));
    const userTemp: any = localStorage.getItem("userInfo");
    const user = JSON.parse(userTemp);
    console.log(res);
    if (user == "") {
      message.error("验证码错误/账号或密码错误/账号处于挂失", 0.5);
      formState.code = "";
      getUserCode();
      router.push("/");
      localStorage.clear();
      return 0;
    }
    if (user != "") {
      const redrict = user.menuList[0].m_path;
      message.success("欢迎您！" + user.u_name, 0.5);
      router.push(redrict);
      setTimeout(() => {
        location.replace(location.href);
      }, 500);
    }
  });
};

const onFinishFailed = (errorInfo: any) => {
  console.log("Failed:", errorInfo);
  message.error("请填写表单", 0.5);
};
</script>

<style scoped>
/* 全屏容器 */
.login-container {
  position: relative;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 背景层 */
.login-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('@/assets/login.png'); /* 本地图片路径（根据实际调整） */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed; /* 固定背景，滚动时不移动（可选） */
  z-index: 1;
}

/* 背景渐变遮罩（提升文字可读性） */
.bg-overlay {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(54, 73, 93, 0.7) 0%, rgba(15, 32, 43, 0.8) 100%);
}

/* 登录卡片 */
.login-card {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 420px;
  padding: 36px 32px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  backdrop-filter: blur(8px);
}

/* 登录头部（Logo+标题） */
.login-header {
  text-align: center;
  margin-bottom: 32px;
}

.logo-icon {
  font-size: 48px;
  margin-bottom: 16px;
  transition: transform 0.3s ease;
}

.logo-icon:hover {
  transform: scale(1.1);
}

.system-title {
  font-size: 24px;
  font-weight: 600;
  color: #364958;
  margin-bottom: 8px;
}

.system-desc {
  font-size: 14px;
  color: #78858f;
  line-height: 1.5;
}

/* 表单样式 */
.login-form {
  width: 100%;
}

/* 自定义输入框 */
.custom-input {
  height: 44px;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  transition: all 0.3s ease;
}

.custom-input:focus {
  border-color: #4299e1;
  box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
}

/* 输入框图标 */
.input-icon {
  color: #94a3b8;
  font-size: 16px;
}

/* 验证码组 */
.code-group {
  display: flex;
  align-items: center;
}

.code-img {
  width: 100%;
  height: 44px;
  border-radius: 8px;
  cursor: pointer;
  object-fit: cover;
  border: 1px solid #e5e7eb;
  transition: all 0.2s ease;
}

.code-img:hover {
  border-color: #4299e1;
  box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
}

/* 登录按钮 */
.login-btn {
  height: 46px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  background: linear-gradient(135deg, #4299e1 0%, #38bdf8 100%);
  border: none;
  transition: all 0.3s ease;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(66, 153, 225, 0.2);
  background: linear-gradient(135deg, #3b82f6 0%, #2dd4bf 100%);
}

.login-btn:active {
  transform: translateY(0);
}

/* 底部版权 */
.login-footer {
  margin-top: 24px;
  text-align: center;
  font-size: 12px;
  color: #94a3b8;
}

/* 响应式适配（手机端） */
@media (max-width: 768px) {
  .login-card {
    margin: 0 20px;
    padding: 28px 24px;
  }

  .system-title {
    font-size: 20px;
  }

  .login-btn {
    height: 44px;
    font-size: 15px;
  }
}
</style>