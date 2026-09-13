const cds = require('@sap/cds')

module.exports = class LegacyFieldsService extends cds.ApplicationService {
  init() {
    this.on('CREATE', 'LegacyOrderFields', async (req) => {
      const { UPSERT, SELECT } = cds.ql
      await UPSERT.into('LegacyOrderFields').entries(req.data)
      return await SELECT.one.from('LegacyOrderFields').where({ VBELN: req.data.VBELN })
    })

    return super.init()
  }
}