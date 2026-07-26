package com.ruoyi.ndt.organization.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.organization.domain.NdtDicomSeries;
import com.ruoyi.ndt.organization.domain.NdtInspectionPart;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeItem;
import com.ruoyi.ndt.organization.domain.NdtObjectTreePart;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeResponse;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeRow;
import com.ruoyi.ndt.organization.domain.NdtPartDicomObject;
import com.ruoyi.ndt.organization.mapper.NdtDicomOrganizationMapper;
import com.ruoyi.ndt.organization.service.NdtDicomOrganizationService;

@Service
public class NdtDicomOrganizationServiceImpl implements NdtDicomOrganizationService
{
    private final NdtDicomOrganizationMapper organizationMapper;
    private final NdtDicomInstanceMapper instanceMapper;

    public NdtDicomOrganizationServiceImpl(NdtDicomOrganizationMapper organizationMapper,
            NdtDicomInstanceMapper instanceMapper)
    {
        this.organizationMapper = organizationMapper;
        this.instanceMapper = instanceMapper;
    }

    @Override
    @Transactional
    public void registerOriginal(Long taskId, Long dicomInstanceId)
    {
        NdtDicomInstance instance = requireInstance(taskId, dicomInstanceId);
        syncSeries(instance, NdtConstants.OBJECT_TYPE_ORIGINAL);
        NdtInspectionPart part = organizationMapper.selectPartBySourceSop(taskId,
                instance.getSopInstanceUid());
        if (part == null)
        {
            part = new NdtInspectionPart();
            part.setTaskId(taskId);
            part.setPartNo(String.format("P-%06d", instance.getId()));
            part.setPartName(firstNonBlank(instance.getSeriesDescription(), instance.getFileName(), part.getPartNo()));
            part.setSourceDicomInstanceId(instance.getId());
            part.setSourceSopInstanceUid(instance.getSopInstanceUid());
            part.setSortOrder(safeInteger(instance.getId()));
            organizationMapper.insertInspectionPart(part);
        }
        insertMembership(taskId, part.getId(), instance.getId(), NdtConstants.OBJECT_TYPE_ORIGINAL, "1");
    }

    @Override
    @Transactional
    public void registerRelated(Long taskId, Long dicomInstanceId, Collection<String> sourceSopUids,
            String objectType)
    {
        NdtDicomInstance instance = requireInstance(taskId, dicomInstanceId);
        String normalizedType = normalizeType(objectType);
        syncSeries(instance, normalizedType);
        if (sourceSopUids == null)
        {
            return;
        }
        Set<String> distinctSources = new LinkedHashSet<>();
        for (String sourceSopUid : sourceSopUids)
        {
            if (sourceSopUid != null && !sourceSopUid.isBlank())
            {
                distinctSources.add(sourceSopUid);
            }
        }
        Map<Long, NdtInspectionPart> targetParts = new LinkedHashMap<>();
        for (String sourceSopUid : distinctSources)
        {
            NdtInspectionPart part = organizationMapper.selectPartBySourceSop(taskId, sourceSopUid);
            if (part != null)
            {
                targetParts.put(part.getId(), part);
            }
            List<NdtInspectionPart> memberParts = organizationMapper.selectPartsByObjectSop(taskId, sourceSopUid);
            if (memberParts != null)
            {
                for (NdtInspectionPart memberPart : memberParts)
                {
                    targetParts.put(memberPart.getId(), memberPart);
                }
            }
        }
        for (NdtInspectionPart part : targetParts.values())
        {
            insertMembership(taskId, part.getId(), instance.getId(), normalizedType, "0");
        }
    }

    @Override
    public NdtObjectTreeResponse selectObjectTree(Long taskId)
    {
        NdtObjectTreeResponse response = new NdtObjectTreeResponse();
        Map<Long, NdtObjectTreePart> parts = new LinkedHashMap<>();
        for (NdtObjectTreeRow row : organizationMapper.selectObjectTreeRows(taskId))
        {
            NdtObjectTreePart part = parts.computeIfAbsent(row.getPartId(), ignored -> toPart(row));
            part.getObjects().add(toItem(row));
        }
        Comparator<NdtObjectTreeItem> objectComparator = Comparator
                .comparingInt((NdtObjectTreeItem item) -> roleOrder(item.getObjectType()))
                .thenComparingInt(item -> numericOrder(item.getInstanceNumber()))
                .thenComparing(NdtObjectTreeItem::getCreateTime,
                        Comparator.nullsLast(Date::compareTo))
                .thenComparing(NdtObjectTreeItem::getId, Comparator.nullsLast(Long::compareTo));
        for (NdtObjectTreePart part : parts.values())
        {
            part.getObjects().sort(objectComparator);
        }
        List<NdtObjectTreePart> orderedParts = new ArrayList<>(parts.values());
        orderedParts.sort(Comparator.comparing(NdtObjectTreePart::getPartNo,
                Comparator.nullsLast(String::compareTo)));
        response.setParts(orderedParts);
        List<NdtObjectTreeItem> unassigned = organizationMapper.selectUnassignedObjectRows(taskId)
                .stream().map(this::toItem).sorted(objectComparator).toList();
        response.setUnassignedObjects(new ArrayList<>(unassigned));
        return response;
    }

