package com.ruoyi.ndt.defect.service;

import java.util.List;
import com.ruoyi.ndt.defect.domain.NdtDefect;

public interface INdtDefectService
{
    List<NdtDefect> selectList(NdtDefect query);
    NdtDefect selectById(Long id);
    int insert(NdtDefect value, String username);
    int update(NdtDefect value, String username);
    int deleteByIds(Long[] ids);
}
