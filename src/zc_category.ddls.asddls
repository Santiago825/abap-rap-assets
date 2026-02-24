@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption tabla Category'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_CATEGORY
  provider contract transactional_query as projection on ZI_CATEGORY_VH
{
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    key Category,
    @Search.defaultSearchElement: true
    CategoryText
}
