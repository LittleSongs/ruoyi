import request from '@/utils/request'

export function listStudy(query) {
  return request({
    url: '/dcm/study/list',
    method: 'get',
    params: query
  })
}

export function getStudy(id) {
  return request({
    url: '/dcm/study/' + id,
    method: 'get'
  })
}

export function delStudy(ids) {
  return request({
    url: '/dcm/study/' + ids,
    method: 'delete'
  })
}

export function listSeriesByStudy(query) {
  return request({
    url: '/dcm/series/list',
    method: 'get',
    params: query
  })
}

export function listInstancesBySeries(query) {
  return request({
    url: '/dcm/instance/list',
    method: 'get',
    params: query
  })
}
