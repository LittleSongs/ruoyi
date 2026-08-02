package com.ruoyi.ndt.study.service;

import java.util.Objects;
import com.ruoyi.common.exception.ServiceException;

/**
 * Cross-level ownership rules for the Component -> Study -> Series hierarchy.
 */
public final class NdtHierarchyRules
{
    private NdtHierarchyRules() { }

    public static void requireStudyOwnership(Long existingWorkpieceId, Long requestedWorkpieceId)
    {
        if (!Objects.equals(existingWorkpieceId, requestedWorkpieceId))
        {
            throw new ServiceException("该StudyInstanceUID已属于其他工件");
        }
    }

    public static void requireSeriesOwnership(Long existingStudyId, Long existingPositionId,
            Long requestedStudyId, Long requestedPositionId)
    {
        if (!Objects.equals(existingStudyId, requestedStudyId))
        {
            throw new ServiceException("该SeriesInstanceUID已属于其他Study");
        }
        if (!Objects.equals(existingPositionId, requestedPositionId))
        {
            throw new ServiceException("该SeriesInstanceUID已属于其他检测部位");
        }
    }
}
