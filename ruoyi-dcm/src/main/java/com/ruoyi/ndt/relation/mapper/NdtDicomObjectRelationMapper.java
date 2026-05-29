package com.ruoyi.ndt.relation.mapper;

import java.util.List;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;

public interface NdtDicomObjectRelationMapper
{
    List<NdtDicomObjectRelation> selectNdtDicomObjectRelationList(NdtDicomObjectRelation relation);

    int insertNdtDicomObjectRelation(NdtDicomObjectRelation relation);
}
