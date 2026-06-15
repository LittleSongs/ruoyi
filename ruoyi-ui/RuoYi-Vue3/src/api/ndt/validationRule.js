import request from '@/utils/request'

export function listValidationRule(query) {
  return request({ url: '/dcm/validationRule/list', method: 'get', params: query })
}

export function getValidationRule(ruleId) {
  return request({ url: '/dcm/validationRule/' + ruleId, method: 'get' })
}

export function addValidationRule(data) {
  return request({ url: '/dcm/validationRule', method: 'post', data })
}

export function updateValidationRule(data) {
  return request({ url: '/dcm/validationRule', method: 'put', data })
}

export function delValidationRule(ruleIds) {
  return request({ url: '/dcm/validationRule/' + ruleIds, method: 'delete' })
}
