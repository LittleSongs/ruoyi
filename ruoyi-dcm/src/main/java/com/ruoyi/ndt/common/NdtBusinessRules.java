package com.ruoyi.ndt.common;

import java.util.Objects;
import java.util.Set;
import com.ruoyi.common.exception.ServiceException;

/**
 * Central validation for values protected by the NDT database constraints.
 */
public final class NdtBusinessRules
{
    private static final Set<String> OBJECT_TYPES = Set.of(
            NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE,
            NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE,
            NdtConstants.OBJECT_TYPE_SCREENSHOT,
            NdtConstants.OBJECT_TYPE_ANNOTATION_IMAGE,
            NdtConstants.OBJECT_TYPE_PRESENTATION_STATE,
            NdtConstants.OBJECT_TYPE_SR,
            NdtConstants.OBJECT_TYPE_OTHER);

    private static final Set<String> STORAGE_TYPES = Set.of(
            NdtConstants.STORAGE_TYPE_ORTHANC,
            NdtConstants.STORAGE_TYPE_FILE_SYSTEM,
            NdtConstants.STORAGE_TYPE_OBJECT_STORAGE,
            NdtConstants.STORAGE_TYPE_DATABASE_JSON);

    private static final Set<String> IMAGE_DERIVED_TYPES = Set.of(
            NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE,
            NdtConstants.OBJECT_TYPE_SCREENSHOT,
            NdtConstants.OBJECT_TYPE_ANNOTATION_IMAGE);

    private static final Set<String> NON_IMAGE_DERIVED_TYPES = Set.of(
            NdtConstants.OBJECT_TYPE_SR);

    private NdtBusinessRules()
    {
    }

    public static void requireObjectType(String objectType)
    {
        if (!OBJECT_TYPES.contains(objectType))
        {
            throw new ServiceException("不支持的DICOM对象类型");
        }
    }

    public static void requireStorageType(String storageType)
    {
        if (!STORAGE_TYPES.contains(storageType))
        {
            throw new ServiceException("不支持的对象存储类型");
        }
    }

    public static void requireDerivedObjectType(String objectType)
    {
        requireObjectType(objectType);
        if (NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE.equals(objectType))
        {
            throw new ServiceException("衍生对象不能使用ORIGINAL_IMAGE类型");
        }
    }

    public static void requireOriginalSource(String objectType)
    {
        if (!NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE.equals(objectType))
        {
            throw new ServiceException("派生对象的来源必须是原始图");
        }
    }

    public static void requireImageDerivedType(String objectType)
    {
        if (!IMAGE_DERIVED_TYPES.contains(objectType))
        {
            throw new ServiceException("同Series派生对象仅支持处理图、截图和标注图");
        }
    }

    public static void requireNonImageDerivedType(String objectType)
    {
        if (!NON_IMAGE_DERIVED_TYPES.contains(objectType))
        {
            throw new ServiceException("独立Series非图像对象当前仅支持SR");
        }
    }

    public static void requireSameSeriesPlacement(String sourceStudyUid, String sourceSeriesUid,
            String incomingStudyUid, String incomingSeriesUid)
    {
        if (!Objects.equals(sourceStudyUid, incomingStudyUid))
        {
            throw new ServiceException("派生图必须与来源原图属于同一个Study Instance UID");
        }
        if (!Objects.equals(sourceSeriesUid, incomingSeriesUid))
        {
            throw new ServiceException("处理图、截图和标注图必须与原始图属于同一个Series Instance UID");
        }
    }

    public static void requireSeparateSeriesPlacement(String sourceStudyUid, String sourceSeriesUid,
            String incomingStudyUid, String incomingSeriesUid)
    {
        if (!Objects.equals(sourceStudyUid, incomingStudyUid))
        {
            throw new ServiceException("非图像对象必须与来源原图属于同一个Study");
        }
        if (Objects.equals(sourceSeriesUid, incomingSeriesUid))
        {
            throw new ServiceException("SR等非图像对象必须使用独立Series");
        }
    }

    public static void requireEvaluationTarget(String type, Long defectId, Long workpieceId)
    {
        boolean defect = NdtConstants.EVALUATION_TYPE_DEFECT.equals(type)
                && defectId != null && workpieceId == null;
        boolean workpiece = NdtConstants.EVALUATION_TYPE_WORKPIECE.equals(type)
                && workpieceId != null && defectId == null;
        if (!defect && !workpiece)
        {
            throw new ServiceException("评定必须且只能关联一个缺陷或一个工件");
        }
    }

    public static void requireReviewResult(String result)
    {
        if (!NdtConstants.REVIEW_RESULT_PASS.equals(result)
                && !NdtConstants.REVIEW_RESULT_REJECT.equals(result))
        {
            throw new ServiceException("复核结果仅支持PASS或REJECT");
        }
    }
}
