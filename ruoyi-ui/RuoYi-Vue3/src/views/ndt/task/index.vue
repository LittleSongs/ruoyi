<template>
  <div class="app-container">
    <el-form :inline="true" :model="query">
      <el-form-item label="任务编号"><el-input v-model="query.taskNo" clearable /></el-form-item>
      <el-form-item label="任务名称"><el-input v-model="query.taskName" clearable /></el-form-item>
      <el-form-item label="客户公司"><el-select v-model="query.customerId" clearable filterable style="width:200px"><el-option v-for="c in customers" :key="c.id" :label="c.name" :value="c.id"/></el-select></el-form-item>
      <el-form-item><el-button type="primary" @click="load">查询</el-button><el-button @click="openTask()">新增任务</el-button></el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows">
      <el-table-column prop="taskNo" label="任务编号" width="170" />
      <el-table-column prop="taskName" label="任务名称" min-width="180" />
      <el-table-column prop="customerName" label="客户公司" min-width="150" />
      <el-table-column label="状态" width="120"><template #default="{row}">{{ taskStatusLabel(row.status) }}</template></el-table-column>
      <el-table-column prop="startTime" label="开始时间" width="165" />
      <el-table-column label="操作" width="340">
        <template #default="{row}">
          <el-button link type="primary" @click="openHierarchy(row)">工件/部位</el-button>
          <el-button link type="primary" @click="openAssign(row)">成员</el-button>
          <el-button link type="primary" @click="openTask(row)">编辑</el-button>
          <el-button link type="danger" @click="removeTask(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load"/>

    <el-dialog v-model="taskVisible" :title="taskForm.id?'编辑任务':'新增任务'" width="620px">
      <el-form ref="taskRef" :model="taskForm" :rules="taskRules" label-width="90px">
        <el-form-item label="任务编号"><el-input v-model="taskForm.taskNo" placeholder="留空自动生成" :disabled="!!taskForm.id"/></el-form-item>
        <el-form-item label="任务名称" prop="taskName"><el-input v-model="taskForm.taskName"/></el-form-item>
        <el-form-item label="客户公司" prop="customerId"><el-select v-model="taskForm.customerId" filterable style="width:100%"><el-option v-for="c in customers" :key="c.id" :label="c.name" :value="c.id"/></el-select></el-form-item>
        <el-form-item label="状态"><el-select v-model="taskForm.status"><el-option v-for="s in taskStatuses" :key="s.value" :label="s.label" :value="s.value"/></el-select></el-form-item>
        <el-form-item label="起止时间"><el-date-picker v-model="taskRange" type="datetimerange" value-format="YYYY-MM-DD HH:mm:ss" style="width:100%"/></el-form-item>
        <el-form-item label="任务说明"><el-input v-model="taskForm.description" type="textarea" :rows="3"/></el-form-item>
      </el-form>
      <template #footer><el-button @click="taskVisible=false">取消</el-button><el-button type="primary" @click="saveTask">保存</el-button></template>
    </el-dialog>

    <el-drawer v-model="hierarchyVisible" title="工件与检测部位" size="82%" class="hierarchy-drawer">
      <div class="task-context">
        <div>
          <div class="task-context__eyebrow">当前检测任务</div>
          <h2>{{ currentTask.taskName || '未命名任务' }}</h2>
          <div class="task-context__meta">
            <span>任务编号：{{ currentTask.taskNo || '-' }}</span>
            <span>客户：{{ currentTask.customerName || '-' }}</span>
            <span v-if="currentTask.startTime">开始时间：{{ currentTask.startTime }}</span>
          </div>
        </div>
        <el-tag :type="taskStatusType(currentTask.status)" effect="light" size="large">
          {{ taskStatusLabel(currentTask.status) }}
        </el-tag>
      </div>

      <div class="hierarchy-layout" v-loading="hierarchyLoading">
        <aside class="workpiece-panel">
          <div class="panel-heading">
            <div>
              <h3>工件列表</h3>
              <span>共 {{ workpieces.length }} 个工件</span>
            </div>
            <el-button type="primary" @click="openWorkpiece()">新增工件</el-button>
          </div>

          <div v-if="workpieces.length" class="workpiece-list">
            <div
              v-for="item in workpieces"
              :key="item.id"
              class="workpiece-card"
              :class="{'is-active': selectedWorkpiece.id === item.id}"
              role="button"
              tabindex="0"
              @click="selectWorkpiece(item)"
              @keydown.enter="selectWorkpiece(item)"
            >
              <div class="workpiece-card__top">
                <strong>{{ item.workpieceName }}</strong>
                <el-tag :type="workpieceStatusType(item.status)" effect="light" size="small">
                  {{ workpieceStatusLabel(item.status) }}
                </el-tag>
              </div>
              <div class="workpiece-card__bottom">
                <span>排序 {{ item.sortNo ?? 0 }}</span>
                <div class="workpiece-card__actions">
                  <el-button link type="primary" @click.stop="openWorkpiece(item)">编辑</el-button>
                  <el-button link type="danger" @click.stop="removeWorkpiece(item)">删除</el-button>
                </div>
              </div>
            </div>
          </div>

          <el-empty v-else description="暂无工件" :image-size="80">
            <el-button type="primary" @click="openWorkpiece()">新增第一个工件</el-button>
          </el-empty>
        </aside>

        <section class="position-panel">
          <template v-if="selectedWorkpiece.id">
            <div class="position-heading">
              <div>
                <div class="position-heading__title">
                  <h3>{{ selectedWorkpiece.workpieceName }}</h3>
                  <el-tag :type="workpieceStatusType(selectedWorkpiece.status)" effect="light">
                    {{ workpieceStatusLabel(selectedWorkpiece.status) }}
                  </el-tag>
                </div>
                <span>检测部位 · 共 {{ positions.length }} 项</span>
              </div>
              <div>
                <el-button type="primary" @click="openPosition()">新增部位</el-button>
              </div>
            </div>

            <section class="study-section">
              <div class="subsection-heading">
                <div>
                  <h4>检测 Study</h4>
                  <span>一次工件检测对应一个 Study；OHIF 按 Study 打开</span>
                </div>
                <el-tag type="primary" effect="plain">共 {{ studies.length }} 个</el-tag>
              </div>
              <el-table v-loading="positionLoading" :data="studies" max-height="260" stripe>
                <el-table-column prop="inspectionMethodCode" label="检测方法" width="100" />
                <el-table-column prop="studyDescription" label="Study 描述" min-width="150" show-overflow-tooltip />
                <el-table-column prop="studyInstanceUid" label="Study Instance UID" min-width="280" show-overflow-tooltip />
                <el-table-column prop="seriesCount" label="Series" width="80" align="center" />
                <el-table-column prop="objectCount" label="对象" width="80" align="center" />
                <el-table-column label="操作" width="90" fixed="right">
                  <template #default="{row}">
                    <el-button link type="success" @click="launchStudy(row)">OHIF</el-button>
                  </template>
                </el-table-column>
                <template #empty><el-empty description="该工件尚未上传 DICOM Study" :image-size="70" /></template>
              </el-table>
            </section>

            <div class="subsection-heading position-subsection-heading">
              <div>
                <h4>稳定检测部位</h4>
                <span>部位属于工件主数据，Series 可关联其中一个部位</span>
              </div>
              <el-tag effect="plain">共 {{ positions.length }} 项</el-tag>
            </div>

            <el-table v-loading="positionLoading" :data="positions" max-height="360" stripe>
              <el-table-column prop="positionCode" label="部位编码" width="160"/>
              <el-table-column prop="positionName" label="部位名称" min-width="200"/>
              <el-table-column prop="sortNo" label="排序" width="90" align="center"/>
              <el-table-column label="操作" width="140" fixed="right">
                <template #default="{row}">
                  <el-button link type="primary" @click="openPosition(row)">编辑</el-button>
                  <el-button link type="danger" @click="removePosition(row)">删除</el-button>
                </template>
              </el-table-column>
              <template #empty>
                <el-empty description="该工件尚未配置检测部位" :image-size="90">
                  <el-button type="primary" @click="openPosition()">新增检测部位</el-button>
                </el-empty>
              </template>
            </el-table>
          </template>

          <div v-else class="position-placeholder">
            <el-empty description="请先从左侧选择一个工件">
              <template #description>
                <p>选择工件后，可在这里查看和管理其检测部位</p>
              </template>
            </el-empty>
          </div>
        </section>
      </div>
    </el-drawer>

    <el-dialog v-model="workpieceVisible" :title="workpieceForm.id?'编辑工件':'新增工件'" width="480px">
      <el-form :model="workpieceForm" label-width="85px"><el-form-item label="工件名称"><el-input v-model="workpieceForm.workpieceName"/></el-form-item><el-form-item label="状态"><el-select v-model="workpieceForm.status"><el-option v-for="s in workpieceStatuses" :key="s.value" :label="s.label" :value="s.value"/></el-select></el-form-item><el-form-item label="排序"><el-input-number v-model="workpieceForm.sortNo" :min="0"/></el-form-item><el-form-item label="备注"><el-input v-model="workpieceForm.remark"/></el-form-item></el-form>
      <template #footer><el-button @click="workpieceVisible=false">取消</el-button><el-button type="primary" @click="saveWorkpiece">保存</el-button></template>
    </el-dialog>
    <el-dialog v-model="positionVisible" :title="positionForm.id?'编辑部位':'新增部位'" width="480px">
      <el-form :model="positionForm" label-width="85px"><el-form-item label="部位编码"><el-input v-model="positionForm.positionCode"/></el-form-item><el-form-item label="部位名称"><el-input v-model="positionForm.positionName"/></el-form-item><el-form-item label="排序"><el-input-number v-model="positionForm.sortNo" :min="0"/></el-form-item><el-form-item label="备注"><el-input v-model="positionForm.remark"/></el-form-item></el-form>
      <template #footer><el-button @click="positionVisible=false">取消</el-button><el-button type="primary" @click="savePosition">保存</el-button></template>
    </el-dialog>

    <el-dialog v-model="assignVisible" title="任务成员" width="760px">
      <el-button @click="assigned.push({userId:null,taskRole:'VIEWER',canView:'1',canUpload:'0',canEvaluate:'0'})">添加成员</el-button>
      <el-table :data="assigned" style="margin-top:12px">
        <el-table-column label="用户" min-width="180"><template #default="{row}"><el-select v-model="row.userId" filterable><el-option v-for="u in users" :key="u.userId" :label="`${u.nickName} (${u.userName})`" :value="u.userId"/></el-select></template></el-table-column>
        <el-table-column label="角色" width="150"><template #default="{row}"><el-select v-model="row.taskRole"><el-option v-for="r in roles" :key="r.value" :label="r.label" :value="r.value"/></el-select></template></el-table-column>
        <el-table-column label="查看" width="70"><template #default="{row}"><el-switch v-model="row.canView" active-value="1" inactive-value="0"/></template></el-table-column>
        <el-table-column label="上传" width="70"><template #default="{row}"><el-switch v-model="row.canUpload" active-value="1" inactive-value="0"/></template></el-table-column>
        <el-table-column label="评定" width="70"><template #default="{row}"><el-switch v-model="row.canEvaluate" active-value="1" inactive-value="0"/></template></el-table-column>
        <el-table-column width="70"><template #default="scope"><el-button link type="danger" @click="assigned.splice(scope.$index,1)">移除</el-button></template></el-table-column>
      </el-table>
      <template #footer><el-button @click="assignVisible=false">取消</el-button><el-button type="primary" @click="saveAssign">保存</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCustomer } from '@/api/ndt/customer'
