namespace s4tobtp;

entity LegacyOrderFields {
  key VBELN       : String(10);
      LegacyFld1  : String(40);
      LegacyFld2  : String(40);
      LegacyFld3  : String(40);
      LegacyFld4  : String(40);
      LegacyFld5  : String(40);
      LegacyFld6  : String(40);            
      LegacyFld7  : String(40);
      LegacyFld8  : String(40);
      LegacyFld9  : String(40);
      LegacyFld10  : String(40);            
      EventId     : String(32);
      ReceivedAt  : Timestamp @cds.on.insert: $now;
}