import request from '@/utils/request'

export const listDicomObject = query => request({ url: '/ndt/dicom/object/list', method: 'get', params: query })
export const getDicomObject = id => request({ url: `/ndt/dicom/object/${id}`, method: 'get' })
export const getObjectTags = id => request({ url: `/ndt/dicom/object/${id}/tags`, method: 'get' })
export const getObjectRelations = id => request({ url: `/ndt/dicom/object/${id}/relations`, method: 'get' })
export const createDerivedObject = data => request({ url: '/ndt/dicom/object/derived', method: 'post', data })
export const deleteDicomObject = ids => request({ url: `/ndt/dicom/object/${ids}`, method: 'delete' })
export const downloadDicomObject = id => request({ url: `/ndt/dicom/object/${id}/download`, method: 'get', responseType: 'blob' })
export function uploadDicomObject(positionId, file) {
  const data = new FormData()
  data.append('positionId', positionId)
  data.append('file', file)
  return request({ url: '/ndt/dicom/object/upload', method: 'post', data, headers: { 'Content-Type': 'multipart/form-data' } })
}

export function uploadDerivedDicomObject(sourceObjectId, objectType, file) {
  const data = new FormData()
  data.append('sourceObjectId', sourceObjectId)
  data.append('objectType', objectType)
  data.append('file', file)
  return request({ url: '/ndt/dicom/object/derived/upload', method: 'post', data, headers: { 'Content-Type': 'multipart/form-data' } })
}
