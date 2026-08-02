<template>
  <div class="app-container">
    <el-form :inline="true"><el-form-item label="任务"><el-select v-model="taskId" filterable style="width:300px" @change="load"><el-option v-for="t in tasks" :key="t.id" :label="`${t.taskNo} - ${t.taskName}`" :value="t.id"/></el-select></el-form-item><el-form-item><el-button type="primary" :disabled="!taskId" @click="load">刷新</el-button></el-form-item></el-form>
    <el-row :gutter="16"><el-col :span="9"><el-card shadow="never"><template #header>Orthanc DICOM层级</template><el-tree :data="tree" node-key="id" :props="{children:'children',label:'title'}" default-expand-all highlight-current @node-click="selected=$event"/></el-card></el-col><el-col :span="15"><el-card shadow="never"><template #header>对象信息</template><el-descriptions v-if="selected" :column="1" border><el-descriptions-item label="节点类型">{{selected.nodeType}}</el-descriptions-item><el-descriptions-item label="对象ID">{{selected.objectId}}</el-descriptions-item><el-descriptions-item label="Orthanc ID">{{selected.orthancId}}</el-descriptions-item><el-descriptions-item label="Study UID">{{selected.studyInstanceUid}}</el-descriptions-item><el-descriptions-item label="Series UID">{{selected.seriesInstanceUid}}</el-descriptions-item><el-descriptions-item label="SOP UID">{{selected.sopInstanceUid}}</el-descriptions-item></el-descriptions><el-empty v-else description="请选择节点"/></el-card></el-col></el-row>
  </div>
</template>
<script setup>
import { onMounted, ref } from 'vue'
import { listTask } from '@/api/ndt/task'
import { getOrthancHierarchy } from '@/api/ndt/orthanc'
const tasks=ref([]),taskId=ref(null),tree=ref([]),selected=ref(null)
async function init(){const r=await listTask({pageNum:1,pageSize:1000});tasks.value=r.rows}
async function load(){if(!taskId.value)return;const r=await getOrthancHierarchy(taskId.value);tree.value=r.data||[];selected.value=null}
onMounted(init)
</script>
