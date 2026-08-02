import request from '@/utils/request'

export const listCustomer = query => request({ url: '/ndt/customer/list', method: 'get', params: query })
export const getCustomer = id => request({ url: `/ndt/customer/${id}`, method: 'get' })
export const addCustomer = data => request({ url: '/ndt/customer', method: 'post', data })
export const updateCustomer = data => request({ url: '/ndt/customer', method: 'put', data })
export const delCustomer = ids => request({ url: `/ndt/customer/${ids}`, method: 'delete' })
