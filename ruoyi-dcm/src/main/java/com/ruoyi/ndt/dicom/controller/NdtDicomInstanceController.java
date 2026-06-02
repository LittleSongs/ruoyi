package com.ruoyi.ndt.dicom.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.service.INdtDicomInstanceService;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.security.NdtAccessService;

@RestController
@RequestMapping("/ndt/dicom")
public class NdtDicomInstanceController extends BaseController
{
    @Autowired
    private INdtDicomInstanceService dicomInstanceService;

    @Autowired
    private NdtDicomObjectRelationMapper objectRelationMapper;

    @Autowired
    private NdtEvaluationMapper evaluationMapper;

    @Autowired
    private NdtAccessService accessService;

    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtDicomInstance instance)
    {
        startPage();
        List<NdtDicomInstance> list = dicomInstanceService.selectNdtDicomInstanceList(instance);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(dicomInstanceService.selectNdtDicomInstanceById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')")
    @Log(title = "NDT DICOM上传", businessType = BusinessType.IMPORT)
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("taskId") Long taskId, @RequestParam("file") MultipartFile file)
    {
        return success(dicomInstanceService.uploadDicom(taskId, file, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:download')")
    @Log(title = "NDT DICOM下载", businessType = BusinessType.EXPORT)
    @GetMapping("/download/{id}")
    public void download(@PathVariable Long id, HttpServletResponse response) throws Exception
    {
        byte[] content = dicomInstanceService.downloadDicom(id);
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
        FileUtils.setAttachmentResponseHeader(response, "dicom-" + id + ".dcm");
        response.getOutputStream().write(content);
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:ohif')")
    @GetMapping("/{id}/ohif")
    public AjaxResult ohif(@PathVariable Long id)
    {
        return AjaxResult.success("操作成功", dicomInstanceService.getOhifViewerUrl(id));
    }

    // TODO: 临时放开用于前端联调测试，后续需要恢复任务权限校验。
    // 当前仅用于验证 OHIF 侧关联对象面板是否能正常读取数据。
    @Anonymous
    @GetMapping("/relation/current")
    public AjaxResult currentRelation(@RequestParam Long taskId,
            @RequestParam(required = false) String studyInstanceUID,
            @RequestParam(required = false) String seriesInstanceUID,
            @RequestParam String sopInstanceUID)
    {
        NdtDicomObjectRelation query = new NdtDicomObjectRelation();
        query.setTaskId(taskId);
        query.setSourceSopInstanceUid(sopInstanceUID);
        List<NdtDicomObjectRelation> relations = objectRelationMapper.selectNdtDicomObjectRelationList(query);

        NdtEvaluation evaluationQuery = new NdtEvaluation();
        evaluationQuery.setTaskId(taskId);
        evaluationQuery.setStudyInstanceUid(studyInstanceUID);
        evaluationQuery.setSeriesInstanceUid(seriesInstanceUID);
        evaluationQuery.setSopInstanceUid(sopInstanceUID);
        List<NdtEvaluation> evaluations = evaluationMapper.selectNdtEvaluationList(evaluationQuery);

        Map<String, Object> data = new HashMap<>();
        data.put("processedImages", filterRelations(relations, "PROCESSED_IMAGE"));
        data.put("snapshots", filterRelations(relations, "SNAPSHOT"));
        data.put("srReports", filterRelations(relations, "SR"));
        data.put("evaluations", evaluations);
        return success(data);
    }

    private List<NdtDicomObjectRelation> filterRelations(List<NdtDicomObjectRelation> relations, String relatedType)
    {
        return relations.stream()
                .filter(relation -> relatedType.equals(relation.getRelatedType()))
                .collect(Collectors.toList());
    }
}
