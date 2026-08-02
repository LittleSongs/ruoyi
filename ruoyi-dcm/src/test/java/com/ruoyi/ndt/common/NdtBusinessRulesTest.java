package com.ruoyi.ndt.common;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.Test;
import com.ruoyi.common.exception.ServiceException;

class NdtBusinessRulesTest
{
    @Test
    void acceptsEveryNewObjectType()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("ORIGINAL_IMAGE"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("PROCESSED_IMAGE"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("SCREENSHOT"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("ANNOTATION_IMAGE"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("PRESENTATION_STATE"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("SR"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireObjectType("OTHER"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireObjectType("ORIGINAL"));
    }

    @Test
    void derivedObjectCannotPretendToBeAnOriginalImage()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireDerivedObjectType("SR"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireDerivedObjectType("PROCESSED_IMAGE"));
        assertThrows(ServiceException.class,
                () -> NdtBusinessRules.requireDerivedObjectType("ORIGINAL_IMAGE"));
    }

    @Test
    void derivedObjectsRequireAnOriginalImageSource()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireOriginalSource("ORIGINAL_IMAGE"));
        assertThrows(ServiceException.class,
                () -> NdtBusinessRules.requireOriginalSource("PROCESSED_IMAGE"));
    }

    @Test
    void imageAndNonImageDerivedTypesAreSeparated()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireImageDerivedType("PROCESSED_IMAGE"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireImageDerivedType("SCREENSHOT"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireImageDerivedType("ANNOTATION_IMAGE"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireImageDerivedType("SR"));

        assertDoesNotThrow(() -> NdtBusinessRules.requireNonImageDerivedType("SR"));
        assertThrows(ServiceException.class,
                () -> NdtBusinessRules.requireNonImageDerivedType("PROCESSED_IMAGE"));
    }

    @Test
    void imageDerivedObjectMustReuseTheSourceStudyAndSeries()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireSameSeriesPlacement(
                "study-1", "series-1", "study-1", "series-1"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireSameSeriesPlacement(
                "study-1", "series-1", "study-2", "series-1"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireSameSeriesPlacement(
                "study-1", "series-1", "study-1", "series-2"));
    }

    @Test
    void nonImageObjectMustUseASeparateSeriesInTheSourceStudy()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireSeparateSeriesPlacement(
                "study-1", "series-1", "study-1", "series-2"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireSeparateSeriesPlacement(
                "study-1", "series-1", "study-2", "series-2"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireSeparateSeriesPlacement(
                "study-1", "series-1", "study-1", "series-1"));
    }

    @Test
    void evaluationTargetIsExclusive()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireEvaluationTarget("DEFECT", 1L, null));
        assertDoesNotThrow(() -> NdtBusinessRules.requireEvaluationTarget("WORKPIECE", null, 2L));
        assertThrows(ServiceException.class,
                () -> NdtBusinessRules.requireEvaluationTarget("DEFECT", 1L, 2L));
        assertThrows(ServiceException.class,
                () -> NdtBusinessRules.requireEvaluationTarget("WORKPIECE", null, null));
    }

    @Test
    void reviewIsLimitedToPassOrReject()
    {
        assertDoesNotThrow(() -> NdtBusinessRules.requireReviewResult("PASS"));
        assertDoesNotThrow(() -> NdtBusinessRules.requireReviewResult("REJECT"));
        assertThrows(ServiceException.class, () -> NdtBusinessRules.requireReviewResult("APPROVED"));
    }
}
