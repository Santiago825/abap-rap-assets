@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption tabla Assets'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_ASSETS
  provider contract transactional_query as projection on ZI_ASSETS
{
    key assetuuid,
    assetid,
    @EndUserText.label: 'Categoria'
    @ObjectModel.text.element: [ 'CategoryText' ]
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CATEGORY_VH', element: 'Category'} }]
    category,
    @UI.hidden: true
    CategoryText,
    brand,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_STATUS_VH', element: 'Status'} }]
    @ObjectModel.text.element: [ 'StatusText' ]
    status,
    @UI.hidden: true
    StatusCriticality,
    
    @UI.hidden: true
    StatusText,
    assignedto,
    puchasedate,
    LastChangedAt,
    local_last_changed_at,

    fechamod,
        @Semantics.largeObject: { mimeType: 'MimeType',   //case-sensitive
                       fileName: 'FileName',   //case-sensitive
                       acceptableMimeTypes: ['image/png', 'image/jpeg'],
                       contentDispositionPreference: #ATTACHMENT }
    Attachment,
    
    @Semantics.mimeType: true
    Mimetype,
    Filename,
    @Search.defaultSearchElement: true
    _Logs : redirected to composition child ZC_LOG
}
