permissionset 50101 "Permission Set "
{
    Assignable = true;
    Caption = 'Permission Set', MaxLength = 30;
    Permissions =
         table "KRIZ e-Invoice Setup" = X,
         tabledata "KRIZ e-Invoice Setup" = RMID,
         table "KRIZ Item Balance Table" = X,
         tabledata "KRIZ Item Balance Table" = RMID,
         table KrizworkerCost = X,
         tabledata KrizworkerCost = RMID,
         table KRIZTADAHeaderPost = X,
         tabledata KRIZTADAHeaderPost = RMID,
         table KRIZTADAHeaderPre = X,
         tabledata KRIZTADAHeaderPre = RMID,
         table krizHotelTable = X,
         tabledata krizHotelTable = RMID,
         table KRIZTADALinePost = X,
         tabledata KRIZTADALinePost = RMID,
         table KRIZTADALinePre = X,
         tabledata KRIZTADALinePre = RMID,
         table KrizTADAParameter = X,
         tabledata KrizTADAParameter = RMID,
         table krizTADAPeriod = X,
         tabledata krizTADAPeriod = RMID,
         table "Tmp Ledger Transaction" = X,
         tabledata "Tmp Ledger Transaction" = RMID,
         table "KRIZ MIS Details" = X,
         tabledata "KRIZ MIS Details" = RMID,

         page "KRIZ e-Invoice Setup List 2" = x;

}