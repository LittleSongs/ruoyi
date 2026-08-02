import request from '@/utils/request'

export const listEvaluationReview = evaluationId => request({ url: '/ndt/evaluation/review', method: 'get', params: { evaluationId } })
export const addEvaluationReview = data => request({ url: '/ndt/evaluation/review', method: 'post', data })