import { listTask, addTask, updateTask, delTask, listTaskUsers, assignTaskUsers } from '@/api/ndt/task'
import { listWorkpiece, addWorkpiece, updateWorkpiece, delWorkpiece } from '@/api/ndt/workpiece'
import { listPosition, addPosition, updatePosition, delPosition } from '@/api/ndt/position'
import { listStudy, getStudyOhif } from '@/api/ndt/study'
import { listUser } from '@/api/system/user'
import { getToken } from '@/utils/auth'

const taskStatuses=[
  {value:'DRAFT',label:'草稿'},
  {value:'IN_PROGRESS',label:'进行中'},
  {value:'COMPLETED',label:'已完成'},
  {value:'CLOSED',label:'已关闭'}
]
const workpieceStatuses=[
  {value:'PENDING',label:'待处理'},
  {value:'IN_PROGRESS',label:'进行中'},
  {value:'COMPLETED',label:'已完成'}
]
const roles=[
  {value:'CREATOR',label:'创建者'},
  {value:'UPLOADER',label:'上传者'},
  {value:'EVALUATOR',label:'评定者'},
  {value:'VIEWER',label:'查看者'}
]
const taskStatusLabel=status=>taskStatuses.find(item=>item.value===status)?.label||status
const workpieceStatusLabel=status=>workpieceStatuses.find(item=>item.value===status)?.label||status
const taskStatusType=status=>({DRAFT:'info',IN_PROGRESS:'primary',COMPLETED:'success',CLOSED:'info'}[status]||'info')
const workpieceStatusType=status=>({PENDING:'warning',IN_PROGRESS:'primary',COMPLETED:'success'}[status]||'info')
const rows=ref([]),total=ref(0),loading=ref(false),customers=ref([]),users=ref([])
const query=reactive({pageNum:1,pageSize:10,taskNo:'',taskName:'',customerId:null})
const taskVisible=ref(false),taskRef=ref(),taskRange=ref([]),taskForm=reactive({id:null,taskNo:'',taskName:'',customerId:null,status:'DRAFT',description:'',startTime:null,finishTime:null})
const taskRules={taskName:[{required:true,message:'请输入任务名称'}],customerId:[{required:true,message:'请选择客户公司'}]}
const hierarchyVisible=ref(false),hierarchyLoading=ref(false),positionLoading=ref(false),currentTask=reactive({}),workpieces=ref([]),positions=ref([]),studies=ref([]),selectedWorkpiece=reactive({})
const workpieceVisible=ref(false),workpieceForm=reactive({id:null,taskId:null,workpieceName:'',status:'PENDING',sortNo:0,remark:''})
const positionVisible=ref(false),positionForm=reactive({id:null,workpieceId:null,positionCode:'',positionName:'',sortNo:0,remark:''})
const assignVisible=ref(false),assigned=ref([])
async function load(){loading.value=true;try{const r=await listTask(query);rows.value=r.rows;total.value=r.total}finally{loading.value=false}}
async function loadOptions(){const [c,u]=await Promise.all([listCustomer({pageNum:1,pageSize:1000}),listUser({pageNum:1,pageSize:1000})]);customers.value=c.rows;users.value=u.rows}
function openTask(row){Object.assign(taskForm,{id:null,taskNo:'',taskName:'',customerId:null,status:'DRAFT',description:'',startTime:null,finishTime:null},row||{});taskRange.value=row&&row.startTime?[row.startTime,row.finishTime]:[];taskVisible.value=true}
async function saveTask(){await taskRef.value.validate();taskForm.startTime=taskRange.value?.[0]||null;taskForm.finishTime=taskRange.value?.[1]||null;await(taskForm.id?updateTask(taskForm):addTask(taskForm));ElMessage.success('保存成功');taskVisible.value=false;load()}
async function removeTask(row){await ElMessageBox.confirm(`确认删除任务“${row.taskName}”吗？`);await delTask(row.id);load()}
async function openHierarchy(row){
  Object.assign(currentTask,row)
  hierarchyVisible.value=true
  clearSelectedWorkpiece()
  positions.value=[]
  studies.value=[]
  hierarchyLoading.value=true
  try{await loadWorkpieces(null,true)}finally{hierarchyLoading.value=false}
}
async function loadWorkpieces(preferredId=selectedWorkpiece.id,autoSelect=false){
  const r=await listWorkpiece({pageNum:1,pageSize:1000,taskId:currentTask.id})
  workpieces.value=r.rows||[]
  const next=workpieces.value.find(item=>item.id===preferredId)||(autoSelect?workpieces.value[0]:null)
  if(next)await selectWorkpiece(next)
  else{clearSelectedWorkpiece();positions.value=[];studies.value=[]}
}
function clearSelectedWorkpiece(){Object.keys(selectedWorkpiece).forEach(key=>delete selectedWorkpiece[key])}
function openWorkpiece(row){Object.assign(workpieceForm,{id:null,taskId:currentTask.id,workpieceName:'',status:'PENDING',sortNo:0,remark:''},row||{});workpieceVisible.value=true}
async function saveWorkpiece(){
  if(!workpieceForm.workpieceName)return ElMessage.warning('请输入工件名称')
  const editingId=workpieceForm.id
  await(editingId?updateWorkpiece(workpieceForm):addWorkpiece(workpieceForm))
  workpieceVisible.value=false
  ElMessage.success(editingId?'工件已更新':'工件已新增')
  await loadWorkpieces(editingId||null,!editingId)
}
async function removeWorkpiece(row){
  await ElMessageBox.confirm(`确认删除工件“${row.workpieceName}”吗？删除后将无法在此任务中继续管理该工件。`,'删除工件',{type:'warning'})
  const removingSelected=selectedWorkpiece.id===row.id
  await delWorkpiece(row.id)
  ElMessage.success('工件已删除')
  await loadWorkpieces(null,removingSelected)
}
async function selectWorkpiece(row){
  Object.assign(selectedWorkpiece,row)
  positionLoading.value=true
  try{
    const [positionResult,studyResult]=await Promise.all([
      listPosition({pageNum:1,pageSize:1000,workpieceId:row.id}),
      listStudy({pageNum:1,pageSize:1000,workpieceId:row.id})
    ])
    if(selectedWorkpiece.id===row.id){positions.value=positionResult.rows||[];studies.value=studyResult.rows||[]}
  }finally{positionLoading.value=false}
}
function openPosition(row){Object.assign(positionForm,{id:null,workpieceId:selectedWorkpiece.id,positionCode:'',positionName:'',sortNo:0,remark:''},row||{});positionVisible.value=true}
async function savePosition(){if(!positionForm.positionCode||!positionForm.positionName)return ElMessage.warning('请输入部位编码和名称');await(positionForm.id?updatePosition(positionForm):addPosition(positionForm));positionVisible.value=false;await selectWorkpiece(selectedWorkpiece)}
async function removePosition(row){await ElMessageBox.confirm('确认删除该检测部位吗？');await delPosition(row.id);await selectWorkpiece(selectedWorkpiece)}
async function openAssign(row){Object.assign(currentTask,row);const r=await listTaskUsers(row.id);assigned.value=(r.data||[]).map(x=>({...x}));assignVisible.value=true}
async function saveAssign(){await assignTaskUsers(currentTask.id,assigned.value);ElMessage.success('成员已更新');assignVisible.value=false}
async function launchStudy(row){const r=await getStudyOhif(row.id);const url=r.data||r.msg;if(!url||!/^https?:\/\//i.test(url))return ElMessage.error('未获取到影像浏览地址，请检查 OHIF 配置');window.open(`${url}${url.includes('?')?'&':'?'}token=${encodeURIComponent(getToken()||'')}`,'_blank','noopener')}
onMounted(()=>{load();loadOptions()})
</script>

<style scoped>
.task-context {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 18px;
  padding: 18px 22px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 12px;
  background: linear-gradient(135deg, var(--el-color-primary-light-9), var(--el-bg-color) 62%);
}

.task-context h2,
.panel-heading h3,
.position-heading h3 {
  margin: 0;
  color: var(--el-text-color-primary);
}

.task-context h2 {
  margin: 5px 0 10px;
  font-size: 21px;
}

.task-context__eyebrow {
  color: var(--el-color-primary);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.08em;
}

.task-context__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 22px;
  color: var(--el-text-color-secondary);
  font-size: 13px;
}

.hierarchy-layout {
  display: grid;
  grid-template-columns: 320px minmax(0, 1fr);
  min-height: calc(100vh - 190px);
  overflow: hidden;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 12px;
  background: var(--el-bg-color);
}

.workpiece-panel {
  padding: 18px;
  border-right: 1px solid var(--el-border-color-lighter);
  background: var(--el-fill-color-lighter);
}

.panel-heading,
.position-heading,
.position-heading__title,
.workpiece-card__top,
.workpiece-card__bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.panel-heading {
  margin-bottom: 16px;
}

.panel-heading h3,
.position-heading h3 {
  font-size: 17px;
}

.panel-heading span,
.position-heading > div > span {
  display: block;
  margin-top: 5px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}

.workpiece-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-height: calc(100vh - 280px);
  padding: 2px;
  overflow-y: auto;
}

