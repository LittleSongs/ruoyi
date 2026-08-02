package com.ruoyi.ndt.dicom.controller;

import java.io.IOException;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.dto.NdtDicomDerivedObjectDto;
import com.ruoyi.ndt.dicom.service.INdtDicomObjectService;

@RestController @RequestMapping("/ndt/dicom/object")
public class NdtDicomObjectController extends BaseController
{
    private final INdtDicomObjectService service;
    public NdtDicomObjectController(INdtDicomObjectService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')") @GetMapping("/list")
    public TableDataInfo list(NdtDicomObject query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')") @Log(title="NDT DICOM对象",businessType=BusinessType.INSERT)
    @PostMapping("/upload") public AjaxResult upload(@RequestParam Long positionId,@RequestParam MultipartFile file){return success(service.uploadOriginal(positionId,file,getUserId(),getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')") @Log(title="NDT衍生对象",businessType=BusinessType.INSERT)
    @PostMapping("/derived") public AjaxResult derived(@RequestBody NdtDicomDerivedObjectDto dto){return success(service.createDerived(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')") @Log(title="NDT影像派生对象",businessType=BusinessType.INSERT)
    @PostMapping("/derived/upload")
    public AjaxResult uploadDerived(@RequestParam Long sourceObjectId,@RequestParam String objectType,
            @RequestParam MultipartFile file)
    {
        return success(service.uploadDerivedImageDicom(sourceObjectId,objectType,file,getUserId(),getUsername()));
    }
    @PreAuthorize("@ss.hasPermi('ndt:dicom:download')") @GetMapping("/{id}/download")
    public void download(@PathVariable Long id,HttpServletResponse response) throws IOException
    {
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION,"attachment; filename=\"ndt-object-"+id+".dcm\"");
        response.getOutputStream().write(service.download(id));
    }
    @PreAuthorize("@ss.hasPermi('ndt:dicom:query')") @GetMapping("/{id}/tags") public AjaxResult tags(@PathVariable Long id){return success(service.tags(id));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:query')") @GetMapping("/{id}/relations") public AjaxResult relations(@PathVariable Long id){return success(service.relations(id));}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:remove')") @Log(title="NDT DICOM对象",businessType=BusinessType.DELETE)
    @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids){return toAjax(service.deleteByIds(ids));}
}
