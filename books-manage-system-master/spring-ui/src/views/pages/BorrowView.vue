<template>
  <a-tabs v-model:activeKey="activeKey" @change="changeTabs">
    <a-tab-pane key="1" tab="统计表">
      <a-space>
        <a-input-search
          style="width: 300px"
          v-model:value="search"
          placeholder="输入ID/名称"
          enter-button
          @search="onSearch"
        />
        <a-button :icon="h(PlusCircleOutlined)" @click="showModal"
          >添加</a-button
        >
        <a-button danger :icon="h(DeleteOutlined)" @click="deleteBorrow">
          批量删除
        </a-button>
        <!-- 导入 -->
        <div style="display: flex; flex-direction: row; align-items: center">
          <a-upload
            :file-list="fileList"
            :before-upload="beforeUpload"
            @remove="handleRemove"
          >
            <a-button
              type="primary"
              :class="fileList.length === 0 ? '' : 'hidden'"
            >
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
        <a href="http://localhost:9090/borrow/exportExcel">
          <a-button :icon="h(DownloadOutlined)" type="primary"> 导出 </a-button>
        </a>
      </a-space>

      <a-divider style="margin: 10px 0" />

      <a-table
        size="middle"
        :row-selection="rowSelection"
        :columns="columns"
        :data-source="dataSource"
        :pagination="pagination"
        rowKey="br_serial"
      >
        <template #bodyCell="{ column, text, record }">
          <template
            v-if="['u_id', 'br_debit_reply'].includes(column.dataIndex)"
          >
            <div>
              <a-input
                v-if="editableData[record.br_serial]"
                v-model:value="editableData[record.br_serial][column.dataIndex]"
                style="margin: -5px 0"
              />
              <template v-else>
                {{ text }}
              </template>
            </div>
          </template>

          <template v-else-if="column.dataIndex === 'br_borrow'">
            <span v-if="editableData[record.br_serial]">
              <a-radio-group
                v-model:value="editableData[record.br_serial][column.dataIndex]"
              >
                <a-radio value="0">借书</a-radio>
                <a-radio value="1">还书</a-radio>
              </a-radio-group>
            </span>
            <span v-else>
              <a-tag color="#f50" v-if="text == '0'">借书</a-tag>
              <a-tag color="#01a96e" v-if="text == '1'">还书</a-tag>
            </span>
          </template>

          <template v-else-if="column.dataIndex === 'operation'">
            <div class="editable-row-operations">
              <span v-if="editableData[record.br_serial]">
                <a-typography-link @click="save(record.br_serial)">
                  保存
                </a-typography-link>
                <a-popconfirm
                  title="确定取消吗"
                  ok-text="确定"
                  cancel-text="取消"
                  @confirm="cancel(record.br_serial)"
                >
                  <a>取消</a>
                </a-popconfirm>
              </span>
              <span v-else>
                <a @click="edit(record.br_serial)">修改</a>
              </span>
            </div>
          </template>
        </template>
      </a-table>
    </a-tab-pane>
    <a-tab-pane key="2" tab="统计图" force-render>
      <!-- <v-chart class="chart" :option="option" /> -->
    </a-tab-pane>
  </a-tabs>
  <a-range-picker
    style="margin-left: 80%"
    v-if="activeKey == '2'"
    v-model:value="datePicker"
    :locale="locale"
    @change="changeDatePicker"
    :format="dateFormat"
    status="warning"
  />
  <v-chart v-if="activeKey == '2'" class="chart" :option="option" />

  <a-modal v-model:open="open" title="添加图书" :footer="null">
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
        label="图书编号"
        name="bs_id"
        :rules="[{ required: true, message: '请输入图书编号!' }]"
      >
        <a-input v-model:value="formState.bs_id" />
      </a-form-item>

      <a-form-item
        label="书本ID"
        name="b_code"
        :rules="[{ required: true, message: '请输入书本ID!' }]"
      >
        <a-input v-model:value="formState.b_code" />
      </a-form-item>

      <a-form-item
        label="借阅用户"
        name="u_id"
        :rules="[{ required: true, message: '请输入借阅用户!' }]"
      >
        <a-input v-model:value="formState.u_id" />
      </a-form-item>

      <a-form-item
        label="借还时间"
        name="br_debit_reply"
        :rules="[{ required: true, message: '请输入借还时间!' }]"
      >
        <a-date-picker
          v-model:value="formState.br_debit_reply"
          placeholder=" "
        />
      </a-form-item>

      <a-form-item
        label="借阅状态"
        name="br_borrow"
        :rules="[{ required: true, message: '请输入借阅状态!' }]"
      >
        <a-radio-group v-model:value="formState.br_borrow">
          <a-radio value="0">借书</a-radio>
          <a-radio value="1">还书</a-radio>
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
  $getBorrow,
  $selectBorrow,
  $deleteBorrow,
  $insertBorrow,
  $updateBorrow,
  $importBorrowExcel,
  $selectByEcharts,
} from "@/api";
import { cloneDeep, now } from "lodash-es";
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
  br_serial: string;
  bs_id: string;
  b_code: string;
  u_id: string;
  br_debit_reply: string;
  br_borrow: number | undefined;
}

