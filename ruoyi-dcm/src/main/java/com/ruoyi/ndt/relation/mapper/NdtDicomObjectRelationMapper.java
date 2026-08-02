package com.ruoyi.ndt.relation.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;

public interface NdtDicomObjectRelationMapper
{
    List<NdtDicomObjectRelation> selectByObjectId(Long objectId);
    int insert(NdtDicomObjectRelation relation);
    int deleteById(@Param("id") Long id);
}
