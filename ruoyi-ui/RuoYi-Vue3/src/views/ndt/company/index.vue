<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="公司名称" prop="companyName">
        <el-input v-model="queryParams.companyName" placeholder="请输入公司名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="公司编码" prop="companyCode">
        <el-input v-model="queryParams.companyCode" placeholder="请输入公司编码" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="所在地区" prop="region">
        <el-input v-model="queryParams.region" placeholder="请输入地区" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 140px">
          <el-option label="合作中" value="0" />
          <el-option label="待审核" value="1" />
          <el-option label="已停用" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleDemoAction">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleDemoAction">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleDemoAction">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="handleQuery" />
    </el-row>

    <el-table v-loading="loading" :data="pagedCompanyList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="公司名称" prop="companyName" min-width="190" :show-overflow-tooltip="true" />
      <el-table-column label="公司编码" prop="companyCode" width="130" />
      <el-table-column label="统一社会信用代码" prop="creditCode" min-width="190" :show-overflow-tooltip="true" />
      <el-table-column label="联系人" prop="contactName" width="110" />
      <el-table-column label="联系电话" prop="contactPhone" width="140" />
      <el-table-column label="所在地区" prop="region" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="状态" prop="status" width="100" align="center">
        <template #default="scope">
          <el-tag :type="statusType(scope.row.status)">{{ statusLabel(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="关联任务数" prop="taskCount" width="110" align="center" />
      <el-table-column label="创建时间" prop="createTime" width="160" align="center" />
      <el-table-column label="备注" prop="remark" min-width="180" :show-overflow-tooltip="true" />
      <el-table-column label="操作" fixed="right" width="150" align="center">
        <template #default>
          <el-button link type="primary" icon="View" @click="handleDemoAction">详情</el-button>
          <el-button link type="primary" icon="Edit" @click="handleDemoAction">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="filteredCompanyList.length > 0"
      :total="filteredCompanyList.length"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
    />
  </div>
</template>

<script setup name="NdtCompany">
const { proxy } = getCurrentInstance()
const loading = ref(false)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  companyName: undefined,
  companyCode: undefined,
  region: undefined,
  status: undefined
})

const companyList = ref([
  {
    id: 1,
    companyName: "华东重工装备有限公司",
    companyCode: "NDT-C001",
    creditCode: "91310115MA1K45A28P",
    contactName: "周经理",
    contactPhone: "13800138001",
    region: "上海市浦东新区",
    status: "0",
    taskCount: 18,
    createTime: "2026-03-12 09:20:18",
    remark: "压力容器焊缝检测长期客户"
  },
  {
    id: 2,
    companyName: "中原管道工程集团",
    companyCode: "NDT-C002",
    creditCode: "91410100MA3X7LQ63D",
    contactName: "李工",
    contactPhone: "13900139002",
    region: "河南省郑州市",
    status: "0",
    taskCount: 25,
    createTime: "2026-03-29 14:06:35",
    remark: "RT与UT检测项目并行"
  },
  {
    id: 3,
    companyName: "南方能源设备检测中心",
    companyCode: "NDT-C003",
    creditCode: "91440300MA5G8B2X0A",
    contactName: "陈主任",
    contactPhone: "13700137003",
    region: "广东省深圳市",
    status: "1",
    taskCount: 6,
    createTime: "2026-04-08 10:44:12",
    remark: "资料审核中，待补充委托协议"
  },
  {
    id: 4,
    companyName: "北方轨道交通制造有限公司",
    companyCode: "NDT-C004",
    creditCode: "91110108MA02H7K19J",
    contactName: "王主管",
    contactPhone: "13600136004",
    region: "北京市海淀区",
    status: "0",
    taskCount: 12,
    createTime: "2026-04-19 16:33:47",
    remark: "车轴与轮对探伤业务"
  },
  {
    id: 5,
    companyName: "西部特种材料股份有限公司",
    companyCode: "NDT-C005",
    creditCode: "91610131MA6U2QF55N",
    contactName: "赵经理",
    contactPhone: "13500135005",
    region: "陕西省西安市",
    status: "2",
    taskCount: 3,
    createTime: "2026-05-06 11:18:09",
    remark: "历史客户，当前暂停合作"
  },
  {
    id: 6,
    companyName: "江南船舶配套工程有限公司",
    companyCode: "NDT-C006",
    creditCode: "91320594MA1Y9M730X",
    contactName: "孙工",
    contactPhone: "13400134006",
    region: "江苏省苏州市",
    status: "0",
    taskCount: 31,
    createTime: "2026-05-20 08:52:41",
    remark: "船体结构件DICOM归档示范客户"
  }
])

const filteredCompanyList = computed(() => {
  return companyList.value.filter(item => {
    const matchName = !queryParams.companyName || item.companyName.includes(queryParams.companyName)
    const matchCode = !queryParams.companyCode || item.companyCode.includes(queryParams.companyCode)
    const matchRegion = !queryParams.region || item.region.includes(queryParams.region)
    const matchStatus = !queryParams.status || item.status === queryParams.status
    return matchName && matchCode && matchRegion && matchStatus
  })
})

const pagedCompanyList = computed(() => {
  const start = (queryParams.pageNum - 1) * queryParams.pageSize
  return filteredCompanyList.value.slice(start, start + queryParams.pageSize)
})

function statusLabel(status) {
  return { "0": "合作中", "1": "待审核", "2": "已停用" }[status] || "未知"
}

function statusType(status) {
  return { "0": "success", "1": "warning", "2": "info" }[status] || "info"
}

function handleQuery() {
  queryParams.pageNum = 1
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
}

function handleDemoAction() {
  proxy.$modal.msgSuccess("演示页面：客户公司资料后端接口待接入")
}
</script>
