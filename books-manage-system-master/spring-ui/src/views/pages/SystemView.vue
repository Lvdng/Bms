<template>
  <a-carousel :after-change="onChange" autoplay>
    <div><h2>欢迎使用悦读图书管理系统</h2></div>
    <div><h2>为中华之崛起而读书。 ——周恩来</h2></div>
    <div><h2>读万卷书，行万里路。 ——刘彝</h2></div>
    <div><h2>学而不思则罔，思而不学则殆。 ——孔子 </h2></div>
  </a-carousel>
  <!--  -->
  <a-space>
    <a-input-search
      style="width: 500px"
      v-model:value="search"
      placeholder="输入书本名称"
      enter-button
      @search="onSearch"
    />
  </a-space>
  <!--  -->
  <a-divider style="margin: 10px 0" />

  <!--  -->
  <a-table
    :columns="columns"
    :data-source="data"
    :locale="locale"
    :pagination="pagination"
    size="middle"
  >
    <template #headerCell="{ column }">
      <template v-if="column.key === 'bs_id'">
        <span>
          <smile-outlined />
          图书编号
        </span>
      </template>
    </template>

    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'name'">
        <a>
          {{ record.name }}
        </a>
      </template>
      <template v-else-if="column.key === 'b_borrow'">
        <span>
          <a-tag color="#01a96e" v-if="record.b_borrow == '1'">在库</a-tag>
          <a-tag color="#f50" v-if="record.b_borrow == '0'">借出</a-tag>
        </span>
      </template>
      <template v-else-if="column.key === 'b_status'">
        <span>
          <a-tag color="#01a96e" v-if="record.b_status == '1'">正常</a-tag>
          <a-tag color="#f50" v-if="record.b_status == '0'">禁用</a-tag>
        </span>
      </template>
    </template>
  </a-table>
</template>
<script lang="ts" setup>
import locale from "ant-design-vue/es/locale/zh_CN";
import { SmileOutlined, DownOutlined } from "@ant-design/icons-vue";
import { reactive, ref, onMounted, h } from "vue";
import { $selectBooknoByBname } from "@/api";
import { message } from "ant-design-vue";

onMounted(()=>{
  setTimeout(() => {
    location.replace(location.href);
  }, 400);
})
const onChange = (current: number) => {
  console.log(current);
};

const pagination = {
  pageNo: 1,
  pageSize: 7, // 默认每页显示数量
  // showSizeChanger: true, // 显示可改变每页数量
  // pageSizeOptions: ["10", "20", "50", "100"], // 每页数量选项
};
const columns = [
  {
    name: "图书编号",
    dataIndex: "bs_id",
    key: "bs_id",
  },
  {
    title: "书本ID",
    dataIndex: "b_code",
    key: "b_code",
  },
  {
    title: "书名",
    dataIndex: "b_name",
    key: "b_name",
  },
  {
    title: "借阅用户",
    dataIndex: "u_id",
    key: "u_id",
  },
  {
    title: "借阅时间",
    key: "b_borrow_date",
    dataIndex: "b_borrow_date",
  },
  {
    title: "借阅状态",
    key: "b_borrow",
    dataIndex: "b_borrow",
  },
  {
    title: "书本状态",
    key: "b_status",
    dataIndex: "b_status",
  },
];

const data = ref([]);

// select
const search = ref<any>("");
const onSearch = () => {
  if (search.value != "") {
    $selectBooknoByBname(search.value).then((res: any) => {
      data.value = res;
    });
  } else {
    message.warning("请输入搜索内容", 0.5);
  }
};
</script>
<style scoped>
/* For demo */
:deep(.slick-slide) {
  text-align: center;
  height: 160px;
  line-height: 160px;
  background: #364d79;
  overflow: hidden;
  margin-bottom: 10px;
}
:deep(.slick-slide h2) {
  color: #fff;
}

:deep(.ant-divider) {
  padding: 10px 0 !important;
}

:deep(.ant-pagination) {
  margin-bottom: 0 !important;
}
</style>
