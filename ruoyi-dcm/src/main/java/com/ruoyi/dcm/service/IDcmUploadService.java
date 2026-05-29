package com.ruoyi.dcm.service;

import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.dcm.domain.DcmUploadResult;

public interface IDcmUploadService
{
    DcmUploadResult uploadAndSync(MultipartFile file, Long uploadUserId, String uploadUserName);
}
