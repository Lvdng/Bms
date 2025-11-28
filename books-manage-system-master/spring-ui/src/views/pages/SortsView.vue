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
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteSorts">
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
    <a href="http://localhost:9090/sorts/exportExcel">
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
        v-if="['id', 'name', 'code', 'create'].includes(column.dataIndex)"
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

  <a-modal v-model:open="open" title="添加类别" :footer="null">
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
        name="s_id"
        :rules="[{ required: true, message: '请输入ID!' }]"
      >
        <a-input v-model:value="formState.s_id" />
      </a-form-item>

      <a-form-item
        label="图标"
        name="s_icon"
        :rules="[{ required: true, message: '请选择图标!' }]"
      >
        <a-select style="width: 80%" v-model:value="formState.s_icon">
          <a-select-option v-for="item in iconList" :key="item.icon">
            <Icon :icon="item.icon"></Icon>
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item
        label="名称"
        name="s_sort"
        :rules="[{ required: true, message: '请输入名称!' }]"
      >
        <a-input v-model:value="formState.s_sort" />
      </a-form-item>
      <a-form-item
        label="类别代码"
        name="s_code"
        :rules="[{ required: true, message: '请输入类别代码!' }]"
      >
        <a-input v-model:value="formState.s_code" />
      </a-form-item>

      <a-form-item
        label="状态"
        name="s_status"
        :rules="[{ required: true, message: '请输入状态!' }]"
      >
        <a-radio-group v-model:value="formState.s_status">
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
  $getSorts,
  $selectSorts,
  $deleteSorts,
  $insertSorts,
  $updateSorts,
  $importSortsExcel,
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
  getSortsList();
});

const getSortsList = () => {
  $getSorts().then((res) => {
    const menu_temp = JSON.stringify(res);
    const menu = JSON.parse(menu_temp);
    const lst: any = [];
    menu.map((item: any) => {
      const menuItem = {
        key: item.s_id,
        icon: item.s_icon,
        name: item.s_sort,
        code: item.s_code,
        status: item.s_status,
        create: item.s_create,
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
    title: "类别代码",
    dataIndex: "code",
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
  code: number;
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
  const editItem_temp = JSON.parse(
    JSON.stringify(
      Object.assign(dataSource.value.filter((item) => key === item.key)[0])
    )
  );
  const editItem: FormState = reactive(<FormState>{});
  editItem.s_id = Number(editItem_temp.key);
  editItem.s_icon = editItem_temp.icon;
  editItem.s_sort = editItem_temp.name;
  editItem.s_code = editItem_temp.code;
  editItem.s_status = Number(editItem_temp.status);
  $updateSorts(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getSortsList();
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
    disabled: record.name === "系统管理员",
    name: record.name,
  }),
};

const deleteSorts = () => {
  const keys_temp = JSON.stringify(selectKeys.value);
  const keys = JSON.parse(keys_temp);
  for (let i = 0; i < keys.length; i++) {
    const element = keys[i];
    $deleteSorts(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        getSortsList();
        return 0;
      }
      message.error("删除失败", 0.5);
    });
  }
};

// select
const search = ref<string>("");
const onSearch = (searchValue: string) => {
  if (searchValue != "") {
    $selectSorts(searchValue).then((res: any) => {
      const lst: any = reactive([]);
      let rs = res[0];
      lst.push({
        key: rs.s_id,
        name: rs.s_sort,
        code: rs.s_code,
        icon: rs.s_icon,
        status: rs.s_status,
        create: rs.s_create,
      });
      const lst_temp = JSON.stringify(lst);
      const _lst = JSON.parse(lst_temp);
      dataSource.value = _lst;
    });
  } else {
    getSortsList();
  }
};

// showModal
const open = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};

// insert
interface FormState {
  s_id: number | undefined;
  s_icon: string;
  s_sort: string;
  s_code: string;
  s_status: number | undefined;
}

const formState = reactive<FormState>({
  s_id: undefined,
  s_icon: "",
  s_sort: "",
  s_code: "",
  s_status: undefined,
});
const onFinish = (values: any) => {
  values.s_id = Number(values.s_id);
  values.s_status = Number(values.s_status);
  values.s_code = values.s_code;
  console.log(values);
  $insertSorts(values).then((res: any) => {
    if (res === 1) {
      message.success("新增成功", 0.5);
      getSortsList();
      formState.s_id = undefined;
      formState.s_icon = "";
      formState.s_sort = "";
      formState.s_code = "";
      formState.s_status = undefined;
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
  $importSortsExcel(formData)
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
