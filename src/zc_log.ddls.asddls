@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption tabla Logs'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_LOG as projection on ZI_LOG
{
    key loguuid,
    parent_uuid,
    maintenancedate,
    servicetype,
    @Semantics.amount.currencyCode: 'Currency'
    cost,
    currency,
    remarks,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at,
    /* Associations */
    _Asset : redirected to parent ZC_ASSETS
}
