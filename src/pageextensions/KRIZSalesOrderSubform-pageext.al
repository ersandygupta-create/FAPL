pageextension 50010 "KRIZ Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("GL Code"; Rec."GL Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dont Check SPQ field.';
            }
        }

    }
}