<template>
  <div class="app-container">
    <el-alert title="一个部位对应一个图像Series：先上传一张原始图，再从该原始图上传处理图、截图或标注图；这些派生图必须保留原图的Study UID和Series UID。SR等非图像对象由评定模块上传到独立Series。" type="info" show-icon :closable="false" />

    <el-form :inline="true" style="margin-top:16px">
      <el-form-item label="任务"><el-select v-model="taskId" filterable @change="taskChanged" style="width:260px"><el-option v-for="t in tasks" :key="t.id" :label="`${t.taskNo} - ${t.taskName}`" :value="t.id"/></el-select></el-form-item>
      <el-form-item label="检测部位"><el-select v-model="positionId" filterable clearable @change="positionChanged" style="width:280px"><el-option v-for="p in positions" :key="p.id" :label="`${p.workpieceName} / ${p.positionCode} ${p.positionName}`" :value="p.id"/></el-select></el-form-item>
      <el-form-item><el-button type="primary" @click="load">查询</el-button><el-upload :show-file-list="false" :http-request="doUpload" accept=".dcm,application/dicom" style="margin-left:8px"><el-button :disabled="!positionId">上传原始DICOM</el-button></el-upload></el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows">
      <el-table-column prop="objectName" label="对象名称" min-width="180"/>
      <el-table-column prop="positionName" label="检测部位" min-width="140"/>
      <el-table-column prop="objectType" label="对象类型" width="165"/>
      <el-table-column prop="storageType" label="存储" width="105"/>
      <el-table-column prop="studyUid" label="Study UID" min-width="210" show-overflow-tooltip/>
      <el-table-column prop="seriesUid" label="Series UID" min-width="210" show-overflow-tooltip/>
      <el-table-column prop="sopInstanceUid" label="SOP UID" min-width="210" show-overflow-tooltip/>
      <el-table-column prop="sha256" label="SHA-256" min-width="180" show-overflow-tooltip/>
      <el-table-column label="操作" fixed="right" width="310"><template #default="{row}"><el-button v-if="row.objectType==='ORIGINAL_IMAGE'" link type="primary" @click="openDerivedUpload(row)">上传派生图</el-button><el-button link @click="showTags(row)">标签</el-button><el-button link @click="showRelations(row)">关系</el-button><el-button link @click="download(row)">下载</el-button><el-button link type="danger" @click="remove(row)">删除</el-button></template></el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load"/>
    <el-dialog v-model="detailVisible" :title="detailTitle" width="760px">
      <el-table :data="details" max-height="520"><el-table-column prop="tagName" label="标签" width="150"/><el-table-column prop="value" label="值" show-overflow-tooltip/><el-table-column prop="sourceObjectId" label="来源对象"/><el-table-column prop="targetObjectId" label="目标对象"/><el-table-column prop="relationType" label="关系"/></el-table>
    </el-dialog>
    <el-dialog v-model="derivedVisible" title="上传同Series派生图" width="560px" @closed="resetDerivedUpload">
      <el-alert title="派生DICOM必须与来源原始图具有相同的Study Instance UID和Series Instance UID；后台不会改写文件标签。" type="warning" :closable="false" show-icon/>
      <el-form :model="derivedForm" label-width="100px" style="margin-top:16px">
        <el-form-item label="来源原始图"><span>{{ derivedSource?.objectName || derivedSource?.sopInstanceUid }}</span></el-form-item>
        <el-form-item label="检测部位"><span>{{ derivedSource?.positionName }}</span></el-form-item>
        <el-form-item label="Study UID"><span class="uid-text">{{ derivedSource?.studyUid }}</span></el-form-item>
        <el-form-item label="Series UID"><span class="uid-text">{{ derivedSource?.seriesUid }}</span></el-form-item>
        <el-form-item label="派生类型"><el-select v-model="derivedForm.objectType" style="width:100%"><el-option label="处理图" value="PROCESSED_IMAGE"/><el-option label="截图" value="SCREENSHOT"/><el-option label="标注图" value="ANNOTATION_IMAGE"/></el-select></el-form-item>
        <el-form-item label="DICOM文件"><el-upload :auto-upload="false" :limit="1" :on-change="derivedFileChanged" :on-remove="derivedFileRemoved" accept=".dcm,application/dicom"><el-button>选择文件</el-button></el-upload></el-form-item>
      </el-form>
      <template #footer><el-button @click="derivedVisible=false">取消</el-button><el-button type="primary" :loading="derivedUploading" @click="submitDerivedUpload">上传</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { saveAs } from 'file-saver'
