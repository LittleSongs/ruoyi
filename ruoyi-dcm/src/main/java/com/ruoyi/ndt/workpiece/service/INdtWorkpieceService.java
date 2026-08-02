package com.ruoyi.ndt.workpiece.service;

import java.util.List;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;

public interface INdtWorkpieceService
{
    List<NdtWorkpiece> selectList(NdtWorkpiece query);
    NdtWorkpiece selectById(Long id);
    int insert(NdtWorkpiece value, String username);
    int update(NdtWorkpiece value, String username);
    int deleteByIds(Long[] ids);
}
