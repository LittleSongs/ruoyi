import request from '@/utils/request'

export function listIntegrity(query) {
  return request({ url: '/ndt/integrity/list', method: 'get', params: query })
}

export function getIntegrity(id) {
  return request({ url: '/ndt/integrity/' + id, method: 'get' })
}

export function verifyIntegrity(dicomInstanceId) {
  return request({ url: '/ndt/integrity/verify/' + dicomInstanceId, method: 'post' })
}
