package com.ruoyi.ndt.dicom.service;

import java.util.List;
import com.ruoyi.ndt.dicom.domain.NdtDicomPrivateTag;

public interface INdtDicomPrivateTagService
{
    List<NdtDicomPrivateTag> selectNdtDicomPrivateTagList(NdtDicomPrivateTag tag);

    List<NdtDicomPrivateTag> selectEnabledNdtDicomPrivateTagList();

    List<String> selectEditableTagNames();

    NdtDicomPrivateTag selectEnabledTagByNameOrCode(String tagKey);

    NdtDicomPrivateTag selectNdtDicomPrivateTagById(Long id);

    int insertNdtDicomPrivateTag(NdtDicomPrivateTag tag, String username);

    int updateNdtDicomPrivateTag(NdtDicomPrivateTag tag, String username);

    int deleteNdtDicomPrivateTagByIds(Long[] ids);

    void checkEditableTagName(String tagName);
}
