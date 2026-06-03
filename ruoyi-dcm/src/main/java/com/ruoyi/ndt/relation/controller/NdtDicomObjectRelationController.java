package com.ruoyi.ndt.relation.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;

/**
 * Anonymous relation queries used by the embedded OHIF viewer.
 */
@RestController
@RequestMapping("/ndt/dicom/relation")
@Anonymous
public class NdtDicomObjectRelationController extends BaseController
{
    @Autowired
    private NdtDicomObjectRelationMapper relationMapper;

    @Autowired
    private NdtEvaluationMapper evaluationMapper;

    @Anonymous
    @GetMapping("/current")
    public AjaxResult current(@RequestParam Map<String, String> params)
    {
        Long taskId = parseLong(params.get("taskId"));
        String sopInstanceUid = first(params, "sopInstanceUID", "sopInstanceUid");
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("processedImages", new ArrayList<>());
        result.put("snapshots", new ArrayList<>());
        result.put("srReports", new ArrayList<>());
        result.put("evaluations", new ArrayList<>());
        if (taskId == null || StringUtils.isEmpty(sopInstanceUid))
        {
            return success(result);
        }

        NdtDicomObjectRelation relationQuery = new NdtDicomObjectRelation();
        relationQuery.setTaskId(taskId);
        relationQuery.setSourceSopInstanceUid(sopInstanceUid);
        List<NdtDicomObjectRelation> relations = relationMapper.selectNdtDicomObjectRelationList(relationQuery);
        result.put("processedImages", filterRelations(relations, NdtConstants.RELATED_TYPE_PROCESSED_IMAGE));
        result.put("snapshots", filterRelations(relations, NdtConstants.RELATED_TYPE_SNAPSHOT));
        result.put("srReports", distinctSrReports(filterRelations(relations, NdtConstants.RELATED_TYPE_SR)));

        NdtEvaluation evaluationQuery = new NdtEvaluation();
        evaluationQuery.setTaskId(taskId);
        evaluationQuery.setSopInstanceUid(sopInstanceUid);
        result.put("evaluations", evaluationMapper.selectNdtEvaluationList(evaluationQuery));
        return success(result);
    }

    private List<NdtDicomObjectRelation> filterRelations(List<NdtDicomObjectRelation> relations, String relatedType)
    {
        List<NdtDicomObjectRelation> result = new ArrayList<>();
        if (relations == null)
        {
            return result;
        }
        for (NdtDicomObjectRelation relation : relations)
        {
            if (relatedType.equals(relation.getRelatedType()))
            {
                result.add(relation);
            }
        }
        return result;
    }

    private List<NdtDicomObjectRelation> distinctSrReports(List<NdtDicomObjectRelation> relations)
    {
        Map<String, NdtDicomObjectRelation> bySop = new LinkedHashMap<>();
        for (NdtDicomObjectRelation relation : relations)
        {
            String key = relation.getRelatedSopInstanceUid();
            if (StringUtils.isNotEmpty(key) && !bySop.containsKey(key))
            {
                bySop.put(key, relation);
            }
        }
        return new ArrayList<>(bySop.values());
    }

    private String first(Map<String, String> params, String firstKey, String secondKey)
    {
        String value = params.get(firstKey);
        return StringUtils.isEmpty(value) ? params.get(secondKey) : value;
    }

    private Long parseLong(String value)
    {
        if (StringUtils.isEmpty(value))
        {
            return null;
        }
        try
        {
            return Long.valueOf(value);
        }
        catch (NumberFormatException ex)
        {
            return null;
        }
    }
}
