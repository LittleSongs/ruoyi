import request from '@/utils/request'

export const listPosition = query => request({ url: '/ndt/position/list', method: 'get', params: query })
export const getPosition = id => request({ url: `/ndt/position/${id}`, method: 'get' })
export const addPosition = data => request({ url: '/ndt/position', method: 'post', data })
export const updatePosition = data => request({ url: '/ndt/position', method: 'put', data })
export const delPosition = ids => request({ url: `/ndt/position/${ids}`, method: 'delete' })
