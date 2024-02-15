$Body = @{
  grant_type = 'client_credentials'
  client_id = '756de01f-3d41-4cd8-b353-c99161a108d3'
	client_secret = '3iwUxCa16dDXCkGtuTkXlPvhsy/9v2'
	scope = 'it:registry:POST:instances,it:registry:DELETE:instances/{id},it:registry:POST:instances/{id}/heartbeats'
	exp = 7
	profile = 'gent:on-prem'
}

$Params = @{
	Method = "POST"
	Uri = "http://127.0.0.1:8080/v2/apis/auth/oauth/token"
	Body = $Body
}

$response = Invoke-RestMethod @Params
if ($response.access_token) {
Write-Output $response | Select-Object -Property * | ConvertTo-Json
Write-Output "{
  ""resources"": {
    ""apis"": {
      ""installationRegistry"": {
        ""headers"": {
          ""Authorization"": ""Bearer $($response.access_token)""
        }
      }
    }
  }
}" >settings.json

}
