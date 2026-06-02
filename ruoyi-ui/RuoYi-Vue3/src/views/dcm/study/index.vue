<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="对象名称" prop="patientName">
        <el-input v-model="queryParams.patientName" placeholder="请输入对象名称" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="对象编号" prop="patientId">
        <el-input v-model="queryParams.patientId" placeholder="请输入对象编号" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="Study 描述" prop="studyDescription">
        <el-input v-model="queryParams.studyDescription" placeholder="请输入 Study 描述" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="Study 日期" prop="studyDate">
        <el-date-picker v-model="queryParams.studyDate" type="date" value-format="YYYYMMDD" format="YYYY-MM-DD" placeholder="请选择日期" clearable style="width: 160px" />
      </el-form-item>
      <el-form-item label="模态" prop="modality">
        <el-input v-model="queryParams.modality" placeholder="如 CT / DX" clearable style="width: 120px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 140px">
          <el-option v-for="dict in dcm_study_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="Study UID" prop="studyInstanceUid">
        <el-input v-model="queryParams.studyInstanceUid" placeholder="请输入 UID" clearable style="width: 240px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="studyList">
      <el-table-column label="ID" align="center" prop="id" width="72" />
      <el-table-column label="对象名称" prop="patientName" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="对象编号" prop="patientId" min-width="110" :show-overflow-tooltip="true" />
      <el-table-column label="Study 描述" prop="studyDescription" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="Study 日期" align="center" prop="studyDate" width="112" />
      <el-table-column label="模态" align="center" prop="modality" width="80" />
      <el-table-column label="Series 数量" align="center" prop="seriesCount" width="100" />
      <el-table-column label="Instance 数量" align="center" prop="instanceCount" width="112" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template #default="scope">
          <dict-tag :options="dcm_study_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="上传时间" align="center" prop="createTime" width="164">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="292" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)" v-hasPermi="['dcm:study:query']">详情</el-button>
          <el-button link type="primary" icon="Picture" @click="openViewer(scope.row)">查看图像</el-button>
          <el-button link type="primary" icon="Edit" @click="handleEvaluation(scope.row)" v-hasPermi="['dcm:evaluation:add']">填写评定</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dcm:study:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-drawer v-model="detailOpen" title="Study 详情" size="78%" append-to-body>
      <el-descriptions v-if="detail" :column="3" border class="detail-base">
        <el-descriptions-item label="对象名称">{{ detail.patientName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="对象编号">{{ detail.patientId || '-' }}</el-descriptions-item>
        <el-descriptions-item label="模态">{{ detail.modality || '-' }}</el-descriptions-item>
        <el-descriptions-item label="Study 描述">{{ detail.studyDescription || '-' }}</el-descriptions-item>
        <el-descriptions-item label="Study 日期">{{ detail.studyDate || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态"><dict-tag :options="dcm_study_status" :value="detail.status" /></el-descriptions-item>
        <el-descriptions-item label="StudyInstanceUID" :span="3">{{ detail.studyInstanceUid }}</el-descriptions-item>
      </el-descriptions>
      <div class="detail-actions">
        <el-button type="primary" icon="Picture" @click="openViewer(detail)">打开 OHIF Viewer</el-button>
      </div>

      <h4>Series 列表</h4>
      <el-table v-loading="seriesLoading" :data="seriesList" highlight-current-row @row-click="selectSeries">
        <el-table-column label="Series UID" prop="seriesInstanceUid" min-width="250" :show-overflow-tooltip="true" />
        <el-table-column label="编号" prop="seriesNumber" width="90" />
        <el-table-column label="描述" prop="seriesDescription" min-width="160" :show-overflow-tooltip="true" />
        <el-table-column label="模态" prop="modality" width="80" />
        <el-table-column label="检查部位" prop="bodyPartExamined" width="130" />
        <el-table-column label="Instance 数量" prop="instanceCount" width="120" align="center" />
      </el-table>
      <pagination v-show="seriesTotal > 0" :total="seriesTotal" v-model:page="seriesQuery.pageNum" v-model:limit="seriesQuery.pageSize" @pagination="loadSeries" />

      <h4 v-if="selectedSeries">Instance 列表 - {{ selectedSeries.seriesDescription || selectedSeries.seriesInstanceUid }}</h4>
      <el-table v-if="selectedSeries" v-loading="instanceLoading" :data="instanceList">
        <el-table-column label="SOP Instance UID" prop="sopInstanceUid" min-width="270" :show-overflow-tooltip="true" />
        <el-table-column label="编号" prop="instanceNumber" width="90" />
        <el-table-column label="图像类型" prop="imageType" min-width="150" :show-overflow-tooltip="true" />
        <el-table-column label="尺寸" width="110">
          <template #default="scope">{{ scope.row.rows || '-' }} x {{ scope.row.columns || '-' }}</template>
        </el-table-column>
      </el-table>
      <pagination v-if="selectedSeries && instanceTotal > 0" :total="instanceTotal" v-model:page="instanceQuery.pageNum" v-model:limit="instanceQuery.pageSize" @pagination="loadInstances" />
    </el-drawer>
  </div>
</template>

<script setup name="DcmStudy">
import { listStudy, getStudy, delStudy, listSeriesByStudy, listInstancesBySeries } from "@/api/dcm/study"

const { proxy } = getCurrentInstance()
const router = useRouter()
const { dcm_study_status } = useDict("dcm_study_status")
const loading = ref(true)
const showSearch = ref(true)
const studyList = ref([])
const total = ref(0)
const detailOpen = ref(false)
const detail = ref()
const seriesLoading = ref(false)
const seriesList = ref([])
const seriesTotal = ref(0)
const selectedSeries = ref()
const instanceLoading = ref(false)
const instanceList = ref([])
const instanceTotal = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  patientName: undefined,
  patientId: undefined,
  studyDescription: undefined,
  studyDate: undefined,
  modality: undefined,
  status: undefined,
  studyInstanceUid: undefined
})
const seriesQuery = reactive({ pageNum: 1, pageSize: 10, studyId: undefined })
const instanceQuery = reactive({ pageNum: 1, pageSize: 10, seriesId: undefined })

function getList() {
  loading.value = true
  listStudy(queryParams).then(response => {
    studyList.value = response.rows
    total.value = response.total
  }).finally(() => {
    loading.value = false
  })
}

function handleQuery() {
  queryParams.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

function openViewer(row) {
  if (row && row.ohifViewerUrl) {
    window.open(row.ohifViewerUrl, "_blank")
  }
}

function handleEvaluation(row) {
  router.push({ path: "/dcm/evaluation", query: { studyId: row.id } })
}

function handleDelete(row) {
  proxy.$modal.confirm('是否确认删除 Study 编号为 "' + row.id + '" 的业务索引？Orthanc 中的影像不会删除。').then(() => {
    return delStudy(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

function handleDetail(row) {
  getStudy(row.id).then(response => {
    detail.value = response.data
    detailOpen.value = true
    selectedSeries.value = undefined
    instanceList.value = []
    seriesQuery.studyId = row.id
    seriesQuery.pageNum = 1
    loadSeries()
  })
}

function loadSeries() {
  seriesLoading.value = true
  listSeriesByStudy(seriesQuery).then(response => {
    seriesList.value = response.rows
    seriesTotal.value = response.total
  }).finally(() => {
    seriesLoading.value = false
  })
}

function selectSeries(row) {
  selectedSeries.value = row
  instanceQuery.seriesId = row.id
  instanceQuery.pageNum = 1
  loadInstances()
}

function loadInstances() {
  instanceLoading.value = true
  listInstancesBySeries(instanceQuery).then(response => {
    instanceList.value = response.rows
    instanceTotal.value = response.total
  }).finally(() => {
    instanceLoading.value = false
  })
}

getList()
</script>

<style scoped>
.detail-base {
  margin-bottom: 14px;
}
.detail-actions {
  margin-bottom: 18px;
}
h4 {
  margin: 18px 0 10px;
  font-weight: 500;
  color: #303133;
}
</style>
