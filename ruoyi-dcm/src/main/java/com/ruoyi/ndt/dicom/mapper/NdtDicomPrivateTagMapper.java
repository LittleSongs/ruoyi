package com.ruoyi.ndt.dicom.mapper;

import java.util.List;
import com.ruoyi.ndt.dicom.domain.NdtDicomPrivateTag;

public interface NdtDicomPrivateTagMapper
{
    List<NdtDicomPrivateTag> selectNdtDicomPrivateTagList(NdtDicomPrivateTag tag);

    List<NdtDicomPrivateTag> selectEnabledNdtDicomPrivateTagList();

    NdtDicomPrivateTag selectNdtDicomPrivateTagById(Long id);

    NdtDicomPrivateTag selectNdtDicomPrivateTagByName(String tagName);

    int insertNdtDicomPrivateTag(NdtDicomPrivateTag tag);

    int updateNdtDicomPrivateTag(NdtDicomPrivateTag tag);

    int softDeleteNdtDicomPrivateTagByIds(Long[] ids);
}
