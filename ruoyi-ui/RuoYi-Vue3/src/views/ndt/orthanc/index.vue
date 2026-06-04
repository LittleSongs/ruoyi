<template>
  <div class="app-container">
    <el-form :inline="true" :model="queryParams" class="mb8">
      <el-form-item label="任务编号">
        <el-input v-model="queryParams.taskNo" placeholder="请输入任务编号" clearable style="width: 180px" />
      </el-form-item>
      <el-form-item label="工件名称">
        <el-input v-model="queryParams.workpieceName" placeholder="请输入工件名称" clearable style="width: 180px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="loadTree">查询</el-button>
        <el-button icon="Refresh" @click="reset">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="12">
      <el-col :span="8">
        <el-card shadow="never">
          <template #header>Orthanc 组织树</template>
          <el-tree :data="treeData" node-key="id" :props="treeProps" default-expand-all highlight-current @node-click="handleNodeClick" />
        </el-card>
      </el-col>
      <el-col :span="16">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>当前节点信息</span>
              <el-button v-if="selectedInstanceId" type="primary" plain size="small" @click="goDicomTagEdit">去 DICOM 文件管理编辑标签</el-button>
            </div>
          </template>
          <el-descriptions :column="2" border v-if="selectedNode">
            <el-descriptions-item label="节点类型">{{ selectedNode.nodeType }}</el-descriptions-item>
            <el-descriptions-item label="标题">{{ selectedNode.title }}</el-descriptions-item>
            <el-descriptions-item label="Orthanc ID">{{ selectedNode.orthancId }}</el-descriptions-item>
            <el-descriptions-item label="StudyUID">{{ selectedNode.studyInstanceUid }}</el-descriptions-item>
            <el-descriptions-item label="SeriesUID">{{ selectedNode.seriesInstanceUid }}</el-descriptions-item>
            <el-descriptions-item label="SOPUID">{{ selectedNode.sopInstanceUid }}</el-descriptions-item>
            <el-descriptions-item label="Modality">{{ selectedNode.modality }}</el-descriptions-item>
            <el-descriptions-item label="Series号">{{ selectedNode.seriesNumber }}</el-descriptions-item>
            <el-descriptions-item label="Instance号">{{ selectedNode.instanceNumber }}</el-descriptions-item>
          </el-descriptions>
          <el-empty v-else description="请选择左侧节点查看详情" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="NdtOrthanc">
import { getOrthancHierarchy } from '@/api/ndt/orthanc'
import { useRouter } from 'vue-router'

const router = useRouter()
const treeData = ref([])
const selectedNode = ref(null)
const selectedInstanceId = ref(null)
const treeProps = { children: 'children', label: 'title' }
const queryParams = reactive({ taskNo: undefined, workpieceName: undefined })

function loadTree() {
  getOrthancHierarchy(queryParams).then((res) => {
    treeData.value = res.data || []
  })
}
function reset() {
  queryParams.taskNo = undefined
  queryParams.workpieceName = undefined
  loadTree()
}
function handleNodeClick(node) {
  selectedNode.value = node
  selectedInstanceId.value = node.nodeType === 'INSTANCE' ? node.dicomInstanceId || node.id : null
}
function goDicomTagEdit() {
  router.push({ path: '/ndt/dicom', query: { dicomInstanceId: selectedInstanceId.value } })
}
onMounted(loadTree)
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
