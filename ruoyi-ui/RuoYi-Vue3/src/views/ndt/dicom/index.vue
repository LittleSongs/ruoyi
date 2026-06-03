<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="任务编号" prop="taskNo">
        <el-input v-model="queryParams.taskNo" placeholder="请输入任务编号" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="工件名称" prop="workpieceName">
        <el-input v-model="queryParams.workpieceName" placeholder="请输入工件名称" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="StudyUID" prop="studyInstanceUid">
        <el-input v-model="queryParams.studyInstanceUid" placeholder="StudyInstanceUID" clearable style="width: 240px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="SOPUID" prop="sopInstanceUid">
        <el-input v-model="queryParams.sopInstanceUid" placeholder="SOPInstanceUID" clearable style="width: 220px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="success" plain icon="RefreshRight" @click="loadHierarchy" v-hasPermi="['ndt:orthanc:list']">刷新Orthanc树</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-row :gutter="12">
      <el-col :span="7">
        <el-card shadow="never" class="tree-card">
          <template #header>Orthanc归档树</template>
          <el-tree ref="treeRef" :data="treeData" node-key="id" :props="treeProps" highlight-current default-expand-all @node-click="handleTreeClick" />
        </el-card>
      </el-col>
      <el-col :span="17">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>实例列表</span>
            </div>
          </template>
          <el-table v-loading="loading" :data="dicomList">
            <el-table-column label="任务编号" prop="taskNo" min-width="150" />
            <el-table-column label="工件" prop="workpieceName" min-width="120" />
            <el-table-column label="StudyUID" prop="studyInstanceUid" min-width="220" :show-overflow-tooltip="true" />
            <el-table-column label="SeriesUID" prop="seriesInstanceUid" min-width="220" :show-overflow-tooltip="true" />
            <el-table-column label="SOPUID" prop="sopInstanceUid" min-width="220" :show-overflow-tooltip="true" />
            <el-table-column label="Orthanc实例" prop="orthancInstanceId" min-width="160" :show-overflow-tooltip="true" />
            <el-table-column label="操作" width="280" align="center">
              <template #default="scope">
                <el-button link type="primary" icon="View" @click="viewInstance(scope.row)">查看</el-button>
                <el-button link type="primary" icon="Edit" @click="openTagDialog(scope.row.id)">编辑Tag</el-button>
                <el-button link type="primary" icon="Link" @click="jumpOhif(scope.row)">OHIF</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
        </el-card>

        <el-card shadow="never" class="detail-card mt12">
          <template #header>
            <div class="card-header">
              <span>归档树选中实例详情</span>
              <el-button v-if="currentDicomId" type="primary" plain size="small" @click="openTagDialog(currentDicomId)">进入编辑</el-button>
            </div>
          </template>
          <template v-if="currentDicomDetail">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="任务编号">{{ currentDicomDetail.taskNo }}</el-descriptions-item>
              <el-descriptions-item label="工件">{{ currentDicomDetail.workpieceName }}</el-descriptions-item>
              <el-descriptions-item label="StudyUID">{{ currentDicomDetail.studyInstanceUid }}</el-descriptions-item>
              <el-descriptions-item label="SeriesUID">{{ currentDicomDetail.seriesInstanceUid }}</el-descriptions-item>
              <el-descriptions-item label="SOPUID">{{ currentDicomDetail.sopInstanceUid }}</el-descriptions-item>
              <el-descriptions-item label="Orthanc实例">{{ currentDicomDetail.orthancInstanceId }}</el-descriptions-item>
            </el-descriptions>
          </template>
          <el-empty v-else description="请选择左侧树节点或列表中的实例查看详情" />
        </el-card>
      </el-col>
    </el-row>

    <el-dialog v-model="tagDialogVisible" title="DICOM Tag 管理" width="960px" append-to-body>
      <el-alert title="仅允许编辑白名单内的标量标签（PatientName、StudyDescription、SeriesDescription），其他字段已锁定。" type="info" show-icon class="mb12" />
      <el-table :data="tagItems" max-height="520">
        <el-table-column label="Tag名" min-width="200">
          <template #default="scope">
            <el-input v-model="scope.row.tagName" placeholder="例如 StudyDescription" disabled />
          </template>
        </el-table-column>
        <el-table-column label="值" min-width="280">
          <template #default="scope">
            <el-input v-model="scope.row.value" :disabled="!scope.row.editable" placeholder="请输入值" />
          </template>
        </el-table-column>
        <el-table-column label="原值" min-width="280">
          <template #default="scope">
            <el-input :model-value="scope.row.originalValue" disabled />
          </template>
        </el-table-column>
        <el-table-column label="可编辑" width="100" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.editable" type="success">是</el-tag>
            <el-tag v-else type="info">否</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template #default="scope">
            <el-button link type="danger" icon="Delete" :disabled="!scope.row.editable" @click="removeTagRow(scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <template #footer>
        <el-button type="primary" @click="saveTags">保存</el-button>
        <el-button @click="tagDialogVisible = false">取消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtDicom">
