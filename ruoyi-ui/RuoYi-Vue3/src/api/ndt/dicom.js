import request from '@/utils/request'

export function listDicom(query) {
  return request({ url: '/ndt/dicom/list', method: 'get', params: query })
}

export function getDicom(id) {
  return request({ url: '/ndt/dicom/' + id, method: 'get' })
}

export function getDicomTags(id) {
  return request({ url: '/ndt/dicom/' + id + '/tags', method: 'get' })
}

export function getDicomTagOptions(id) {
  return request({ url: '/ndt/dicom/' + id + '/tag-options', method: 'get' })
}

export function addDicomTag(id, data) {
  return request({ url: '/ndt/dicom/' + id + '/tags', method: 'post', data })
}

export function updateDicomTag(id, data) {
  return request({ url: '/ndt/dicom/' + id + '/tags', method: 'put', data })
}

export function removeDicomTag(id, data) {
  return request({ url: '/ndt/dicom/' + id + '/tags', method: 'delete', data })
}

export function downloadDicom(id) {
  return request({ url: '/ndt/dicom/download/' + id, method: 'get' })
}

export function uploadDicom(taskId, file) {
  const formData = new FormData()
  formData.append('taskId', taskId)
  formData.append('file', file)
  return request({
    url: '/ndt/dicom/upload',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
