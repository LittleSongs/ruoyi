import request from '@/utils/request'

export function listTask(query) {
  return request({ url: '/ndt/task/list', method: 'get', params: query })
}

export function getTask(id) {
  return request({ url: '/ndt/task/' + id, method: 'get' })
}

export function addTask(data) {
  return request({ url: '/ndt/task', method: 'post', data })
}

export function updateTask(data) {
  return request({ url: '/ndt/task', method: 'put', data })
}

export function delTask(ids) {
  return request({ url: '/ndt/task/' + ids, method: 'delete' })
}

export function listTaskUsers(taskId) {
  return request({ url: '/ndt/task/' + taskId + '/users', method: 'get' })
}

export function assignTaskUsers(taskId, data) {
  return request({ url: '/ndt/task/' + taskId + '/users', method: 'put', data })
}

export function getTaskOhif(taskId) {
  return request({ url: '/ndt/task/' + taskId + '/ohif', method: 'get' })
}
