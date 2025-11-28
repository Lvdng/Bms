<template>
  <a-space>
    <a-input-search
      style="width: 300px"
      v-model:value="search"
      placeholder="输入ID/名称"
      enter-button
      @search="onSearch"
    />
    <a-button :icon="h(PlusCircleOutlined)" @click="showModal"
      >默认添加</a-button
    >
    <a-button :icon="h(PlusCircleOutlined)" @click="showModalCustom"
      >自定义添加</a-button
    >
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteBookno">
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
    <a href="http://localhost:9090/bookno/exportExcel">
      <a-button :icon="h(DownloadOutlined)" type="primary"> 导出 </a-button>
    </a>
  </a-space>

  <a-divider style="margin: 10px 0" />

  <a-table
    size="middle"
    :row-selection="rowSelection"
    :columns="columns"
    :data-source="dataSource"
    rowKey="b_code"
  >
    <template #bodyCell="{ column, text, record }">
      <template v-if="['u_id', 'b_borrow_date'].includes(column.dataIndex)">
        <div>
          <a-input
            v-if="editableData[record.b_code]"
            v-model:value="editableData[record.b_code][column.dataIndex]"
            style="margin: -5px 0"
          />
          <template v-else>
            {{ text }}
          </template>
        </div>
      </template>

      <template v-else-if="column.dataIndex === 'b_borrow'">
        <span v-if="editableData[record.b_code]">
          <a-radio-group
            v-model:value="editableData[record.b_code][column.dataIndex]"
          >
            <a-radio value="1">在库</a-radio>
            <a-radio value="0">借出</a-radio>
          </a-radio-group>
        </span>
        <span v-else>
          <a-tag color="#01a96e" v-if="text == '1'">在库</a-tag>
          <a-tag color="#f50" v-if="text == '0'">借出</a-tag>
        </span>
      </template>

      <template v-else-if="column.dataIndex === 'b_status'">
        <span v-if="editableData[record.b_code]">
          <a-radio-group
            v-model:value="editableData[record.b_code][column.dataIndex]"
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
          <span v-if="editableData[record.b_code]">
            <a-typography-link @click="save(record.b_code)">
              保存
            </a-typography-link>
            <a-popconfirm
              title="确定取消吗"
              ok-text="确定"
              cancel-text="取消"
              @confirm="cancel(record.b_code)"
            >
              <a>取消</a>
            </a-popconfirm>
          </span>
          <span v-else>
            <a @click="edit(record.b_code)">修改</a>
          </span>
        </div>
      </template>
    </template>
  </a-table>

  <a-modal
    v-model:open="open"
    title="添加书本"
    :footer="null"
    @cancel="afterClose"
  >
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
        name="b_code"
        :rules="[{ required: false, message: '请输入ID!' }]"
      >
        <a-input v-if="custom" v-model:value="formState.b_code" />
        <a-input v-if="!custom" disabled v-model:value="formState.b_code" />
      </a-form-item>

      <a-form-item
        label="图书编号"
        name="bs_id"
        :rules="[{ required: true, message: '请输入图书编号!' }]"
      >
        <a-input v-model:value="formState.bs_id" />
      </a-form-item>

      <a-form-item
        label="名称"
        name="b_name"
        :rules="[{ required: false, message: '请输入名称!' }]"
      >
        <a-input v-if="custom" v-model:value="formState.b_name" />
        <a-input v-if="!custom" disabled v-model:value="formState.b_name" />
      </a-form-item>

      <a-form-item label="借阅用户" name="u_id">
        <a-input v-model:value="formState.u_id" />
      </a-form-item>
      <a-form-item label="借阅时间" name="b_borrow_date">
        <a-input v-model:value="formState.b_borrow_date" />
      </a-form-item>

      <a-form-item
        label="借阅状态"
        name="b_borrow"
        :rules="[{ required: true, message: '请输入借阅状态!' }]"
      >
        <a-radio-group v-model:value="formState.b_borrow">
          <a-radio value="1">在库</a-radio>
          <a-radio value="0">借出</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="书本状态"
        name="b_status"
        :rules="[{ required: true, message: '请输入书本状态!' }]"
      >
        <a-radio-group v-model:value="formState.b_status">
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
  $getBookno,
  $selectBookno,
  $deleteBookno,
  $insertBookno,
  $updateBookno,
  $importBooknoExcel,
} from "@/api";
import { cloneDeep } from "lodash-es";
import { reactive, ref, onMounted, h } from "vue";
import type { UnwrapRef } from "vue";
import { type TableProps, type TableColumnType, message } from "ant-design-vue";
import {
  PlusCircleOutlined,
  DeleteOutlined,
  DownloadOutlined,
  CloudUploadOutlined,
} from "@ant-design/icons-vue";
import { Icon } from "@/config/Icon";

