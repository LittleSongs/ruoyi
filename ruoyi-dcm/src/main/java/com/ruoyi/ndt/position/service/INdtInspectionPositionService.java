package com.ruoyi.ndt.position.service;

import java.util.List;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;

public interface INdtInspectionPositionService
{
    List<NdtInspectionPosition> selectList(NdtInspectionPosition query);
    NdtInspectionPosition selectById(Long id);
    int insert(NdtInspectionPosition value, String username);
    int update(NdtInspectionPosition value, String username);
    int deleteByIds(Long[] ids);
}
