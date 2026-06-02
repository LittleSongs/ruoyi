<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="任务ID" prop="taskId"><el-input v-model="queryParams.taskId" clearable placeholder="任务ID" style="width: 120px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="SOP UID" prop="sopInstanceUid"><el-input v-model="queryParams.sopInstanceUid" clearable placeholder="SOPInstanceUID" style="width: 240px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" clearable placeholder="状态" style="width: 130px">
          <el-option v-for="dict in ndt_evaluation_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:evaluation:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:evaluation:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:evaluation:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="evaluationList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="任务ID" prop="taskId" width="90" align="center" />
      <el-table-column label="任务编号" prop="taskNo" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="SOPInstanceUID" prop="sopInstanceUID" min-width="240" :show-overflow-tooltip="true" />
      <el-table-column label="缺陷类型" prop="defectType" min-width="120" />
      <el-table-column label="缺陷等级" prop="defectLevel" width="100" align="center" />
      <el-table-column label="结论" prop="conclusion" min-width="180" :show-overflow-tooltip="true" />
      <el-table-column label="评定人员" prop="evaluatorUserName" width="110" />
      <el-table-column label="评定时间" prop="evaluateTime" width="160" align="center"><template #default="scope">{{ parseTime(scope.row.evaluateTime) || '-' }}</template></el-table-column>
      <el-table-column label="状态" prop="status" width="100" align="center"><template #default="scope"><dict-tag :options="ndt_evaluation_status" :value="scope.row.status" /></template></el-table-column>
      <el-table-column label="操作" width="190" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Document" @click="viewAnnotation(scope.row)">标注</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['ndt:evaluation:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:evaluation:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="evaluationRef" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="检测任务" prop="taskId">
          <el-select v-model="form.taskId" filterable placeholder="请选择任务" style="width: 100%" @change="loadDicoms">
            <el-option v-for="task in taskOptions" :key="task.id" :label="task.taskNo + ' / ' + task.taskName" :value="task.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="DICOM实例">
          <el-select v-model="selectedDicomId" filterable clearable placeholder="可选择任务下实例" style="width: 100%" @change="selectDicom">
            <el-option v-for="dicom in dicomOptions" :key="dicom.id" :label="dicom.instanceNumber + ' / ' + dicom.sopInstanceUid" :value="dicom.id" />
          </el-select>
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="缺陷类型"><el-input v-model="form.defectType" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="缺陷等级"><el-input v-model="form.defectLevel" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="结论"><el-input v-model="form.conclusion" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="标注JSON"><el-input v-model="form.annotationJson" type="textarea" :rows="5" /></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio v-for="dict in ndt_evaluation_status" :key="dict.value" :value="dict.value">{{ dict.label }}</el-radio></el-radio-group></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtEvaluation">
import { listEvaluation, getEvaluation, addEvaluation, updateEvaluation, delEvaluation } from "@/api/ndt/evaluation"
import { listTask } from "@/api/ndt/task"
import { listDicom } from "@/api/ndt/dicom"

const { proxy } = getCurrentInstance()
const { ndt_evaluation_status } = useDict("ndt_evaluation_status")
const loading = ref(true)
const showSearch = ref(true)
const evaluationList = ref([])
const taskOptions = ref([])
const dicomOptions = ref([])
const selectedDicomId = ref()
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const title = ref("")
const queryParams = reactive({ pageNum: 1, pageSize: 10, taskId: undefined, sopInstanceUid: undefined, status: undefined })
const form = ref({})
const rules = { taskId: [{ required: true, message: "检测任务不能为空", trigger: "change" }] }

function getList() { loading.value = true; listEvaluation(queryParams).then(res => { evaluationList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false }) }
function loadTasks() { listTask({ pageNum: 1, pageSize: 300 }).then(res => { taskOptions.value = res.rows }) }
function loadDicoms() { if (!form.value.taskId) return; listDicom({ pageNum: 1, pageSize: 500, taskId: form.value.taskId }).then(res => { dicomOptions.value = res.rows }) }
function selectDicom(id) {
  const dicom = dicomOptions.value.find(item => item.id === id)
  if (!dicom) return
  form.value.studyInstanceUid = dicom.studyInstanceUid
  form.value.seriesInstanceUid = dicom.seriesInstanceUid
  form.value.sopInstanceUid = dicom.sopInstanceUid
}
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function reset() { selectedDicomId.value = undefined; dicomOptions.value = []; form.value = { id: undefined, taskId: undefined, studyInstanceUid: undefined, seriesInstanceUid: undefined, sopInstanceUid: undefined, defectType: undefined, defectLevel: undefined, conclusion: undefined, annotationJson: undefined, status: "DRAFT" }; proxy.resetForm("evaluationRef") }
function handleAdd() { reset(); title.value = "新增评定结果"; open.value = true }
function handleUpdate(row) { reset(); const id = row ? row.id : ids.value[0]; getEvaluation(id).then(res => { form.value = res.data; title.value = "修改评定结果"; open.value = true; loadDicoms() }) }
function submitForm() {
  proxy.$refs.evaluationRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateEvaluation(form.value) : addEvaluation(form.value)
    request.then(() => { proxy.$modal.msgSuccess("保存成功"); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.id); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除评定结果编号为 "' + deleteIds + '" 的数据项？').then(() => delEvaluation(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess("删除成功") }).catch(() => {})
}
function viewAnnotation(row) { proxy.$alert(row.annotationJson || "{}", "标注JSON", { confirmButtonText: "确定" }) }
onMounted(() => { loadTasks(); getList() })
</script>
