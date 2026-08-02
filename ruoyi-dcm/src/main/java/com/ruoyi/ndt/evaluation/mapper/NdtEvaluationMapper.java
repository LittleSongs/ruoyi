package com.ruoyi.ndt.evaluation.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;

public interface NdtEvaluationMapper
{
    List<NdtEvaluation> selectList(NdtEvaluation query);
    NdtEvaluation selectById(Long id);
    int insert(NdtEvaluation evaluation);
    int update(NdtEvaluation evaluation);
    int updateStatus(@Param("id") Long id, @Param("status") String status,
            @Param("evaluatorId") Long evaluatorId, @Param("updateBy") String updateBy);
    int softDeleteByIds(Long[] ids);
}
