const request = require('request');
 
const options = {
  method: 'GET',
  url: 'http://127.0.0.1:8080/v2/apis/auth/logins/oitwc',
  headers: {
    'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJpdDphdXRoOmtleS9FMTAwRERCNS05RERELTQzNzItQkZCOC0yRUI5MzM5RjU4ODQiLCJzdWIiOiJFRkM2NjA4QS1ENDdDLTRFOTQtOEVBMi1CRDRENDk3RDFBODMiLCJhdWQiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJleHAiOjE2NzQ2NTAyOTIsImlhdCI6MTY3NDU2Mzg5MiwianRpIjoiZGUzZjE2YmEtMjAwYi00ZmI0LWI0NDgtY2UwZTFjMmM1ZTYzIiwic2NvcGUiOlsiKiJdLCJvaXQiOnsibmFtZSI6IkFkbWluIiwic2lkIjoiNmY3ODE4MzItYmM0YS00Zjc3LTg1NTMtM2RhMzQ4ZTg0YjExIiwicm9sZSI6IkFkbWluIiwicm9sZUlkIjoxfX0.IyRBkyoUM21ZTAK_byUxIvpUyJpqF8ISTuvGsUIkPu-kGZ-t0UuMtGnYoEKBb5vppeoUPkarJSqmSTlAGiTzoxcs4W7EfAhjggdWz5N-d5DLAO2n2URBW6-OYrMOe-JbpyU4_DSqbuPENwOgEqIt-gAHPuS5tA3pTvDzD_5ib4JTPL3BL-XONG9fsR7p9t0KkSXQVo9AaExqSP__8-mxQZhaDJx8cTEKU5s56Jnf3vtn9KZgY3BNDm6luLD0b6DGNJLaDFnstuEKe56_FPa6Rt6FapR35xdUcmlLyPFxZq_RFs_UavBr9jM32WEoJrtsL9vADhcKStuJWf8PRP_S0Q',
    'Content-Type': 'application/json'
  }
};
 
function callback(error, response, body) {
  console.log(response)
}
 
request(options, callback);
