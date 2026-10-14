<template>
  <div class="app-container">
    <el-form :inline="true" :model="query">
      <el-form-item label="客户公司"><el-input v-model="query.name" clearable @keyup.enter="search" /></el-form-item>
      <el-form-item>
        <el-button type="primary" @click="search">查询</el-button>
        <el-button v-hasPermi="['ndt:customer:add']" @click="openCompany()">新增客户公司</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows">
      <el-table-column prop="name" label="客户公司名称" min-width="180" />
      <el-table-column prop="contactName" label="联系人" width="140" />
      <el-table-column prop="contactPhone" label="联系电话" width="160" />
      <el-table-column prop="remark" label="备注" min-width="160" show-overflow-tooltip />
      <el-table-column label="操作" width="230">
        <template #default="{ row }">
          <el-button v-hasPermi="['ndt:customer:account:list']" link type="primary" @click.stop="openAccounts(row)">客户账号</el-button>
          <el-button v-hasPermi="['ndt:customer:edit']" link type="primary" @click.stop="openCompany(row)">编辑</el-button>
          <el-button v-hasPermi="['ndt:customer:remove']" link type="danger" @click.stop="removeCompany(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="loadCompanies" />

    <el-drawer
      v-model="accountsDrawerVisible"
      :title="selectedCompany ? selectedCompany.name + ' · 客户账号' : '客户账号'"
      direction="rtl"
      size="min(1100px, 100vw)"
      append-to-body
    >
      <template v-if="selectedCompany">
        <div class="account-heading">
          <p class="account-hint">客户账号固定属于当前公司，用于登录客户图像平台。</p>
          <el-button v-hasPermi="['ndt:customer:account:add']" type="primary" @click="openAccount()">新增客户账号</el-button>
        </div>
        <el-table v-loading="accountLoading" :data="accounts">
          <el-table-column prop="userName" label="登录账号" min-width="150" />
          <el-table-column prop="nickName" label="姓名 / 昵称" min-width="140" />
          <el-table-column prop="phonenumber" label="手机号" width="150" />
          <el-table-column prop="email" label="邮箱" min-width="180" />
          <el-table-column label="状态" width="90"><template #default="{ row }"><el-tag :type="row.status === '0' ? 'success' : 'info'">{{ row.status === '0' ? '正常' : '停用' }}</el-tag></template></el-table-column>
          <el-table-column label="操作" width="230" fixed="right">
            <template #default="{ row }">
              <el-button v-hasPermi="['ndt:customer:account:edit']" link type="primary" @click="openAccount(row)">编辑</el-button>
              <el-button v-hasPermi="['ndt:customer:account:resetPwd']" link type="primary" @click="openPassword(row)">重置密码</el-button>
              <el-button v-hasPermi="['ndt:customer:account:remove']" link type="danger" @click="removeAccount(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="accountTotal > 0" :total="accountTotal" v-model:page="accountQuery.pageNum" v-model:limit="accountQuery.pageSize" @pagination="loadAccounts" />
      </template>
    </el-drawer>

    <el-dialog v-model="companyVisible" :title="companyForm.id ? '编辑客户公司' : '新增客户公司'" width="520px">
      <el-form ref="companyFormRef" :model="companyForm" :rules="companyRules" label-width="100px">
        <el-form-item label="公司名称" prop="name"><el-input v-model="companyForm.name" maxlength="100" /></el-form-item>
        <el-form-item label="联系人"><el-input v-model="companyForm.contactName" maxlength="50" /></el-form-item>
        <el-form-item label="联系电话"><el-input v-model="companyForm.contactPhone" maxlength="30" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="companyForm.remark" type="textarea" maxlength="500" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="companyVisible = false">取消</el-button><el-button type="primary" :loading="savingCompany" @click="saveCompany">保存</el-button></template>
    </el-dialog>

    <el-dialog v-model="accountVisible" :title="accountForm.userId ? '编辑客户账号' : '新增客户账号'" width="550px" append-to-body>
      <el-form ref="accountFormRef" :model="accountForm" :rules="accountRules" label-width="100px">
        <el-form-item label="客户公司"><el-input :model-value="accountCompany?.name" disabled /></el-form-item>
        <el-form-item label="登录账号" prop="userName"><el-input v-model="accountForm.userName" :disabled="!!accountForm.userId" maxlength="20" /></el-form-item>
        <el-form-item label="姓名 / 昵称" prop="nickName"><el-input v-model="accountForm.nickName" maxlength="30" /></el-form-item>
        <el-form-item v-if="!accountForm.userId" label="初始密码" prop="password"><el-input v-model="accountForm.password" type="password" show-password autocomplete="new-password" maxlength="20" /></el-form-item>
        <el-form-item label="手机号" prop="phonenumber"><el-input v-model="accountForm.phonenumber" maxlength="11" /></el-form-item>
        <el-form-item label="邮箱" prop="email"><el-input v-model="accountForm.email" maxlength="50" /></el-form-item>
        <el-form-item label="角色"><el-tag>客户</el-tag></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="accountForm.status"><el-radio value="0">正常</el-radio><el-radio value="1">停用</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注"><el-input v-model="accountForm.remark" type="textarea" maxlength="500" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="accountVisible = false">取消</el-button><el-button type="primary" :loading="savingAccount" @click="saveAccount">保存</el-button></template>
    </el-dialog>

    <el-dialog v-model="passwordVisible" title="重置客户账号密码" width="440px" append-to-body>
      <el-form ref="passwordFormRef" :model="passwordForm" :rules="passwordRules" label-width="100px">
        <el-form-item label="登录账号">{{ passwordAccount?.userName }}</el-form-item>
        <el-form-item label="新密码" prop="password"><el-input v-model="passwordForm.password" type="password" show-password autocomplete="new-password" maxlength="20" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="passwordVisible = false">取消</el-button><el-button type="primary" :loading="savingPassword" @click="savePassword">保存</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCustomer, addCustomer, updateCustomer, delCustomer, listCustomerAccounts, addCustomerAccount, updateCustomerAccount, delCustomerAccount, resetCustomerAccountPassword } from '@/api/ndt/customer'
