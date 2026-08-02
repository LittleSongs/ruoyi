import request from '@/utils/request'

export function listIntegrity(query) {
  return request({ url: '/ndt/integrity/list', method: 'get', params: query })
}

export function getIntegrity(id) {
  return request({ url: '/ndt/integrity/' + id, method: 'get' })
}

export function verifyIntegrity(objectId) {
  return request({ url: '/ndt/integrity/verify/' + objectId, method: 'post' })
}
