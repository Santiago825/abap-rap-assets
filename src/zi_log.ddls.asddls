@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERFACE LOGS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LOG as select from zit_logs
    association to parent ZI_ASSETS as _Asset
    on $projection.parent_uuid = _Asset.Assetuuid
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
    _Asset
}
