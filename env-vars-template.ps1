### Authentication details
$env:TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$env:TF_VAR_user_ocid="ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$env:TF_VAR_fingerprint="38:4b:39:f0:03:39:xxxxxxxxxxxxxxxxxxxxxxxxx"
$env:TF_VAR_private_key_path="C:\Travail\Travail2023\xxxxxxxxxxxx\xxxxxxxxxxKey.pem"

### SSH Key DB VV
$env:TF_VAR_ssh_public_key = Get-Content C:\Travail\Travail2023\xxxxxxxxxxxxxxx\xxxxxxxxxxxxxKey.pub -Raw
$env:TF_VAR_ssh_private_key = Get-Content C:\Travail\Travail2023\xxxxxxxxxxxxxxx\xxxxxxxxxxxxKey.key -Raw

### Compartment
$env:TF_VAR_compartment_ocid="ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxxxx"

### Region
$env:TF_VAR_region="eu-paris-1"