import { listTask, getTaskObjectTree } from '@/api/ndt/task'
import { listDicomObject, uploadDicomObject, uploadDerivedDicomObject, getObjectTags, getObjectRelations, downloadDicomObject, deleteDicomObject } from '@/api/ndt/dicom'

const tasks=ref([]),positions=ref([]),taskId=ref(null),positionId=ref(null),rows=ref([]),total=ref(0),loading=ref(false)
const query=reactive({pageNum:1,pageSize:10})
const detailVisible=ref(false),detailTitle=ref(''),details=ref([])
const derivedVisible=ref(false),derivedUploading=ref(false),derivedSource=ref(null),derivedFile=ref(null)
const derivedForm=reactive({objectType:'PROCESSED_IMAGE'})
async function loadTasks(){const r=await listTask({pageNum:1,pageSize:1000});tasks.value=r.rows}
async function taskChanged(){positionId.value=null;positions.value=[];if(!taskId.value)return;const r=await getTaskObjectTree(taskId.value);for(const w of r.data.workpieces||[])for(const p of w.positions||[])positions.value.push({...p,workpieceName:w.workpieceName});positionChanged()}
function positionChanged(){query.pageNum=1;load()}
async function load(){loading.value=true;try{const r=await listDicomObject({...query,taskId:taskId.value,positionId:positionId.value});rows.value=r.rows;total.value=r.total}finally{loading.value=false}}
async function doUpload({file}){const r=await uploadDicomObject(positionId.value,file);if(r.data.finalStatus!=='PASS')return ElMessage.error((r.data.errors||[]).join('；')||'DICOM校验失败');ElMessage.success('上传成功');load()}
function openDerivedUpload(row){derivedSource.value=row;derivedVisible.value=true}
function derivedFileChanged(file){derivedFile.value=file.raw}
function derivedFileRemoved(){derivedFile.value=null}
function resetDerivedUpload(){derivedSource.value=null;derivedFile.value=null;derivedForm.objectType='PROCESSED_IMAGE'}
async function submitDerivedUpload(){if(!derivedFile.value)return ElMessage.warning('请选择DICOM文件');derivedUploading.value=true;try{await uploadDerivedDicomObject(derivedSource.value.id,derivedForm.objectType,derivedFile.value);ElMessage.success('派生图已归档到原图所在Series');derivedVisible.value=false;load()}finally{derivedUploading.value=false}}
async function showTags(row){const r=await getObjectTags(row.id);detailTitle.value='DICOM标签';details.value=Object.entries(r.data||{}).map(([tagName,v])=>({tagName,value:typeof v==='object'?JSON.stringify(v):v}));detailVisible.value=true}
async function showRelations(row){const r=await getObjectRelations(row.id);detailTitle.value='对象关系';details.value=r.data||[];detailVisible.value=true}
async function download(row){saveAs(await downloadDicomObject(row.id),row.objectName||`object-${row.id}.dcm`)}
async function remove(row){await ElMessageBox.confirm('确认删除该对象索引吗？Orthanc文件不会自动删除。');await deleteDicomObject(row.id);load()}
onMounted(()=>{loadTasks();load()})
</script>
<style scoped>
.uid-text { overflow-wrap: anywhere; }
</style>
