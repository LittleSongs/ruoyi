import request from '@/utils/request'

export function getOrthancHierarchy(query) {
  return request({ url: '/ndt/orthanc/hierarchy', method: 'get', params: query })
}

export function getOrthancTags(dicomInstanceId) {
  return request({ url: '/ndt/orthanc/' + dicomInstanceId + '/tags', method: 'get' })
}

export function updateOrthancTags(dicomInstanceId, data) {
  return request({ url: '/ndt/orthanc/' + dicomInstanceId + '/tags', method: 'put', data })
}
