$username = 'admin'
$password = 'esm@rtv49'
$base_url = 'http://127.0.0.1:8080'
$token_expire = 7


$Params = @{
	Method = "POST"
	Uri = $base_url + "/v2/apis/auth/logins"
	Body =  @{
		username = $username
		password = $password
	}
}
$response_token = Invoke-RestMethod @Params
if (!$response_token.access_token) { 
	Write-Error "fail login username or password may be wrong"
	exit 
}

$Params = @{
	Method = "GET"
	Uri = $base_url + "/v2/apis/auth/clients"
	Headers = @{
		'Authorization' = "Bearer $($response_token.access_token)"
		'Content-Type' = 'application/json'
	}
}
# Invoke-RestMethod @Params | Select-Object -Property * | ConvertTo-Json
$response_clients = Invoke-RestMethod @Params
# $response_clients | Select-Object -Property * | ConvertTo-Json
$clients_agent = $response_clients.data | Where-Object {$_.name -eq "Agent Installation"}
# $clients_agent | Select-Object -Property * | ConvertTo-Json
# $clients_agent.id | ConvertTo-Json

$Params = @{
	Method = "POST"
	Uri = $base_url + "/v2/apis/auth/oauth/token"
	Body = @{
		grant_type = 'client_credentials'
		client_id = $clients_agent.id
		client_secret = $clients_agent.clientSecret
		scope = 'it:registry:POST:instances,it:registry:DELETE:instances/{id},it:registry:POST:instances/{id}/heartbeats'
		exp = $token_expire
		profile = 'agent:on-prem'
	}
}

$response = Invoke-RestMethod @Params
if ($response.access_token) {
$settings_file_number =  (Get-ChildItem -Path .\downloads\* -Include settings* *.json | Measure-Object).Count
if ($settings_file_number) {
	$settings_file_name = "settings (" + $settings_file_number + ").json"
} else {
	$settings_file_name = "settings.json"
}
Write-Output $settings_file_name
If(!(test-path -PathType container "./downloads")) { New-Item -ItemType Directory -Path "./downloads" }
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
}" >>./downloads/$settings_file_name

}