    private NdtDicomInstance requireInstance(Long taskId, Long dicomInstanceId)
    {
        NdtDicomInstance instance = instanceMapper.selectNdtDicomInstanceById(dicomInstanceId);
        if (instance == null || taskId == null || !taskId.equals(instance.getTaskId()))
        {
            throw new ServiceException("DICOM instance does not belong to the task");
        }
        return instance;
    }

    private void syncSeries(NdtDicomInstance instance, String objectType)
    {
        NdtDicomSeries series = new NdtDicomSeries();
        series.setTaskId(instance.getTaskId());
        series.setStudyInstanceUid(instance.getStudyInstanceUid());
        series.setSeriesInstanceUid(instance.getSeriesInstanceUid());
        series.setOrthancSeriesId(instance.getOrthancSeriesId());
        series.setModality(instance.getModality());
        series.setSeriesNumber(instance.getSeriesNumber());
        series.setSeriesDescription(instance.getSeriesDescription());
        series.setSeriesRole(objectType);
        organizationMapper.upsertDicomSeries(series);
        instance.setDicomSeriesId(organizationMapper.selectSeriesIdByUid(instance.getSeriesInstanceUid()));
        instance.setObjectType(objectType);
        instanceMapper.updateNdtDicomInstance(instance);
    }

    private void insertMembership(Long taskId, Long partId, Long instanceId, String role, String primaryFlag)
    {
        NdtPartDicomObject membership = new NdtPartDicomObject();
        membership.setTaskId(taskId);
        membership.setPartId(partId);
        membership.setDicomInstanceId(instanceId);
        membership.setObjectRole(role);
        membership.setSortOrder(safeInteger(instanceId));
        membership.setPrimaryFlag(primaryFlag);
        organizationMapper.insertPartObject(membership);
    }

    private NdtObjectTreePart toPart(NdtObjectTreeRow row)
    {
        NdtObjectTreePart part = new NdtObjectTreePart();
        part.setId(row.getPartId());
        part.setPartNo(row.getPartNo());
        part.setPartName(row.getPartName());
        part.setSourceDicomInstanceId(row.getSourceDicomInstanceId());
        part.setSourceSopInstanceUid(row.getSourceSopInstanceUid());
        return part;
    }

    private NdtObjectTreeItem toItem(NdtObjectTreeRow row)
    {
        NdtObjectTreeItem item = new NdtObjectTreeItem();
        item.setId(row.getDicomInstanceId());
        item.setObjectType(normalizeType(row.getObjectType()));
        item.setLabel(labelFor(item.getObjectType(), row.getSeriesDescription(), row.getInstanceNumber()));
        item.setStudyInstanceUid(row.getStudyInstanceUid());
        item.setSeriesInstanceUid(row.getSeriesInstanceUid());
        item.setSopInstanceUid(row.getSopInstanceUid());
        item.setModality(row.getModality());
        item.setSeriesNumber(row.getSeriesNumber());
        item.setInstanceNumber(row.getInstanceNumber());
        item.setSeriesDescription(row.getSeriesDescription());
        item.setCreateTime(row.getCreateTime());
        return item;
    }

    private String normalizeType(String value)
    {
        if (value == null || value.isBlank())
        {
            return NdtConstants.OBJECT_TYPE_OTHER_DERIVED;
        }
        return value;
    }

    private String labelFor(String type, String description, String instanceNumber)
    {
        String role = switch (type)
        {
            case NdtConstants.OBJECT_TYPE_ORIGINAL -> "原始图像";
            case NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE -> "处理图像";
            case NdtConstants.OBJECT_TYPE_SNAPSHOT -> "截图";
            case NdtConstants.OBJECT_TYPE_PRESENTATION_STATE -> "标注状态";
            case NdtConstants.OBJECT_TYPE_SR -> "结构化报告";
            default -> "其他衍生对象";
        };
        String suffix = firstNonBlank(description, instanceNumber == null ? null : "#" + instanceNumber);
        return suffix == null ? role : role + " · " + suffix;
    }

    private int roleOrder(String type)
    {
        return switch (normalizeType(type))
        {
            case NdtConstants.OBJECT_TYPE_ORIGINAL -> 10;
            case NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE -> 20;
            case NdtConstants.OBJECT_TYPE_SNAPSHOT -> 30;
            case NdtConstants.OBJECT_TYPE_PRESENTATION_STATE -> 40;
            case NdtConstants.OBJECT_TYPE_SR -> 50;
            case NdtConstants.OBJECT_TYPE_OTHER_DERIVED -> 60;
            default -> 99;
        };
    }

    private int numericOrder(String value)
    {
        try { return value == null ? Integer.MAX_VALUE : Integer.parseInt(value); }
        catch (NumberFormatException ignored) { return Integer.MAX_VALUE; }
    }

    private int safeInteger(Long value)
    {
        return value == null ? 0 : (int) Math.min(value, Integer.MAX_VALUE);
    }

    private String firstNonBlank(String... values)
    {
        for (String value : values)
        {
            if (value != null && !value.isBlank()) return value;
        }
        return null;
    }
}
