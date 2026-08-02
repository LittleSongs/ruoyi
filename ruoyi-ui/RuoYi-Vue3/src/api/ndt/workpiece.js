import request from '@/utils/request'

export const listWorkpiece = query => request({ url: '/ndt/workpiece/list', method: 'get', params: query })
export const getWorkpiece = id => request({ url: `/ndt/workpiece/${id}`, method: 'get' })
export const addWorkpiece = data => request({ url: '/ndt/workpiece', method: 'post', data })
export const updateWorkpiece = data => request({ url: '/ndt/workpiece', method: 'put', data })
export const delWorkpiece = ids => request({ url: `/ndt/workpiece/${ids}`, method: 'delete' })