.workpiece-card {
  position: relative;
  padding: 15px 14px;
  overflow: hidden;
  border: 1px solid var(--el-border-color);
  border-radius: 9px;
  background: var(--el-bg-color);
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s, transform 0.2s;
}

.workpiece-card::before {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  width: 4px;
  background: transparent;
  content: '';
}

.workpiece-card:hover {
  border-color: var(--el-color-primary-light-5);
  box-shadow: var(--el-box-shadow-light);
  transform: translateY(-1px);
}

.workpiece-card:focus-visible {
  outline: 2px solid var(--el-color-primary-light-3);
  outline-offset: 1px;
}

.workpiece-card.is-active {
  border-color: var(--el-color-primary-light-3);
  background: var(--el-color-primary-light-9);
  box-shadow: 0 4px 14px rgb(64 158 255 / 12%);
}

.workpiece-card.is-active::before {
  background: var(--el-color-primary);
}

.workpiece-card__top strong {
  overflow: hidden;
  color: var(--el-text-color-primary);
  text-overflow: ellipsis;
  white-space: nowrap;
}

.workpiece-card__bottom {
  margin-top: 12px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}

.workpiece-card__actions {
  opacity: 0;
  transition: opacity 0.2s;
}

.workpiece-card:hover .workpiece-card__actions,
.workpiece-card.is-active .workpiece-card__actions,
.workpiece-card:focus-within .workpiece-card__actions {
  opacity: 1;
}

