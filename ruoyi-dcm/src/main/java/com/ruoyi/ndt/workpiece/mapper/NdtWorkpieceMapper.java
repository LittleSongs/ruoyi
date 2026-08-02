package com.ruoyi.ndt.workpiece.mapper;

import java.util.List;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;

public interface NdtWorkpieceMapper
{
    List<NdtWorkpiece> selectList(NdtWorkpiece query);
    List<NdtWorkpiece> selectByTaskId(Long taskId);
    NdtWorkpiece selectById(Long id);
    int insert(NdtWorkpiece workpiece);
    int update(NdtWorkpiece workpiece);
    int softDeleteByIds(Long[] ids);
}
