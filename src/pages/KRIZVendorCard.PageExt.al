pageextension 50016 "KRIZ Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("Agreement Date"; Rec."Agreement Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Agreement Date field';
            }
            field("Valid Upto"; Rec."Valid Upto")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Agreement Date field';
            }

        }
    }
}