import { listDicom, getDicom, getDicomTags, updateDicomTag } from '@/api/ndt/dicom'
import { getOrthancHierarchy } from '@/api/ndt/orthanc'
import { getTaskOhif } from '@/api/ndt/task'
import { useRoute } from 'vue-router'

const route = useRoute()
const { proxy } = getCurrentInstance()
const loading = ref(false)
const showSearch = ref(true)
const dicomList = ref([])
const total = ref(0)
const treeData = ref([])
const treeRef = ref()
const currentDicomId = ref(null)
const currentDicomDetail = ref(null)
const tagDialogVisible = ref(false)
const tagItems = ref([])
const treeProps = { children: 'children', label: 'title' }
const EDITABLE_TAGS = new Set(['PatientName', 'StudyDescription', 'SeriesDescription'])
const queryParams = reactive({ pageNum: 1, pageSize: 10, taskNo: undefined, workpieceName: undefined, studyInstanceUid: undefined, sopInstanceUid: undefined })

function getList() {
  loading.value = true
  listDicom(queryParams).then(res => { dicomList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false })
}
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function loadHierarchy() { getOrthancHierarchy(queryParams).then(res => { treeData.value = res.data || [] }) }
function extractDicomInstanceId(node) {
  if (!node || node.nodeType !== 'INSTANCE') return null
  return node.dicomInstanceId || node.id
}
function viewInstance(row) {
  currentDicomId.value = row.id
  currentDicomDetail.value = row
  highlightTreeNode(row.id)
}
function highlightTreeNode(dicomInstanceId) {
  const walk = nodes => {
    for (const node of nodes || []) {
      if (String(node.dicomInstanceId || node.id) === String(dicomInstanceId)) {
        treeRef.value?.setCurrentKey(node.id)
        return true
      }
      if (walk(node.children)) return true
    }
    return false
  }
  walk(treeData.value)
}
function handleTreeClick(node) {
  const id = extractDicomInstanceId(node)
  if (id) {
    currentDicomId.value = id
    currentDicomDetail.value = node
    getDicom(id).then(res => { currentDicomDetail.value = res.data || currentDicomDetail.value })
  } else {
    currentDicomDetail.value = node
  }
}
function openTagDialog(id) {
  currentDicomId.value = id
  getDicomTags(id).then(res => {
    tagItems.value = (res.data || []).map(item => ({ ...item, editable: EDITABLE_TAGS.has(item.tagName) }))
    tagDialogVisible.value = true
  })
}
function removeTagRow(index) { if (tagItems.value[index]?.editable) tagItems.value.splice(index, 1) }
function saveTags() {
  updateDicomTag(currentDicomId.value, tagItems.value).then(() => {
    proxy.$modal.msgSuccess('保存成功')
    tagDialogVisible.value = false
    getList(); loadHierarchy()
    if (currentDicomId.value) {
      getDicom(currentDicomId.value).then(res => { currentDicomDetail.value = res.data || null })
    }
  })
}
function jumpOhif(row) {
  getTaskOhif(row.id).then(res => { window.open(res.data, "_blank") })
}
function openDicomFromRoute() {
  const dicomInstanceId = route.query.dicomInstanceId
  if (!dicomInstanceId) return
  const id = Number(dicomInstanceId)
  if (Number.isNaN(id)) return
  currentDicomId.value = id
  getDicom(id).then(res => {
    currentDicomDetail.value = res.data || null
    highlightTreeNode(id)
  })
}
onMounted(() => {
  getList()
  loadHierarchy()
  openDicomFromRoute()
})
watch(() => route.query.dicomInstanceId, () => {
  openDicomFromRoute()
})
</script>

<style scoped>
.tree-card { min-height: 720px; }
.detail-card { min-height: 260px; }
.mt12 { margin-top: 12px; }
.card-header { display: flex; justify-content: space-between; align-items: center; }
.dialog-actions { margin-top: 12px; }
</style>
