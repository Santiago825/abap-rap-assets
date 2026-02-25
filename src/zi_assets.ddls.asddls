@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERFACE ASSETS'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_ASSETS as select from zit_assets
composition [0..*] of ZI_LOG as _Logs
association [0..1] to ZI_STATUS_VH as _StatusVH on $projection.status = _StatusVH.Status
association [0..1] to ZI_CATEGORY_VH as _CategoryVH on $projection.category = _CategoryVH.Category
{
    key assetuuid,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    @Search.ranking: #HIGH
    assetid,
    @ObjectModel.text.element: [ 'category' ]
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CATEGORY_VH', element: 'Category'} }]
    category ,
    _CategoryVH.CategoryText as  CategoryText,
    brand,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_STATUS_VH', element: 'Status'} }]
    @ObjectModel.text.element: [ 'status' ]
    status,
    case status
        when 'A' then 3
        when 'B' then 1
        when 'R' then 2
        else 0
    end as StatusCriticality,
    _StatusVH.StatusText as StatusText,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    @Search.ranking: #MEDIUM
    assignedto,
    puchasedate,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    local_last_changed_at,
    fechamod,
    @Semantics.largeObject: { mimeType: 'MimeType',   //case-sensitive
                       fileName: 'FileName',   //case-sensitive
                       acceptableMimeTypes: ['image/png', 'image/jpeg','application/pdf', 
                       'application/vnd.ms-excel', 
                       'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                       ],
                       contentDispositionPreference: #ATTACHMENT }
    attachment as Attachment,
    @Semantics.mimeType: true
    mimetype as  Mimetype,
    filename as Filename,     
    _Logs

}
