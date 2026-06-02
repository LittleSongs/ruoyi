import request from '@/utils/request'

export function listEvaluation(query) {
  return request({ url: '/ndt/evaluation/list', method: 'get', params: query })
}

export function getEvaluation(id) {
  return request({ url: '/ndt/evaluation/' + id, method: 'get' })
}

export function addEvaluation(data) {
  return request({ url: '/ndt/evaluation', method: 'post', data })
}

export function updateEvaluation(data) {
  return request({ url: '/ndt/evaluation', method: 'put', data })
}

export function delEvaluation(ids) {
  return request({ url: '/ndt/evaluation/' + ids, method: 'delete' })
}
