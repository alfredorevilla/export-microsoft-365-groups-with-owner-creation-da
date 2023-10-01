Connect-MgGraph -AccessToken `
(    (Get-MsalToken -ClientId 14d82eec-204b-4c2f-b7e8-296a70dab67e -TenantId 4e99c5b8-a221-44bc-ae44-88974c1376e1 `
            -Scopes  "Directory.Read.All", "AuditLog.Read.All" -ForceRefresh).AccessToken |
    ConvertTo-SecureString -AsPlainText -Force)
    
Get-MgGroup -Property   "id,displayName,createdDateTime"  -ExpandProperty 'owners($select=id,displayName,createdDateTime)' |
ForEach-Object { $group = $_; $_.Owners | 
    Select-Object  @{N = "GroupId"; E = { $group.id } } , @{N = "GroupDisplayName"; E = { $group.displayName } }, `
    @{N = "GroupCreatedDateTime"; E = { $group.createdDateTime } } , @{N = "OwnerId"; E = { $_.Id } } , `
    @{ N = "OwnerDisplayName"; E = { $_.AdditionalProperties.displayName } } , `
    @{N = "OwnerCreatedDateTime"; E = { $_.AdditionalProperties.createdDateTime } } } |
ConvertTo-Csv -NoTypeInformation | 
Out-File GroupOwners.csv -Encoding utf8

