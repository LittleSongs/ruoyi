<template>
  <div class="app-container report-page">
    <div class="report-toolbar">
      <div>
        <div class="page-title">报告管理</div>
        <div class="page-subtitle">以检测任务为主线，汇总图像、标注、评定、报告正文与归档资料。</div>
      </div>
      <div class="toolbar-actions">
        <el-button type="primary" icon="DocumentAdd" @click="handleMockAction('已生成报告草稿')">生成报告草稿</el-button>
        <el-button icon="Download" @click="handleMockAction('已打包当前任务归档资料')">下载归档包</el-button>
      </div>
    </div>

    <el-row :gutter="12" class="summary-row">
      <el-col v-for="item in summaryCards" :key="item.label" :xs="12" :sm="12" :md="6">
        <div class="summary-panel" :class="item.className">
          <div class="summary-label">{{ item.label }}</div>
          <div class="summary-value">{{ item.value }}</div>
          <div class="summary-note">{{ item.note }}</div>
        </div>
      </el-col>
    </el-row>

    <el-form :model="queryParams" :inline="true" class="query-form">
      <el-form-item label="关键词">
        <el-input v-model="queryParams.keyword" placeholder="任务编号 / 工件 / 客户" clearable style="width: 220px" prefix-icon="Search" />
      </el-form-item>
      <el-form-item label="报告状态">
        <el-select v-model="queryParams.reportStatus" placeholder="全部状态" clearable style="width: 150px">
          <el-option v-for="item in reportStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="归档状态">
        <el-select v-model="queryParams.archiveStatus" placeholder="全部" clearable style="width: 130px">
          <el-option label="未归档" value="OPEN" />
          <el-option label="已归档" value="ARCHIVED" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="filteredReports"
      row-key="id"
      highlight-current-row
      :current-row-key="currentReport.id"
      @row-click="selectReport"
    >
      <el-table-column label="任务编号" prop="taskNo" min-width="150" :show-overflow-tooltip="true" />
      <el-table-column label="任务名称" prop="taskName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="工件名称" prop="workpieceName" min-width="130" :show-overflow-tooltip="true" />
      <el-table-column label="客户部门" prop="customerDeptName" min-width="130" :show-overflow-tooltip="true" />
      <el-table-column label="图像资料" min-width="190">
        <template #default="scope">
          <div class="asset-counts">
            <el-tag size="small" type="info">DICOM {{ scope.row.assetStats.dicom }}</el-tag>
            <el-tag size="small" type="success">处理 {{ scope.row.assetStats.processed }}</el-tag>
            <el-tag size="small" type="warning">标注 {{ scope.row.assetStats.annotated }}</el-tag>
            <el-tag size="small">截图 {{ scope.row.assetStats.screenshot }}</el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="评定状态" prop="evaluationStatus" align="center" width="110">
        <template #default="scope">
          <el-tag :type="scope.row.evaluationStatus === '已完成' ? 'success' : 'warning'">{{ scope.row.evaluationStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="报告状态" prop="reportStatus" align="center" width="120">
        <template #default="scope">
          <el-tag :type="statusTypeMap[scope.row.reportStatus]">{{ scope.row.reportStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="版本" prop="version" align="center" width="80" />
      <el-table-column label="更新日期" prop="updateTime" align="center" width="120" />
      <el-table-column label="操作" fixed="right" width="260" align="center">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click.stop="selectReport(scope.row)">查看</el-button>
          <el-button link type="primary" icon="EditPen" @click.stop="handleMockAction('已进入报告编辑示例')">编辑</el-button>
          <el-button link type="primary" icon="FolderChecked" @click.stop="handleMockAction('已提交归档示例')">归档</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="workspace">
      <div class="workspace-header">
        <div>
          <div class="section-title">{{ currentReport.reportTitle }}</div>
          <div class="section-meta">
            {{ currentReport.taskNo }} / {{ currentReport.workpieceName }} / StudyUID: {{ currentReport.studyInstanceUid }}
          </div>
        </div>
        <el-steps :active="currentReport.step" finish-status="success" simple class="report-steps">
          <el-step title="采集" />
          <el-step title="评定" />
          <el-step title="生成" />
          <el-step title="审核" />
          <el-step title="归档" />
        </el-steps>
      </div>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="任务概览" name="overview">
          <el-descriptions :column="3" border>
            <el-descriptions-item label="报告编号">{{ currentReport.reportNo }}</el-descriptions-item>
            <el-descriptions-item label="报告版本">{{ currentReport.version }}</el-descriptions-item>
            <el-descriptions-item label="报告状态">{{ currentReport.reportStatus }}</el-descriptions-item>
            <el-descriptions-item label="检测方法">{{ currentReport.method }}</el-descriptions-item>
            <el-descriptions-item label="检测标准">{{ currentReport.standard }}</el-descriptions-item>
            <el-descriptions-item label="验收等级">{{ currentReport.acceptanceLevel }}</el-descriptions-item>
            <el-descriptions-item label="报告人">{{ currentReport.reporter }}</el-descriptions-item>
            <el-descriptions-item label="审核人">{{ currentReport.reviewer }}</el-descriptions-item>
            <el-descriptions-item label="签发日期">{{ currentReport.issueDate || "未签发" }}</el-descriptions-item>
          </el-descriptions>

          <el-row :gutter="12" class="mt12">
            <!-- <el-col :xs="24" :md="8">
              <div class="info-panel">
                <div class="panel-title">报告组成</div>
                <el-timeline>
                  <el-timeline-item v-for="item in currentReport.reportSections" :key="item" type="primary">
                    {{ item }}
                  </el-timeline-item>
                </el-timeline>
              </div>
            </el-col> -->
            <el-col :xs="24" :md="16">
              <div class="info-panel">
                <div class="panel-title">交付物清单</div>
                <el-table :data="currentReport.deliverables" size="small">
                  <el-table-column label="交付物" prop="name" min-width="160" />
                  <el-table-column label="格式" prop="format" width="120" />
                  <el-table-column label="来源" prop="source" min-width="160" />
                  <el-table-column label="状态" prop="status" width="100" align="center">
                    <template #default="scope">
                      <el-tag size="small" :type="scope.row.status === '已完成' ? 'success' : 'warning'">{{ scope.row.status }}</el-tag>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="图像资料" name="images">
          <div class="image-toolbar">
            <el-radio-group v-model="imageFilter" size="small">
              <el-radio-button label="ALL">全部</el-radio-button>
              <el-radio-button label="PROCESSED">处理后图像</el-radio-button>
              <el-radio-button label="ANNOTATED">标注图像</el-radio-button>
              <el-radio-button label="SCREENSHOT">截图 / 局部图</el-radio-button>
            </el-radio-group>
            <el-button type="primary" plain icon="Upload" @click="handleMockAction('已打开上传图像示例')">上传图像</el-button>
          </div>
          <div class="image-grid">
            <div v-for="image in filteredImages" :key="image.id" class="image-card">
              <div class="mock-image" :class="image.type">
                <div class="scan-lines"></div>
                <div class="defect-marker" :style="{ left: image.markerLeft, top: image.markerTop }"></div>
                <span>{{ image.shortName }}</span>
              </div>
              <div class="image-info">
                <div class="image-title">{{ image.title }}</div>
                <div class="image-desc">{{ image.desc }}</div>
                <div class="image-actions">
                  <el-tag size="small" :type="image.includeInReport ? 'success' : 'info'">
                    {{ image.includeInReport ? "进入报告" : "仅归档" }}
                  </el-tag>
                  <el-button link type="primary" icon="ZoomIn" @click="handleMockAction('已打开图像预览示例')">预览</el-button>
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>

        <el-tab-pane label="评定结果" name="evaluation">
          <el-table :data="currentReport.evaluations">
            <el-table-column label="序号" type="index" width="60" align="center" />
            <el-table-column label="SOPInstanceUID" prop="sopInstanceUid" min-width="230" :show-overflow-tooltip="true" />
            <el-table-column label="缺陷类型" prop="defectType" width="120" />
            <el-table-column label="缺陷等级" prop="defectLevel" width="110" align="center" />
            <el-table-column label="尺寸 / 位置" prop="position" min-width="140" />
            <el-table-column label="评定结论" prop="conclusion" min-width="220" :show-overflow-tooltip="true" />
            <el-table-column label="评定人员" prop="evaluator" width="100" />
            <el-table-column label="评定时间" prop="evaluateTime" width="160" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="报告正文" name="content">
          <el-row :gutter="12">
            <el-col :xs="24" :md="12">
              <div class="content-block">
                <div class="panel-title">检测依据</div>
                <p>{{ currentReport.content.basis }}</p>
              </div>
              <div class="content-block">
                <div class="panel-title">图像处理说明</div>
                <p>{{ currentReport.content.processing }}</p>
              </div>
            </el-col>
            <el-col :xs="24" :md="12">
              <div class="content-block">
                <div class="panel-title">评定要求</div>
                <p>{{ currentReport.content.requirement }}</p>
              </div>
              <div class="content-block conclusion-block">
                <div class="panel-title">报告结论</div>
                <p>{{ currentReport.content.conclusion }}</p>
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="附件归档" name="archive">
          <el-row :gutter="12">
            <el-col :xs="24" :md="16">
              <el-table :data="currentReport.attachments">
                <el-table-column label="资料名称" prop="name" min-width="180" />
                <el-table-column label="类型" prop="type" width="120" />
                <el-table-column label="版本" prop="version" width="90" align="center" />
                <el-table-column label="上传人" prop="uploader" width="100" />
                <el-table-column label="上传日期" prop="uploadTime" width="120" />
                <el-table-column label="状态" prop="status" width="100" align="center">
                  <template #default="scope">
                    <el-tag size="small" :type="scope.row.status === '已归档' ? 'success' : 'info'">{{ scope.row.status }}</el-tag>
                  </template>
                </el-table-column>
              </el-table>
            </el-col>
            <el-col :xs="24" :md="8">
              <div class="archive-panel">
                <div class="panel-title">归档包结构</div>
                <el-tree :data="archiveTree" :props="{ label: 'label', children: 'children' }" default-expand-all />
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>

        <el-tab-pane label="版本记录" name="versions">
          <el-timeline>
            <el-timeline-item
              v-for="item in currentReport.versions"
              :key="item.version"
              :timestamp="item.time"
              :type="item.type"
            >
              <div class="version-title">{{ item.version }} {{ item.action }}</div>
              <div class="version-desc">{{ item.desc }}</div>
            </el-timeline-item>
          </el-timeline>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup name="NdtReport">
const { proxy } = getCurrentInstance()

const reportStatusOptions = [
  { label: "草稿", value: "草稿" },
  { label: "待审核", value: "待审核" },
  { label: "已签发", value: "已签发" },
  { label: "已归档", value: "已归档" }
]

const statusTypeMap = {
  草稿: "info",
  待审核: "warning",
  已签发: "success",
  已归档: "primary"
}

const reports = ref([
  {
    id: 1,
    taskNo: "NDT-2026-0604-001",
    taskName: "压力管道焊缝 DR 检测",
    workpieceName: "DN300 环焊缝 A12",
    customerDeptName: "制造一部",
    studyInstanceUid: "1.2.826.0.1.3680043.10.543.20260604001",
    reportNo: "RPT-2026-DR-001",
    reportTitle: "压力管道焊缝数字射线检测报告",
    reportStatus: "待审核",
    archiveStatus: "OPEN",
    evaluationStatus: "已完成",
    version: "V2",
    updateTime: "2026-06-04",
    step: 3,
    method: "DR 数字射线检测",
    standard: "NB/T 47013.2-2015",
    acceptanceLevel: "II 级",
    reporter: "张工",
    reviewer: "李工",
    issueDate: "",
    assetStats: { dicom: 48, processed: 12, annotated: 6, screenshot: 8 },
    reportSections: ["任务信息", "检测依据", "图像处理说明", "缺陷评定表", "关键图像", "检测结论", "签发信息"],
    deliverables: [
      { name: "检测报告正文", format: "PDF / Word", source: "报告模板 + 评定结果", status: "已完成" },
      { name: "关键图像清单", format: "PNG", source: "处理后图像 / 标注图", status: "已完成" },
      { name: "任务归档包", format: "ZIP", source: "报告、图纸、标准、原始数据", status: "待归档" }
    ],
    images: [
      { id: 1, type: "PROCESSED", shortName: "DR-12", title: "增强处理图像 12", desc: "窗宽窗位调整，噪声抑制后用于报告展示。", markerLeft: "58%", markerTop: "44%", includeInReport: true },
      { id: 2, type: "ANNOTATED", shortName: "ANN-12", title: "焊缝 A12 标注图", desc: "包含条状缺陷框、长度测量线与缺陷编号。", markerLeft: "44%", markerTop: "38%", includeInReport: true },
      { id: 3, type: "SCREENSHOT", shortName: "LOC-03", title: "局部放大截图", desc: "缺陷区域 2.5 倍局部图，用于正文图 3。", markerLeft: "62%", markerTop: "52%", includeInReport: true },
      { id: 4, type: "PROCESSED", shortName: "DR-24", title: "对比度增强图像 24", desc: "保留为复核资料，不进入正式报告。", markerLeft: "35%", markerTop: "50%", includeInReport: false }
    ],
    evaluations: [
      { sopInstanceUid: "1.2.826.0.1.3680043.10.543.12", defectType: "未熔合", defectLevel: "II", position: "A12 / 45mm", conclusion: "缺陷长度 6.4mm，按 II 级验收可接受。", evaluator: "王工", evaluateTime: "2026-06-04 10:22" },
      { sopInstanceUid: "1.2.826.0.1.3680043.10.543.18", defectType: "气孔", defectLevel: "I", position: "A12 / 108mm", conclusion: "单点气孔，尺寸低于记录阈值，建议归档备查。", evaluator: "王工", evaluateTime: "2026-06-04 10:35" }
    ],
    content: {
      basis: "依据委托任务、工艺卡及 NB/T 47013.2-2015 要求，对指定焊缝进行数字射线检测。",
      processing: "报告图像保留原始 DICOM 关联，同时保存增强处理图、带标注图和局部截图，所有图片纳入任务归档包。",
      requirement: "缺陷等级按委托方验收要求执行，关键缺陷需保留评定记录、标注数据和截图证据。",
      conclusion: "本次检测范围内发现少量可记录缺陷，综合评定满足 II 级验收要求，建议按当前版本提交审核。"
    },
    attachments: [
      { name: "委托检测单", type: "委托资料", version: "V1", uploader: "赵工", uploadTime: "2026-06-03", status: "已归档" },
      { name: "焊缝布片图", type: "图纸", version: "V2", uploader: "张工", uploadTime: "2026-06-04", status: "待归档" },
      { name: "检测标准摘录", type: "检测标准", version: "V1", uploader: "系统", uploadTime: "2026-06-04", status: "已归档" }
    ],
    versions: [
      { version: "V2", action: "提交审核", time: "2026-06-04 11:20", desc: "补充局部截图和缺陷评定表，等待审核。", type: "warning" },
      { version: "V1", action: "生成草稿", time: "2026-06-04 10:50", desc: "从任务信息、评定结果和图像清单生成报告草稿。", type: "primary" }
    ]
  },
  {
    id: 2,
    taskNo: "NDT-2026-0603-014",
    taskName: "压力容器封头 RT 复核",
    workpieceName: "封头 B 区",
    customerDeptName: "质检中心",
    studyInstanceUid: "1.2.826.0.1.3680043.10.543.20260603014",
    reportNo: "RPT-2026-RT-014",
    reportTitle: "压力容器封头射线复核报告",
    reportStatus: "已签发",
    archiveStatus: "OPEN",
    evaluationStatus: "已完成",
    version: "V1",
    updateTime: "2026-06-03",
    step: 4,
    method: "RT 射线检测",
    standard: "GB/T 3323.1-2019",
    acceptanceLevel: "III 级",
    reporter: "陈工",
    reviewer: "李工",
    issueDate: "2026-06-03",
    assetStats: { dicom: 32, processed: 8, annotated: 3, screenshot: 4 },
    reportSections: ["任务信息", "检测参数", "复核图像", "评定结论", "签发信息"],
    deliverables: [
      { name: "复核报告", format: "PDF", source: "报告模板", status: "已完成" },
      { name: "复核截图", format: "PNG", source: "OHIF 截图", status: "已完成" },
      { name: "归档包", format: "ZIP", source: "签发报告 + 附件", status: "待归档" }
    ],
    images: [
      { id: 5, type: "PROCESSED", shortName: "RT-07", title: "灰度均衡图像", desc: "用于封头边缘区域观察。", markerLeft: "48%", markerTop: "46%", includeInReport: true },
      { id: 6, type: "ANNOTATED", shortName: "ANN-07", title: "复核标注图", desc: "标记疑似夹渣位置。", markerLeft: "54%", markerTop: "42%", includeInReport: true },
      { id: 7, type: "SCREENSHOT", shortName: "CAP-02", title: "审核截图", desc: "审核确认时的局部截图。", markerLeft: "40%", markerTop: "57%", includeInReport: false }
    ],
    evaluations: [
      { sopInstanceUid: "1.2.826.0.1.3680043.10.543.07", defectType: "夹渣", defectLevel: "II", position: "B 区 / 72mm", conclusion: "复核后判定为可接受显示。", evaluator: "陈工", evaluateTime: "2026-06-03 16:10" }
    ],
    content: {
      basis: "依据复核委托单及 GB/T 3323.1-2019 标准执行。",
      processing: "对封头边缘区域进行灰度均衡和局部放大，保留原始图像关联。",
      requirement: "复核意见需与原评定记录同时归档。",
      conclusion: "复核结果满足 III 级验收要求，报告已签发，待完成资料归档。"
    },
    attachments: [
      { name: "原始评定报告", type: "历史报告", version: "V1", uploader: "系统", uploadTime: "2026-06-03", status: "已归档" },
      { name: "复核委托单", type: "委托资料", version: "V1", uploader: "陈工", uploadTime: "2026-06-03", status: "已归档" }
    ],
    versions: [
      { version: "V1", action: "签发报告", time: "2026-06-03 17:10", desc: "审核通过并完成报告签发。", type: "success" }
    ]
  },
  {
    id: 3,
    taskNo: "NDT-2026-0602-008",
    taskName: "管板焊缝数字底片评定",
    workpieceName: "管板 C5",
    customerDeptName: "研发试制部",
    studyInstanceUid: "1.2.826.0.1.3680043.10.543.20260602008",
    reportNo: "RPT-2026-DR-008",
    reportTitle: "管板焊缝数字底片评定报告",
    reportStatus: "已归档",
    archiveStatus: "ARCHIVED",
    evaluationStatus: "已完成",
    version: "V3",
    updateTime: "2026-06-02",
    step: 5,
    method: "DR 数字底片评定",
    standard: "企业检测规程 Q/NDT-DR-2026",
    acceptanceLevel: "试验件评定",
    reporter: "张工",
    reviewer: "刘工",
    issueDate: "2026-06-02",
    assetStats: { dicom: 64, processed: 16, annotated: 9, screenshot: 12 },
    reportSections: ["任务信息", "试验要求", "图像证据", "评定记录", "结论", "归档索引"],
    deliverables: [
      { name: "正式报告", format: "PDF", source: "已签发版本", status: "已完成" },
      { name: "结构化数据", format: "JSON", source: "报告正文", status: "已完成" },
      { name: "任务归档包", format: "ZIP", source: "全量资料", status: "已完成" }
    ],
    images: [
      { id: 8, type: "PROCESSED", shortName: "DR-31", title: "试验件处理图", desc: "用于算法对照评定。", markerLeft: "46%", markerTop: "40%", includeInReport: true },
      { id: 9, type: "ANNOTATED", shortName: "ANN-31", title: "缺陷标注总图", desc: "标注 3 处线性显示。", markerLeft: "60%", markerTop: "50%", includeInReport: true },
      { id: 10, type: "SCREENSHOT", shortName: "SR-01", title: "SR 预留截图", desc: "后续生成结构化报告 SR 时作为引用图。", markerLeft: "52%", markerTop: "54%", includeInReport: true }
    ],
    evaluations: [
      { sopInstanceUid: "1.2.826.0.1.3680043.10.543.31", defectType: "线性显示", defectLevel: "记录", position: "C5 / 32mm", conclusion: "试验件记录项，已纳入归档。", evaluator: "刘工", evaluateTime: "2026-06-02 14:26" }
    ],
    content: {
      basis: "依据研发试制任务书和企业数字底片评定规程执行。",
      processing: "保存原始、处理、标注、截图四类图像，形成可追溯资料包。",
      requirement: "试验件评定以过程记录和后续算法验证为主。",
      conclusion: "资料已完成签发和归档，可作为后续 SR 结构化报告生成样例。"
    },
    attachments: [
      { name: "试验任务书", type: "评定要求", version: "V1", uploader: "研发部", uploadTime: "2026-06-02", status: "已归档" },
      { name: "正式报告 PDF", type: "报告", version: "V3", uploader: "系统", uploadTime: "2026-06-02", status: "已归档" },
      { name: "图像索引清单", type: "清单", version: "V3", uploader: "系统", uploadTime: "2026-06-02", status: "已归档" }
    ],
    versions: [
      { version: "V3", action: "归档完成", time: "2026-06-02 18:30", desc: "报告、图纸、评定要求、检测标准和图像资料完成归档。", type: "success" },
      { version: "V2", action: "签发报告", time: "2026-06-02 17:45", desc: "审核通过并签发。", type: "primary" },
      { version: "V1", action: "生成草稿", time: "2026-06-02 16:20", desc: "生成报告初稿。", type: "info" }
    ]
  }
])

const queryParams = reactive({
  keyword: "",
  reportStatus: undefined,
  archiveStatus: undefined
})

const activeTab = ref("overview")
const imageFilter = ref("ALL")
const currentReport = ref(reports.value[0])

const filteredReports = computed(() => {
  const keyword = queryParams.keyword.trim().toLowerCase()
  return reports.value.filter((item) => {
    const matchedKeyword = !keyword || [item.taskNo, item.taskName, item.workpieceName, item.customerDeptName]
      .some((value) => String(value).toLowerCase().includes(keyword))
    const matchedStatus = !queryParams.reportStatus || item.reportStatus === queryParams.reportStatus
    const matchedArchive = !queryParams.archiveStatus || item.archiveStatus === queryParams.archiveStatus
    return matchedKeyword && matchedStatus && matchedArchive
  })
})

const summaryCards = computed(() => [
  { label: "报告任务", value: reports.value.length, note: "按检测任务生成", className: "summary-task" },
  { label: "待审核", value: reports.value.filter((item) => item.reportStatus === "待审核").length, note: "需要审核签发", className: "summary-review" },
  { label: "已签发", value: reports.value.filter((item) => item.reportStatus === "已签发").length, note: "可交付客户", className: "summary-issued" },
  { label: "已归档", value: reports.value.filter((item) => item.archiveStatus === "ARCHIVED").length, note: "资料包已闭环", className: "summary-archive" }
])

const filteredImages = computed(() => {
  if (imageFilter.value === "ALL") return currentReport.value.images
  return currentReport.value.images.filter((item) => item.type === imageFilter.value)
})

const archiveTree = computed(() => [
  {
    label: currentReport.value.taskNo,
    children: [
      { label: "01_报告文件", children: [{ label: `${currentReport.value.reportNo}_${currentReport.value.version}.pdf` }] },
      { label: "02_图像资料", children: [{ label: "原始DICOM" }, { label: "处理后图像" }, { label: "标注图像" }, { label: "截图与局部图" }] },
      { label: "03_评定记录", children: [{ label: "缺陷评定表.xlsx" }, { label: "标注数据.json" }] },
      { label: "04_支撑资料", children: [{ label: "图纸" }, { label: "评定要求" }, { label: "检测标准" }] }
    ]
  }
])

function selectReport(row) {
  currentReport.value = row
  activeTab.value = "overview"
  imageFilter.value = "ALL"
}

function resetQuery() {
  queryParams.keyword = ""
  queryParams.reportStatus = undefined
  queryParams.archiveStatus = undefined
}

function handleMockAction(message) {
  proxy.$modal.msgSuccess(message)
}
</script>

<style scoped>
.report-page {
  color: #1f2937;
}

.report-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 12px;
}

.page-title {
  font-size: 22px;
  font-weight: 650;
  line-height: 30px;
}

.page-subtitle {
  margin-top: 4px;
  color: #667085;
  font-size: 13px;
}

.toolbar-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.summary-row {
  margin-bottom: 12px;
}

.summary-panel {
  min-height: 104px;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #ffffff;
  border-top: 3px solid #64748b;
}

.summary-task {
  border-top-color: #2563eb;
}

.summary-review {
  border-top-color: #d97706;
}

.summary-issued {
  border-top-color: #16a34a;
}

.summary-archive {
  border-top-color: #0891b2;
}

.summary-label {
  color: #667085;
  font-size: 13px;
}

.summary-value {
  margin-top: 8px;
  font-size: 28px;
  font-weight: 700;
}

.summary-note {
  margin-top: 6px;
  color: #667085;
  font-size: 12px;
}

.query-form {
  padding: 12px 12px 0;
  margin-bottom: 12px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #ffffff;
}

.asset-counts {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.workspace {
  margin-top: 12px;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #ffffff;
}

.workspace-header {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(420px, 560px);
  gap: 16px;
  align-items: center;
  margin-bottom: 12px;
}

.section-title {
  font-size: 18px;
  font-weight: 650;
}

.section-meta {
  margin-top: 4px;
  color: #667085;
  font-size: 12px;
  word-break: break-all;
}

.report-steps {
  min-width: 0;
}

.mt12 {
  margin-top: 12px;
}

.info-panel,
.archive-panel,
.content-block {
  padding: 14px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fafafa;
}

.panel-title {
  margin-bottom: 10px;
  color: #111827;
  font-size: 14px;
  font-weight: 650;
}

.image-toolbar {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 12px;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 12px;
}

.image-card {
  overflow: hidden;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #ffffff;
}

.mock-image {
  position: relative;
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  color: #f8fafc;
  font-weight: 700;
  letter-spacing: 0;
  background:
    linear-gradient(135deg, rgba(15, 23, 42, 0.94), rgba(51, 65, 85, 0.9)),
    repeating-linear-gradient(90deg, transparent 0 18px, rgba(255, 255, 255, 0.06) 18px 20px);
}

.mock-image.PROCESSED {
  background:
    radial-gradient(circle at 48% 45%, rgba(226, 232, 240, 0.35), transparent 34%),
    linear-gradient(135deg, #111827, #475569);
}

.mock-image.ANNOTATED {
  background:
    radial-gradient(circle at 55% 44%, rgba(248, 113, 113, 0.24), transparent 32%),
    linear-gradient(135deg, #172554, #334155);
}

.mock-image.SCREENSHOT {
  background:
    radial-gradient(circle at 45% 50%, rgba(20, 184, 166, 0.25), transparent 35%),
    linear-gradient(135deg, #0f172a, #365314);
}

.scan-lines {
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(0deg, transparent 0 12px, rgba(255, 255, 255, 0.04) 12px 13px);
}

.defect-marker {
  position: absolute;
  width: 46px;
  height: 28px;
  border: 2px solid #f59e0b;
  border-radius: 50%;
  transform: translate(-50%, -50%) rotate(-12deg);
}

.image-info {
  padding: 12px;
}

.image-title {
  font-weight: 650;
}

.image-desc {
  min-height: 38px;
  margin-top: 6px;
  color: #667085;
  font-size: 12px;
  line-height: 19px;
}

.image-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-top: 10px;
}

.content-block {
  min-height: 132px;
  margin-bottom: 12px;
  line-height: 24px;
}

.content-block p {
  margin: 0;
  color: #344054;
}

.conclusion-block {
  border-left: 4px solid #16a34a;
  background: #f7fef9;
}

.version-title {
  font-weight: 650;
}

.version-desc {
  margin-top: 4px;
  color: #667085;
}

@media (max-width: 1100px) {
  .workspace-header {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .report-toolbar {
    align-items: stretch;
    flex-direction: column;
  }

  .toolbar-actions {
    justify-content: flex-start;
  }

  .workspace {
    padding: 12px;
  }
}
</style>