interface FormState {
  b_code: string;
  bs_id: string;
  b_name: string;
  u_id: string;
  b_borrow_date: string;
  b_borrow: number | undefined;
  b_status: number | undefined;
}

onMounted(() => {
  getBooknoList();
});

const getBooknoList = () => {
  $getBookno().then((res) => {
    dataSource.value = JSON.parse(JSON.stringify(res));
  });
};

const columns: TableColumnType<FormState>[] = [
  {
    title: "书本ID",
    dataIndex: "b_code",
  },
  {
    title: "图书编号",
    dataIndex: "bs_id",
  },
  {
    title: "名称",
    dataIndex: "b_name",
  },
  {
    title: "借阅用户",
    dataIndex: "u_id",
  },
  {
    title: "借阅时间",
    dataIndex: "b_borrow_date",
  },
  {
    title: "借阅状态",
    dataIndex: "b_borrow",
  },
  {
    title: "书本状态",
    dataIndex: "b_status",
  },
  {
    title: "操作",
    dataIndex: "operation",
    width: "14%",
  },
];

const data: any[] = reactive([]);
const dataSource = ref(data);
const editableData: UnwrapRef<Record<any, any>> = reactive([]);

// update
const editItem: FormState = reactive(<FormState>{});
const edit = (b_code: string) => {
  editableData[b_code] = cloneDeep(
    dataSource.value.filter((item) => b_code === item.b_code)[0]
  );
};
const save = (b_code: string) => {
  Object.assign(
    dataSource.value.filter((item) => b_code === item.b_code)[0],
    editableData[b_code]
  );
  const editItem = JSON.parse(
    JSON.stringify(
      Object.assign(
        dataSource.value.filter((item) => b_code === item.b_code)[0]
      )
    )
  );

  $updateBookno(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getBooknoList();
    } else {
      message.error("修改失败", 0.5);
    }
  });
  delete editableData[b_code];
};
const cancel = (b_code: string) => {
  delete editableData[b_code];
};

// delete
const selectKeys: any = ref([]);
const rowSelection: TableProps["rowSelection"] = {
  onChange: (selectedRowKeys: any[], selectedRows: FormState[]) => {
    selectKeys.value = selectedRowKeys;
  },
  getCheckboxProps: (record: FormState) => ({
    disabled: record.u_id !== null && record.u_id !== "",
    bs_name: record.u_id,
  }),
};

const deleteBookno = () => {
  const b_codes = JSON.parse(JSON.stringify(selectKeys.value));
  for (let i = 0; i < b_codes.length; i++) {
    const element = b_codes[i];
    $deleteBookno(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        getBooknoList();
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
    $selectBookno(searchValue).then((res: any) => {
      dataSource.value = res;
    });
  } else {
    getBooknoList();
  }
};

// showModal
const open = ref<boolean>(false);
const custom = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};
const showModalCustom = () => {
  open.value = true;
  custom.value = true;
};
const afterClose = () => {
  custom.value = false;
};

// insert
const formState = reactive<FormState>({
  b_code: "",
  bs_id: "",
  b_name: "",
  u_id: "",
  b_borrow_date: "",
  b_borrow: undefined,
  b_status: undefined,
});

const onFinish = (values: any) => {
  values.b_borrow = Number(values.b_borrow);
  values.b_status = Number(values.b_status);
  //addBookno
  const _request = JSON.parse(JSON.stringify(values));
  console.log(_request);

  $insertBookno(_request).then((res: any) => {
    if (res === 1) {
      message.success("添加成功", 0.5);
      formState.b_code = "";
      formState.bs_id = "";
      formState.b_name = "";
      formState.u_id = "";
      formState.b_borrow_date = "";
      formState.b_borrow = undefined;
      formState.b_status = undefined;
      open.value = false;
    } else {
      message.error("添加失败", 0.5);
    }
    getBooknoList();
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
  $importBooknoExcel(formData)
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
