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
    <a-button danger :icon="h(DeleteOutlined)" @click="deleteBooks">
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
    <a href="http://localhost:9090/books/exportExcel">
      <a-button :icon="h(DownloadOutlined)" type="primary"> 导出 </a-button>
    </a>
  </a-space>

  <a-divider style="margin: 10px 0" />

  <a-table
    size="middle"
    :row-selection="rowSelection"
    :columns="columns"
    :data-source="dataSource"
    rowKey="bs_id"
  >
    <template #bodyCell="{ column, text, record }">
      <template
        v-if="
          [
            'id',
            'bs_name',
            'bs_isbn',
            'bs_auth',
            'bs_publish',
            'bs_price',
            'bs_volume',
            'bs_inventory',
          ].includes(column.dataIndex)
        "
      >
        <div>
          <a-input
            v-if="editableData[record.bs_id]"
            v-model:value="editableData[record.bs_id][column.dataIndex]"
            style="margin: -5px 0"
          />
          <template v-else>
            {{ text }}
          </template>
        </div>
      </template>

      <template v-else-if="column.dataIndex === 's_id'">
        <span v-if="editableData[record.bs_id]">
          <a-select
            ref="select"
            v-model:value="editableData[record.bs_id][column.dataIndex]"
          >
            <a-select-option v-for="item in sortsList" :value="item.s_id">
              {{ item.s_sort }}
            </a-select-option>
          </a-select>
        </span>
        <span v-else>
          <div v-for="item in sortsList">
            <a-tag color="#3b5999" v-if="text == item.s_id">
              {{ item.s_sort }}
            </a-tag>
          </div>
        </span>
      </template>

      <template v-else-if="column.dataIndex === 'bs_status'">
        <span v-if="editableData[record.bs_id]">
          <a-radio-group
            v-model:value="editableData[record.bs_id][column.dataIndex]"
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
          <span v-if="editableData[record.bs_id]">
            <a-typography-link @click="save(record.bs_id)">
              保存
            </a-typography-link>
            <a-popconfirm
              title="确定取消吗"
              ok-text="确定"
              cancel-text="取消"
              @confirm="cancel(record.bs_id)"
            >
              <a>取消</a>
            </a-popconfirm>
          </span>
          <span v-else>
            <a @click="edit(record.bs_id)">修改</a>
          </span>
        </div>
      </template>
    </template>
  </a-table>

  <a-modal v-model:open="open" title="添加图书" :footer="null">
    <a-form
      :model="formState"
      bs_name="basic"
      :label-col="{ span: 4 }"
      :wrapper-col="{ span: 20 }"
      autocomplete="off"
      @finish="onFinish"
      @finishFailed="onFinishFailed"
    >
      <a-form-item
        label="编号"
        name="bs_id"
        :rules="[{ required: true, message: '请输入ID!' }]"
      >
        <a-input v-model:value="formState.bs_id" />
      </a-form-item>

      <a-form-item
        label="名称"
        name="bs_name"
        :rules="[{ required: true, message: '请输入名称!' }]"
      >
        <a-input v-model:value="formState.bs_name" />
      </a-form-item>

      <a-form-item
        label="ISBN"
        name="bs_isbn"
        :rules="[{ required: true, message: '请输入ISBN!' }]"
      >
        <a-input v-model:value="formState.bs_isbn" />
      </a-form-item>

      <a-form-item
        label="类别"
        name="s_id"
        :rules="[{ required: true, message: '请选择类别!' }]"
      >
        <a-radio-group v-model:value="formState.s_id">
          <a-radio
            v-for="item in sortsList"
            :value="item.s_id"
            :class="item.s_status == 1 ? 'green' : 'red'"
          >
            {{ item.s_sort }}
          </a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="作者"
        name="bs_auth"
        :rules="[{ required: true, message: '请输入作者!' }]"
      >
        <a-input v-model:value="formState.bs_auth" />
      </a-form-item>

      <a-form-item
        label="出版社"
        name="bs_publish"
        :rules="[{ required: true, message: '请输入出版社!' }]"
      >
        <a-input v-model:value="formState.bs_publish" />
      </a-form-item>

      <a-form-item
        label="价格"
        name="bs_price"
        :rules="[{ required: true, message: '请输入价格!' }]"
      >
        <a-input v-model:value="formState.bs_price" />
      </a-form-item>

      <a-form-item
        label="图书总数"
        name="bs_volume"
        :rules="[{ required: true, message: '请输入图书总数!' }]"
      >
        <a-input v-model:value="formState.bs_volume" />
      </a-form-item>

      <a-form-item
        label="图书库存"
        name="bs_inventory"
        :rules="[{ required: true, message: '请输入图书库存!' }]"
      >
        <a-input v-model:value="formState.bs_inventory" />
      </a-form-item>

      <a-form-item
        label="状态"
        name="bs_status"
        :rules="[{ required: true, message: '请输入状态!' }]"
      >
        <a-radio-group v-model:value="formState.bs_status">
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
  $getBooks,
  $selectBooks,
  $deleteBooks,
  $insertBooks,
  $updateBooks,
  $getSorts,
  $importBooksExcel,
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
  bs_id: string;
  bs_name: string;
  s_id: number | undefined;
  bs_isbn: string;
  bs_auth: string;
  bs_publish: string;
  bs_price: number | undefined;
  bs_volume: number | undefined;
  bs_inventory: number | undefined;
  bs_status: number | undefined;
}

