import request from '@/utils/request'

export function listReport(query) {
  return request({ url: '/ndt/report/list', method: 'get', params: query })
}
