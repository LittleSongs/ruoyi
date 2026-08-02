<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>OHIF 工业评定入口</template>
      <el-alert title="启动时会把当前登录令牌传给OHIF；OHIF读取后立即从地址栏移除，并使用Bearer令牌访问NDT接口。" type="info" show-icon :closable="false"/>
      <el-form label-width="110px" style="max-width:760px;margin-top:18px">
        <el-form-item label="OHIF地址"><el-input :model-value="config.viewerUrl" readonly/></el-form-item>
        <el-form-item label="检测任务"><el-select v-model="taskId" filterable style="width:100%" @change="loadWorkpieces"><el-option v-for="t in tasks" :key="t.id" :label="`${t.taskNo} - ${t.taskName}`" :value="t.id"/></el-select></el-form-item>
        <el-form-item label="工件"><el-select v-model="workpieceId" filterable style="width:100%" :disabled="!taskId" @change="loadStudies"><el-option v-for="w in workpieces" :key="w.id" :label="w.workpieceName" :value="w.id"/></el-select></el-form-item>
        <el-form-item label="检测 Study"><el-select v-model="studyId" filterable style="width:100%" :disabled="!workpieceId"><el-option v-for="s in studies" :key="s.id" :label="studyLabel(s)" :value="s.id"/></el-select></el-form-item>
        <el-form-item><el-button type="primary" :disabled="!studyId" @click="launch">打开该 Study 的工业阅片与评定</el-button></el-form-item>
      </el-form>
    </el-card>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { listTask } from '@/api/ndt/task'
import { listWorkpiece } from '@/api/ndt/workpiece'
import { listStudy, getStudyOhif } from '@/api/ndt/study'
import { getOhifConfig } from '@/api/ndt/ohif'
import { getToken } from '@/utils/auth'
const config=reactive({viewerUrl:''}),tasks=ref([]),workpieces=ref([]),studies=ref([]),taskId=ref(null),workpieceId=ref(null),studyId=ref(null)
async function load(){const [c,t]=await Promise.all([getOhifConfig(),listTask({pageNum:1,pageSize:1000})]);Object.assign(config,c.data||{});tasks.value=t.rows}
async function loadWorkpieces(){workpieceId.value=null;studyId.value=null;studies.value=[];if(!taskId.value){workpieces.value=[];return}const r=await listWorkpiece({pageNum:1,pageSize:1000,taskId:taskId.value});workpieces.value=r.rows||[]}
async function loadStudies(){studyId.value=null;if(!workpieceId.value){studies.value=[];return}const r=await listStudy({pageNum:1,pageSize:1000,workpieceId:workpieceId.value});studies.value=r.rows||[]}
function studyLabel(study){return `${study.inspectionMethodCode||'未标注方法'} - ${study.studyDescription||study.studyInstanceUid}`}
async function launch(){const r=await getStudyOhif(studyId.value);const url=r.data;window.open(`${url}${url.includes('?')?'&':'?'}token=${encodeURIComponent(getToken()||'')}`,'_blank','noopener')}
onMounted(load)
</script>
