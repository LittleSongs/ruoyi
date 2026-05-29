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
    public static final String TASK_STATUS_ASSIGNED = "ASSIGNED";
    public static final String TASK_STATUS_UPLOADED = "UPLOADED";
    public static final String TASK_STATUS_EVALUATING = "EVALUATING";
    public static final String TASK_STATUS_EVALUATED = "EVALUATED";
    public static final String TASK_STATUS_CLOSED = "CLOSED";

    public static final String INTEGRITY_STATUS_UNKNOWN = "UNKNOWN";
    public static final String INTEGRITY_STATUS_PASS = "PASS";
    public static final String INTEGRITY_STATUS_FAIL = "FAIL";

    public static final String EVALUATION_STATUS_DRAFT = "DRAFT";
    public static final String EVALUATION_STATUS_SUBMITTED = "SUBMITTED";

    public static final String UID_TYPE_STUDY = "STUDY";
    public static final String UID_TYPE_SERIES = "SERIES";
    public static final String UID_TYPE_SOP_INSTANCE = "SOP_INSTANCE";
    public static final String UID_ROOT_TYPE_CUSTOM_ROOT = "CUSTOM_ROOT";
    public static final String UID_ROOT_TYPE_UUID_2_25 = "UUID_2_25";

    public static final String RELATED_TYPE_PROCESSED_IMAGE = "PROCESSED_IMAGE";
    public static final String RELATED_TYPE_SNAPSHOT = "SNAPSHOT";
    public static final String RELATED_TYPE_SR = "SR";
    public static final String RELATED_TYPE_EVALUATION = "EVALUATION";

    public static final String DEL_FLAG_NORMAL = "0";
    public static final String DEL_FLAG_DELETED = "2";
    public static final String YES = "1";
    public static final String NO = "0";

    private NdtConstants()
    {
    }
}
