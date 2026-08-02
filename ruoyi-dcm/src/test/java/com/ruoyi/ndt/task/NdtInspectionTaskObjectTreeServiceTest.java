package com.ruoyi.ndt.task;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.mapper.NdtInspectionPositionMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.series.mapper.NdtDicomSeriesMapper;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;
import com.ruoyi.ndt.task.mapper.NdtTaskUserMapper;
import com.ruoyi.ndt.task.service.impl.NdtInspectionTaskServiceImpl;
import com.ruoyi.ndt.task.vo.NdtTaskObjectTreeVo;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.mapper.NdtWorkpieceMapper;

class NdtInspectionTaskObjectTreeServiceTest
{
    private NdtWorkpieceMapper workpieceMapper;
    private NdtInspectionPositionMapper positionMapper;
    private NdtInspectionStudyMapper studyMapper;
    private NdtDicomObjectMapper objectMapper;
    private NdtAccessService accessService;
    private NdtInspectionTaskServiceImpl service;

    @BeforeEach
    void setUp()
    {
        workpieceMapper = mock(NdtWorkpieceMapper.class);
        positionMapper = mock(NdtInspectionPositionMapper.class);
        studyMapper = mock(NdtInspectionStudyMapper.class);
        objectMapper = mock(NdtDicomObjectMapper.class);
        accessService = mock(NdtAccessService.class);
        service = new NdtInspectionTaskServiceImpl(
                mock(NdtInspectionTaskMapper.class),
                mock(NdtTaskUserMapper.class),
                workpieceMapper,
                positionMapper,
                studyMapper,
                mock(NdtDicomSeriesMapper.class),
                objectMapper,
                accessService);
    }

    @Test
    void studyScopedTreeDoesNotMixObjectsFromAnotherStudy()
    {
        NdtInspectionStudy selectedStudy = study(101L, 10L, 20L, "study-101");
        NdtWorkpiece selectedWorkpiece = workpiece(20L, 10L, "工件A");
        NdtInspectionPosition position = position(30L, 20L, "P01", "1号焊缝");
        NdtDicomObject selectedObject = new NdtDicomObject();
        selectedObject.setId(1001L);
        selectedObject.setStudyId(101L);

        when(studyMapper.selectById(101L)).thenReturn(selectedStudy);
        when(workpieceMapper.selectById(20L)).thenReturn(selectedWorkpiece);
        when(positionMapper.selectByWorkpieceId(20L)).thenReturn(List.of(position));
        when(objectMapper.selectByStudyAndPosition(101L, 30L))
                .thenReturn(List.of(selectedObject));

        NdtTaskObjectTreeVo tree = service.selectObjectTree(10L, 101L);

        assertEquals(10L, tree.getTaskId());
        assertEquals(1, tree.getWorkpieces().size());
        assertEquals(20L, tree.getWorkpieces().get(0).getId());
        assertEquals(1, tree.getWorkpieces().get(0).getStudies().size());
        assertEquals(101L, tree.getWorkpieces().get(0).getStudies().get(0).getId());
        assertEquals(List.of(selectedObject),
                tree.getWorkpieces().get(0).getPositions().get(0).getObjects());
        verify(objectMapper).selectByStudyAndPosition(101L, 30L);
        verify(objectMapper, never()).selectByPositionId(30L);
        verify(workpieceMapper, never()).selectByTaskId(10L);
    }

    @Test
    void rejectsStudyThatDoesNotBelongToRequestedTask()
    {
        when(studyMapper.selectById(101L)).thenReturn(study(101L, 11L, 20L, "study-101"));

        assertThrows(ServiceException.class, () -> service.selectObjectTree(10L, 101L));

        verify(workpieceMapper, never()).selectById(20L);
        verify(objectMapper, never()).selectByStudyAndPosition(101L, 30L);
    }

    private NdtInspectionStudy study(Long id, Long taskId, Long workpieceId, String uid)
    {
        NdtInspectionStudy study = new NdtInspectionStudy();
        study.setId(id);
        study.setTaskId(taskId);
        study.setWorkpieceId(workpieceId);
        study.setStudyInstanceUid(uid);
        study.setInspectionMethodCode("CT");
        return study;
    }

    private NdtWorkpiece workpiece(Long id, Long taskId, String name)
    {
        NdtWorkpiece workpiece = new NdtWorkpiece();
        workpiece.setId(id);
        workpiece.setTaskId(taskId);
        workpiece.setWorkpieceName(name);
        workpiece.setStatus("PENDING");
        return workpiece;
    }

    private NdtInspectionPosition position(Long id, Long workpieceId, String code, String name)
    {
        NdtInspectionPosition position = new NdtInspectionPosition();
        position.setId(id);
        position.setWorkpieceId(workpieceId);
        position.setPositionCode(code);
        position.setPositionName(name);
        return position;
    }
}
