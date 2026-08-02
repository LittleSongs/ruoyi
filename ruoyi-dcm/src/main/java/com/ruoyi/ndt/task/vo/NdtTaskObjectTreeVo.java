package com.ruoyi.ndt.task.vo;

import java.util.ArrayList;
import java.util.List;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;

public class NdtTaskObjectTreeVo
{
    private Long taskId;
    private List<WorkpieceNode> workpieces = new ArrayList<>();

    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public List<WorkpieceNode> getWorkpieces() { return workpieces; }
    public void setWorkpieces(List<WorkpieceNode> workpieces) { this.workpieces = workpieces; }

    public static class WorkpieceNode
    {
        private Long id;
        private String workpieceName;
        private String status;
        private List<StudyNode> studies = new ArrayList<>();
        private List<PositionNode> positions = new ArrayList<>();
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getWorkpieceName() { return workpieceName; }
        public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public List<StudyNode> getStudies() { return studies; }
        public void setStudies(List<StudyNode> studies) { this.studies = studies; }
        public List<PositionNode> getPositions() { return positions; }
        public void setPositions(List<PositionNode> positions) { this.positions = positions; }
    }

    public static class StudyNode
    {
        private Long id;
        private String studyInstanceUid;
        private String inspectionMethodCode;
        private String studyDescription;
        private List<SeriesNode> series = new ArrayList<>();
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getStudyInstanceUid() { return studyInstanceUid; }
        public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
        public String getInspectionMethodCode() { return inspectionMethodCode; }
        public void setInspectionMethodCode(String inspectionMethodCode) { this.inspectionMethodCode = inspectionMethodCode; }
        public String getStudyDescription() { return studyDescription; }
        public void setStudyDescription(String studyDescription) { this.studyDescription = studyDescription; }
        public List<SeriesNode> getSeries() { return series; }
        public void setSeries(List<SeriesNode> series) { this.series = series; }
    }

    public static class SeriesNode
    {
        private Long id;
        private Long positionId;
        private String seriesInstanceUid;
        private String modality;
        private String seriesDescription;
        private List<NdtDicomObject> objects = new ArrayList<>();
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public Long getPositionId() { return positionId; }
        public void setPositionId(Long positionId) { this.positionId = positionId; }
        public String getSeriesInstanceUid() { return seriesInstanceUid; }
        public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
        public String getModality() { return modality; }
        public void setModality(String modality) { this.modality = modality; }
        public String getSeriesDescription() { return seriesDescription; }
        public void setSeriesDescription(String seriesDescription) { this.seriesDescription = seriesDescription; }
        public List<NdtDicomObject> getObjects() { return objects; }
        public void setObjects(List<NdtDicomObject> objects) { this.objects = objects; }
    }

    public static class PositionNode
    {
        private Long id;
        private String positionCode;
        private String positionName;
        private List<NdtDicomObject> objects = new ArrayList<>();
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getPositionCode() { return positionCode; }
        public void setPositionCode(String positionCode) { this.positionCode = positionCode; }
        public String getPositionName() { return positionName; }
        public void setPositionName(String positionName) { this.positionName = positionName; }
        public List<NdtDicomObject> getObjects() { return objects; }
        public void setObjects(List<NdtDicomObject> objects) { this.objects = objects; }
    }
}
