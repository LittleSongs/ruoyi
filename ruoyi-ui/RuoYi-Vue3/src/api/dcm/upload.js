import request from '@/utils/request'

// 上传单个 DCM 文件并同步所属 Study
export function uploadDcm(data) {
  return request({
    url: '/dcm/upload',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data',
      repeatSubmit: false
    },
    timeout: 600000
  })
}