onMounted(() => {
  let now = new Date();
  let _month =
    10 > now.getMonth() + 1 ? "0" + (now.getMonth() + 1) : now.getMonth() + 1;
  let _month_ = 10 > now.getMonth() ? "0" + now.getMonth() : now.getMonth();
  let _day = 10 > now.getDate() ? "0" + now.getDate() : now.getDate();
  // let _hour = 10 > now.getHours() ? "0" + now.getHours() : now.getHours();
  // let _minute =  10 > now.getMinutes() ? "0" + now.getMinutes() : now.getMinutes();
  // let _second =  10 > now.getSeconds() ? "0" + now.getSeconds() : now.getSeconds();
  start.value = now.getFullYear() + "-" + _month_ + "-" + _day;
  end.value = now.getFullYear() + "-" + _month + "-" + _day;
  getBorrowList();
  selectByEcharts();
  const br_tabs = localStorage.getItem("br_tabs");
  if (br_tabs == null) {
    activeKey.value = "1";
  } else {
    activeKey.value = localStorage.getItem("br_tabs");
  }
});

const getBorrowList = () => {
  $getBorrow().then((res) => {
    dataSource.value = JSON.parse(JSON.stringify(res));
  });
};

const pagination = ref({
  defaultPageSize: 9,
});

const columns: TableColumnType<FormState>[] = [
  {
    title: "流水号",
    dataIndex: "br_serial",
  },
  {
    title: "借阅书本",
    dataIndex: "b_code",
  },
  {
    title: "借阅用户",
    dataIndex: "u_id",
  },
  {
    title: "借还时间",
    dataIndex: "br_debit_reply",
  },
  {
    title: "借阅状态",
    dataIndex: "br_borrow",
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
const edit = (br_serial: string) => {
  editableData[br_serial] = cloneDeep(
    dataSource.value.filter((item) => br_serial === item.br_serial)[0]
  );
};
const save = (br_serial: string) => {
  Object.assign(
    dataSource.value.filter((item) => br_serial === item.br_serial)[0],
    editableData[br_serial]
  );
  const editItem = JSON.parse(
    JSON.stringify(
      Object.assign(
        dataSource.value.filter((item) => br_serial === item.br_serial)[0]
      )
    )
  );

  $updateBorrow(editItem).then((res: any) => {
    if (res === 1) {
      message.success("修改成功", 0.5);
      getBorrowList();
    } else {
      message.error("修改失败", 0.5);
    }
  });
  getBorrowList();
  delete editableData[br_serial];
};
const cancel = (br_serial: string) => {
  delete editableData[br_serial];
};

// delete
const selectBR_serials: any = ref([]);
const rowSelection: TableProps["rowSelection"] = {
  onChange: (selectedRowKeys: any[], selectedRows: FormState[]) => {
    selectBR_serials.value = selectedRowKeys;
  },
};

const deleteBorrow = () => {
  const br_serials = JSON.parse(JSON.stringify(selectBR_serials.value));
  for (let i = 0; i < br_serials.length; i++) {
    const element = br_serials[i];
    $deleteBorrow(element).then((res: any) => {
      if (res === 1) {
        message.success("删除成功", 0.5);
        return 0;
      }
      message.error("删除失败,请先解除图书-作者关系", 0.5);
    });
    getBorrowList();
  }
};

// select
const search = ref<string>("");
const onSearch = (searchValue: string) => {
  if (searchValue != "") {
    $selectBorrow(searchValue).then((res: any) => {
      dataSource.value = res;
    });
  } else {
    getBorrowList();
  }
};

// showModal
const open = ref<boolean>(false);
const showModal = () => {
  open.value = true;
};

// insert
const formState = reactive<FormState>({
  br_serial: "",
  bs_id: "",
  b_code: "",
  u_id: "",
  br_debit_reply: "",
  br_borrow: undefined,
});

const onFinish = (values: any) => {
  values.br_borrow = Number(values.br_borrow);
  values.bs_b_status = Number(values.b_status);
  //addBorrow
  const _request = JSON.parse(JSON.stringify(values));
  console.log(_request);

  $insertBorrow(_request).then((res: any) => {
    if (res === 1) {
      message.success("添加成功", 0.5);
      formState.br_serial = "";
      formState.u_id = "";
      formState.b_code = "";
      formState.br_debit_reply = "";
      formState.br_borrow = undefined;
      open.value = false;
      getBorrowList();
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
  $importBorrowExcel(formData)
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

const activeKey: any = ref("1");

const option = reactive({
  title: {
    text: " ",
  },
  tooltip: {
    trigger: "axis",
  },
  legend: {
    data: ["借书", "还书"],
  },
  grid: {
    left: "3%",
    right: "4%",
    bottom: "3%",
    containLabel: true,
  },
  toolbox: {
    feature: {
      saveAsImage: {},
    },
  },
  xAxis: {
    type: "category",
    boundaryGap: false,
    data: [],
  },
  yAxis: {
    type: "value",
  },
  series: [
    {
      name: "借书",
      type: "line",
      stack: "Total",
      data: [],
    },
    {
      name: "还书",
      type: "line",
      stack: "Total",
      data: [],
    },
  ],
});
import dayjs, { Dayjs } from "dayjs";
import locale from "ant-design-vue/es/date-picker/locale/zh_CN";
const dateFormat = "YYYY-MM-DD";
const datePicker = ref<Dayjs>(dayjs("2023-01-01", dateFormat));
const start: any = ref("");
const end: any = ref("");

const selectByEcharts = () => {
  $selectByEcharts(start.value.toString(), end.value.toString()).then(
    (res: any) => {
      const debit: any = [];
      const reply: any = [];
      const date: any = [];
      for (let i = 0; i < res.length; i++) {
        const element = res[i];
        debit.push(element.debit);
        reply.push(element.reply);
        date.push(element.date);
      }
      option.series[0].data = debit;
      option.series[1].data = reply;
      option.xAxis.data = date;
    }
  );
};

const changeDatePicker = () => {
  const date = JSON.parse(JSON.stringify(datePicker.value));
  start.value = date[0].substring(0, 10);
  end.value = date[1].substring(0, 10);
  selectByEcharts();
};

const changeTabs = (activeKey: any) => {
  localStorage.setItem("br_tabs", activeKey);
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
  /* visibility: hidden; */
  /* transform: scale(0); */
}

:deep(.ant-tabs-nav-list) {
  height: 40px;
}
.chart {
  width: 100%;
  height: 550px;
}
</style>
