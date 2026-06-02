import request from '@/utils/request'

export function listUidRule(query) {
  return request({ url: '/ndt/uidRule/list', method: 'get', params: query })
}

export function getUidRule(id) {
  return request({ url: '/ndt/uidRule/' + id, method: 'get' })
}

export function addUidRule(data) {
  return request({ url: '/ndt/uidRule', method: 'post', data })
}

export function updateUidRule(data) {
  return request({ url: '/ndt/uidRule', method: 'put', data })
}

export function delUidRule(ids) {
  return request({ url: '/ndt/uidRule/' + ids, method: 'delete' })
}

export function generateUid(params) {
  return request({ url: '/ndt/uidRule/generate', method: 'get', params })
}
