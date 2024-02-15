$Body = @{
	username = 'admin'
	password = 'esm@rtv49'
}

$Params = @{
	Method = "POST"
	Uri = "http://127.0.0.1:8080/v2/apis/auth/logins"
	Body = $Body
}

Invoke-RestMethod @Params | Select-Object -Property * | ConvertTo-Json