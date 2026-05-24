pageextension 50008 "KRIZ Sales Invoice" extends "Sales Invoice"
{
    layout
    {


        addbefore("External Document No.")
        {
            field("PO No."; rec."PO No.")
            {
                ApplicationArea = All;
                ToolTip = 'Enter Po number here';
            }
            field("PO Date"; rec."PO Date")
            {
                ApplicationArea = All;
                ToolTip = 'Enter Po Date here';
            }
            field("Shipping from Location"; rec."Shipping from Location")
            {
                ApplicationArea = All;
                ToolTip = 'Enter the ship from location name';
            }
        }
    }
}
