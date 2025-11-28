<template>
  <a-space>
    <a-input-search
      style="width: 300px"
      v-model:value="search"
      placeholder="输入ID/名称"
      enter-button
      @search="onSearch"
    />
    <a-button :icon="h(PlusCircleOutlined)" @click="showModal">添加</a-button>
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteUser">批量删除</a-button>
    <!-- 导入 -->
    <div style="display: flex; flex-direction: row; align-items: center">
      <a-upload
        :file-list="fileList"
        :before-upload="beforeUpload"
        @remove="handleRemove"
      >
        <a-button type="primary" :class="fileList.length === 0 ? '' : 'hidden'">
          <CloudUploadOutlined />
          导入
        </a-button>
      </a-upload>
      <a-button
        type="primary"
        :class="fileList.length === 0 ? 'hidden' : ''"
        :loading="uploading"
        @click="handleUpload"
      >
        <CloudUploadOutlined />
        {{ uploading ? "上传中..." : "上传" }}
      </a-button>
    </div>
    <!-- 导出 -->
    <a href="http://localhost:9090/user/exportExcel">
      <a-button :icon="h(DownloadOutlined)" type="primary"> 导出 </a-button>
    </a>
  </a-space>

  <a-divider style="margin: 10px 0" />

  <a-table
    size="middle"
    :row-selection="rowSelection"
    :columns="columns"
    :data-source="dataSource"
    rowKey="key"
  >
    <template #bodyCell="{ column, text, record }">
      <template
        v-if="['id', 'name', 'sex', 'birth'].includes(column.dataIndex)"
      >
        <div>
          <a-input
            v-if="editableData[record.key]"
            v-model:value="editableData[record.key][column.dataIndex]"
            style="margin: -5px 0"
          />
          <template v-else>
            {{ text }}
          </template>
        </div>
      </template>

      <template v-else-if="column.dataIndex === 'pwd'">
        <a-dropdown>
          <template #overlay>
            <a-menu>
              <a-menu-item key="1">
                <UserOutlined />
                {{ text }}
              </a-menu-item>
            </a-menu>
          </template>
          <a-button size="small" style="font-size: 12px">
            查看
            <DownOutlined />
          </a-button>
        </a-dropdown>
      </template>

      <template v-else-if="column.dataIndex === 'i_identity'">
        <span v-if="editableData[record.key]">
          <a-select v-model:value="editableData[record.key][column.dataIndex]">
            <a-select-option v-for="item in roleList" :value="item.r_id">
              {{ item.r_ide }}
            </a-select-option>
          </a-select>
        </span>
        <span v-else>
          <a-tag color="#3b5999">{{ text }}</a-tag>
        </span>
      </template>

      <template v-else-if="column.dataIndex === 'i_status'">
        <a-tag color="#01a96e" v-if="text == '1'">正常</a-tag>
        <a-tag color="#f50" v-if="text == '0'">禁用</a-tag>
      </template>

      <template v-else-if="column.dataIndex === 'status'">
        <span v-if="editableData[record.key]">
          <a-radio-group
            v-model:value="editableData[record.key][column.dataIndex]"
          >
            <a-radio value="1">正常</a-radio>
            <a-radio value="0">禁用</a-radio>
          </a-radio-group>
        </span>
        <span v-else>
          <a-tag color="#01a96e" v-if="text == '1'">正常</a-tag>
          <a-tag color="#f50" v-if="text == '0'">挂失</a-tag>
        </span>
      </template>

      <template v-else-if="column.dataIndex === 'operation'">
        <div class="editable-row-operations">
          <span v-if="editableData[record.key]">
            <a-typography-link @click="save(record.key)">
              保存
            </a-typography-link>
            <a-popconfirm
              title="确定取消吗"
              ok-text="确定"
              cancel-text="取消"
              @confirm="cancel(record.key)"
            >
              <a>取消</a>
            </a-popconfirm>
          </span>
          <span v-else>
            <a @click="edit(record.key)">修改</a>
          </span>
        </div>
      </template>
    </template>
  </a-table>

  <a-modal v-model:open="open" title="添加用户" :footer="null">
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
        label="账号"
        name="u_id"
        :rules="[{ required: true, message: '请输入账号!' }]"
      >
        <a-input v-model:value="formState.u_id" />
      </a-form-item>

      <a-form-item
        label="密码"
        name="u_pwd"
        :rules="[{ required: true, message: '请输入密码!' }]"
      >
        <a-input v-model:value="formState.u_pwd" />
      </a-form-item>

      <a-form-item
        label="名称"
        name="u_name"
        :rules="[{ required: true, message: '请输入名称!' }]"
      >
        <a-input v-model:value="formState.u_name" />
      </a-form-item>

      <a-form-item
        label="性别"
        name="u_sex"
        :rules="[{ required: true, message: '请选择性别!' }]"
      >
        <a-radio-group v-model:value="formState.u_sex">
          <a-radio value="男">男</a-radio>
          <a-radio value="女">女</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="出生日期"
        name="u_birth"
        :rules="[{ required: true, message: '请输入出生日期!' }]"
      >
        <a-date-picker v-model:value="formState.u_birth" placeholder=" " />
      </a-form-item>

      <a-form-item
        label="角色"
        name="i_identity"
        :rules="[{ required: true, message: '请选择角色!' }]"
      >
        <a-radio-group v-model:value="formState.i_identity">
          <a-radio
            v-for="item in roleList"
            :value="item.r_id"
            :class="item.r_status == 1 ? 'green' : 'red'"
          >
            {{ item.r_ide }}
          </a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="状态"
        name="u_status"
        :rules="[{ required: true, message: '请输入状态!' }]"
      >
        <a-radio-group v-model:value="formState.u_status">
          <a-radio value="1">正常</a-radio>
          <a-radio value="0">禁用</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item :wrapper-col="{ offset: 4, span: 18 }">
        <a-button style="width: 90%" type="primary" html-type="submit">
          提交
        </a-button>
      </a-form-item>
    </a-form>
  </a-modal>
