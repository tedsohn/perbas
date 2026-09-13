using { sales.intelligence as db } from '../db/schema';

/**
 * Side-by-side extension service — Clean Core PoC.
 *
 * Each entity below deliberately separates two column groups so the UI
 * makes the architecture visible:
 *   - "S/4: ..." fields  -> virtual, sourced live from the on-prem system
 *                           (never persisted here — Clean Core principle:
 *                           the S/4 core stays untouched, we only READ it)
 *   - "BTP HDI: ..." fields -> persisted in this side-by-side app's own
 *                           HDI container, computed by the AI insight logic
 */
service SalesOrderIntelligenceService @(path: '/odata/v4/sales-order-intelligence') {

  @readonly
  @UI.FieldGroup #S4Data       : { $Type: 'UI.FieldGroupType', Data: [
    { Value: salesOrder,  Label: 'Sales Order' },
    { Value: customer,    Label: 'Customer' },
    { Value: netValue,    Label: 'Net Value' },
    { Value: currency,    Label: 'Currency' }
  ]}
  @UI.FieldGroup #BTPInsights  : { $Type: 'UI.FieldGroupType', Data: [
    { Value: riskLevel,         Label: 'Risk Level' },
    { Value: riskScore,         Label: 'Risk Score (%)' },
    { Value: riskFactors,       Label: 'Risk Factors' },
    { Value: historicalPattern, Label: 'Historical Pattern' },
    { Value: materialAvailable, Label: 'Material Available' },
    { Value: supplierDelayFlag, Label: 'Supplier Delay Flag' },
    { Value: scoredAt,          Label: 'Scored At' }
  ]}
  @UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'S/4HANA Backend (Untouched Core)',      Target: '@UI.FieldGroup#S4Data' },
    { $Type: 'UI.ReferenceFacet', Label: 'BTP HANA Cloud — AI Insights (HDI)',    Target: '@UI.FieldGroup#BTPInsights' }
  ]
  @UI.LineItem: [
    { Value: salesOrder,   Label: 'S/4: Sales Order' },
    { Value: customer,     Label: 'S/4: Customer' },
    { Value: netValue,     Label: 'S/4: Net Value' },
    { Value: riskLevel,    Label: 'BTP HDI: Risk Level' },
    { Value: riskScore,    Label: 'BTP HDI: Risk Score (%)' },
    { Value: riskFactors,  Label: 'BTP HDI: Risk Factors' },
    { Value: scoredAt,     Label: 'BTP HDI: Scored At' }
  ]
  entity OrderRiskInsights as projection on db.OrderRiskInsights {
    *,
    virtual null as customer : String(10),
    virtual null as netValue : Decimal(15,2),
    virtual null as currency : String(3)
  };

  @readonly
  @UI.FieldGroup #S4Delivery   : { $Type: 'UI.FieldGroupType', Data: [
    { Value: salesOrder,  Label: 'Sales Order' },
    { Value: customer,    Label: 'Customer' }
  ]}
  @UI.FieldGroup #BTPDelivery  : { $Type: 'UI.FieldGroupType', Data: [
    { Value: originalDeliveryDate,  Label: 'Original Delivery Date' },
    { Value: predictedDeliveryDate, Label: 'Predicted Delivery Date' },
    { Value: delayDays,             Label: 'Delay (Days)' },
    { Value: delayReason,           Label: 'Delay Reason' },
    { Value: confidenceScore,       Label: 'Confidence (%)' }
  ]}
  @UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'S/4HANA Backend (Untouched Core)',   Target: '@UI.FieldGroup#S4Delivery' },
    { $Type: 'UI.ReferenceFacet', Label: 'BTP HANA Cloud — AI Insights (HDI)', Target: '@UI.FieldGroup#BTPDelivery' }
  ]
  @UI.LineItem: [
    { Value: salesOrder,            Label: 'S/4: Sales Order' },
    { Value: customer,              Label: 'S/4: Customer' },
    { Value: originalDeliveryDate,  Label: 'BTP HDI: Original Date' },
    { Value: predictedDeliveryDate, Label: 'BTP HDI: Predicted Date' },
    { Value: delayDays,             Label: 'BTP HDI: Delay (Days)' },
    { Value: confidenceScore,       Label: 'BTP HDI: Confidence (%)' }
  ]
  entity DeliveryPredictions as projection on db.DeliveryPredictions {
    *,
    virtual null as customer : String(10)
  };

  @readonly
  @UI.LineItem: [
    { Value: customer,           Label: 'S/4: Customer' },
    { Value: sentimentLabel,     Label: 'BTP HDI: Sentiment' },
    { Value: sentimentScore,     Label: 'BTP HDI: Score' },
    { Value: openComplaints30d,  Label: 'BTP HDI: Open Complaints (30d)' },
    { Value: escalationRisk,     Label: 'BTP HDI: Escalation Risk' }
  ]
  entity CustomerSentiments as projection on db.CustomerSentiments;

  function getOrderIntelligence(salesOrder : String(10)) returns {
    salesOrder : String;
    customer   : String;
    netValue   : Decimal;
    currency   : String;
    items      : array of {
      material : String;
      quantity : Decimal;
      plant    : String;
    };
    risk : {
      score   : Decimal;
      level   : String;
      factors : String;
    };
    delivery : {
      originalDate  : Date;
      predictedDate : Date;
      delayDays     : Integer;
      reason        : String;
      confidence    : Decimal;
    };
    sentiment : {
      score           : Decimal;
      label           : String;
      openComplaints  : Integer;
      escalationRisk  : Boolean;
      lastSyncDate    : Date;
    };
  };
}