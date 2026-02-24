@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VISTA AYUDA ESTADOS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_STATUS_VH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_STATUS' )
{
    @UI.hidden: true
    key domain_name,
    @UI.hidden: true
    key value_position,
    @EndUserText.label: 'Codigo de Estado'
    @UI.lineItem: [{ position: 10  }]
    value_low as Status,
    @EndUserText.label: 'Descripcion'
    @UI.lineItem: [{ position: 20  }]
    @Semantics.text: true
    text as StatusText
    
}
