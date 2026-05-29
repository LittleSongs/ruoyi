package com.ruoyi.dcm.service;

import java.util.List;
import com.ruoyi.dcm.domain.DcmInstance;

public interface IDcmInstanceService
{
    List<DcmInstance> selectDcmInstanceList(DcmInstance instance);
}