onMounted(() => {
  getBooksList();
  getSortsList();
});
const getSortsList = () => {
  $getSorts().then((res: any) => {
    sortsList.value = JSON.parse(JSON.stringify(res));
  });
};
const getBooksList = () => {
  $getBooks().then((res) => {
    dataSource.value = JSON.parse(JSON.stringify(res));
  });
};

const columns: TableColumnType<FormState>[] = [
  {
    title: "图书编号",
    dataIndex: "bs_id",
  },
  {
    title: "名称",
    dataIndex: "bs_name",
  },
  {
    title: "ISBN",
    dataIndex: "bs_isbn",
  },
  {
    title: "类别",
    dataIndex: "s_id",
  },
  {
    title: "作者",
    dataIndex: "bs_auth",
  },
  {
    title: "出版社",
    dataIndex: "bs_publish",
  },
  {
    title: "价格",
    dataIndex: "bs_price",
    width: "7%",
  },
  {
    title: "总数",
    dataIndex: "bs_volume",
  },
  {
    title: "库存",
    dataIndex: "bs_inventory",
  },
  {
    title: "图书状态",
    dataIndex: "bs_status",
  },
  {
    title: "创建时间",
    dataIndex: "bs_create",
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
const edit = (bs_id: string) => {
  editableData[bs_id] = cloneDeep(
    dataSource.value.filter((item) => bs_id === item.bs_id)[0]
  );
};
const save = (bs_id: string) => {
  Object.assign(
    dataSource.value.filter((item) => bs_id === item.bs_id)[0],
    editableData[bs_id]
  );
  const editItem = JSON.parse(
    JSON.stringify(
      Object.assign(dataSource.value.filter((item) => bs_id === item.bs_id)[0])
    )
  );
  editItem.s_id = Number(editItem.s_id);
  editItem.bs_price = Number(editItem.bs_price);
  editItem.bs_volume = Number(editItem.bs_volume);
  editItem.bs_inventory = Number(editItem.bs_inventory);
  editItem.bs_status = Number(editItem.bs_status);

  $updateBooks(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getBooksList();
    } else {
      message.error("修改失败", 0.5);
    }
  });
  delete editableData[bs_id];
};
const cancel = (bs_id: string) => {
  delete editableData[bs_id];
};

// delete
const selectKeys: any = ref([]);
const rowSelection: TableProps["rowSelection"] = {
  onChange: (selectedRowKeys: any[], selectedRows: FormState[]) => {
    selectKeys.value = selectedRowKeys;
  },
  getCheckboxProps: (record: FormState) => ({
    // disabled: record.bs_auth === "系统管理员",
    // bs_name: record.bs_auth,
  }),
};

const deleteBooks = () => {
  const bs_ids = JSON.parse(JSON.stringify(selectKeys.value));
  for (let i = 0; i < bs_ids.length; i++) {
    const element = bs_ids[i];
    $deleteBooks(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        getBooksList();
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
    $selectBooks(searchValue).then((res: any) => {
      dataSource.value = JSON.parse(JSON.stringify(res));
    });
  } else {
    getBooksList();
  }
};

// showModal
const open = ref<boolean>(false);
const sortsList = ref<any>([]);
const showModal = () => {
  open.value = true;
};

// insert

const formState = reactive<FormState>({
  bs_id: "",
  bs_name: "",
  s_id: undefined,
  bs_isbn: "",
  bs_auth: "",
  bs_publish: "",
  bs_price: undefined,
  bs_volume: undefined,
  bs_inventory: undefined,
  bs_status: undefined,
});

const onFinish = (values: any) => {
  // values.bs_price = Number(values.bs_price);
  // values.bs_volume = Number(values.bs_volume);
  // values.bs_inventory = Number(values.bs_inventory);
  // values.bs_status = Number(values.bs_status);
  //addBooks
  const _request = JSON.parse(JSON.stringify(values));
  console.log(_request);

  $insertBooks(_request).then((res: any) => {
    if (res === 1) {
      message.success("添加成功", 0.5);
      formState.bs_id = "";
      formState.bs_name = "";
      formState.s_id = undefined;
      formState.bs_isbn = "";
      formState.bs_auth = "";
      formState.bs_publish = "";
      formState.bs_price = undefined;
      formState.bs_volume = undefined;
      formState.bs_inventory = undefined;
      formState.bs_status = undefined;
      open.value = false;
      getBooksList();
    } else {
      message.error("添加失败", 0.5);
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
  $importBooksExcel(formData)
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
