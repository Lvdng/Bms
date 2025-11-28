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
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteRole">
      批量删除
    </a-button>
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
    <a href="http://localhost:9090/role/exportExcel">
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
      <template v-if="['id', 'name', 'book', 'day'].includes(column.dataIndex)">
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

      <template v-else-if="column.dataIndex === 'icon'">
        <span v-if="editableData[record.key]">
          <a-select v-model:value="editableData[record.key].icon">
            <a-select-option v-for="item in iconList" :key="item.icon">
              <Icon :icon="item.icon"></Icon>
            </a-select-option>
          </a-select>
        </span>
        <span v-else>
          <Icon :icon="text"></Icon>
        </span>
      </template>

      <template v-else-if="column.dataIndex === 'menu'">
        <span v-if="editableData[record.key]">
          <a-select
            @change="handleChange"
            :field-names="{ label: 'm_name', value: 'm_id' }"
            v-model:value="editableData[record.key][column.dataIndex]"
            mode="multiple"
            style="width: 100%"
            placeholder="请选择可操作路由"
            :options="options"
          ></a-select>
        </span>
        <span v-else>
          <a-dropdown-button>
            {{ text[0].label }}
            <template #overlay>
              <a-menu>
                <a-menu-item v-for="item in text" :key="item.value">
                  <Icon :icon="item.icon"></Icon>
                  {{ item.label }}
                </a-menu-item>
              </a-menu>
            </template>
          </a-dropdown-button>
        </span>
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
          <a-tag color="#f50" v-if="text == '0'">禁用</a-tag>
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

  <a-modal v-model:open="open" title="添加角色" :footer="null">
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
        label="ID"
        name="r_id"
        :rules="[{ required: true, message: '请输入ID!' }]"
      >
        <a-input v-model:value="formState.r_id" />
      </a-form-item>

      <a-form-item
        label="图标"
        name="r_icon"
        :rules="[{ required: true, message: '请选择图标!' }]"
      >
        <a-select style="width: 80%" v-model:value="formState.r_icon">
          <a-select-option v-for="item in iconList" :key="item.icon">
            <Icon :icon="item.icon"></Icon>
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item
        label="名称"
        name="r_ide"
        :rules="[{ required: true, message: '请输入名称!' }]"
      >
        <a-input v-model:value="formState.r_ide" />
      </a-form-item>
      <a-form-item
        label="借阅书数"
        name="r_limit_book"
        :rules="[{ required: true, message: '请输入借阅书数!' }]"
      >
        <a-input v-model:value="formState.r_limit_book" />
      </a-form-item>

      <a-form-item
        label="借阅天数"
        name="r_limit_day"
        :rules="[{ required: true, message: '请输入借阅天数!' }]"
      >
        <a-input v-model:value="formState.r_limit_day" />
      </a-form-item>

      <a-form-item
        label="路由"
        name="r_menu"
        :rules="[{ required: true, message: '请选择路由!' }]"
      >
        <a-select
          :field-names="{ label: 'm_name', value: 'm_id' }"
          v-model:value="formState.r_menu"
          mode="multiple"
          style="width: 80%"
          placeholder=" "
          :options="options"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="状态"
        name="r_status"
        :rules="[{ required: true, message: '请输入状态!' }]"
      >
        <a-radio-group v-model:value="formState.r_status">
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
  $getRole,
  $selectRole,
  $deleteRole,
  $insertRole,
  $updateRole,
  $getMenu,
  $deleteRoleMenuAll,
  $insertRoleMenu,
  $deleteRoleMenuAllWithUser,
  $importRoleExcel,
} from "@/api";
import { cloneDeep } from "lodash-es";
import { reactive, ref, onMounted, h } from "vue";
import type { UnwrapRef } from "vue";
import { Icon, iconList } from "@/config/Icon";
import { type TableProps, type TableColumnType, message } from "ant-design-vue";
import {
  PlusCircleOutlined,
  DeleteOutlined,
  DownloadOutlined,
  CloudUploadOutlined,
} from "@ant-design/icons-vue";

onMounted(() => {
  getRoleList();
  getMenuList();
});

const options = reactive<any["options"]>([]);
const getMenuList = () => {
  $getMenu().then((res: any) => {
    res.map((item: any) => {
      options.push(item);
    });
  });
};

const getRoleList = () => {
  $getRole().then((res) => {
    const menu = JSON.parse(JSON.stringify(res));
    const lst: any = [];
    menu.map((item: any) => {
      const menuItem = {
        key: item.r_id,
        icon: item.r_icon,
        name: item.r_ide,
        book: item.r_limit_book,
        day: item.r_limit_day,
        roleMenu: item.roleMenuList,
        menu: item.menuList,
        status: item.r_status,
        create: item.r_create,
      };
      lst.push(menuItem);
    });

    for (let i = 0; i < lst.length; i++) {
      const element = lst[i];
      for (let j = 0; j < element.menu.length; j++) {
        const e = element.menu[j];
        const require = {
          value: e.m_id,
          label: e.m_name,
          icon: e.m_icon,
        };
        lst[i].menu[j] = require;
      }
    }
    dataSource.value = lst;
  });
};

