pageextension 50007 "KRIZ Sales Order" extends "Sales Order"
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
        }
    }
}
