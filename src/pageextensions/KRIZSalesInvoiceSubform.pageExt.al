pageextension 50001 "KRIZ Sales Invoice Subform" extends "Sales Invoice Subform"
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