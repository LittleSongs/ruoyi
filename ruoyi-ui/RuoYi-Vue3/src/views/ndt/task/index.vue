<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="任务编号" prop="taskNo">
        <el-input v-model="queryParams.taskNo" placeholder="请输入任务编号" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="任务名称" prop="taskName">
        <el-input v-model="queryParams.taskName" placeholder="请输入任务名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="工件名称" prop="workpieceName">
        <el-input v-model="queryParams.workpieceName" placeholder="请输入工件名称" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 140px">
          <el-option v-for="dict in ndt_task_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['ndt:task:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['ndt:task:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Upload" :disabled="single" @click="handleUpload" v-hasPermi="['ndt:dicom:upload']">上传DICOM</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['ndt:task:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="任务编号" prop="taskNo" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="任务名称" prop="taskName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="工件名称" prop="workpieceName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="客户部门" prop="customerDeptName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="StudyInstanceUID" prop="studyInstanceUid" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="状态" prop="status" align="center" width="100">
        <template #default="scope"><dict-tag :options="ndt_task_status" :value="scope.row.status" /></template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createTime" align="center" width="160">
        <template #default="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="280">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)" v-hasPermi="['ndt:task:query']">详情</el-button>
          <el-button link type="primary" icon="User" @click="handleAssign(scope.row)" v-hasPermi="['ndt:task:assign']">分配</el-button>
          <el-button link type="primary" icon="Picture" @click="openOhif(scope.row)" v-hasPermi="['ndt:task:ohif']">OHIF</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['ndt:task:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="taskRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="任务编号" prop="taskNo"><el-input v-model="form.taskNo" placeholder="为空则自动生成" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="任务名称" prop="taskName"><el-input v-model="form.taskName" placeholder="请输入任务名称" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="工件名称" prop="workpieceName"><el-input v-model="form.workpieceName" placeholder="请输入工件名称" /></el-form-item></el-col>
          <el-col :span="12">
            <el-form-item label="客户部门" prop="customerDeptId">
              <el-tree-select v-model="form.customerDeptId" :data="deptOptions" :props="{ value: 'id', label: 'label', children: 'children' }" value-key="id" check-strictly placeholder="请选择客户部门" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="公开示例">
          <el-switch v-model="form.isPublicSample" active-value="1" inactive-value="0" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog title="DICOM 文件上传" v-model="uploadOpen" width="560px" append-to-body>
      <el-form label-width="110px">
        <el-form-item label="当前任务">
          <el-input v-model="uploadTaskLabel" disabled />
        </el-form-item>
        <el-form-item label="选择文件">
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :limit="1"
            :show-file-list="true"
            accept=".dcm"
            :on-change="handleUploadFileChange"
            :on-remove="handleUploadFileRemove"
          >
            <el-button type="primary">选择 DICOM 文件</el-button>
            <template #tip>
              <div class="el-upload__tip">仅支持 .dcm 文件</div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" :loading="uploading" @click="submitUpload">上 传</el-button>
        <el-button @click="uploadOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog title="任务分配" v-model="assignOpen" width="860px" append-to-body>
      <el-table :data="assignRows">
        <el-table-column label="用户" min-width="180">
          <template #default="scope">
            <el-select v-model="scope.row.userId" filterable placeholder="选择用户" style="width: 100%">
              <el-option v-for="user in userOptions" :key="user.userId" :label="user.userName + ' / ' + user.nickName" :value="user.userId" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="任务角色" width="150">
          <template #default="scope">
            <el-select v-model="scope.row.taskRole" placeholder="角色">
              <el-option v-for="dict in ndt_task_role" :key="dict.value" :label="dict.label" :value="dict.value" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="查看" width="90" align="center"><template #default="scope"><el-switch v-model="scope.row.canView" active-value="1" inactive-value="0" /></template></el-table-column>
        <el-table-column label="上传" width="90" align="center"><template #default="scope"><el-switch v-model="scope.row.canUpload" active-value="1" inactive-value="0" /></template></el-table-column>
        <el-table-column label="评定" width="90" align="center"><template #default="scope"><el-switch v-model="scope.row.canEvaluate" active-value="1" inactive-value="0" /></template></el-table-column>
        <el-table-column label="操作" width="80" align="center">
          <template #default="scope"><el-button link type="primary" icon="Delete" @click="assignRows.splice(scope.$index, 1)" /></template>
        </el-table-column>
      </el-table>
      <div class="dialog-actions"><el-button icon="Plus" @click="addAssignRow">添加人员</el-button></div>
      <template #footer>
        <el-button type="primary" @click="submitAssign">保 存</el-button>
        <el-button @click="assignOpen = false">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="NdtTask">
import { listTask, getTask, addTask, updateTask, delTask, listTaskUsers, assignTaskUsers, getTaskOhif } from "@/api/ndt/task"
import { uploadDicom } from "@/api/ndt/dicom"
import { deptTreeSelect, listUser } from "@/api/system/user"

const { proxy } = getCurrentInstance()
const { ndt_task_status, ndt_task_role } = useDict("ndt_task_status", "ndt_task_role")
const loading = ref(true)
const showSearch = ref(true)
const taskList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const open = ref(false)
const assignOpen = ref(false)
const uploadOpen = ref(false)
const uploading = ref(false)
const uploadTaskId = ref(null)
const uploadTaskLabel = ref("")
const uploadFile = ref(null)
const title = ref("")
const deptOptions = ref([])
const userOptions = ref([])
const assignTaskId = ref()
const assignRows = ref([])

const queryParams = reactive({ pageNum: 1, pageSize: 10, taskNo: undefined, taskName: undefined, workpieceName: undefined, status: undefined })
const form = ref({})
const rules = { taskName: [{ required: true, message: "任务名称不能为空", trigger: "blur" }], customerDeptId: [{ required: true, message: "客户部门不能为空", trigger: "change" }] }

function getList() {
  loading.value = true
  listTask(queryParams).then(res => { taskList.value = res.rows; total.value = res.total }).finally(() => { loading.value = false })
}
function handleQuery() { queryParams.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm("queryRef"); handleQuery() }
function reset() { form.value = { id: undefined, taskNo: undefined, taskName: undefined, workpieceName: undefined, customerDeptId: undefined, isPublicSample: "0", remark: undefined }; proxy.resetForm("taskRef") }
function handleAdd() { reset(); title.value = "新增检测任务"; open.value = true }
function handleUpdate(row) { reset(); const id = row ? row.id : ids.value[0]; getTask(id).then(res => { form.value = res.data; title.value = "修改检测任务"; open.value = true }) }
function handleDetail(row) { handleUpdate(row) }
function submitForm() {
  proxy.$refs.taskRef.validate(valid => {
    if (!valid) return
    const request = form.value.id ? updateTask(form.value) : addTask(form.value)
    request.then(() => { proxy.$modal.msgSuccess("保存成功"); open.value = false; getList() })
  })
}
function cancel() { open.value = false; reset() }
function handleSelectionChange(selection) { ids.value = selection.map(item => item.id); single.value = selection.length !== 1; multiple.value = !selection.length }
function handleDelete(row) {
  const deleteIds = row ? row.id : ids.value
  proxy.$modal.confirm('是否确认删除检测任务编号为 "' + deleteIds + '" 的数据项？').then(() => delTask(deleteIds)).then(() => { getList(); proxy.$modal.msgSuccess("删除成功") }).catch(() => {})
}
function handleAssign(row) {
  assignTaskId.value = row.id
  Promise.all([listTaskUsers(row.id), listUser({ pageNum: 1, pageSize: 500 })]).then(([assigned, users]) => {
    assignRows.value = assigned.data || []
    userOptions.value = users.rows || []
    assignOpen.value = true
  })
}
function handleUpload() {
  if (!ids.value.length) {
    proxy.$modal.msgWarning("请选择一个任务后再上传 DICOM 文件")
    return
  }
  const row = taskList.value.find(item => item.id === ids.value[0])
  uploadTaskId.value = row?.id || ids.value[0]
  uploadTaskLabel.value = `${row?.taskNo || ""}${row?.taskNo && row?.taskName ? " / " : ""}${row?.taskName || ""}`
  uploadFile.value = null
  uploadOpen.value = true
}
function handleUploadFileChange(file) {
  uploadFile.value = file.raw
}
function handleUploadFileRemove() {
  uploadFile.value = null
}
function submitUpload() {
  if (!uploadFile.value) {
    proxy.$modal.msgWarning("请先选择 DICOM 文件")
    return
  }
  uploading.value = true
  uploadDicom(uploadTaskId.value, uploadFile.value)
    .then((res) => {
      const data = res.data || {}
      if (data.finalStatus === 'FAIL') {
        const errorText = (data.errors || []).join('；') || 'DICOM校验失败，文件未上传到Orthanc'
        proxy.$alert(errorText, '校验失败', {
          type: 'error',
          confirmButtonText: '关闭',
          showClose: true,
          closeOnClickModal: false,
          closeOnPressEscape: false,
          customClass: 'dicom-error-message-box'
        })
        return
      }
      proxy.$modal.msgSuccess("上传成功")
      uploadOpen.value = false
      getList()
    })
    .finally(() => {
      uploading.value = false
    })
}
function addAssignRow() { assignRows.value.push({ userId: undefined, taskRole: "VIEWER", canView: "1", canUpload: "0", canEvaluate: "0" }) }
function submitAssign() {
  assignTaskUsers(assignTaskId.value, assignRows.value).then(() => { proxy.$modal.msgSuccess("分配成功"); assignOpen.value = false; getList() })
}
function openOhif(row) {
  getTaskOhif(row.id).then(res => { window.open(res.data, "_blank") })
}
onMounted(() => {
  deptTreeSelect().then(res => { deptOptions.value = res.data })
  getList()
})
</script>

<style scoped>
.dialog-actions {
  margin-top: 12px;
}

:deep(.el-upload) {
  width: 100%;
}

:global(.dicom-error-message-box) {
  width: 760px;
  max-width: calc(100vw - 32px);
}

:global(.dicom-error-message-box .el-message-box__content) {
  max-height: 60vh;
  overflow: auto;
}

:global(.dicom-error-message-box .el-message-box__message) {
  white-space: pre-wrap;
  word-break: break-word;
  line-height: 1.6;
  text-align: left;
}
</style>