.position-panel {
  min-width: 0;
  padding: 20px 22px;
}

.position-heading {
  margin-bottom: 18px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.position-heading__title {
  justify-content: flex-start;
}

.study-section {
  margin-bottom: 22px;
  padding: 16px;
  border: 1px solid var(--el-color-primary-light-7);
  border-radius: 10px;
  background: var(--el-color-primary-light-9);
}

.subsection-heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.subsection-heading h4 {
  margin: 0;
  color: var(--el-text-color-primary);
  font-size: 15px;
}

.subsection-heading span {
  display: block;
  margin-top: 4px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}

.position-subsection-heading {
  margin-top: 4px;
}

.position-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 270px);
}

.position-placeholder p {
  color: var(--el-text-color-secondary);
}

:deep(.hierarchy-drawer .el-drawer__header) {
  margin-bottom: 0;
  padding-bottom: 18px;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

:deep(.hierarchy-drawer .el-drawer__body) {
  padding-top: 18px;
}

@media (max-width: 1100px) {
  .hierarchy-layout {
    grid-template-columns: 270px minmax(0, 1fr);
  }

  .task-context__meta span:last-child {
    display: none;
  }
}

@media (max-width: 800px) {
  .hierarchy-layout {
    display: block;
  }

  .workpiece-panel {
    border-right: 0;
    border-bottom: 1px solid var(--el-border-color-lighter);
  }

  .workpiece-list {
    max-height: 280px;
  }

  .task-context,
  .position-heading {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
