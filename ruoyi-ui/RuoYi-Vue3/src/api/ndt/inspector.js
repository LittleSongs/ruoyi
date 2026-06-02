import request from '@/utils/request'

export function listInspector(query) {
  return request({ url: '/ndt/inspector/list', method: 'get', params: query })
}

export function getInspector(id) {
  return request({ url: '/ndt/inspector/' + id, method: 'get' })
}

export function getInspectorByUser(userId) {
  return request({ url: '/ndt/inspector/user/' + userId, method: 'get' })
}

export function addInspector(data) {
  return request({ url: '/ndt/inspector', method: 'post', data })
}

export function updateInspector(data) {
  return request({ url: '/ndt/inspector', method: 'put', data })
}

export function delInspector(ids) {
  return request({ url: '/ndt/inspector/' + ids, method: 'delete' })
}
