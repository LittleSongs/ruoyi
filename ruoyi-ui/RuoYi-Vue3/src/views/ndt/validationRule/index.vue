<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="SOPClassUID" prop="sopClassUid">
        <el-input v-model="queryParams.sopClassUid" placeholder="请输入SOPClassUID" clearable style="width: 260px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="规则类型" prop="ruleType">
        <el-select v-model="queryParams.ruleType" placeholder="规则类型" clearable style="width: 140px">
          <el-option label="必备Tag" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="启用" prop="enabled">
        <el-select v-model="queryParams.enabled" placeholder="启用状态" clearable style="width: 120px">
          <el-option label="是" value="Y" />
          <el-option label="否" value="N" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:validationRule:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:validationRule:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:validationRule:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="ruleList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="规则名称" prop="ruleName" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="SOPClassUID" prop="sopClassUid" min-width="240" :show-overflow-tooltip="true" />
      <el-table-column label="SOP名称" prop="sopName" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="规则类型" prop="ruleType" width="110" align="center">
        <template #default="scope">{{ ruleTypeLabel(scope.row.ruleType) }}</template>
      </el-table-column>
      <el-table-column label="Tag编号" prop="tagCode" width="120" />
      <el-table-column label="Tag名称" prop="tagName" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="VR" prop="vr" width="70" align="center" />
      <el-table-column label="私有创建者" prop="privateCreator" min-width="130" :show-overflow-tooltip="true" />
      <el-table-column label="允许空值" prop="allowBlank" width="90" align="center">
        <template #default="scope"><el-tag :type="scope.row.allowBlank === 'Y' ? 'warning' : 'info'">{{ yesNoLabel(scope.row.allowBlank) }}</el-tag></template>
      </el-table-column>
      <el-table-column label="失败级别" prop="severity" width="100" align="center" />
      <el-table-column label="启用" prop="enabled" width="80" align="center">
        <template #default="scope"><el-tag :type="scope.row.enabled === 'Y' ? 'success' : 'info'">{{ yesNoLabel(scope.row.enabled) }}</el-tag></template>
      </el-table-column>
      <el-table-column label="排序" prop="sortOrder" width="80" align="center" />
      <el-table-column label="备注" prop="remark" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="操作" width="160" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['ndt:validationRule:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:validationRule:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="860px" append-to-body>
      <el-form ref="ruleRef" :model="form" :rules="rules" label-width="120px">
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="规则名称" prop="ruleName"><el-input v-model="form.ruleName" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="规则类型" prop="ruleType"><el-select v-model="form.ruleType" style="width: 100%"><el-option label="1：必备 Tag" :value="1" /></el-select></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="SOPClassUID" prop="sopClassUid"><el-input v-model="form.sopClassUid" placeholder="* 表示通用规则" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="SOP名称"><el-input v-model="form.sopName" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="Modality"><el-input v-model="form.modality" placeholder="CT / DX / CR" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="Tag编号" prop="tagCode"><el-input v-model="form.tagCode" placeholder="00080016" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="显示格式" prop="tagDisplay"><el-input v-model="form.tagDisplay" placeholder="(0008,0016)" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="Tag名称"><el-input v-model="form.tagName" placeholder="SOPClassUID" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="8"><el-form-item label="VR"><el-input v-model="form.vr" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="允许空值"><el-switch v-model="form.allowBlank" active-value="Y" inactive-value="N" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="启用"><el-switch v-model="form.enabled" active-value="Y" inactive-value="N" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="8"><el-form-item label="失败级别"><el-select v-model="form.severity" style="width: 100%"><el-option label="ERROR" value="ERROR" /><el-option label="WARNING" value="WARNING" /></el-select></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="排序"><el-input-number v-model="form.sortOrder" :min="0" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="私有创建者"><el-input v-model="form.privateCreator" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="失败提示"><el-input v-model="form.failMessage" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtValidationRule">
import { listValidationRule, getValidationRule, addValidationRule, updateValidationRule, delValidationRule } from '@/api/ndt/validationRule'

const { proxy } = getCurrentInstance()
const loading = ref(true)
const showSearch = ref(true)
const ruleList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const title = ref('')
const queryParams = reactive({ pageNum: 1, pageSize: 10, sopClassUid: undefined, ruleType: undefined, enabled: undefined })
const form = ref({})
const rules = {
  ruleName: [{ required: true, message: '规则名称不能为空', trigger: 'blur' }],
  sopClassUid: [{ required: true, message: 'SOPClassUID不能为空', trigger: 'blur' }],
  ruleType: [{ required: true, message: '规则类型不能为空', trigger: 'change' }],
  tagCode: [{ required: true, message: 'Tag编号不能为空', trigger: 'blur' }],
  tagDisplay: [{ required: true, message: '显示格式不能为空', trigger: 'blur' }]
}

function getList() {
  loading.value = true
  listValidationRule(queryParams).then(res => { ruleList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false })
}
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function reset() {
  form.value = { ruleId: undefined, ruleName: undefined, sopClassUid: '*', sopName: undefined, modality: undefined, ruleType: 1, tagCode: undefined, tagDisplay: undefined, tagName: undefined, vr: undefined, privateCreator: undefined, allowBlank: 'N', severity: 'ERROR', enabled: 'Y', sortOrder: 0, failMessage: undefined, remark: undefined }
  proxy.resetForm('ruleRef')
}
function handleAdd() { reset(); title.value = '新增自定义校验规则'; open.value = true }
function handleUpdate(row) {
  reset()
  const ruleId = row ? row.ruleId : ids.value[0]
  getValidationRule(ruleId).then(res => { form.value = res.data; title.value = '修改自定义校验规则'; open.value = true })
}
function submitForm() {
  proxy.$refs.ruleRef.validate(valid => {
    if (!valid) return
    const request = form.value.ruleId ? updateValidationRule(form.value) : addValidationRule(form.value)
    request.then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.ruleId); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.ruleId : ids.value
  proxy.$modal.confirm('是否确认删除自定义校验规则编号为 "' + deleteIds + '" 的数据项？').then(() => delValidationRule(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }).catch(() => {})
}
function ruleTypeLabel(value) { return Number(value) === 1 ? '必备Tag' : value }
function yesNoLabel(value) { return value === 'Y' ? '是' : '否' }

onMounted(getList)
</script>
