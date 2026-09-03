reportextension 50001 "Kriz Voucher Print" extends 18041
{
    dataset
    {
        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            begin

                VendLedgerEntry.Reset();
                VendLedgerEntry.SetRange("Document No.", "Document No.");
                // VendLedgerEntry.SetRange(Description, '<>%1', '');
                if VendLedgerEntry.Find('-') then
                    NarrationNew := VendLedgerEntry.Description
                else
                    // Write your logic here, e.g., fetching related records or modifying variables
                    NarrationNew := "G/L Entry".Description;
            end;
        }
        add("G/L Entry")// Add changes to dataitems and columns here
        {
            column(NarrationNew; NarrationNew)
            {
                Caption = 'Narration New';
            }
            column(Description; "G/L Entry".Description)
            {
                Caption = 'Description';
            }

        }


    }



    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = './src/reports/KrizPostedVoucher.rdl';
        }
    }

    var
        NarrationNew: Text[250];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VendLedgerEntry: Record "Vendor Ledger Entry";
}