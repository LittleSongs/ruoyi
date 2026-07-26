package com.ruoyi.ndt.evaluation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryResponse;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryRow;
import com.ruoyi.ndt.evaluation.service.impl.NdtEvaluationHistoryServiceImpl;
import com.ruoyi.ndt.organization.mapper.NdtDicomOrganizationMapper;

class NdtEvaluationHistoryServiceImplTest
{
    @Mock
    private NdtDicomOrganizationMapper organizationMapper;

    private NdtEvaluationHistoryServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new NdtEvaluationHistoryServiceImpl(organizationMapper);
    }

    @Test
    void groupsHistoryForEveryPartContainingTheCurrentObject()
    {
        when(organizationMapper.selectEvaluationHistoryRows(8L, "multi-source-sr")).thenReturn(List.of(
                row(52L, "P-000032", "source-2", 202L, "裂纹"),
                row(51L, "P-000031", "source-1", 201L, "气孔")));

        NdtEvaluationHistoryResponse response = service.selectHistory(8L, "multi-source-sr");

        assertEquals(List.of("P-000031", "P-000032"), response.getParts().stream()
                .map(part -> part.getPartNo()).toList());
        assertEquals("source-1", response.getParts().get(0).getSourceSopInstanceUid());
        assertEquals("气孔", response.getParts().get(0).getEvaluations().get(0).getDefectType());
    }

    @Test
    void returnsTheSamePartHistoryForOriginalAndDerivedObjects()
    {
        List<NdtEvaluationHistoryRow> history = List.of(row(51L, "P-000031", "source-1", 201L, "裂纹"));
        when(organizationMapper.selectEvaluationHistoryRows(8L, "source-1")).thenReturn(history);
        when(organizationMapper.selectEvaluationHistoryRows(8L, "processed-1")).thenReturn(history);

        assertEquals(201L, service.selectHistory(8L, "source-1").getParts().get(0)
                .getEvaluations().get(0).getId());
        assertEquals(201L, service.selectHistory(8L, "processed-1").getParts().get(0)
                .getEvaluations().get(0).getId());
    }

    private NdtEvaluationHistoryRow row(Long partId, String partNo, String sourceSopUid,
            Long evaluationId, String defectType)
    {
        NdtEvaluationHistoryRow row = new NdtEvaluationHistoryRow();
        row.setPartId(partId);
        row.setPartNo(partNo);
        row.setPartName(partNo);
        row.setSourceSopInstanceUid(sourceSopUid);
        row.setEvaluationId(evaluationId);
        row.setEvaluatorUserName("inspector");
        row.setEvaluateTime(new Date(evaluationId));
        row.setDefectType(defectType);
        row.setDefectLevel("II");
        row.setConclusion("合格");
        return row;
    }
}
