package com.ruoyi.ndt.evaluation.service.impl;

import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryItem;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryPart;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryResponse;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryRow;
import com.ruoyi.ndt.evaluation.service.NdtEvaluationHistoryService;
import com.ruoyi.ndt.organization.mapper.NdtDicomOrganizationMapper;

@Service
public class NdtEvaluationHistoryServiceImpl implements NdtEvaluationHistoryService
{
    private final NdtDicomOrganizationMapper organizationMapper;

    public NdtEvaluationHistoryServiceImpl(NdtDicomOrganizationMapper organizationMapper)
    {
        this.organizationMapper = organizationMapper;
    }

    @Override
    public NdtEvaluationHistoryResponse selectHistory(Long taskId, String sopInstanceUid)
    {
        Map<Long, NdtEvaluationHistoryPart> grouped = new LinkedHashMap<>();
        for (NdtEvaluationHistoryRow row : organizationMapper.selectEvaluationHistoryRows(taskId, sopInstanceUid))
        {
            NdtEvaluationHistoryPart part = grouped.computeIfAbsent(row.getPartId(), ignored -> toPart(row));
            if (row.getEvaluationId() != null)
            {
                part.getEvaluations().add(toItem(row));
            }
        }
        for (NdtEvaluationHistoryPart part : grouped.values())
        {
            part.getEvaluations().sort(Comparator
                    .comparing(NdtEvaluationHistoryItem::getEvaluateTime,
                            Comparator.nullsLast(Comparator.reverseOrder()))
                    .thenComparing(NdtEvaluationHistoryItem::getId,
                            Comparator.nullsLast(Comparator.reverseOrder())));
        }
        NdtEvaluationHistoryResponse response = new NdtEvaluationHistoryResponse();
        response.setParts(grouped.values().stream()
                .sorted(Comparator.comparing(NdtEvaluationHistoryPart::getPartNo,
                        Comparator.nullsLast(String::compareTo)))
                .toList());
        return response;
    }

    private NdtEvaluationHistoryPart toPart(NdtEvaluationHistoryRow row)
    {
        NdtEvaluationHistoryPart value = new NdtEvaluationHistoryPart();
        value.setId(row.getPartId());
        value.setPartNo(row.getPartNo());
        value.setPartName(row.getPartName());
        value.setSourceSopInstanceUid(row.getSourceSopInstanceUid());
        return value;
    }

    private NdtEvaluationHistoryItem toItem(NdtEvaluationHistoryRow row)
    {
        NdtEvaluationHistoryItem value = new NdtEvaluationHistoryItem();
        value.setId(row.getEvaluationId());
        value.setEvaluatorUserId(row.getEvaluatorUserId());
        value.setEvaluatorUserName(row.getEvaluatorUserName());
        value.setEvaluateTime(row.getEvaluateTime());
        value.setDefectType(row.getDefectType());
        value.setDefectLevel(row.getDefectLevel());
        value.setConclusion(row.getConclusion());
        value.setStatus(row.getStatus());
        return value;
    }
}
