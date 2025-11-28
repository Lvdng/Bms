<template>
  <div>
    <a-row>
      <a-col :span="12">
        <a-card title="基本信息" hoverable>
          <template #extra><a @click="showModal">修改</a></template>
          <a-descriptions>
            <a-descriptions-item v-for="item in basic" :label="item.label">
              {{ item.val }}
            </a-descriptions-item>
          </a-descriptions>
        </a-card>
        <a-card title="收件箱" hoverable>
          <a-list size="small" :data-source="data" :locale="locale">
            <template #renderItem="{ item }">
              <a-list-item><MailOutlined /> {{ item }}</a-list-item>
            </template>
          </a-list>
        </a-card>
      </a-col>
      <a-col :span="12">
        <a-card title="近期活动" style="height: 463px" hoverable>
          <a-list size="small" :data-source="recentData">
            <template #renderItem="{ item }">
              <a-list-item>
                <i style="color: #1677ff">{{
                  item.br_borrow ? "归还了" : "借阅了"
                }}</i>
                书本 {{ item.b_code }}——————————————————{{
                  item.br_debit_reply
                }}
              </a-list-item>
            </template>
          </a-list>
        </a-card>
      </a-col>
    </a-row>

    <a-modal v-model:open="open" title="修改个人信息" :footer="null">
      <a-form
        :model="formState"
        name="basic"
        :label-col="{ span: 4 }"
        :wrapper-col="{ span: 20 }"
        autocomplete="off"
        @finish="onFinish"
        @finishFailed="onFinishFailed"
      >
        <a-form-item
          label="密码"
          name="u_pwd"
          :rules="[{ required: true, message: '请输入密码!' }]"
        >
          <a-input v-model:value="formState.u_pwd" />
        </a-form-item>

        <a-form-item
          label="姓名"
          name="u_name"
          :rules="[{ required: false, message: '请输入姓名!' }]"
        >
          <a-input v-model:value="formState.u_name" />
        </a-form-item>

        <a-form-item
          label="性别"
          name="u_sex"
          :rules="[{ required: false, message: '请选择性别!' }]"
        >
          <a-radio-group v-model:value="formState.u_sex">
            <a-radio value="男">男</a-radio>
            <a-radio value="女">女</a-radio>
          </a-radio-group>
        </a-form-item>

        <a-form-item
          label="出生日期"
          name="u_birth"
          :rules="[{ required: false, message: '请输入出生日期!' }]"
        >
          <a-date-picker v-model:value="formState.u_birth" placeholder=" " />
        </a-form-item>

        <a-form-item
          label="帐号状态"
          name="u_status"
          :rules="[{ required: false, message: '请选择帐号状态!' }]"
        >
          <a-radio-group v-model:value="formState.u_status">
            <a-radio value="1">正常</a-radio>
            <a-radio value="0">挂失</a-radio>
          </a-radio-group>
        </a-form-item>

        <a-form-item :wrapper-col="{ offset: 4, span: 18 }">
          <a-button style="width: 90%" type="primary" html-type="submit">
            提交
          </a-button>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import locale from "ant-design-vue/es/locale/zh_CN";
import { onMounted, ref, reactive } from "vue";
import { MailOutlined, MailFilled } from "@ant-design/icons-vue";
import { $selectBorrowByUid, $updateUser } from "@/api";
import { message } from "ant-design-vue";

const userInfo: any = ref([]);
const basic: any = ref([]);
const userRoleList: any = ref([]);
const roleList: any = ref([]);
const roleMenuList: any = ref([]);
const menuList: any = ref([]);

const data: string[] = [];
const recentData: any = ref([]);

onMounted(() => {
  const userTemp: any = localStorage.getItem("userInfo");
  const user = JSON.parse(userTemp);
  userInfo.value = user;
  const basic_temp: any = [
    { label: "姓名", val: user.u_name },
    { label: "账号", val: user.u_id },
    { label: "性别", val: user.u_sex },
    { label: "出生日期", val: user.u_birth },
    { label: "账号状态", val: user.u_status == 1 ? "正常" : "挂失" },
    { label: "权限", val: user.roleList[0].r_ide },
    // { label: "可借书本书", val: user.roleList[0].r_limit_book },
    // { label: "可借天数", val: user.roleList[0].r_limit_day },
  ];
  basic.value = basic_temp;
  userRoleList.value = user.userRoleList;
  roleList.value = user.roleList;
  roleMenuList.value = user.roleMenuList;
  menuList.value = user.menuList;

  $selectBorrowByUid(userInfo.value.u_id).then((res: any) => {
    recentData.value = res;
  });
});

interface FormState {
  u_id: string;
  u_pwd: string;
  u_name: string;
  u_sex: string;
  u_birth: string;
  u_status: number | undefined;
}
const formState = reactive<FormState>({
  u_id: "",
  u_pwd: "",
  u_name: "",
  u_sex: "",
  u_birth: "",
  u_status: 1,
});
// showModal
const open = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};
const onFinish = (values: any) => {
  values.u_id = JSON.parse(JSON.stringify(userInfo.value.u_id));
  $updateUser(values).then((res: any) => {
    if (res == 1) {
      message.success("修改成功", 0.5);
      formState.u_pwd = "";
      formState.u_birth = "";
      formState.u_name = "";
      formState.u_sex = "";
      open.value = false;
    }
  });
};

const onFinishFailed = (errorInfo: any) => {
  console.log("Failed:", errorInfo);
};
</script>

<style scoped>
.ant-input {
  width: 80%;
}
.ant-card {
  min-height: 100px;
  margin: 10px;
}
.blue {
  color: white;
  background-image: linear-gradient(to right, #68a6fb, #3464ed);
}
.pink {
  color: white;
  background-image: linear-gradient(to right, #ed5d7b, #d65484);
}
.purple {
  color: white;
  background-image: linear-gradient(to right, #d324fd, #aa2ff3);
}
</style>
