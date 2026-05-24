pageextension 50012 KrizPostedSalesInvoiceListPage extends 143
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(processing)
        {
            action(RunMyCustomReport)
            {
                Caption = 'Eternity Sales Invoice - freight';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    MyReport: Report 50017;
                begin
                    SalesInvoiceHeader.SetRange("No.", Rec."No.");
                    // Run the report with the current record
                    Report.Run(50017, true, false, SalesInvoiceHeader);
                end;
            }
            action(RunMyCustomReport1)
            {
                Caption = 'Frontier Debit Note';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    MyReport: Report 50018;
                begin
                    SalesInvoiceHeader.SetRange("No.", Rec."No.");
                    // Run the report with the current record
                    Report.Run(50018, true, true, SalesInvoiceHeader);
                end;
            }
            action(EternityTax_SalesInvoiceReport)
            {
                Caption = 'Eternity sales invoice-tax invoice';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    MyReport: Report 50028;
                begin
                    SalesInvoiceHeader.SetRange("No.", Rec."No.");
                    // Run the report with the current record
                    Report.Run(50028, true, false, SalesInvoiceHeader);
                end;
            }
        }
    }

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
}