const request = require('request');
 
const options = {
  method: 'POST',
  url: 'http://127.0.0.1:8080/v2/apis/auth/oauth/token',
  headers: {
    // connection: 'keep-alive',
    // 'keep-alive': 'timeout=7, max=100',
    // 'content-length': '299',
    'Content-Type': 'application/x-www-form-urlencoded'
    // host: '127.0.0.1:4884',
    // 'x-original-url': '/v2/apis/auth/oauth/token'
  },
  form: {
    'grant_type': 'client_credentials',
    'client_id': '756de01f-3d41-4cd8-b353-c99161a108d3',
    'client_secret': '3iwUxCa16dDXCkGtuTkXlPvhsy/9v2',
    'scope': 'it:registry:POST:instances,it:registry:DELETE:instances/{id},it:registry:POST:instances/{id}/heartbeats',
    'exp': '7',
    'profile': 'gent:on-prem'
  }
};
 
function callback(error, response, body) {
  console.log(response)
}
 
request(options, callback);
