using s4tobtp as db from '../db/schema';

@requires: 'PublishLegacyFields'
service LegacyFieldsService {
  entity LegacyOrderFields as projection on db.LegacyOrderFields;
}