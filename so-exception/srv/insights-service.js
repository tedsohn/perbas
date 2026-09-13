const cds = require('@sap/cds');
const onPrem = require('./lib/onprem-client');

module.exports = cds.service.impl(async function () {

  const { OrderRiskInsights, DeliveryPredictions, CustomerSentiments } = this.entities;

  // Populate the virtual "S/4" columns on read, by calling the on-prem client.
  // This is the Clean Core pattern: the fields are never stored in the HDI
  // container, only fetched live and merged into the response.
  this.after('READ', OrderRiskInsights, async (rows) => {
    const list = Array.isArray(rows) ? rows : [rows];
    await Promise.all(list.filter(Boolean).map(async (row) => {
      const order = await onPrem.getSalesOrder(row.salesOrder);
      if (order) {
        row.customer = order.customer;
        row.netValue = order.netValue;
        row.currency = order.currency;
      }
    }));
  });

  this.after('READ', DeliveryPredictions, async (rows) => {
    const list = Array.isArray(rows) ? rows : [rows];
    await Promise.all(list.filter(Boolean).map(async (row) => {
      const order = await onPrem.getSalesOrder(row.salesOrder);
      if (order) row.customer = order.customer;
    }));
  });

  this.on('getOrderIntelligence', async (req) => {
    const { salesOrder } = req.data;
    const order = await onPrem.getSalesOrder(salesOrder);
    if (!order) return req.error(404, `Sales Order ${salesOrder} not found`);

    const [risk, delivery, sentiment] = await Promise.all([
      SELECT.one.from(OrderRiskInsights).where({ salesOrder }),
      SELECT.one.from(DeliveryPredictions).where({ salesOrder }),
      SELECT.one.from(CustomerSentiments).where({ customer: order.customer })
    ]);

    return {
      salesOrder: order.salesOrder, customer: order.customer,
      netValue: order.netValue, currency: order.currency, items: order.items,
      risk: risk ? { score: risk.riskScore, level: risk.riskLevel, factors: risk.riskFactors } : null,
      delivery: delivery ? { originalDate: delivery.originalDeliveryDate, predictedDate: delivery.predictedDeliveryDate, delayDays: delivery.delayDays, reason: delivery.delayReason, confidence: delivery.confidenceScore } : null,
      sentiment: sentiment ? { score: sentiment.sentimentScore, label: sentiment.sentimentLabel, openComplaints: sentiment.openComplaints30d, escalationRisk: sentiment.escalationRisk, lastSyncDate: sentiment.lastInteractionDate } : null
    };
  });
});