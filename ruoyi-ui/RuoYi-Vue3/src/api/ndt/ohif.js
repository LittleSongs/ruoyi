import request from '@/utils/request'

export function getOhifConfig() {
  return request({ url: '/ndt/ohif/config', method: 'get' })
}
