<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="Study UID" prop="studyInstanceUid"><el-input v-model="queryParams.studyInstanceUid" clearable placeholder="StudyInstanceUID" style="width: 240px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="SOP UID" prop="sopInstanceUid"><el-input v-model="queryParams.sopInstanceUid" clearable placeholder="SOPInstanceUID" style="width: 240px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="校验状态" prop="verifyStatus">
        <el-select v-model="queryParams.verifyStatus" clearable placeholder="状态" style="width: 130px">
          <el-option v-for="dict in ndt_integrity_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="recordList">
      <el-table-column label="StudyInstanceUID" prop="studyInstanceUid" min-width="230" :show-overflow-tooltip="true" />
      <el-table-column label="SeriesInstanceUID" prop="seriesInstanceUid" min-width="230" :show-overflow-tooltip="true" />
      <el-table-column label="SOPInstanceUID" prop="sopInstanceUid" min-width="230" :show-overflow-tooltip="true" />
      <el-table-column label="File SHA-256" prop="fileSha256" min-width="260" :show-overflow-tooltip="true" />
      <el-table-column label="校验状态" prop="verifyStatus" width="100" align="center"><template #default="scope"><dict-tag :options="ndt_integrity_status" :value="scope.row.verifyStatus" /></template></el-table-column>
      <el-table-column label="导入时间" prop="importTime" width="160" align="center"><template #default="scope">{{ parseTime(scope.row.importTime) }}</template></el-table-column>
      <el-table-column label="最后校验" prop="lastVerifyTime" width="160" align="center"><template #default="scope">{{ parseTime(scope.row.lastVerifyTime) || '-' }}</template></el-table-column>
      <el-table-column label="操作" width="100" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Refresh" :disabled="!scope.row.dicomInstanceId" @click="handleVerify(scope.row)" v-hasPermi="['ndt:integrity:verify']">重检</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script setup name="NdtIntegrity">
import { listIntegrity, verifyIntegrity } from "@/api/ndt/integrity"

const { proxy } = getCurrentInstance()
const { ndt_integrity_status } = useDict("ndt_integrity_status")
const loading = ref(true)
const showSearch = ref(true)
const recordList = ref([])
const total = ref(0)
const queryParams = reactive({ pageNum: 1, pageSize: 10, studyInstanceUid: undefined, sopInstanceUid: undefined, verifyStatus: undefined })

function getList() { loading.value = true; listIntegrity(queryParams).then(res => { recordList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false }) }
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function handleVerify(row) { verifyIntegrity(row.dicomInstanceId).then(() => { proxy.$modal.msgSuccess("校验完成"); getList() }) }
onMounted(getList)
</script>
