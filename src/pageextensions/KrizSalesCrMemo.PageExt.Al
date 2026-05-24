pageextension 50155 "Sales Cr. Memo" extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field("Kriz Reference Doc. No"; Rec."Kriz Reference Doc. No")
            {
                ApplicationArea = All;
                Caption = 'Reference Document No.';
            }
        }
    }


}