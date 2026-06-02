package com.ruoyi.ndt.orthanc;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.ruoyi.ndt.dicom.domain.NdtDicomTagItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;
import com.ruoyi.ndt.dicom.service.INdtDicomInstanceService;

/**
 * Orthanc hierarchy and tag helper service.
 */
@Service
public class NdtOrthancService
{
    private static final Set<String> EDITABLE_TAG_WHITELIST = new HashSet<>(Arrays.asList("PatientName", "StudyDescription",
            "SeriesDescription"));

    @Autowired
    private OrthancService orthancService;

    @Autowired
    private INdtDicomInstanceService dicomInstanceService;

    public List<NdtOrthancHierarchyNode> selectHierarchy(String taskNo, String workpieceName)
    {
        NdtDicomInstance query = new NdtDicomInstance();
        query.setTaskNo(taskNo);
        query.setWorkpieceName(workpieceName);
        List<NdtDicomInstance> instances = dicomInstanceService.selectNdtDicomInstanceList(query);
        Map<String, NdtOrthancHierarchyNode> studyMap = new LinkedHashMap<>();
        Map<String, NdtOrthancHierarchyNode> seriesMap = new LinkedHashMap<>();
        List<NdtOrthancHierarchyNode> roots = new ArrayList<>();
        for (NdtDicomInstance instance : instances)
        {
            String studyKey = StringUtils.isNotEmpty(instance.getOrthancStudyId()) ? instance.getOrthancStudyId()
                    : instance.getStudyInstanceUid();
            String seriesKey = StringUtils.isNotEmpty(instance.getOrthancSeriesId()) ? instance.getOrthancSeriesId()
                    : instance.getSeriesInstanceUid();
            NdtOrthancHierarchyNode study = studyMap.get(studyKey);
            if (study == null)
            {
                study = buildStudyNode(instance, studyKey);
                studyMap.put(studyKey, study);
                roots.add(study);
            }
            NdtOrthancHierarchyNode series = seriesMap.get(seriesKey);
            if (series == null)
            {
                series = buildSeriesNode(instance, study, seriesKey);
                seriesMap.put(seriesKey, series);
                study.getChildren().add(series);
            }
            series.getChildren().add(buildInstanceNode(instance, series));
        }
        return roots;
    }

    public List<NdtDicomTagItem> selectTagsByInstanceId(Long dicomInstanceId)
    {
        NdtDicomInstance instance = dicomInstanceService.selectNdtDicomInstanceById(dicomInstanceId);
        if (instance == null)
        {
            return new ArrayList<>();
        }
        JSONObject tags = orthancService.getInstanceSimplifiedTags(instance.getOrthancInstanceId());
        return convertTags(tags);
    }

    public List<NdtDicomTagItem> updateTags(Long dicomInstanceId, List<NdtDicomTagItem> items)
    {
        NdtDicomInstance instance = dicomInstanceService.selectNdtDicomInstanceById(dicomInstanceId);
        if (instance == null)
        {
            return new ArrayList<>();
        }
        JSONObject payload = new JSONObject();
        for (NdtDicomTagItem item : items)
        {
            if (item == null || StringUtils.isEmpty(item.getTagName()))
            {
                continue;
            }
            if (!isEditableTag(item.getTagName()))
            {
                continue;
            }
            if (item.getValue() == null)
            {
                continue;
            }
            if (item.getOriginalValue() != null && item.getOriginalValue().equals(item.getValue()))
            {
                continue;
            }
            payload.put(item.getTagName(), item.getValue());
        }
        if (payload.isEmpty())
        {
            return selectTagsByInstanceId(dicomInstanceId);
        }
        NdtDicomUploadResult result = dicomInstanceService.replaceDicomTags(dicomInstanceId, payload,
                0L, "system");
        return selectTagsByInstanceId(result.getDicomInstanceId());
    }

    public boolean isEditableTag(String tagName)
    {
        return StringUtils.isNotEmpty(tagName) && EDITABLE_TAG_WHITELIST.contains(tagName);
    }

    private List<NdtDicomTagItem> convertTags(JSONObject tags)
    {
        List<NdtDicomTagItem> items = new ArrayList<>();
        if (tags == null)
        {
            return items;
        }
        for (Map.Entry<String, Object> entry : tags.entrySet())
        {
            NdtDicomTagItem item = new NdtDicomTagItem();
            item.setTagName(entry.getKey());
            item.setValue(entry.getValue() == null ? null : String.valueOf(entry.getValue()));
            item.setOriginalValue(item.getValue());
            item.setEditable(Boolean.TRUE);
            items.add(item);
        }
        return items;
    }

    private NdtOrthancHierarchyNode buildStudyNode(NdtDicomInstance instance, String studyKey)
    {
        NdtOrthancHierarchyNode node = new NdtOrthancHierarchyNode();
        node.setId("study-" + studyKey);
        node.setNodeType("STUDY");
        node.setOrthancId(instance.getOrthancStudyId());
        node.setStudyInstanceUid(instance.getStudyInstanceUid());
        node.setTitle(StringUtils.isNotEmpty(instance.getTaskName()) ? instance.getTaskName() : "Study");
        node.setSubtitle(instance.getStudyInstanceUid());
        node.setLeaf(Boolean.FALSE);
        return node;
    }

    private NdtOrthancHierarchyNode buildSeriesNode(NdtDicomInstance instance, NdtOrthancHierarchyNode study, String seriesKey)
    {
        NdtOrthancHierarchyNode node = new NdtOrthancHierarchyNode();
        node.setId(study.getId() + "-series-" + seriesKey);
        node.setParentId(study.getId());
        node.setNodeType("SERIES");
        node.setOrthancId(instance.getOrthancSeriesId());
        node.setStudyInstanceUid(instance.getStudyInstanceUid());
        node.setSeriesInstanceUid(instance.getSeriesInstanceUid());
        node.setModality(instance.getModality());
        node.setSeriesNumber(instance.getSeriesNumber());
        node.setTitle(StringUtils.isNotEmpty(instance.getSeriesDescription()) ? instance.getSeriesDescription() : "Series");
        node.setSubtitle(instance.getSeriesInstanceUid());
        node.setLeaf(Boolean.FALSE);
        return node;
    }

    private NdtOrthancHierarchyNode buildInstanceNode(NdtDicomInstance instance, NdtOrthancHierarchyNode series)
    {
        NdtOrthancHierarchyNode node = new NdtOrthancHierarchyNode();
        node.setId(series.getId() + "-instance-" + instance.getSopInstanceUid());
        node.setParentId(series.getId());
        node.setNodeType("INSTANCE");
        node.setOrthancId(instance.getOrthancInstanceId());
        node.setDicomInstanceId(instance.getId());
        node.setStudyInstanceUid(instance.getStudyInstanceUid());
        node.setSeriesInstanceUid(instance.getSeriesInstanceUid());
        node.setSopInstanceUid(instance.getSopInstanceUid());
        node.setInstanceNumber(instance.getInstanceNumber());
        node.setTitle(StringUtils.isNotEmpty(instance.getFileName()) ? instance.getFileName() : instance.getSopInstanceUid());
        node.setSubtitle(instance.getInstanceNumber());
        node.setLeaf(Boolean.TRUE);
        return node;
    }
}
