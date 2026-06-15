package com.ruoyi.dcm.validation;

import java.util.HashMap;
import java.util.Map;
import com.ruoyi.common.utils.StringUtils;

/**
 * Minimal DICOM metadata needed by upload validation.
 */
public class DcmDicomMetadata
{
    private final Map<String, String> tagValues = new HashMap<>();
    private String transferSyntaxUid;
    private String mediaStorageSopClassUid;
    private String sopClassUid;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;

    public String getTagValue(String tagCode)
    {
        return tagValues.get(normalizeTagCode(tagCode));
    }

    public boolean containsTag(String tagCode)
    {
        return tagValues.containsKey(normalizeTagCode(tagCode));
    }

    public void putTagValue(String tagCode, String value)
    {
        tagValues.put(normalizeTagCode(tagCode), value);
    }

    public Map<String, String> getTagValues()
    {
        return tagValues;
    }

    public String getTransferSyntaxUid() { return transferSyntaxUid; }
    public void setTransferSyntaxUid(String transferSyntaxUid) { this.transferSyntaxUid = transferSyntaxUid; putTagValue("00020010", transferSyntaxUid); }
    public String getMediaStorageSopClassUid() { return mediaStorageSopClassUid; }
    public void setMediaStorageSopClassUid(String mediaStorageSopClassUid) { this.mediaStorageSopClassUid = mediaStorageSopClassUid; putTagValue("00020002", mediaStorageSopClassUid); }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; putTagValue("00080016", sopClassUid); }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; putTagValue("0020000D", studyInstanceUid); }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; putTagValue("0020000E", seriesInstanceUid); }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; putTagValue("00080018", sopInstanceUid); }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; putTagValue("00080060", modality); }

    public static String normalizeTagCode(String tagCode)
    {
        return StringUtils.isEmpty(tagCode) ? "" : tagCode.replace("(", "").replace(")", "")
                .replace(",", "").replace(" ", "").toUpperCase();
    }
}
