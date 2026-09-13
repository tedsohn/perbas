@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header - Interface View'
define view entity ZI_SalesOrderHeader
  as select from zso_head
{
  key vbeln  as SalesOrder,
      kunnr  as Customer,
      netwr  as NetValue,
      waerk  as Currency,
      erdat  as CreatedDate
}
