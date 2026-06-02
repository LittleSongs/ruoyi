import request from '@/utils/request'

export function listEvaluation(query) {
  return request({
    url: '/dcm/evaluation/list',
    method: 'get',
    params: query
  })
}

export function getEvaluation(id) {
  return request({
    url: '/dcm/evaluation/' + id,
    method: 'get'
  })
}

export function getEvaluationByStudy(studyId) {
  return request({
    url: '/dcm/evaluation/byStudy/' + studyId,
    method: 'get'
  })
}

export function addEvaluation(data) {
  return request({
    url: '/dcm/evaluation',
    method: 'post',
    data
  })
}

export function updateEvaluation(data) {
  return request({
    url: '/dcm/evaluation',
    method: 'put',
    data
  })
}

export function delEvaluation(ids) {
  return request({
    url: '/dcm/evaluation/' + ids,
    method: 'delete'
  })
}
