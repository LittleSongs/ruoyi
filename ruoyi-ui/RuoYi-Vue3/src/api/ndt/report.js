import request from '@/utils/request'

export const listReport = query => request({ url: '/ndt/report/list', method: 'get', params: query })
export const getReport = id => request({ url: `/ndt/report/${id}`, method: 'get' })
export const downloadReport = id => request({ url: `/ndt/report/${id}/download`, method: 'get', responseType: 'blob' })
export const updateReportStatus = (id, status) => request({ url: `/ndt/report/${id}/status`, method: 'put', params: { status } })
export const delReport = id => request({ url: `/ndt/report/${id}`, method: 'delete' })
export function uploadReport(taskId, file) {
  const data = new FormData()
  data.append('taskId', taskId)
  data.append('file', file)
  return request({ url: '/ndt/report/upload', method: 'post', data, headers: { 'Content-Type': 'multipart/form-data' } })
}
