import request from '@/utils/request'

export const listStudy = query => request({ url: '/ndt/study/list', method: 'get', params: query })
export const getStudy = id => request({ url: `/ndt/study/${id}`, method: 'get' })
export const getStudyOhif = id => request({ url: `/ndt/study/${id}/ohif`, method: 'get' })
