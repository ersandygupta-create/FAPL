pageextension 50196 KrizFALedgerEntry extends 5604
{

    actions
    {
        addlast(processing)    // Add changes to page actions here
        {
            action(Update)
            {
                Caption = 'Update Data';
                ApplicationArea = All;
                trigger OnAction()

                var
                    KrizImportFALedgerEntry: Codeunit KrizImportFALedgerEntry;
                begin
                    KrizImportFALedgerEntry.ImportExcelFALedger();
                end;
            }
        }
    }


}