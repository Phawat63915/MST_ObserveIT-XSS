$username = 'admin'
$password = 'esm@rtv49'
$base_url = 'http://127.0.0.1:8080'

# agent, agent_script, screenshot_storage_optimizer
$type_download = "agent"

# 1 = 1 day
$token_expire = 7

# 1 = 1 token or client
$token_count = 50





#Login to get access token for script
function cache_access {
    
    param(
        [bool]$reset = $false
    )

    begin {
        if ($reset) {
            $Params = @{
                Method = "POST"
                Uri = $base_url + "/v2/apis/auth/logins"
                Body =  @{
                    username = $username
                    password = $password
                }
            }
            $res = Invoke-RestMethod @Params
            if (!$res.access_token) { 
                Write-Error "fail login username or password may be wrong"
                exit 
            }
            $global:cache.login_cache = $res
        }
    }

    process {
        $cache | ConvertTo-Json | Out-File -FilePath .\cache.json
    }

    end {}
}

#Check Access token expire for login for script
Try {
    if ((Test-Path -Path "cache.json")) {
        $global:cache += Get-Content -Raw cache.json | ConvertFrom-Json
    } else {
        $global:cache += @{}
    }
    
    $Params = @{
        Method = "GET"
        Uri = $base_url + "/v2/apis/auth/logins/validation"
        Headers = @{
            'Authorization' = "Bearer $($cache.login_cache.access_token)"
        }
    }

    (Invoke-RestMethod @Params) | Out-Null
} Catch {
    cache_access $true
}

# $check_token | ConvertTo-Json

#Get all clients type for Agents
function auth_clients {
    param ()

    begin {
        $Params = @{
            Method = "GET"
            Uri = $base_url + "/v2/apis/auth/clients"
            Headers = @{
                'Authorization' = "Bearer $($cache.login_cache.access_token)"
                'Content-Type' = 'application/json'
            }
        }
    }

    process {
        $res = Invoke-RestMethod @Params
        $global:client_agent = $res.data | Where-Object {$_.name -eq "Agent Installation"}
        $global:client_screenshot = $res.data | Where-Object {$_.name -eq "Screenshot Storage Optimizer"}
        $res | ConvertTo-Json
    }

    end {}
}

auth_clients

function save {
    param (
        $text = $null,
        $name = $null,
        $type = $null
    )

    begin {}

    process {

        $settings_file_number =  (Get-ChildItem -Path .\downloads\* -Include $name* *.$type | Measure-Object).Count
        if ($settings_file_number) {
            $settings_file_name = "$name (" + $settings_file_number + ").$type"
        } else {
            $settings_file_name = "$name.$type"
        }
        Write-Output $settings_file_name
        If(!(test-path -PathType container "./downloads")) { New-Item -ItemType Directory -Path "./downloads" }

        Write-Output $text >>./downloads/$settings_file_name

    }
    
    end {}
    
}
#Screenshot Storage Optimizer (Download JWT File)
function screenshot_storage_optimizer {
    param (
        $res = $null
    )

    begin {
        $access_token = $res.access_token
        $refresh_token = $res.refresh_token
        $client_id = $client_screenshot.id.ToLower()
    }

    process {
        if ($res.access_token) {

$text = "{
    ""access_token"": ""${access_token}"",
    ""refresh_token"": ""${refresh_token}"",
    ""client_id"": ""${client_id}"",
}"
            save $text settings json
            $res | ConvertTo-Json
            $res.refresh_token
            
        }
    }

    end {}
    
}

#Agent Installation (Download JWT File)
function save_agent {
    param (
        $res = $null
    )

    begin {}

    process {
        if ($res.access_token) {

$text = "{
  ""resources"": {
    ""apis"": {
      ""installationRegistry"": {
        ""headers"": {
          ""Authorization"": ""Bearer $($res.access_token)""
        }
      }
    }
  }
}"
            save $text settings json
            
        }
    }

    end {}
    
}

