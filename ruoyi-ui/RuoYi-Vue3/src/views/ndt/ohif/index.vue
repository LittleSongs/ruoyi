<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>OHIF 入口配置</template>
      <el-form :model="form" label-width="140px" style="max-width: 720px">
        <el-form-item label="OHIF 地址">
          <el-input v-model="form.viewerUrl" placeholder="例如 http://localhost:3000" />
        </el-form-item>
        <el-form-item label="说明">
          <el-input v-model="form.remark" type="textarea" :rows="4" placeholder="可填写默认跳转地址、鉴权参数等说明" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="save">保存</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup name="NdtOhif">
import { getOhifConfig } from '@/api/ndt/ohif'

const form = ref({ viewerUrl: 'http://localhost:3000', remark: '' })

function save() {
  proxy.$modal.msgSuccess('当前页面用于展示与预留配置，后续可接入后端配置接口')
}

onMounted(() => {
  getOhifConfig().then(res => {
    if (res.data) form.value = res.data
  }).catch(() => {})
})
</script>
