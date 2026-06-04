import request from '@/utils/request'

export function listDicomPrivateTag(query) {
  return request({ url: '/ndt/dicomPrivateTag/list', method: 'get', params: query })
}

export function listEnabledDicomPrivateTag() {
  return request({ url: '/ndt/dicomPrivateTag/enabled', method: 'get' })
}

export function getDicomPrivateTag(id) {
  return request({ url: '/ndt/dicomPrivateTag/' + id, method: 'get' })
}

export function addDicomPrivateTag(data) {
  return request({ url: '/ndt/dicomPrivateTag', method: 'post', data })
}

export function updateDicomPrivateTag(data) {
  return request({ url: '/ndt/dicomPrivateTag', method: 'put', data })
}

export function delDicomPrivateTag(ids) {
  return request({ url: '/ndt/dicomPrivateTag/' + ids, method: 'delete' })
}
