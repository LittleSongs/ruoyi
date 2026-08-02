package com.ruoyi.ndt.evaluation.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;

public interface INdtEvaluationService
{
    List<NdtEvaluation> selectList(NdtEvaluation query);
    NdtEvaluation selectById(Long id);
    int insert(NdtEvaluation value, Long userId, String username);
    int update(NdtEvaluation value, String username);
    int submit(Long id, Long userId, String username);
    NdtDicomObject submitWithSr(Long id, Long sourceObjectId, MultipartFile file,
            Long userId, String username);
    int deleteByIds(Long[] ids);
}
