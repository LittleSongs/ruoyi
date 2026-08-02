<template>
  <div class="app-container">
    <el-form :inline="true" :model="query">
      <el-form-item label="客户名称"><el-input v-model="query.name" clearable @keyup.enter="load" /></el-form-item>
      <el-form-item><el-button type="primary" @click="load">查询</el-button><el-button @click="open()">新增客户</el-button></el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows">
      <el-table-column prop="name" label="客户名称" min-width="180" />
      <el-table-column prop="contactName" label="联系人" width="140" />
      <el-table-column prop="contactPhone" label="联系电话" width="160" />
      <el-table-column prop="remark" label="备注" min-width="200" show-overflow-tooltip />
      <el-table-column label="操作" width="160">
        <template #default="{ row }"><el-button link type="primary" @click="open(row)">编辑</el-button><el-button link type="danger" @click="remove(row)">删除</el-button></template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load" />
    <el-dialog v-model="visible" :title="form.id?'编辑客户':'新增客户'" width="520px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="客户名称" prop="name"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="联系人"><el-input v-model="form.contactName" /></el-form-item>
        <el-form-item label="联系电话"><el-input v-model="form.contactPhone" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="visible=false">取消</el-button><el-button type="primary" @click="save">保存</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCustomer, addCustomer, updateCustomer, delCustomer } from '@/api/ndt/customer'

const rows=ref([]),total=ref(0),loading=ref(false),visible=ref(false),formRef=ref()
const query=reactive({pageNum:1,pageSize:10,name:''})
const form=reactive({id:null,name:'',contactName:'',contactPhone:'',remark:''})
const rules={name:[{required:true,message:'请输入客户名称',trigger:'blur'}]}
function reset(){Object.assign(form,{id:null,name:'',contactName:'',contactPhone:'',remark:''})}
async function load(){loading.value=true;try{const r=await listCustomer(query);rows.value=r.rows;total.value=r.total}finally{loading.value=false}}
function open(row){reset();if(row)Object.assign(form,row);visible.value=true}
async function save(){await formRef.value.validate();await (form.id?updateCustomer(form):addCustomer(form));ElMessage.success('保存成功');visible.value=false;load()}
async function remove(row){await ElMessageBox.confirm(`确认删除客户“${row.name}”吗？`,'提示',{type:'warning'});await delCustomer(row.id);ElMessage.success('删除成功');load()}
onMounted(load)
</script>
