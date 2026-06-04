<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="标签名称" prop="tagName">
        <el-input v-model="queryParams.tagName" placeholder="请输入标签名称" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="显示名称" prop="tagLabel">
        <el-input v-model="queryParams.tagLabel" placeholder="请输入显示名称" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="启用" prop="enabled">
        <el-select v-model="queryParams.enabled" placeholder="启用状态" clearable style="width: 120px">
          <el-option label="是" value="1" />
          <el-option label="否" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:dicomPrivateTag:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:dicomPrivateTag:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:dicomPrivateTag:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="tagList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="显示名称" prop="tagLabel" min-width="130" />
      <el-table-column label="标签名称" prop="tagName" min-width="200" :show-overflow-tooltip="true" />
      <el-table-column label="标签号" prop="tagCode" width="120" />
      <el-table-column label="VR" prop="vr" width="80" align="center" />
      <el-table-column label="默认值" prop="defaultValue" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="启用" prop="enabled" width="80" align="center">
        <template #default="scope"><el-tag :type="scope.row.enabled === '1' ? 'success' : 'info'">{{ scope.row.enabled === '1' ? '是' : '否' }}</el-tag></template>
      </el-table-column>
      <el-table-column label="内置" prop="builtin" width="80" align="center">
        <template #default="scope"><el-tag :type="scope.row.builtin === '1' ? 'warning' : 'info'">{{ scope.row.builtin === '1' ? '是' : '否' }}</el-tag></template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" min-width="180" :show-overflow-tooltip="true" />
      <el-table-column label="操作" width="170" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['ndt:dicomPrivateTag:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:dicomPrivateTag:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="tagRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="显示名称" prop="tagLabel"><el-input v-model="form.tagLabel" placeholder="例如：委托方" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="标签名称" prop="tagName"><el-input v-model="form.tagName" placeholder="例如：0011,1010 或 Manufacturer" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="标签号"><el-input v-model="form.tagCode" placeholder="例如：0011,1010" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="VR"><el-input v-model="form.vr" placeholder="例如：LO / LT" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="默认值"><el-input v-model="form.defaultValue" placeholder="新增到DICOM时的默认值，可为空" /></el-form-item>
        <el-form-item label="启用"><el-switch v-model="form.enabled" active-value="1" inactive-value="0" /></el-form-item>
        <el-form-item label="内置"><el-switch v-model="form.builtin" active-value="1" inactive-value="0" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtDicomPrivateTag">
import { listDicomPrivateTag, getDicomPrivateTag, addDicomPrivateTag, updateDicomPrivateTag, delDicomPrivateTag } from "@/api/ndt/dicomPrivateTag"

const { proxy } = getCurrentInstance()
const loading = ref(true)
const showSearch = ref(true)
const tagList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const title = ref("")
const queryParams = reactive({ pageNum: 1, pageSize: 10, tagName: undefined, tagLabel: undefined, enabled: undefined })
const form = ref({})
const rules = {
  tagLabel: [{ required: true, message: "显示名称不能为空", trigger: "blur" }],
  tagName: [{ required: true, message: "标签名称不能为空", trigger: "blur" }]
}

function getList() {
  loading.value = true
  listDicomPrivateTag(queryParams).then(res => { tagList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false })
}
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function reset() {
  form.value = { id: undefined, tagName: undefined, tagLabel: undefined, tagCode: undefined, vr: "LO", defaultValue: "", enabled: "1", builtin: "0", remark: undefined }
  proxy.resetForm("tagRef")
}
function handleAdd() { reset(); title.value = "新增DICOM私有标签"; open.value = true }
function handleUpdate(row) {
  reset()
  const id = row ? row.id : ids.value[0]
  getDicomPrivateTag(id).then(res => { form.value = res.data; title.value = "修改DICOM私有标签"; open.value = true })
}
function submitForm() {
  proxy.$refs.tagRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateDicomPrivateTag(form.value) : addDicomPrivateTag(form.value)
    request.then(() => { proxy.$modal.msgSuccess("保存成功"); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.id); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除DICOM私有标签编号为 "' + deleteIds + '" 的数据项？').then(() => delDicomPrivateTag(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess("删除成功") }).catch(() => {})
}
onMounted(getList)
</script>
