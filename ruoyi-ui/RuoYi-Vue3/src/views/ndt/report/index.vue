<template>
  <div class="app-container">
    <el-alert title="这里归档的是任务级普通PDF报告，不属于DICOM Study/Series层级。DICOM SR请在评定模块提交并归档。每次上传PDF会自动生成下一个任务内版本号并保存SHA-256。" type="info" :closable="false" show-icon/>
    <el-form :inline="true" style="margin-top:16px"><el-form-item label="任务"><el-select v-model="taskId" filterable clearable style="width:300px" @change="load"><el-option v-for="t in tasks" :key="t.id" :label="`${t.taskNo} - ${t.taskName}`" :value="t.id"/></el-select></el-form-item><el-form-item><el-button type="primary" @click="load">查询</el-button><el-upload :show-file-list="false" :http-request="doUpload" accept="application/pdf,.pdf"><el-button :disabled="!taskId" style="margin-left:8px">上传新版本</el-button></el-upload></el-form-item></el-form>
    <el-table :data="rows" v-loading="loading"><el-table-column prop="taskName" label="任务" min-width="170"/><el-table-column prop="reportName" label="报告名称" min-width="180"/><el-table-column prop="version" label="版本" width="80"/><el-table-column prop="status" label="状态" width="110"/><el-table-column prop="sha256" label="SHA-256" min-width="210" show-overflow-tooltip/><el-table-column prop="generateName" label="上传人" width="120"/><el-table-column prop="generateTime" label="上传时间" width="170"/><el-table-column label="操作" width="220"><template #default="{row}"><el-button link @click="download(row)">下载</el-button><el-button link type="success" :disabled="row.status==='RELEASED'" @click="release(row)">发布</el-button><el-button link type="danger" @click="remove(row)">删除</el-button></template></el-table-column></el-table>
    <pagination v-show="total>0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load"/>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { saveAs } from 'file-saver'
import { listTask } from '@/api/ndt/task'
import { listReport, uploadReport, downloadReport, updateReportStatus, delReport } from '@/api/ndt/report'
const tasks=ref([]),taskId=ref(null),rows=ref([]),total=ref(0),loading=ref(false),query=reactive({pageNum:1,pageSize:10})
async function loadTasks(){const r=await listTask({pageNum:1,pageSize:1000});tasks.value=r.rows}
async function load(){loading.value=true;try{const r=await listReport({...query,taskId:taskId.value});rows.value=r.rows;total.value=r.total}finally{loading.value=false}}
async function doUpload({file}){await uploadReport(taskId.value,file);ElMessage.success('报告版本已上传');load()}
async function download(row){saveAs(await downloadReport(row.id),row.reportName)}
async function release(row){await updateReportStatus(row.id,'RELEASED');ElMessage.success('报告已发布');load()}
async function remove(row){await ElMessageBox.confirm('删除报告后本地PDF文件也会被删除，确认继续？');await delReport(row.id);load()}
onMounted(()=>{loadTasks();load()})
</script>
