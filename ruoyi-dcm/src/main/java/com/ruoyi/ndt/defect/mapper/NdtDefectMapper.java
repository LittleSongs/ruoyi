package com.ruoyi.ndt.defect.mapper;

import java.util.List;
import com.ruoyi.ndt.defect.domain.NdtDefect;

public interface NdtDefectMapper
{
    List<NdtDefect> selectList(NdtDefect query);
    NdtDefect selectById(Long id);
    int insert(NdtDefect defect);
    int update(NdtDefect defect);
    int softDeleteByIds(Long[] ids);
}
