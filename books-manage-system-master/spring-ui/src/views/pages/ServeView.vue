<template>
  <div>
    <a-row :gutter="30">
      <a-col :span="8">
        <a-card hoverable class="blue">
          最大借阅书本数：<i>{{ topList[1] }} </i></a-card
        >
      </a-col>
      <a-col :span="8">
        <a-card hoverable class="pink">
          最大借阅天数： <i>{{ topList[2] }}</i>
        </a-card>
      </a-col>
      <a-col :span="8"
        ><a-card hoverable class="purple">
          当前借阅书本数：<i>{{ data.length }}</i>
        </a-card>
      </a-col>
    </a-row>
    <!--  -->
    <a-row :gutter="30" style="margin-top: 20px">
      <a-col :span="8">
        <a-card hoverable style="height: 525px;">
          <FireTwoTone />
          <span style="font-weight: bold"> 借还台</span>
          <!--  -->
          <a-form
            :label-col="labelCol"
            :wrapper-col="wrapperCol"
            style="margin-top: 30px"
          >
            <a-form-item label="书本ID" v-bind="validateInfos.b_code">
              <a-input
                v-model:value="modelRef.b_code"
                placeholder="请输入书本ID"
                @blur="validate('b_code', { trigger: 'blur' }).catch(() => {})"
              />
            </a-form-item>
            <a-form-item label="借还书" v-bind="validateInfos.br_borrow">
              <a-select
                v-model:value="modelRef.br_borrow"
                placeholder="请选择借书或还书"
              >
                <a-select-option value="0">借书</a-select-option>
                <a-select-option value="1">还书</a-select-option>
              </a-select>
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 24, offset: 0 }">
              <a-button
                type="primary"
                @click.prevent="onSubmit"
                style="width: 100%"
              >
                提交
              </a-button>
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 24, offset: 0 }">
              <a-button @click="resetFields" style="width: 100%">
                取消
              </a-button>
            </a-form-item>
          </a-form>
        </a-card>
      </a-col>
      <a-col :span="16">
        <a-card hoverable style="height: 525px;">
          <!--  -->
          <a-table
            size="middle"
            :columns="columns"
            :data-source="data"
            :pagination="pagination"
            rowKey="b_code"
          >
            <template #bodyCell="{ column, text }">
              <template v-if="column.dataIndex === 'b_code'">
                <a>{{ text }}</a>
              </template>
            </template>
            <template #title><BookTwoTone /> 借阅图书</template>
          </a-table>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import {
  FireTwoTone,
  BookTwoTone,
} from "@ant-design/icons-vue";
import { reactive, toRaw, h } from "vue";
import { Form, message } from "ant-design-vue";
import { $selectBooknoByUid, $borrowBook } from "@/api";
const topList: any = ref([]);
const userInfo: any = ref([]);
onMounted(() => {
  const userTemp: any = localStorage.getItem("userInfo");
  const user = JSON.parse(userTemp);
  userInfo.value = user;
  const top: any = [
    user.roleList[0].r_ide,
    user.roleList[0].r_limit_book,
    user.roleList[0].r_limit_day,
  ];
  topList.value = top;
  getBorrowBooks();
});
const getBorrowBooks = () => {
  $selectBooknoByUid(userInfo.value.u_id).then((res: any) => {
    data.value = res;
  });
};
const pagination = ref({
  defaultPageSize: 7,
});

const columns = [
  {
    title: "书本ID",
    dataIndex: "b_code",
  },
  {
    title: "图书编号",
    dataIndex: "bs_id",
  },
  {
    title: "图书名称",
    dataIndex: "b_name",
  },
  {
    title: "借阅日期",
    dataIndex: "b_borrow_date",
  },
];

const data = ref([]);
//

const useForm = Form.useForm;
const labelCol = { span: 5 };
const wrapperCol = { span: 19 };
const modelRef = reactive({
  b_code: "",
  br_borrow: undefined,
});
const rulesRef = reactive({
  b_code: [
    {
      required: true,
      message: "请输入书本ID",
    },
    {
      min: 8,
      max: 11,
      message: "长度必须在8~11位",
      trigger: "blur",
    },
  ],
  br_borrow: [
    {
      required: true,
      message: "请选择借书或还书",
    },
  ],
});
const { resetFields, validate, validateInfos } = useForm(modelRef, rulesRef);
const onSubmit = () => {
  validate()
    .then(() => {
      const _req: any = toRaw(modelRef);
      _req.br_borrow = Number(_req.br_borrow);
      const user = JSON.parse(JSON.stringify(userInfo.value));
      _req.u_id = user.u_id;
      $borrowBook(_req).then((res: any) => {
        if (res === 1) {
          message.success("成功", 0.5);
          getBorrowBooks();
          modelRef.b_code = "";
          modelRef.br_borrow = undefined;
        } else {
          message.error("书本异常，失败", 0.5);
        }
      });
    })
    .catch((err) => {
      console.log("error", err);
    });
};
</script>

<style scoped>
.ant-card {
  min-height: 96px;
}
i {
  font-size: 30px;
}
.blue {
  color: white;
  background-image: linear-gradient(to right, #67a5fb, #3768ee);
}
.pink {
  color: white;
  background-image: linear-gradient(to right, #ee5e7a, #d85583);
}
.purple {
  color: white;
  background-image: linear-gradient(to right, #d224fd, #aa2ff3);
}

div :deep() .ant-table-footer,
div :deep() .ant-table-title {
  background-color: #fff !important;
  font-weight: bold;
}
</style>
