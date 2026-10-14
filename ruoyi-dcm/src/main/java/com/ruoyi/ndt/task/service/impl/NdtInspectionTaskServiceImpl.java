package com.ruoyi.ndt.task.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.mapper.NdtInspectionPositionMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.series.domain.NdtDicomSeries;
import com.ruoyi.ndt.series.mapper.NdtDicomSeriesMapper;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.domain.NdtTaskUser;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;
import com.ruoyi.ndt.task.mapper.NdtTaskUserMapper;
import com.ruoyi.ndt.task.service.INdtInspectionTaskService;
import com.ruoyi.ndt.task.vo.NdtTaskObjectTreeVo;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.mapper.NdtWorkpieceMapper;

@Service
public class NdtInspectionTaskServiceImpl implements INdtInspectionTaskService
{
    private final NdtInspectionTaskMapper taskMapper;
    private final NdtTaskUserMapper taskUserMapper;
    private final NdtWorkpieceMapper workpieceMapper;
    private final NdtInspectionPositionMapper positionMapper;
    private final NdtInspectionStudyMapper studyMapper;
    private final NdtDicomSeriesMapper seriesMapper;
    private final NdtDicomObjectMapper objectMapper;
    private final NdtAccessService accessService;
    @org.springframework.beans.factory.annotation.Autowired
    private com.ruoyi.ndt.customer.mapper.NdtCustomerMapper customerMapper;

    public NdtInspectionTaskServiceImpl(NdtInspectionTaskMapper taskMapper, NdtTaskUserMapper taskUserMapper,
            NdtWorkpieceMapper workpieceMapper, NdtInspectionPositionMapper positionMapper,
            NdtInspectionStudyMapper studyMapper, NdtDicomSeriesMapper seriesMapper,
            NdtDicomObjectMapper objectMapper, NdtAccessService accessService)
    {
        this.taskMapper = taskMapper;
        this.taskUserMapper = taskUserMapper;
        this.workpieceMapper = workpieceMapper;
        this.positionMapper = positionMapper;
        this.studyMapper = studyMapper;
        this.seriesMapper = seriesMapper;
        this.objectMapper = objectMapper;
        this.accessService = accessService;
    }

    public List<NdtInspectionTask> selectNdtInspectionTaskList(NdtInspectionTask task)
    {
        accessService.applyTaskListScope(task);
        return taskMapper.selectNdtInspectionTaskList(task);
    }

    public NdtInspectionTask selectNdtInspectionTaskById(Long id)
    {
        accessService.checkViewTask(id);
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(id);
        if (task != null) task.setTaskUsers(taskUserMapper.selectNdtTaskUsersByTaskId(id));
        return task;
    }

