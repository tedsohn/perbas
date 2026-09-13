namespace sales.intelligence;

using { cuid, managed } from '@sap/cds/common';

entity OrderRiskInsights : cuid, managed {
  salesOrder         : String(10)  @title: 'Sales Order';
  riskScore          : Decimal(5,2) @title: 'Risk Score (%)';
  riskLevel          : String(10)  enum { Low; Medium; High; Critical };
  riskFactors        : String(1000);
  historicalPattern  : String(200);
  materialAvailable  : Boolean;
  supplierDelayFlag  : Boolean;
  scoredAt           : Timestamp;
}

entity DeliveryPredictions : cuid, managed {
  salesOrder            : String(10)  @title: 'Sales Order';
  originalDeliveryDate  : Date;
  predictedDeliveryDate : Date;
  delayDays             : Integer;
  delayReason           : String(500);
  confidenceScore       : Decimal(5,2);
  inboundShipmentDelay  : Boolean;
  transportConstraint   : Boolean;
}

entity CustomerSentiments : cuid, managed {
  customer             : String(10)  @title: 'Customer';
  sentimentScore       : Decimal(5,2);
  sentimentLabel       : String(10)  enum { Positive; Neutral; Negative };
  openComplaints30d    : Integer;
  escalationRisk       : Boolean;
  lastInteractionDate  : Date;
  lastInteractionType  : String(20)  enum { Email; Call; Ticket; Survey };
}
