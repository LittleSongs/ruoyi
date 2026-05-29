package com.ruoyi.ndt.task.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.task.domain.NdtTaskUser;

public interface NdtTaskUserMapper
{
    List<NdtTaskUser> selectNdtTaskUserList(NdtTaskUser taskUser);

    List<NdtTaskUser> selectNdtTaskUsersByTaskId(Long taskId);

    int countTaskPermission(@Param("taskId") Long taskId, @Param("userId") Long userId,
            @Param("permissionField") String permissionField);

    int countTaskRole(@Param("taskId") Long taskId, @Param("userId") Long userId,
            @Param("taskRole") String taskRole);

    int insertNdtTaskUser(NdtTaskUser taskUser);

    int deleteNdtTaskUsersByTaskId(Long taskId);
}
