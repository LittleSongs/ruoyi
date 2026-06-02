<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="对象名称" prop="patientName">
        <el-input v-model="queryParams.patientName" placeholder="请输入对象名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="Study ID" prop="studyId">
        <el-input v-model="queryParams.studyId" placeholder="请输入 Study ID" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="评定状态" prop="evaluationStatus">
        <el-select v-model="queryParams.evaluationStatus" placeholder="请选择状态" clearable style="width: 150px">
          <el-option v-for="dict in dcm_evaluation_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['dcm:evaluation:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['dcm:evaluation:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['dcm:evaluation:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="evaluationList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="id" align="center" width="70" />
      <el-table-column label="Study ID" prop="studyId" align="center" width="86" />
      <el-table-column label="对象名称" prop="patientName" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="Study 描述" prop="studyDescription" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="图像质量" prop="imageQualityResult" align="center" width="102">
        <template #default="scope"><dict-tag :options="dcm_quality_result" :value="scope.row.imageQualityResult" /></template>
      </el-table-column>
      <el-table-column label="缺陷结果" prop="defectResult" align="center" width="102">
        <template #default="scope"><dict-tag :options="dcm_defect_result" :value="scope.row.defectResult" /></template>
      </el-table-column>
      <el-table-column label="缺陷等级" prop="defectLevel" align="center" width="105" />
      <el-table-column label="评定状态" prop="evaluationStatus" align="center" width="100">
        <template #default="scope"><dict-tag :options="dcm_evaluation_status" :value="scope.row.evaluationStatus" /></template>
      </el-table-column>
      <el-table-column label="评定人" prop="evaluatorName" align="center" width="100" />
      <el-table-column label="提交时间" prop="evaluationTime" align="center" width="165">
        <template #default="scope">{{ parseTime(scope.row.evaluationTime) || '-' }}</template>
      </el-table-column>
      <el-table-column label="操作" width="135" align="center" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dcm:evaluation:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dcm:evaluation:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="evaluationRef" :model="form" :rules="rules" label-width="112px">
        <el-form-item label="Study" prop="studyId">
          <el-select v-model="form.studyId" filterable placeholder="请选择 Study" style="width: 100%" :disabled="!!form.id">
            <el-option
              v-for="study in studyOptions"
              :key="study.id"
              :label="studyLabel(study)"
              :value="study.id"
            />
          </el-select>
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="图像质量" prop="imageQualityResult">
              <el-select v-model="form.imageQualityResult" placeholder="请选择" style="width: 100%">
                <el-option v-for="dict in dcm_quality_result" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="缺陷结果" prop="defectResult">
              <el-select v-model="form.defectResult" placeholder="请选择" style="width: 100%">
                <el-option v-for="dict in dcm_defect_result" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="缺陷等级" prop="defectLevel">
          <el-input v-model="form.defectLevel" placeholder="请输入缺陷等级" />
        </el-form-item>
        <el-form-item label="缺陷描述" prop="defectDescription">
          <el-input v-model="form.defectDescription" type="textarea" :rows="3" placeholder="请输入缺陷描述" />
        </el-form-item>
        <el-form-item label="评定结论" prop="evaluationConclusion">
          <el-input v-model="form.evaluationConclusion" type="textarea" :rows="3" placeholder="请输入评定结论" />
        </el-form-item>
        <el-form-item label="评定状态" prop="evaluationStatus">
          <el-radio-group v-model="form.evaluationStatus">
            <el-radio v-for="dict in dcm_evaluation_status" :key="dict.value" :value="dict.value">{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">保 存</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="DcmEvaluation">
import { listStudy } from "@/api/dcm/study"
import { listEvaluation, getEvaluation, getEvaluationByStudy, addEvaluation, updateEvaluation, delEvaluation } from "@/api/dcm/evaluation"

const { proxy } = getCurrentInstance()
const route = useRoute()
const { dcm_evaluation_status, dcm_quality_result, dcm_defect_result } = useDict(
  "dcm_evaluation_status", "dcm_quality_result", "dcm_defect_result"
)
const loading = ref(true)
const showSearch = ref(true)
const evaluationList = ref([])
const studyOptions = ref([])
const total = ref(0)
const open = ref(false)
const title = ref("")
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const form = ref({})
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  patientName: undefined,
  studyId: undefined,
  evaluationStatus: undefined
})
const rules = {
  studyId: [{ required: true, message: "Study 不能为空", trigger: "change" }],
  imageQualityResult: [{ required: true, message: "图像质量结果不能为空", trigger: "change" }],
  defectResult: [{ required: true, message: "缺陷结果不能为空", trigger: "change" }],
  evaluationStatus: [{ required: true, message: "评定状态不能为空", trigger: "change" }]
}

function getList() {
  loading.value = true
  listEvaluation(queryParams).then(response => {
    evaluationList.value = response.rows
    total.value = response.total
  }).finally(() => {
    loading.value = false
  })
}

function loadStudyOptions() {
  return listStudy({ pageNum: 1, pageSize: 200 }).then(response => {
    studyOptions.value = response.rows
  })
}

function studyLabel(study) {
  return `${study.id} - ${study.patientName || "未命名对象"} - ${study.studyDescription || study.studyInstanceUid}`
}

function reset() {
  form.value = {
    id: undefined,
    studyId: undefined,
    imageQualityResult: "UNKNOWN",
    defectResult: "UNKNOWN",
    defectLevel: undefined,
    defectDescription: undefined,
    evaluationConclusion: undefined,
    evaluationStatus: "DRAFT",
    remark: undefined
  }
  proxy.resetForm("evaluationRef")
}

function handleQuery() {
  queryParams.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

function handleAdd() {
  reset()
  open.value = true
  title.value = "新增评定记录"
}

function handleUpdate(row) {
  reset()
  const id = row ? row.id : ids.value[0]
  getEvaluation(id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改评定记录"
  })
}

function openForStudy(studyId) {
  reset()
  getEvaluationByStudy(studyId).then(response => {
    if (response.data) {
      form.value = response.data
      title.value = "修改评定记录"
    } else {
      form.value.studyId = Number(studyId)
      title.value = "新增评定记录"
    }
    open.value = true
  })
}

function submitForm() {
  proxy.$refs.evaluationRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateEvaluation(form.value) : addEvaluation(form.value)
    request.then(() => {
      proxy.$modal.msgSuccess("保存成功")
      open.value = false
      getList()
    })
  })
}

function cancel() {
  open.value = false
  reset()
}

function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除评定记录编号为 "' + deleteIds + '" 的数据项？').then(() => {
    return delEvaluation(deleteIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

onMounted(() => {
  getList()
  loadStudyOptions().then(() => {
    if (route.query.studyId) {
      openForStudy(route.query.studyId)
    }
  })
})

watch(() => route.query.studyId, (studyId, previous) => {
  if (studyId && studyId !== previous) {
    openForStudy(studyId)
  }
})
</script>