const columns: TableColumnType<DataItem>[] = [
  {
    title: "ID",
    dataIndex: "key",
  },
  {
    title: "图标",
    dataIndex: "icon",
    width: "10%",
  },
  {
    title: "名称",
    dataIndex: "name",
  },
  {
    title: "借阅书数",
    dataIndex: "book",
  },
  {
    title: "借阅天数",
    dataIndex: "day",
  },
  {
    title: "管理路由",
    dataIndex: "menu",
  },
  {
    title: "状态",
    dataIndex: "status",
    width: "16%",
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
  key: number;
  icon: string;
  name: string;
  book: number;
  day: number;
  roleMenu: any;
  menu: any;
  status: number;
  create: string;
}
const data: any[] = reactive([]);
const dataSource = ref(data);
const editableData: UnwrapRef<Record<any, any>> = reactive([]);
// update
const handleChange = (value: string) => {
  const r_id = JSON.parse(JSON.stringify(isEdit.value)).roleMenu[0].r_id;
  const roleMenu = JSON.parse(JSON.stringify(isEdit.value)).roleMenu;
  if (value.length > roleMenu.length) {
    for (let i = 0; i < value.length; i++) {
      const element = value[i];
      $insertRoleMenu(r_id, element).then((res: any) => {
        console.log(res);
      });
    }
  } else {
    $deleteRoleMenuAll(r_id).then((res: any) => {
      console.log(res);
      for (let i = 0; i < value.length; i++) {
        const element = value[i];
        $insertRoleMenu(r_id, element);
      }
    });
  }
};
const isEdit: any = ref([]);
const edit = (key: string) => {
  editableData[key] = cloneDeep(
    dataSource.value.filter((item) => key === item.key)[0]
  );
  isEdit.value = JSON.parse(JSON.stringify(editableData[key]));
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
  const editItem: FormState = reactive(<FormState>{});
  editItem.r_id = Number(editItem_temp.key);
  editItem.r_icon = editItem_temp.icon;
  editItem.r_ide = editItem_temp.name;
  editItem.r_limit_book = Number(editItem_temp.book);
  editItem.r_limit_day = Number(editItem_temp.day);
  editItem.r_status = Number(editItem_temp.status);
  $updateRole(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getRoleList();
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
    selectKeys.value = selectedRowKeys;
  },
  getCheckboxProps: (record: DataItem) => ({
    disabled: record.name === "系统管理员",
    name: record.name,
  }),
};

const deleteRole = () => {
  const keys = JSON.parse(JSON.stringify(selectKeys.value));
  for (let i = 0; i < keys.length; i++) {
    const element = keys[i];
    $deleteRoleMenuAllWithUser(element);
    $deleteRole(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        getRoleList();
        return 0;
      }
      message.error("删除失败,请先解除用户-角色关系", 0.5);
    });
  }
};

// select
const search = ref<any>("");
const onSearch = () => {
  if (search.value != "") {
    $selectRole(search.value).then((res: any) => {
      const lst: any = ref([]);
      let rs = res[0];
      lst.value.push({
        key: rs.r_id,
        name: rs.r_ide,
        book: rs.r_limit_book,
        icon: rs.r_icon,
        day: rs.r_limit_day,
        roleMenu: rs.roleMenuList,
        menu: rs.menuList,
        status: rs.r_status,
        create: rs.r_create,
      });
      const _lst = JSON.parse(JSON.stringify(lst.value));
      const menu = [];
      for (let i = 0; i < _lst[0].menu.length; i++) {
        const element = _lst[0].menu[i];
        const req = {
          label: element.m_name,
          value: element.m_id,
          icon: element.m_icon,
        };
        menu.push(req);
      }
      _lst[0].menu = menu;
      dataSource.value = _lst;
    });
  } else {
    getRoleList();
  }
};

// showModal
const open = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};

// insert
interface FormState {
  r_id: number | undefined;
  r_icon: string;
  r_ide: string;
  r_limit_book: number | undefined;
  r_limit_day: number | undefined;
  r_menu: any;
  r_status: number | undefined;
}

const formState = reactive<FormState>({
  r_id: undefined,
  r_icon: "",
  r_ide: "",
  r_limit_book: undefined,
  r_limit_day: undefined,
  r_menu: [],
  r_status: undefined,
});

const onFinish = (values: any) => {
  values.r_id = Number(values.r_id);
  values.r_status = Number(values.r_status);
  values.r_limit_book = Number(values.r_limit_book);
  values.r_limit_day = Number(values.r_limit_day);
  values.r_menu = JSON.parse(JSON.stringify(values.r_menu));
  $insertRole(values).then((res: any) => {
    if (res === 1) {
      for (let i = 0; i < values.r_menu.length; i++) {
        const element = values.r_menu[i];
        $insertRoleMenu(values.r_id, element).then((res: any) => {
          console.log(res);
        });
      }
      message.success("新增成功", 0.5);
      getRoleList();
      formState.r_id = undefined;
      formState.r_icon = "";
      formState.r_ide = "";
      formState.r_limit_book = undefined;
      formState.r_limit_day = undefined;
      formState.r_status = undefined;
      formState.r_menu = [];
      open.value = false;
    } else {
      message.error("新增失败", 0.5);
    }
  });
};

const onFinishFailed = (errorInfo: any) => {
  console.log("Failed:", errorInfo);
};
// 导入
import type { UploadProps } from "ant-design-vue";

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
  $importRoleExcel(formData)
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

:deep(.ant-upload-wrapper) {
  display: flex;
  flex-direction: row;
  align-items: center;
  line-height: 32px;
}
.hidden {
  display: none;
}
</style>
