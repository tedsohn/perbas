@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item - Interface View'
define view entity ZI_SalesOrderItem
  as select from zso_items
{
  key vbeln  as SalesOrder,
  key posnr  as ItemNumber,
      matnr  as Material,
      kwmeng as Quantity,
      meins  as Unit,
      werks  as Plant
}
