@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERFACE CATEGORIA'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CATEGORY_VH as select from zcat_asset
{
    @EndUserText.label: 'Categoria'
    key cat_id as Category,
    @EndUserText.label: 'Descripcion'
    @Semantics.text: true
    description as CategoryText
}
