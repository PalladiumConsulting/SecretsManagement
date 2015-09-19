function Get-Authentication()
{
    Param([string]$userName, [string]$apiKey, [string]$urlBase, [boolean]$isHost)

    #get authenitcate token
    If ($isHost) {
        $userName = "host/" + $userName
    }
    $userName = [System.Web.HttpUtility]::UrlEncode($userName)
    $uri = "https://" + $urlBase + "/api/authn/users/" +  $userName + "/authenticate"
    Write-Host "Authenticate Uri: " $uri
    $response = Invoke-WebRequest $uri -Body $apiKey -Method Post -UseBasicParsing

    #base64 encode the response
    $token = Out-String -InputObject $response.Content

    #convert the token to a Base64 encoded string
    $b = [System.Text.Encoding]::UTF8.GetBytes($token)
    $token = [System.Convert]::ToBase64String($b)

    #create header for token authentication
    $tokenString = 'Token token="' + $token + '"'
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", $tokenString)

  $headers
}

function Create-Host()
{
    Param($userName, $password, $urlBase, $groupName)
    #setup inital authorization
    $b = [System.Text.Encoding]::UTF8.GetBytes($userName + ":" + $password)
    $authString = [System.Convert]::ToBase64String($b)
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic " + $authString)

    #get token
    $uri = "https://" + $urlBase + "/api/authn/users/login"
    $userApiKey = Invoke-RestMethod $uri  -Headers $headers  
    $headers = Get-Authentication -userName $userName -apiKey $userApiKey -urlBase $urlBase

    #get API Key
    $uri= "https://" + $urlBase + "/api/hosts?ownerid=" + $groupName
    $apiKey = Invoke-RestMethod $uri  -Headers $headers -Method Post

    #add the host to the Test Layer
    $hostUri = "https://" + $urlBase + "/api/layers/Test/hosts?hostid=" + [System.Web.HttpUtility]::UrlEncode("host:" + $apiKey.id)
    $resp = Invoke-RestMethod $hostUri -Headers $headers -Method Post
    
    return $apiKey;
}

$key = Create-Host -userName {{insert username}} -password {{insert password}} -urlBase {{insert conjur URL}} -groupName {{insert group name}}

Set-OctopusVariable -name "APIKey" -value $key.api_key
Set-OctopusVariable -name "APIUser" -value $key.id