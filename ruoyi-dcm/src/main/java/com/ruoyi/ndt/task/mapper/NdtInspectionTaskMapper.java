package com.ruoyi.ndt.task.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;

public interface NdtInspectionTaskMapper
{
    List<NdtInspectionTask> selectNdtInspectionTaskList(NdtInspectionTask task);
    NdtInspectionTask selectNdtInspectionTaskById(Long id);
    NdtInspectionTask selectNdtInspectionTaskByTaskNo(String taskNo);
    int insertNdtInspectionTask(NdtInspectionTask task);
    int updateNdtInspectionTask(NdtInspectionTask task);
    int updateNdtInspectionTaskStatus(@Param("id") Long id, @Param("status") String status,
            @Param("updateBy") String updateBy);
    int softDeleteNdtInspectionTaskByIds(Long[] ids);
}