import { checkPermi } from '@/utils/permission'

const rows = ref([]), total = ref(0), loading = ref(false), selectedCompany = ref(null)
const query = reactive({ pageNum: 1, pageSize: 10, name: '' })
const companyVisible = ref(false), companyFormRef = ref(), savingCompany = ref(false)
const companyForm = reactive({ id: null, name: '', contactName: '', contactPhone: '', remark: '' })
const companyRules = { name: [{ required: true, message: '请输入客户公司名称', trigger: 'blur' }] }
const accountsDrawerVisible = ref(false)
const accounts = ref([]), accountTotal = ref(0), accountLoading = ref(false)
const accountQuery = reactive({ pageNum: 1, pageSize: 10 })
const accountVisible = ref(false), accountFormRef = ref(), savingAccount = ref(false), accountCompany = ref(null)
const accountForm = reactive({ userId: null, userName: '', nickName: '', password: '', phonenumber: '', email: '', status: '0', remark: '' })
const passwordRule = [{ required: true, message: '请输入密码', trigger: 'blur' }, { min: 5, max: 20, message: '密码长度为5至20位', trigger: 'blur' }]
const accountRules = {
  userName: [{ required: true, message: '请输入登录账号', trigger: 'blur' }, { min: 2, max: 20, message: '账号长度为2至20位', trigger: 'blur' }],
  nickName: [{ required: true, message: '请输入姓名或昵称', trigger: 'blur' }],
  password: passwordRule,
  email: [{ type: 'email', message: '请输入正确的邮箱', trigger: 'blur' }],
  phonenumber: [{ pattern: /^$|^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }]
}
const passwordVisible = ref(false), passwordFormRef = ref(), passwordAccount = ref(null), passwordCompanyId = ref(null), savingPassword = ref(false)
const passwordForm = reactive({ password: '' }), passwordRules = { password: passwordRule }
let accountRequest = 0
function search() { query.pageNum = 1; loadCompanies() }
async function loadCompanies() {
  loading.value = true
  try {
    const r = await listCustomer(query); rows.value = r.rows; total.value = r.total
    if (selectedCompany.value) {
      selectedCompany.value = rows.value.find(c => c.id === selectedCompany.value.id) || null
      if (!selectedCompany.value) { accountsDrawerVisible.value = false; accounts.value = []; accountTotal.value = 0; accountRequest++ }
    }
  } finally { loading.value = false }
}
function openCompany(row) {
  Object.assign(companyForm, { id: null, name: '', contactName: '', contactPhone: '', remark: '' }, row || {})
  companyVisible.value = true
}
async function saveCompany() {
  await companyFormRef.value.validate(); savingCompany.value = true
  try { await (companyForm.id ? updateCustomer(companyForm) : addCustomer(companyForm)); companyVisible.value = false; ElMessage.success('客户公司已保存'); await loadCompanies() }
  finally { savingCompany.value = false }
}
async function removeCompany(row) {
  await ElMessageBox.confirm(`确认删除客户公司“${row.name}”吗？`, '提示')
  await delCustomer(row.id); ElMessage.success('已删除'); await loadCompanies()
}
function openAccounts(row) {
  if (!row || !checkPermi(['ndt:customer:account:list'])) return
  selectedCompany.value = row
  accounts.value = []; accountTotal.value = 0; accountQuery.pageNum = 1
  accountsDrawerVisible.value = true
  loadAccounts()
}
async function loadAccounts() {
  if (!selectedCompany.value) return
  const companyId = selectedCompany.value.id, requestId = ++accountRequest
  accountLoading.value = true
  try { const r = await listCustomerAccounts(companyId, accountQuery); if (requestId === accountRequest) { accounts.value = r.rows; accountTotal.value = r.total } }
  finally { if (requestId === accountRequest) accountLoading.value = false }
}
function openAccount(row) {
  accountCompany.value = { ...selectedCompany.value }
  Object.assign(accountForm, { userId: null, userName: '', nickName: '', password: '', phonenumber: '', email: '', status: '0', remark: '' }, row || {})
  accountVisible.value = true
}
async function saveAccount() {
  await accountFormRef.value.validate(); savingAccount.value = true
  const { userId, password, ...data } = accountForm
  try {
    await (userId ? updateCustomerAccount(accountCompany.value.id, userId, data) : addCustomerAccount(accountCompany.value.id, { ...data, password }))
    accountVisible.value = false; ElMessage.success('客户账号已保存'); await loadAccounts()
  } finally { savingAccount.value = false }
}
async function removeAccount(row) {
  const companyId = selectedCompany.value.id
  await ElMessageBox.confirm(`确认删除客户账号“${row.userName}”吗？`, '提示')
  await delCustomerAccount(companyId, row.userId); ElMessage.success('已删除'); await loadAccounts()
}
function openPassword(row) { passwordAccount.value = row; passwordCompanyId.value = selectedCompany.value.id; passwordForm.password = ''; passwordVisible.value = true }
async function savePassword() {
  await passwordFormRef.value.validate(); savingPassword.value = true
  try { await resetCustomerAccountPassword(passwordCompanyId.value, passwordAccount.value.userId, passwordForm.password); passwordVisible.value = false; ElMessage.success('密码已重置，该账号需重新登录') }
  finally { savingPassword.value = false }
}
onMounted(loadCompanies)
</script>
<style scoped>
.account-heading { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 16px; }
.account-hint { margin: 0; color: #606266; font-size: 13px; }
</style>