</template>
<script lang="ts" setup>
import {
  $getUser,
  $selectUser,
  $deleteUser,
  $insertUser,
  $updateUser,
  $getRole,
  $updateUserRole,
  $insertUserRole,
  $importUserExcel,
} from "@/api";
import { cloneDeep } from "lodash-es";
import { reactive, ref, onMounted, h } from "vue";
import type { UnwrapRef } from "vue";
import { type TableProps, type TableColumnType, message } from "ant-design-vue";
import type { UploadChangeParam } from "ant-design-vue";
import {
  PlusCircleOutlined,
  DeleteOutlined,
  CloudUploadOutlined,
  DownloadOutlined,
} from "@ant-design/icons-vue";
import { Icon } from "@/config/Icon";

onMounted(() => {
  getUserList();
  getRoleList();
});
const getRoleList = () => {
  $getRole().then((res) => {
    roleList.value = res;
  });
};
const getUserList = () => {
  $getUser().then((res) => {
    const user_temp = JSON.stringify(res);
    const user = JSON.parse(user_temp);
    const lst: any = [];
    user.map((item: any) => {
      const userItem = {
        key: item.u_id,
        pwd: item.u_pwd,
        name: item.u_name,
        sex: item.u_sex,
        birth: item.u_birth,
        i_identity: item.roleList[0].r_ide,
        i_status: item.roleList[0].r_status,
        status: item.u_status,
        create: item.u_create,
      };
      lst.push(userItem);
    });
    dataSource.value = lst;
  });
};

