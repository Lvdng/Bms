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
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteMenu">
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
    <a href="http://localhost:9090/menu/exportExcel">
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
        v-if="
          ['id', 'name', 'path', 'component', 'create'].includes(
            column.dataIndex
          )
        "
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

  <a-modal v-model:open="open" title="添加路由" :footer="null">
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
        name="m_id"
        :rules="[{ required: true, message: '请输入ID!' }]"
      >
        <a-input v-model:value="formState.m_id" />
      </a-form-item>

      <a-form-item
        label="图标"
        name="m_icon"
        :rules="[{ required: true, message: '请选择图标!' }]"
      >
        <a-select style="width: 80%" v-model:value="formState.m_icon">
          <a-select-option v-for="item in iconList" :key="item.icon">
            <Icon :icon="item.icon"></Icon>
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item
        label="名称"
        name="m_name"
        :rules="[{ required: true, message: '请输入名称!' }]"
      >
        <a-input v-model:value="formState.m_name" />
      </a-form-item>
      <a-form-item
        label="路径"
        name="m_path"
        :rules="[{ required: true, message: '请输入路径!' }]"
      >
        <a-input v-model:value="formState.m_path" />
      </a-form-item>

      <a-form-item
        label="组件"
        name="m_component"
        :rules="[{ required: true, message: '请输入组件!' }]"
      >
        <a-input v-model:value="formState.m_component" />
      </a-form-item>

      <a-form-item
        label="状态"
        name="m_status"
        :rules="[{ required: true, message: '请输入状态!' }]"
      >
        <a-radio-group v-model:value="formState.m_status">
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
  $getMenu,
  $selectMenu,
  $deleteMenu,
  $insertMenu,
  $updateMenu,
  $importMenuExcel,
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
  getMenuList();
});

const getMenuList = () => {
  $getMenu().then((res) => {
    const menu_temp = JSON.stringify(res);
    const menu = JSON.parse(menu_temp);
    const lst: any = [];
    menu.map((item: any) => {
      const menuItem = {
        key: item.m_id,
        icon: item.m_icon,
        name: item.m_name,
        path: item.m_path,
        component: item.m_component,
        status: item.m_status,
        create: item.m_create,
      };
      lst.push(menuItem);
    });
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
    title: "路径",
    dataIndex: "path",
  },
  {
    title: "组件",
    dataIndex: "component",
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
  path: string;
  component: string;
  status: number;
  create: string;
}
const data: any[] = reactive([]);
const dataSource = ref(data);
const editableData: UnwrapRef<Record<any, any>> = reactive([]);
// update
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
  const item = JSON.stringify(
    Object.assign(dataSource.value.filter((item) => key === item.key)[0])
  );
  const editItem_temp = JSON.parse(item);
  const editItem: FormState = reactive(<FormState>{});
  editItem.m_id = editItem_temp.key;
  editItem.m_icon = editItem_temp.icon;
  editItem.m_name = editItem_temp.name;
  editItem.m_path = editItem_temp.path;
  editItem.m_component = editItem_temp.component;
  editItem.m_status = Number(editItem_temp.status);
  $updateMenu(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getMenuList();
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
    disabled: record.name === "系统管理",
    name: record.name,
  }),
};

const deleteMenu = () => {
  const keys_temp = JSON.stringify(selectKeys.value);
  const keys = JSON.parse(keys_temp);
  for (let i = 0; i < keys.length; i++) {
    const element = keys[i];
    $deleteMenu(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        getMenuList();
        return 0;
      }
      message.error("删除失败,请先解除用户-路由关系", 0.5);
    });
  }
};

// select
const search = ref<string>("");
const onSearch = (searchValue: string) => {
  if (searchValue != "") {
    $selectMenu(searchValue).then((res: any) => {
      const lst: any = reactive([]);
      let rs = res[0];
      lst.push({
        key: rs.m_id,
        name: rs.m_name,
        path: rs.m_path,
        icon: rs.m_icon,
        component: rs.m_component,
        status: rs.m_status,
      });
      const lst_temp = JSON.stringify(lst);
      const _lst = JSON.parse(lst_temp);
      dataSource.value = _lst;
    });
  } else {
    getMenuList();
  }
};

// showModal
const open = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};

// insert
interface FormState {
  m_id: number | undefined;
  m_icon: string;
  m_name: string;
  m_path: string;
  m_component: string;
  m_status: number | undefined;
}

const formState = reactive<FormState>({
  m_id: undefined,
  m_icon: "",
  m_name: "",
  m_path: "",
  m_component: "",
  m_status: undefined,
});
const onFinish = (values: any) => {
  values.m_id = Number(values.m_id);
  values.m_status = Number(values.m_status);
  $insertMenu(values).then((res: any) => {
    if (res === 1) {
      message.success("新增成功", 0.5);
      getMenuList();
      formState.m_id = undefined;
      formState.m_icon = "";
      formState.m_name = "";
      formState.m_path = "";
      formState.m_component = "";
      formState.m_status = undefined;
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
  $importMenuExcel(formData)
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
