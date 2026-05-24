pageextension 50014 "KRIZ Sales Invoice MIS" extends "Sales Invoice"
{
    actions
    {
        addlast(processing)
        {
            action(ImportMISReport)
            {
                Caption = 'Import MIS Report';
                Image = Import;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ImportReport: Report "Import MIS Details";
                begin
                    Report.RunModal(Report::"Import MIS Details", true, true);
                end;

            }
        }

    }


}