package com.ruoyi.ndt.position.mapper;

import java.util.List;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;

public interface NdtInspectionPositionMapper
{
    List<NdtInspectionPosition> selectList(NdtInspectionPosition query);
    List<NdtInspectionPosition> selectByWorkpieceId(Long workpieceId);
    NdtInspectionPosition selectById(Long id);
    NdtInspectionPosition selectByIdForUpdate(Long id);
    int insert(NdtInspectionPosition position);
    int update(NdtInspectionPosition position);
    int softDeleteByIds(Long[] ids);
}
