<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="规则名称" prop="ruleName"><el-input v-model="queryParams.ruleName" clearable placeholder="规则名称" style="width: 180px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="UID类型" prop="uidType">
        <el-select v-model="queryParams.uidType" clearable placeholder="UID类型" style="width: 150px">
          <el-option v-for="dict in ndt_uid_type" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:uidRule:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:uidRule:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:uidRule:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="ruleList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="规则名称" prop="ruleName" min-width="180" />
      <el-table-column label="UID类型" prop="uidType" width="130"><template #default="scope"><dict-tag :options="ndt_uid_type" :value="scope.row.uidType" /></template></el-table-column>
      <el-table-column label="根类型" prop="rootType" width="150"><template #default="scope"><dict-tag :options="ndt_uid_root_type" :value="scope.row.rootType" /></template></el-table-column>
      <el-table-column label="UID Root (自定义)" prop="uidRoot" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="后缀模式 (自定义)" prop="suffixPattern" min-width="190" :show-overflow-tooltip="true" />
      <el-table-column label="启用" prop="enabled" width="80" align="center"><template #default="scope">{{ scope.row.enabled === '1' ? '是' : '否' }}</template></el-table-column>
      <el-table-column label="操作" width="220" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="MagicStick" @click="handleGenerate(scope.row)" v-hasPermi="['ndt:uidRule:generate']">测试</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['ndt:uidRule:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:uidRule:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="680px" append-to-body>
      <el-form ref="ruleRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="规则名称" prop="ruleName"><el-input v-model="form.ruleName" /></el-form-item>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="UID类型" prop="uidType"><el-select v-model="form.uidType" style="width: 100%"><el-option v-for="dict in ndt_uid_type" :key="dict.value" :label="dict.label" :value="dict.value" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="根类型" prop="rootType"><el-select v-model="form.rootType" style="width: 100%"><el-option v-for="dict in ndt_uid_root_type" :key="dict.value" :label="dict.label" :value="dict.value" /></el-select></el-form-item></el-col>
        </el-row>
        <el-form-item label="UID Root"><el-input v-model="form.uidRoot" placeholder="自定义Root时填写" /></el-form-item>
        <el-form-item label="后缀模式"><el-input v-model="form.suffixPattern" placeholder="{type}.{timestamp}.{random}" /><div class="form-tip">必须包含至少一个{random}, 示例：xxxx.{random}</div></el-form-item>
        <el-form-item label="启用"><el-switch v-model="form.enabled" active-value="1" inactive-value="0" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtUidRule">
import { listUidRule, getUidRule, addUidRule, updateUidRule, delUidRule, generateUid } from "@/api/ndt/uidRule"


const { proxy } = getCurrentInstance()
const { ndt_uid_type, ndt_uid_root_type } = useDict("ndt_uid_type", "ndt_uid_root_type")
const loading = ref(true)
const showSearch = ref(true)
const ruleList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const title = ref("")
const queryParams = reactive({ pageNum: 1, pageSize: 10, ruleName: undefined, uidType: undefined })
const form = ref({})
const rules = { ruleName: [{ required: true, message: "规则名称不能为空", trigger: "blur" }], uidType: [{ required: true, message: "UID类型不能为空", trigger: "change" }], rootType: [{ required: true, message: "根类型不能为空", trigger: "change" }] }

function getList() { loading.value = true; listUidRule(queryParams).then(res => { ruleList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false }) }
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function reset() { form.value = { id: undefined, ruleName: undefined, uidType: "STUDY", rootType: "UUID_2_25", uidRoot: undefined, suffixPattern: "{type}.{timestamp}.{random}", enabled: "1", remark: undefined }; proxy.resetForm("ruleRef") }
function handleAdd() { reset(); title.value = "新增UID规则"; open.value = true }
function handleUpdate(row) { reset(); const id = row ? row.id : ids.value[0]; getUidRule(id).then(res => { form.value = res.data; title.value = "修改UID规则"; open.value = true }) }
function submitForm() {
  proxy.$refs.ruleRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateUidRule(form.value) : addUidRule(form.value)
    request.then(() => { proxy.$modal.msgSuccess("保存成功"); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.id); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除UID规则编号为 "' + deleteIds + '" 的数据项？').then(() => delUidRule(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess("删除成功") }).catch(() => {})
}
function handleGenerate(row) {
  generateUid({ uidType: row.uidType, ruleId: row.id }).then(res => {
    proxy.$alert(res.data, "生成结果", { confirmButtonText: "确定" })
  })
}
onMounted(getList)
</script>
