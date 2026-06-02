<template>
  <div class="app-container dcm-upload-page">
    <el-card shadow="never">
      <template #header>
        <span>DCM 文件上传</span>
      </template>
      <el-alert
        title="上传文件将由后端归档到 Orthanc，并同步该文件所属 Study 的全部 Series 与 Instance 索引。"
        type="info"
        :closable="false"
        show-icon
        class="mb20"
      />
      <el-upload
        ref="uploadRef"
        drag
        accept=".dcm"
        :auto-upload="false"
        :limit="1"
        :on-change="handleChange"
        :on-remove="handleRemove"
        :on-exceed="handleExceed"
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">将 DCM 文件拖到此处，或<em>点击选择</em></div>
        <template #tip>
          <div class="el-upload__tip">仅支持单个 .dcm 文件，文件大小不超过 10MB。</div>
        </template>
      </el-upload>
      <div class="actions">
        <el-button type="primary" icon="Upload" :loading="uploading" @click="submitUpload" v-hasPermi="['dcm:upload:add']">
          上传并归档
        </el-button>
        <el-button icon="Refresh" :disabled="uploading" @click="resetUpload">清空</el-button>
      </div>
    </el-card>

    <el-card v-if="result" shadow="never" class="result-card">
      <template #header>
        <span>上传结果</span>
      </template>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="对象名称">{{ result.patientName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="Study 描述">{{ result.studyDescription || '-' }}</el-descriptions-item>
        <el-descriptions-item label="StudyInstanceUID" :span="2">{{ result.studyInstanceUid }}</el-descriptions-item>
        <el-descriptions-item label="SeriesInstanceUID" :span="2">{{ result.seriesInstanceUid }}</el-descriptions-item>
        <el-descriptions-item label="SOPInstanceUID" :span="2">{{ result.sopInstanceUid }}</el-descriptions-item>
        <el-descriptions-item label="Orthanc Study ID" :span="2">{{ result.orthancStudyId }}</el-descriptions-item>
      </el-descriptions>
      <div class="actions">
        <el-button type="primary" icon="View" @click="openViewer">查看图像</el-button>
        <el-button icon="List" @click="goToStudy">前往 Study 列表</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup name="DcmUpload">
import { UploadFilled } from "@element-plus/icons-vue"
import { uploadDcm } from "@/api/dcm/upload"

const { proxy } = getCurrentInstance()
const router = useRouter()
const uploadRef = ref()
const selectedFile = ref()
const uploading = ref(false)
const result = ref()

function handleChange(file) {
  selectedFile.value = file.raw
}

function handleRemove() {
  selectedFile.value = undefined
}

function handleExceed() {
  proxy.$modal.msgWarning("第一阶段仅支持单文件上传，请先清空已选文件")
}

function submitUpload() {
  if (!selectedFile.value) {
    proxy.$modal.msgWarning("请先选择 DCM 文件")
    return
  }
  if (!/\.dcm$/i.test(selectedFile.value.name)) {
    proxy.$modal.msgWarning("请选择 .dcm 文件")
    return
  }
  if (selectedFile.value.size > 10 * 1024 * 1024) {
    proxy.$modal.msgWarning("单个文件不能超过 10MB")
    return
  }
  const formData = new FormData()
  formData.append("file", selectedFile.value)
  uploading.value = true
  uploadDcm(formData).then(response => {
    result.value = response.data
    proxy.$modal.msgSuccess("DCM 上传并归档成功")
  }).finally(() => {
    uploading.value = false
  })
}

function resetUpload() {
  uploadRef.value.clearFiles()
  selectedFile.value = undefined
  result.value = undefined
}

function openViewer() {
  window.open(result.value.ohifViewerUrl, "_blank")
}

function goToStudy() {
  router.push("/dcm/study")
}
</script>

<style scoped>
.dcm-upload-page {
  max-width: 960px;
}
.mb20 {
  margin-bottom: 20px;
}
.actions {
  margin-top: 20px;
}
.result-card {
  margin-top: 16px;
}
</style>
