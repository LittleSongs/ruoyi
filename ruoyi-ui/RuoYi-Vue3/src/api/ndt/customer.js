import request from '@/utils/request'

export const listCustomer = query => request({ url: '/ndt/customer/list', method: 'get', params: query })
export const getCustomer = id => request({ url: `/ndt/customer/${id}`, method: 'get' })
export const addCustomer = data => request({ url: '/ndt/customer', method: 'post', data })
export const updateCustomer = data => request({ url: '/ndt/customer', method: 'put', data })
export const delCustomer = ids => request({ url: `/ndt/customer/${ids}`, method: 'delete' })

export const listCustomerAccounts = (customerId, query) => request({ url: `/ndt/customer/${customerId}/accounts`, method: 'get', params: query })
export const addCustomerAccount = (customerId, data) => request({ url: `/ndt/customer/${customerId}/accounts`, method: 'post', data })
export const updateCustomerAccount = (customerId, userId, data) => request({ url: `/ndt/customer/${customerId}/accounts/${userId}`, method: 'put', data })
export const delCustomerAccount = (customerId, userId) => request({ url: `/ndt/customer/${customerId}/accounts/${userId}`, method: 'delete' })
export const resetCustomerAccountPassword = (customerId, userId, password) => request({ url: `/ndt/customer/${customerId}/accounts/${userId}/password`, method: 'put', data: { password } })