const columns: TableColumnType<DataItem>[] = [
  {
    title: "账号",
    dataIndex: "key",
  },
  {
    title: "密码",
    dataIndex: "pwd",
    width: "7%",
  },
  {
    title: "名称",
    dataIndex: "name",
  },
  {
    title: "性别",
    dataIndex: "sex",
  },
  {
    title: "出生日期",
    dataIndex: "birth",
  },
  {
    title: "角色",
    dataIndex: "i_identity",
    width: "12%",
  },
  {
    title: "角色状态",
    dataIndex: "i_status",
    width: "7%",
  },
  {
    title: "用户状态",
    dataIndex: "status",
    width: "14%",
  },
  {
    title: "创建时间",
    dataIndex: "create",
  },
  {
    title: "操作",
    dataIndex: "operation",
    width: "14%",
  },
];

interface DataItem {
  key: string;
  pwd: string;
  name: string;
  sex: string;
  birth: string;
  i_identity: string;
  i_status: number;
  status: number;
  create: string;
}
const data: any[] = reactive([]);
const dataSource = ref(data);
const editableData: UnwrapRef<Record<any, any>> = reactive([]);
// update
const editItem: FormState = reactive(<FormState>{});
const edit = (key: string) => {
  editableData[key] = cloneDeep(
    dataSource.value.filter((item) => key === item.key)[0]
  );
};
const save = (key: string) => {
  Object.assign(
    dataSource.value.filter((item) => key === item.key)[0],
    editableData[key]
  );
  const editItem_temp = JSON.parse(
    JSON.stringify(
      Object.assign(dataSource.value.filter((item) => key === item.key)[0])
    )
  );
  editItem.u_id = editItem_temp.key;
  editItem.u_pwd = editItem_temp.pwd;
  editItem.u_name = editItem_temp.name;
  editItem.u_sex = editItem_temp.sex;
  editItem.u_birth = editItem_temp.birth;
  editItem.u_status = Number(editItem_temp.status);
  editItem.i_identity = editItem_temp.i_identity;
  if (typeof JSON.parse(JSON.stringify(editItem)).i_identity == "number") {
    const re_userRole = {
      u_id: editItem.u_id,
      r_id: editItem.i_identity,
    };
    $updateUserRole(re_userRole).then((res: any) => {
      console.log(res);
    });
  }

  $updateUser(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getUserList();
    } else {
      message.error("修改失败", 0.5);
    }
  });
  delete editableData[key];
};
const cancel = (key: string) => {
  delete editableData[key];
};

// delete
const selectKeys: any = ref([]);
const rowSelection: TableProps["rowSelection"] = {
  onChange: (selectedRowKeys: any[], selectedRows: DataItem[]) => {
    // console.log(`selectedRowKeys: ${selectedRowKeys}`,"selectedRows: ",selectedRows);
    selectKeys.value = selectedRowKeys;
  },
  getCheckboxProps: (record: DataItem) => ({
    disabled: record.i_identity === "系统管理员",
    name: record.i_identity,
  }),
};

const deleteUser = () => {
  const keys = selectKeys.value; // 不需要JSON序列化再解析，直接用数组
  if (keys.length === 0) {
    message.warning("请先选择要删除的用户");
    return;
  }

  // 循环删除（建议用Promise.all优化，这里先保持原逻辑）
  keys.forEach((key: any) => {
    $deleteUser(key)
        .then((res: any) => {
          if (res === 1) {
            message.success("删除成功", 0.5);
            getUserList(); // 刷新列表
          } else {
            message.error("删除失败,请先解除用户-角色关系", 0.5);
          }
        })
        .catch((err: any) => {
          // 捕获错误（如CORS、网络异常等）
          message.error("请求失败：" + err.message, 1);
          console.error("删除请求错误：", err);
        });
  });
};
// const deleteUser = () => {
//   const keys_temp = JSON.stringify(selectKeys.value);
//   const keys = JSON.parse(keys_temp);
//   for (let i = 0; i < keys.length; i++) {
//     const element = keys[i];
//     $deleteUser(element).then((res: any) => {
//       if (res === 1) {
//         message.success("删除成功", 0.5);
//         getUserList();
//         return 0;
//       }
//       message.error("删除失败,请先解除用户-角色关系", 0.5);
//     })
//   }
// };

