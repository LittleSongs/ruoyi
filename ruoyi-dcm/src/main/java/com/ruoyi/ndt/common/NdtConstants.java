package com.ruoyi.ndt.common;

/**
 * NDT business constants.
 */
public class NdtConstants
{
    public static final String ROLE_SUPER_ADMIN = "admin";
    public static final String ROLE_COMPANY_ADMIN = "ndt_company_admin";
    public static final String ROLE_INSPECTOR = "ndt_inspector";
    public static final String ROLE_CUSTOMER = "ndt_customer";

    public static final String TASK_ROLE_CREATOR = "CREATOR";
    public static final String TASK_ROLE_UPLOADER = "UPLOADER";
    public static final String TASK_ROLE_EVALUATOR = "EVALUATOR";
    public static final String TASK_ROLE_VIEWER = "VIEWER";

    public static final String TASK_STATUS_DRAFT = "DRAFT";
    public static final String TASK_STATUS_IN_PROGRESS = "IN_PROGRESS";
    public static final String TASK_STATUS_COMPLETED = "COMPLETED";
    public static final String TASK_STATUS_CLOSED = "CLOSED";

    public static final String WORKPIECE_STATUS_PENDING = "PENDING";
    public static final String WORKPIECE_STATUS_IN_PROGRESS = "IN_PROGRESS";
    public static final String WORKPIECE_STATUS_COMPLETED = "COMPLETED";

    public static final String INTEGRITY_STATUS_UNKNOWN = "UNKNOWN";
    public static final String INTEGRITY_STATUS_PASS = "PASS";
    public static final String INTEGRITY_STATUS_FAIL = "FAIL";

    public static final String EVALUATION_STATUS_DRAFT = "DRAFT";
    public static final String EVALUATION_STATUS_SUBMITTED = "SUBMITTED";
    public static final String EVALUATION_TYPE_DEFECT = "DEFECT";
    public static final String EVALUATION_TYPE_WORKPIECE = "WORKPIECE";
    public static final String REVIEW_RESULT_PASS = "PASS";
    public static final String REVIEW_RESULT_REJECT = "REJECT";

    public static final String UID_TYPE_STUDY = "STUDY";
    public static final String UID_TYPE_SERIES = "SERIES";
    public static final String UID_TYPE_SOP_INSTANCE = "SOP_INSTANCE";
    public static final String UID_ROOT_TYPE_CUSTOM_ROOT = "CUSTOM_ROOT";
    public static final String UID_ROOT_TYPE_UUID_2_25 = "UUID_2_25";

    public static final String RELATION_TYPE_DERIVED_FROM = "DERIVED_FROM";
    public static final String RELATION_TYPE_REFERENCES = "REFERENCES";
    public static final String RELATION_TYPE_GENERATED_FROM = "GENERATED_FROM";

    public static final String OBJECT_TYPE_ORIGINAL_IMAGE = "ORIGINAL_IMAGE";
    public static final String OBJECT_TYPE_PROCESSED_IMAGE = "PROCESSED_IMAGE";
    public static final String OBJECT_TYPE_SCREENSHOT = "SCREENSHOT";
    public static final String OBJECT_TYPE_ANNOTATION_IMAGE = "ANNOTATION_IMAGE";
    public static final String OBJECT_TYPE_PRESENTATION_STATE = "PRESENTATION_STATE";
    public static final String OBJECT_TYPE_SR = "SR";
    public static final String OBJECT_TYPE_OTHER = "OTHER";

    public static final String STORAGE_TYPE_ORTHANC = "ORTHANC";
    public static final String STORAGE_TYPE_FILE_SYSTEM = "FILE_SYSTEM";
    public static final String STORAGE_TYPE_OBJECT_STORAGE = "OBJECT_STORAGE";
    public static final String STORAGE_TYPE_DATABASE_JSON = "DATABASE_JSON";

    public static final String REPORT_STATUS_DRAFT = "DRAFT";
    public static final String REPORT_STATUS_RELEASED = "RELEASED";

    public static final String DEL_FLAG_NORMAL = "0";
    public static final String DEL_FLAG_DELETED = "2";
    public static final String YES = "1";
    public static final String NO = "0";

    private NdtConstants()
    {
    }
}
