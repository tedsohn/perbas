@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order Item - Consumption View'
@UI.headerInfo: { typeName: 'Sales Order Item', typeNamePlural: 'Sales Order Items' }
define view entity ZC_SalesOrderItem
  as select from ZI_SalesOrderItem
{
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key SalesOrder,
      @UI.lineItem: [{ position: 20 }]
  key ItemNumber,
      @UI.lineItem: [{ position: 30 }]
      Material,
      @UI.lineItem: [{ position: 40 }]
      Quantity,
      @UI.lineItem: [{ position: 50 }]
      Unit,
      @UI.lineItem: [{ position: 60 }]
      Plant
}
