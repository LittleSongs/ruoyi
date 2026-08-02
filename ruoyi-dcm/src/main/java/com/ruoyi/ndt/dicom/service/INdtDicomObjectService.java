package com.ruoyi.ndt.dicom.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.domain.NdtDicomObjectUploadResult;
import com.ruoyi.ndt.dicom.dto.NdtDicomDerivedObjectDto;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;

public interface INdtDicomObjectService
{
    List<NdtDicomObject> selectList(NdtDicomObject query);
    NdtDicomObject selectById(Long id);
    NdtDicomObjectUploadResult uploadOriginal(Long positionId, MultipartFile file, Long userId, String username);
    NdtDicomObject createDerived(NdtDicomDerivedObjectDto dto, String username);
    NdtDicomObject uploadDerivedImageDicom(Long sourceObjectId, String objectType,
            MultipartFile file, Long userId, String username);
    NdtDicomObject uploadDerivedDicom(Long sourceObjectId, String objectType, String relationType,
            MultipartFile file, Long userId, String username);
    byte[] download(Long id);
    JSONObject tags(Long id);
    List<NdtDicomObjectRelation> relations(Long id);
    int deleteByIds(Long[] ids);
}
