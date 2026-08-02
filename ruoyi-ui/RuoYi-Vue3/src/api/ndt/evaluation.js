import request from '@/utils/request'

export const listEvaluation = query => request({ url: '/ndt/evaluation/list', method: 'get', params: query })
export const getEvaluation = id => request({ url: `/ndt/evaluation/${id}`, method: 'get' })
export const addEvaluation = data => request({ url: '/ndt/evaluation', method: 'post', data })
export const updateEvaluation = data => request({ url: '/ndt/evaluation', method: 'put', data })
export const delEvaluation = ids => request({ url: `/ndt/evaluation/${ids}`, method: 'delete' })
export const submitEvaluation = id => request({ url: `/ndt/evaluation/${id}/submit`, method: 'post' })
export function submitEvaluationWithSr(id, sourceObjectId, file) {
  const data = new FormData()
  data.append('sourceObjectId', sourceObjectId)
  data.append('srFile', file)
  return request({ url: `/ndt/evaluation/${id}/submit-with-sr`, method: 'post', data, headers: { 'Content-Type': 'multipart/form-data' } })
}
