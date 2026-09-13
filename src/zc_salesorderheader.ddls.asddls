@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order Header - Consumption View'
@Search.searchable: true
@UI.headerInfo: { typeName: 'Sales Order', typeNamePlural: 'Sales Orders' }
define view entity ZC_SalesOrderHeader
  as select from ZI_SalesOrderHeader
{
      @UI.lineItem: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key SalesOrder,
      @UI.lineItem: [{ position: 20 }]
      Customer,
      @UI.lineItem: [{ position: 30 }]
      NetValue,
      @UI.lineItem: [{ position: 40 }]
      Currency,
      @UI.lineItem: [{ position: 50 }]
      CreatedDate
}
