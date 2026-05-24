pageextension 50015 "KRIZ Customer Card" extends "Customer Card"
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
            field("Vendor Code"; Rec."Vendor Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Agreement Date field';
            }
            field("Security Deposit"; Rec."Security Deposit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Security Deposit field';
            }
            field("Cost Center"; Rec."Cost Center")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Cost Center field';
            }
        }
    }
}