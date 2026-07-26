package com.ruoyi.ndt.organization.domain;

import java.util.ArrayList;
import java.util.List;

public class NdtObjectTreeResponse
{
    private List<NdtObjectTreePart> parts = new ArrayList<>();
    private List<NdtObjectTreeItem> unassignedObjects = new ArrayList<>();

    public List<NdtObjectTreePart> getParts() { return parts; }
    public void setParts(List<NdtObjectTreePart> value) { this.parts = value; }
    public List<NdtObjectTreeItem> getUnassignedObjects() { return unassignedObjects; }
    public void setUnassignedObjects(List<NdtObjectTreeItem> value) { this.unassignedObjects = value; }
}
