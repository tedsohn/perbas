const MOCK_ORDERS = {
  '0000000001': {
    salesOrder: '0000000001', customer: '0000100001', netValue: 12500.00, currency: 'USD',
    items: [{ material: 'M-1001', quantity: 50, plant: '1010' }, { material: 'M-1002', quantity: 20, plant: '1010' }]
  },
  '0000000002': {
    salesOrder: '0000000002', customer: '0000100002', netValue: 3200.00, currency: 'USD',
    items: [{ material: 'M-2001', quantity: 10, plant: '1020' }]
  },
  '0000000003': {
    salesOrder: '0000000003', customer: '0000100003', netValue: 7800.00, currency: 'USD',
    items: [{ material: 'M-3001', quantity: 30, plant: '1010' }, { material: 'M-3002', quantity: 15, plant: '1030' }]
  }
};

async function getSalesOrder(salesOrder) {
  const order = MOCK_ORDERS[salesOrder];
  if (!order) return null;
  await new Promise(resolve => setTimeout(resolve, 50));
  return order;
}

module.exports = { getSalesOrder };
