package com.ruoyi.ndt.organization.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.organization.domain.NdtDicomSeries;
import com.ruoyi.ndt.organization.domain.NdtInspectionPart;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeRow;
import com.ruoyi.ndt.organization.domain.NdtPartDicomObject;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryRow;

public interface NdtDicomOrganizationMapper
{
    int upsertDicomSeries(NdtDicomSeries series);
    Long selectSeriesIdByUid(String seriesInstanceUid);
    NdtInspectionPart selectPartBySourceSop(@Param("taskId") Long taskId,
            @Param("sourceSopInstanceUid") String sourceSopInstanceUid);
    List<NdtInspectionPart> selectPartsByObjectSop(@Param("taskId") Long taskId,
            @Param("sopInstanceUid") String sopInstanceUid);
    int insertInspectionPart(NdtInspectionPart part);
    int insertPartObject(NdtPartDicomObject object);
    List<NdtObjectTreeRow> selectObjectTreeRows(Long taskId);
    List<NdtObjectTreeRow> selectUnassignedObjectRows(Long taskId);
    List<NdtEvaluationHistoryRow> selectEvaluationHistoryRows(@Param("taskId") Long taskId,
            @Param("sopInstanceUid") String sopInstanceUid);
}
