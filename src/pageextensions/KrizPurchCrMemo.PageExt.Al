pageextension 50003 "Kriz Purchase Cr.Memo" extends 52
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
            field("Kriz Reference Doc. Date"; Rec."Kriz Reference Doc. Date")
            {
                ApplicationArea = All;
                Caption = 'Reference Document Date';
            }
        }
    }


}