// select
const search = ref<string>("");
const onSearch = (searchValue: string) => {
  if (searchValue != "") {
    $selectUser(searchValue).then((res: any) => {
      const lst: any = reactive([]);
      let rs = res[0];
      lst.push({
        key: rs.u_id,
        name: rs.u_name,
        sex: rs.u_sex,
        pwd: rs.u_pwd,
        birth: rs.u_birth,
        status: rs.u_status,
        create: rs.u_create,
        i_identity: rs.roleList[0].r_ide,
        i_status: rs.roleList[0].r_status,
      });
      const lst_temp = JSON.stringify(lst);
      const _lst = JSON.parse(lst_temp);
      dataSource.value = _lst;
    });
  } else {
    getUserList();
  }
};

// showModal
const open = ref<boolean>(false);
const roleList = ref<any>([]);
const showModal = () => {
  open.value = true;
};

// insert
interface FormState {
  u_id: string;
  u_pwd: string;
  u_name: string;
  u_sex: string;
  u_birth: string;
  i_identity: number | undefined | string;
  u_status: number | undefined;
}

const formState = reactive<FormState>({
  u_id: "",
  u_pwd: "",
  u_name: "",
  u_sex: "",
  u_birth: "",
  i_identity: undefined,
  u_status: undefined,
});

const onFinish = (values: any) => {
  values.u_status = Number(values.u_status);
  values.i_identity = Number(values.i_identity);
  values.u_birth = JSON.parse(JSON.stringify(values.u_birth)).substring(0, 10);
  //addUser
  $insertUser(values).then((res: any) => {
    console.log(res);
    if (res === 1) {
      // addRole
      const userRole = reactive({
        u_id: values.u_id,
        r_id: values.i_identity,
      });
      const userRole_temp = JSON.stringify(userRole);
      const request_role = JSON.parse(userRole_temp);
      $insertUserRole(request_role).then((res: any) => {
        if (res === 1) {
          message.success("添加成功", 0.5);
          formState.u_id = "";
          formState.u_pwd = "";
          formState.u_name = "";
          formState.u_sex = "";
          formState.u_birth = "";
          formState.i_identity = undefined;
          formState.u_status = undefined;
          open.value = false;
          getUserList();
        } else {
          message.error("添加失败", 0.5);
        }
      });
    }
  });
};

const onFinishFailed = (errorInfo: any) => {
  console.log("Failed:", errorInfo);
};

// 导入
import type { UploadProps } from "ant-design-vue";
import axios from "axios";

const fileList = ref<any["fileList"]>([]);
const uploading = ref<boolean>(false);

const handleRemove: UploadProps["onRemove"] = (file) => {
  const index = fileList.value.indexOf(file);
  const newFileList = fileList.value.slice();
  newFileList.splice(index, 1);
  fileList.value = newFileList;
};

const beforeUpload: UploadProps["beforeUpload"] = (file) => {
  fileList.value = [...(fileList.value || []), file];
  return false;
};

const handleUpload = () => {
  const formData = new FormData();
  fileList.value.forEach((file: UploadProps["fileList"]) => {
    formData.append("file", file as any);
  });
  uploading.value = true;
  $importUserExcel(formData)
    .then(() => {
      fileList.value = [];
      uploading.value = false;
      message.success("上传成功.");
    })
    .catch(() => {
      fileList.value = [];
      uploading.value = false;
      message.error("上传失败.");
    });
};
</script>

<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}

.ant-input {
  width: 80%;
}
.green {
  color: green;
  padding: 6px 0;
}
.red {
  color: red;
  padding: 6px 0;
}


.hidden {
  display: none;
}
</style>
