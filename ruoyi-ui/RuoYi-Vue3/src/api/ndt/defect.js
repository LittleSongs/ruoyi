import request from '@/utils/request'

export const listDefect = query => request({ url: '/ndt/defect/list', method: 'get', params: query })
export const getDefect = id => request({ url: `/ndt/defect/${id}`, method: 'get' })
export const addDefect = data => request({ url: '/ndt/defect', method: 'post', data })
export const updateDefect = data => request({ url: '/ndt/defect', method: 'put', data })
export const delDefect = ids => request({ url: `/ndt/defect/${ids}`, method: 'delete' })
