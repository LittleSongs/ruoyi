package com.ruoyi.ndt.report.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.report.domain.NdtTaskReport;

public interface NdtTaskReportMapper
{
    List<NdtTaskReport> selectList(NdtTaskReport query);
    NdtTaskReport selectById(Long id);
    Integer selectMaxNumericVersion(Long taskId);
    int insert(NdtTaskReport report);
    int updateStatus(@Param("id") Long id, @Param("status") String status,
            @Param("updateBy") String updateBy);
    int deleteById(Long id);
}