#Agent Installation (Download Script File)
function save_agent_script {
    param (
        $res = $null
    )

    begin {
        $wa = "{"
        $wv = "}"
        $q = [char]([convert]::toint16('60',16)) # `
        $a = "$"
    }

    process {

        if ($res) {

$text = "
#!/bin/bash
# 
# Copyright 2017 ObserveIT Ltd.  All rights reserved.
# Use is subject to license terms.
#
# Preinstall script for OSX remote deploy manager
#

# Write an application server ip to /tmp/oit_remote_install.cfg:
#  replace 0.0.0.0 with the server ip
echo 'SERVER=0.0.0.0' > /tmp/oit_remote_install.cfg


# Optional parameters - uncomment appropriate echo line and put a parameter after =

# Password, if required (i.e. if it was specified in application server)
#echo 'PASSWORD=' >> /tmp/oit_remote_install.cfg

# Policy GUID, link the agent to a specific group policy
#echo 'POLICY=' >> /tmp/oit_remote_install.cfg

# User name to prompt for accessibility or All to prompt to all users
#echo 'ACCESSIBILITY_PROMPT=' >> /tmp/oit_remote_install.cfg

# Allow - popup of screen recording permission for all users, Never - No popup for screen recording for any user (all users will be in MetaData Only mode) or Username - User name to prompt for screen recording
#echo 'ALLOW_SCREENRECORDING_POPUP=' >> /tmp/oit_remote_install.cfg

# Agent process name, default is 'logger'
# echo 'LOGGER_NAME=logger' >> /tmp/oit_remote_install.cfg

# MacOS 11 M1 emulation package install
# echo 'INSTALL_EMULATION=true' >> /tmp/oit_remote_install.cfg

# Proxy Data - Url
# echo 'PROXY_URL=' >> /tmp/oit_remote_install.cfg

# Proxy Data - Port
# echo 'PROXY_PORT=' >> /tmp/oit_remote_install.cfg

# Proxy Data - Domain
# echo 'PROXY_DOMAIN=' >> /tmp/oit_remote_install.cfg

# Proxy Data - User name
# echo 'PROXY_USERNAME=' >> /tmp/oit_remote_install.cfg

# Proxy Data - User password
# echo 'PROXY_USERPASSWORD=' >> /tmp/oit_remote_install.cfg

file_location=${a}${wa}file_location:-/tmp/it-config-install.json${wv}

# Write location of preconfig file into /tmp/oit_remote_install.cfg:
echo PRECONFIG_FILENAME=${a}${wa}file_location${wv} >> /tmp/oit_remote_install.cfg

# Validate preconfig file path leads to readable file, and .cfg is parsable, to avoid later installation failure.

preconfigline=${q}grep ""PRECONFIG_FILENAME${a}""  /tmp/oit_remote_install.cfg${q}

preconfig_file_path=${a}${wa}preconfigline#*=${wv}


cat > ${a}file_location <<EOF
{
    ""resources"": {
	""apis"": {
	    ""installationRegistry"": {
		""headers"": {
		    ""Authorization"": ""$($res.access_token)""
		}
            }
        }
    }
}
EOF

if [ ! -r ""${a}preconfig_file_path"" ]; then

	echo ""Error: No readable preconfig file found at: $preconfig_file_path. Verify and run script again.""

	exit 1

fi
"
            save $text preinstall sh
            
        }
    }

    end {}
    
}

#Generate tokens for Agents
function auth_get_token {
    param ()
    
    begin {
        $Params = @{
            Method = "POST"
            Uri = $base_url + "/v2/apis/auth/oauth/token"
            Body = @{
                grant_type = 'client_credentials'
                client_id = $client_agent.id
                client_secret = $client_agent.clientSecret
                scope = 'it:registry:POST:instances,it:registry:DELETE:instances/{id},it:registry:POST:instances/{id}/heartbeats'
                exp = $token_expire
                profile = 'agent:on-prem'
            }
        }
    }

    process {
        $res = Invoke-RestMethod @Params
        
        # Write-Output $res | ConvertTo-Json

        switch ($type_download) {
            "agent" { save_agent $res }
            "agent_script" { save_agent_script $res }
            "screenshot_storage_optimizer" { screenshot_storage_optimizer $res }
            Default {
                Write-Output "Invalid type_download"
                exit
            }
        }
    
    }

    end {}
}


for ($i = 0; $i -lt $token_count; $i++) {
    auth_get_token
}

