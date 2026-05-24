reportextension 50001 "Kriz Voucher Print" extends 18041
{
    dataset
    {
        add("G/L Entry")// Add changes to dataitems and columns here
        {
            column(NarrationNew; "G/L Entry".description)
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
}