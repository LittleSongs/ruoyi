<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="用户名" prop="userName"><el-input v-model="queryParams.userName" clearable placeholder="用户名" style="width: 160px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="人员编号" prop="inspectorNo"><el-input v-model="queryParams.inspectorNo" clearable placeholder="人员编号" style="width: 160px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="证书编号" prop="certificateNo"><el-input v-model="queryParams.certificateNo" clearable placeholder="证书编号" style="width: 180px" @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:inspector:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:inspector:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:inspector:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="profileList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="用户ID" prop="userId" width="90" align="center" />
      <el-table-column label="用户名" prop="userName" min-width="120" />
      <el-table-column label="昵称" prop="nickName" min-width="120" />
      <el-table-column label="检测人员编号" prop="inspectorNo" min-width="140" />
      <el-table-column label="证书编号" prop="certificateNo" min-width="160" />
      <el-table-column label="资质等级" prop="qualificationLevel" width="120" />
      <el-table-column label="有效期至" prop="expireDate" width="120" align="center" />
      <el-table-column label="操作" width="150" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['ndt:inspector:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:inspector:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="profileRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="系统用户" prop="userId">
              <el-select v-model="form.userId" filterable placeholder="请选择用户" style="width: 100%">
                <el-option v-for="user in userOptions" :key="user.userId" :label="user.userName + ' / ' + user.nickName" :value="user.userId" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12"><el-form-item label="人员编号" prop="inspectorNo"><el-input v-model="form.inspectorNo" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="证书编号"><el-input v-model="form.certificateNo" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="证书名称"><el-input v-model="form.certificateName" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="资质等级"><el-input v-model="form.qualificationLevel" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="证书附件"><el-input v-model="form.certificateFile" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="发证日期"><el-date-picker v-model="form.issueDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="有效期至"><el-date-picker v-model="form.expireDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtInspector">
import { listInspector, getInspector, addInspector, updateInspector, delInspector } from "@/api/ndt/inspector"
import { listUser } from "@/api/system/user"

const { proxy } = getCurrentInstance()
const loading = ref(true)
const showSearch = ref(true)
const profileList = ref([])
const userOptions = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const title = ref("")
const queryParams = reactive({ pageNum: 1, pageSize: 10, userName: undefined, inspectorNo: undefined, certificateNo: undefined })
const form = ref({})
const rules = { userId: [{ required: true, message: "系统用户不能为空", trigger: "change" }], inspectorNo: [{ required: true, message: "人员编号不能为空", trigger: "blur" }] }

function getList() { loading.value = true; listInspector(queryParams).then(res => { profileList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false }) }
function loadUsers() { listUser({ pageNum: 1, pageSize: 500 }).then(res => { userOptions.value = res.rows }) }
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function reset() { form.value = { id: undefined, userId: undefined, inspectorNo: undefined, certificateNo: undefined, certificateName: undefined, qualificationLevel: undefined, issueDate: undefined, expireDate: undefined, certificateFile: undefined, remark: undefined }; proxy.resetForm("profileRef") }
function handleAdd() { reset(); title.value = "新增检测人员档案"; open.value = true }
function handleUpdate(row) { reset(); const id = row ? row.id : ids.value[0]; getInspector(id).then(res => { form.value = res.data; title.value = "修改检测人员档案"; open.value = true }) }
function submitForm() {
  proxy.$refs.profileRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateInspector(form.value) : addInspector(form.value)
    request.then(() => { proxy.$modal.msgSuccess("保存成功"); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.id); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除检测人员档案编号为 "' + deleteIds + '" 的数据项？').then(() => delInspector(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess("删除成功") }).catch(() => {})
}
onMounted(() => { loadUsers(); getList() })
</script>
