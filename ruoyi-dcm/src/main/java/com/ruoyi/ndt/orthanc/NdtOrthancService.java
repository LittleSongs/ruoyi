package com.ruoyi.ndt.orthanc;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.domain.NdtDicomTagItem;
import com.ruoyi.ndt.dicom.service.INdtDicomObjectService;

@Service
public class NdtOrthancService
{
    private final OrthancService orthanc;
    private final INdtDicomObjectService objectService;
    public NdtOrthancService(OrthancService orthanc,INdtDicomObjectService objectService)
    {
        this.orthanc=orthanc;this.objectService=objectService;
    }
    public List<NdtOrthancHierarchyNode> selectHierarchy(Long taskId)
    {
        NdtDicomObject query=new NdtDicomObject();query.setTaskId(taskId);
        Map<String,NdtOrthancHierarchyNode> studies=new LinkedHashMap<>();
        Map<String,NdtOrthancHierarchyNode> seriesMap=new LinkedHashMap<>();
        for(NdtDicomObject object:objectService.selectList(query))
        {
            String studyKey=StringUtils.isEmpty(object.getStudyUid())?"NO_STUDY":object.getStudyUid();
            String seriesKey=studyKey+"|"+(StringUtils.isEmpty(object.getSeriesUid())?"NO_SERIES":object.getSeriesUid());
            NdtOrthancHierarchyNode study=studies.computeIfAbsent(studyKey,key->study(object,key));
            NdtOrthancHierarchyNode series=seriesMap.get(seriesKey);
            if(series==null){series=series(object,study,seriesKey);seriesMap.put(seriesKey,series);study.getChildren().add(series);}
            series.getChildren().add(instance(object,series));
        }
        return new ArrayList<>(studies.values());
    }
    public List<NdtDicomTagItem> selectTagsByObjectId(Long objectId)
    {
        NdtDicomObject object=objectService.selectById(objectId);
        JSONObject tags=orthanc.getInstanceTags(object.getOrthancInstanceId());
        List<NdtDicomTagItem> result=new ArrayList<>();
        for(Map.Entry<String,Object> entry:tags.entrySet())
        {
            NdtDicomTagItem item=new NdtDicomTagItem();item.setTagName(entry.getKey());
            item.setTagLabel(entry.getKey());item.setValue(extract(entry.getValue()));
            item.setOriginalValue(item.getValue());item.setEditable(Boolean.FALSE);item.setConfigured(Boolean.FALSE);
            result.add(item);
        }
        return result;
    }
    private String extract(Object value)
    {
        if(value instanceof JSONObject json){Object inner=json.get("Value");return inner==null?null:String.valueOf(inner);}
        return value==null?null:String.valueOf(value);
    }
    private NdtOrthancHierarchyNode study(NdtDicomObject object,String key)
    {
        NdtOrthancHierarchyNode node=new NdtOrthancHierarchyNode();node.setId("study-"+key);
        node.setNodeType("STUDY");node.setStudyInstanceUid(object.getStudyUid());
        node.setTitle("Study");node.setSubtitle(object.getStudyUid());node.setLeaf(Boolean.FALSE);return node;
    }
    private NdtOrthancHierarchyNode series(NdtDicomObject object,NdtOrthancHierarchyNode parent,String key)
    {
        NdtOrthancHierarchyNode node=new NdtOrthancHierarchyNode();node.setId("series-"+key);
        node.setParentId(parent.getId());node.setNodeType("SERIES");node.setStudyInstanceUid(object.getStudyUid());
        node.setSeriesInstanceUid(object.getSeriesUid());node.setTitle("Series");node.setSubtitle(object.getSeriesUid());
        node.setLeaf(Boolean.FALSE);return node;
    }
    private NdtOrthancHierarchyNode instance(NdtDicomObject object,NdtOrthancHierarchyNode parent)
    {
        NdtOrthancHierarchyNode node=new NdtOrthancHierarchyNode();node.setId("object-"+object.getId());
        node.setParentId(parent.getId());node.setNodeType("OBJECT");node.setOrthancId(object.getOrthancInstanceId());
        node.setObjectId(object.getId());node.setStudyInstanceUid(object.getStudyUid());
        node.setSeriesInstanceUid(object.getSeriesUid());node.setSopInstanceUid(object.getSopInstanceUid());
        node.setTitle(StringUtils.isEmpty(object.getObjectName())?object.getSopInstanceUid():object.getObjectName());
        node.setSubtitle(object.getObjectType());node.setLeaf(Boolean.TRUE);return node;
    }
}
