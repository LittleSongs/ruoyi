import request from '@/utils/request'

export function getOrthancHierarchy(taskId) {
  return request({ url: '/ndt/orthanc/hierarchy', method: 'get', params: { taskId } })
}

export function getOrthancTags(objectId) {
  return request({ url: '/ndt/orthanc/' + objectId + '/tags', method: 'get' })
}