    @Transactional(rollbackFor = Exception.class)
    public int insertNdtInspectionTask(NdtInspectionTask task, Long userId, String username)
    {
        validate(task);
        if (StringUtils.isEmpty(task.getTaskNo()))
            task.setTaskNo("NDT" + DateUtils.dateTimeNow() + IdUtils.fastSimpleUUID().substring(0, 6));
        if (taskMapper.selectNdtInspectionTaskByTaskNo(task.getTaskNo()) != null)
            throw new ServiceException("检测任务编号已存在");
        if (StringUtils.isEmpty(task.getStatus())) task.setStatus(NdtConstants.TASK_STATUS_DRAFT);
        task.setCreateBy(username);
        task.setUpdateBy(username);
        int rows = taskMapper.insertNdtInspectionTask(task);
        NdtTaskUser creator = new NdtTaskUser();
        creator.setTaskId(task.getId());
        creator.setUserId(userId);
        creator.setTaskRole(NdtConstants.TASK_ROLE_CREATOR);
        creator.setCanEvaluate(NdtConstants.YES);
        creator.setCanUpload(NdtConstants.YES);
        creator.setCanView(NdtConstants.YES);
        creator.setAssignedBy(username);
        taskUserMapper.insertNdtTaskUser(creator);
        return rows;
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateNdtInspectionTask(NdtInspectionTask task, String username)
    {
        accessService.checkManageTask(task.getId());
        validate(task);
        task.setUpdateBy(username);
        return taskMapper.updateNdtInspectionTask(task);
    }

    public int deleteNdtInspectionTaskByIds(Long[] ids)
    {
        for (Long id : ids) accessService.checkManageTask(id);
        return taskMapper.softDeleteNdtInspectionTaskByIds(ids);
    }

    @Transactional(rollbackFor = Exception.class)
    public int assignTaskUsers(Long taskId, List<NdtTaskUser> users, String username)
    {
        accessService.checkManageTask(taskId);
        taskUserMapper.deleteNdtTaskUsersByTaskId(taskId);
        int rows = 0;
        if (users != null) for (NdtTaskUser user : users)
        {
            normalizeTaskUser(taskId, user, username);
            rows += taskUserMapper.insertNdtTaskUser(user);
        }
        return Math.max(rows, 1);
    }

    public List<NdtTaskUser> selectNdtTaskUsersByTaskId(Long taskId)
    {
        accessService.checkViewTask(taskId);
        return taskUserMapper.selectNdtTaskUsersByTaskId(taskId);
    }

    public NdtTaskObjectTreeVo selectObjectTree(Long taskId)
    {
        return selectObjectTree(taskId, null);
    }

    public NdtTaskObjectTreeVo selectObjectTree(Long taskId, Long studyId)
    {
        accessService.checkViewTask(taskId);
        if (studyId != null)
        {
            return selectStudyObjectTree(taskId, studyId);
        }
        NdtTaskObjectTreeVo tree = new NdtTaskObjectTreeVo();
        tree.setTaskId(taskId);
        for (NdtWorkpiece workpiece : workpieceMapper.selectByTaskId(taskId))
        {
            NdtTaskObjectTreeVo.WorkpieceNode workpieceNode = new NdtTaskObjectTreeVo.WorkpieceNode();
            workpieceNode.setId(workpiece.getId());
            workpieceNode.setWorkpieceName(workpiece.getWorkpieceName());
            workpieceNode.setStatus(workpiece.getStatus());
            for (NdtInspectionStudy study : studyMapper.selectByWorkpieceId(workpiece.getId()))
            {
                NdtTaskObjectTreeVo.StudyNode studyNode = new NdtTaskObjectTreeVo.StudyNode();
                studyNode.setId(study.getId());
                studyNode.setStudyInstanceUid(study.getStudyInstanceUid());
                studyNode.setInspectionMethodCode(study.getInspectionMethodCode());
                studyNode.setStudyDescription(study.getStudyDescription());
                for (NdtDicomSeries series : seriesMapper.selectByStudyId(study.getId()))
                {
                    NdtTaskObjectTreeVo.SeriesNode seriesNode = new NdtTaskObjectTreeVo.SeriesNode();
                    seriesNode.setId(series.getId());
                    seriesNode.setPositionId(series.getPositionId());
                    seriesNode.setSeriesInstanceUid(series.getSeriesInstanceUid());
                    seriesNode.setModality(series.getModality());
                    seriesNode.setSeriesDescription(series.getSeriesDescription());
                    NdtDicomObject objectQuery = new NdtDicomObject();
                    objectQuery.setSeriesId(series.getId());
                    seriesNode.setObjects(objectMapper.selectList(objectQuery));
                    studyNode.getSeries().add(seriesNode);
                }
                workpieceNode.getStudies().add(studyNode);
            }
            for (NdtInspectionPosition position : positionMapper.selectByWorkpieceId(workpiece.getId()))
            {
                NdtTaskObjectTreeVo.PositionNode positionNode = new NdtTaskObjectTreeVo.PositionNode();
                positionNode.setId(position.getId());
                positionNode.setPositionCode(position.getPositionCode());
                positionNode.setPositionName(position.getPositionName());
                positionNode.setObjects(objectMapper.selectByPositionId(position.getId()));
                workpieceNode.getPositions().add(positionNode);
            }
            tree.getWorkpieces().add(workpieceNode);
        }
        return tree;
    }

    private NdtTaskObjectTreeVo selectStudyObjectTree(Long taskId, Long studyId)
    {
        NdtInspectionStudy study = studyMapper.selectById(studyId);
        if (study == null)
        {
            throw new ServiceException("检测Study不存在");
        }
        if (!taskId.equals(study.getTaskId()))
        {
            throw new ServiceException("检测Study与任务不匹配");
        }
        NdtWorkpiece workpiece = workpieceMapper.selectById(study.getWorkpieceId());
        if (workpiece == null || !taskId.equals(workpiece.getTaskId()))
        {
            throw new ServiceException("检测Study所属工件不存在");
        }

        NdtTaskObjectTreeVo tree = new NdtTaskObjectTreeVo();
        tree.setTaskId(taskId);
        NdtTaskObjectTreeVo.WorkpieceNode workpieceNode = new NdtTaskObjectTreeVo.WorkpieceNode();
        workpieceNode.setId(workpiece.getId());
        workpieceNode.setWorkpieceName(workpiece.getWorkpieceName());
        workpieceNode.setStatus(workpiece.getStatus());

        NdtTaskObjectTreeVo.StudyNode studyNode = new NdtTaskObjectTreeVo.StudyNode();
        studyNode.setId(study.getId());
        studyNode.setStudyInstanceUid(study.getStudyInstanceUid());
        studyNode.setInspectionMethodCode(study.getInspectionMethodCode());
        studyNode.setStudyDescription(study.getStudyDescription());
        for (NdtDicomSeries series : seriesMapper.selectByStudyId(study.getId()))
        {
            NdtTaskObjectTreeVo.SeriesNode seriesNode = new NdtTaskObjectTreeVo.SeriesNode();
            seriesNode.setId(series.getId());
            seriesNode.setPositionId(series.getPositionId());
            seriesNode.setSeriesInstanceUid(series.getSeriesInstanceUid());
            seriesNode.setModality(series.getModality());
            seriesNode.setSeriesDescription(series.getSeriesDescription());
            NdtDicomObject objectQuery = new NdtDicomObject();
            objectQuery.setSeriesId(series.getId());
            seriesNode.setObjects(objectMapper.selectList(objectQuery));
            studyNode.getSeries().add(seriesNode);
        }
        workpieceNode.getStudies().add(studyNode);

        for (NdtInspectionPosition position : positionMapper.selectByWorkpieceId(workpiece.getId()))
        {
            NdtTaskObjectTreeVo.PositionNode positionNode = new NdtTaskObjectTreeVo.PositionNode();
            positionNode.setId(position.getId());
            positionNode.setPositionCode(position.getPositionCode());
            positionNode.setPositionName(position.getPositionName());
            positionNode.setObjects(objectMapper.selectByStudyAndPosition(studyId, position.getId()));
            workpieceNode.getPositions().add(positionNode);
        }
        tree.getWorkpieces().add(workpieceNode);
        return tree;
    }

    private void validate(NdtInspectionTask task)
    {
        if (task == null || StringUtils.isEmpty(task.getTaskName())) throw new ServiceException("任务名称不能为空");
        if (task.getCustomerId() == null) throw new ServiceException("客户公司不能为空");
        if (customerMapper.selectByIdForUpdate(task.getCustomerId()) == null)
            throw new ServiceException("客户公司不存在或已删除");
    }

    private void normalizeTaskUser(Long taskId, NdtTaskUser user, String username)
    {
        if (user.getUserId() == null) throw new ServiceException("分配用户不能为空");
        if (!List.of(NdtConstants.TASK_ROLE_CREATOR, NdtConstants.TASK_ROLE_UPLOADER,
                NdtConstants.TASK_ROLE_EVALUATOR, NdtConstants.TASK_ROLE_VIEWER).contains(user.getTaskRole()))
            throw new ServiceException("任务角色不合法");
        user.setTaskId(taskId);
        user.setAssignedBy(username);
        if (StringUtils.isEmpty(user.getCanView())) user.setCanView(NdtConstants.YES);
        if (StringUtils.isEmpty(user.getCanUpload())) user.setCanUpload(NdtConstants.NO);
        if (StringUtils.isEmpty(user.getCanEvaluate())) user.setCanEvaluate(NdtConstants.NO);
    }
}
