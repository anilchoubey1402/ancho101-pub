# Install Azure PowerShell module if not already installed
#Install-Module -Name Az -Force

# Connect to Azure using your credentials
Connect-AzAccount

# List all Service Principals
$servicePrincipals = Get-AzADServicePrincipal

foreach ($spn in $servicePrincipals) {
    $appId = $spn.AppId
    $spnName = $spn.DisplayName
    

    # Check if the SPN is using a secret
    $secrets = Get-AzADAppCredential -DisplayName $spnName
    
    #-ErrorAction SilentlyContinue
    if ($secrets) {
        Write-Output "Service Principal $spnName is using a secret."
    }
    
    # Check if the SPN is using a certificate
    $certs = Get-AzADCertificate -ObjectId $spn.AppId -ErrorAction SilentlyContinue
    if ($certs) {
        Write-Output "Service Principal $spnName (AppId: $appId) is using a certificate."
    }
}

# Disconnect from Azure
#Disconnect-AzAccount
# created my sel signed cert in azure for using in my App

$certname = "MyAzureAppCert"    ## Replace {certificateName}
$cert = New-SelfSignedCertificate -Subject "CN=$certname" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256

#export this cert to a folder location

Export-Certificate -Cert $cert -FilePath "C:\My_Self_Signed_AzureAppCert\$certname.cer"   ## Specify your preferred location




$servicePrincipals = Get-AppUsingCert4Test

foreach ($spn in $servicePrincipals) {
    $appId = $spn.AppId
    $spnName = $spn.DisplayName

    # Retrieve credentials (secrets and certificates) associated with the SPN
    $credentials = Get-AzADAppCredential -ApplicationId $appId -ErrorAction SilentlyContinue
        

    if ($credentials) {
        foreach ($credential in $credentials) {
            if ($credential.Type -ne "AsymmetricX509Cert") {
                Write-Output "Service Principal $spnName (AppId: $appId) is using a secret which will expire on "
            } elseif ($credential.Type -eq "AsymmetricX509Cert") {
                Write-Output "Service Principal $spnName (AppId: $appId) is using a certificate."
            }
        }
    }
}

$c = Get-AzADAppCredential -DisplayName "Terraform cloud App" 
$c = Get-AzADAppCredential -DisplayName "AppUsingCert4Test"


#THIRD ITERATION

$servicePrincipals = Get-AppUsingCert4Test

foreach ($spn in $servicePrincipals) {
    $appId = $spn.AppId
    $spnName = $spn.DisplayName

    # Retrieve credentials (secrets and certificates) associated with the SPN
    $credentials = Get-AzADAppCredential -ApplicationId $appId -ErrorAction SilentlyContinue
        

    if ($credentials) {
        foreach ($credential in $credentials) {
            if ($credential.GetType(MicrosoftGraphPasswordCredential)){
                Write-Output "Service Principal $spnName (AppId: $appId) is using a secret

            } elseif ($credential. "MicrosoftGraphKeyCredentialCredential") {
                Write-Output "Service Principal $spnName (AppId: $appId) is using a certificate."
            }
        }
    }
}

