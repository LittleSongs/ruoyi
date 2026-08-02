package com.ruoyi.ndt.study;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.study.service.NdtHierarchyRules;

class NdtStudyOwnershipTest
{
    @Test
    void rejectsStudyUidAlreadyOwnedByAnotherWorkpiece()
    {
        assertDoesNotThrow(() -> NdtHierarchyRules.requireStudyOwnership(10L, 10L));
        assertThrows(ServiceException.class,
                () -> NdtHierarchyRules.requireStudyOwnership(10L, 20L));
    }

    @Test
    void rejectsSeriesUidAlreadyOwnedByAnotherStudyOrPosition()
    {
        assertDoesNotThrow(() -> NdtHierarchyRules.requireSeriesOwnership(3L, 7L, 3L, 7L));
        assertThrows(ServiceException.class,
                () -> NdtHierarchyRules.requireSeriesOwnership(3L, 7L, 4L, 7L));
        assertThrows(ServiceException.class,
                () -> NdtHierarchyRules.requireSeriesOwnership(3L, 7L, 3L, 8L));
    }
}
