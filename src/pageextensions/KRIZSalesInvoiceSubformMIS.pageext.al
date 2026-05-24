pageextension 50011 "KRIZ Sales Invoice Subform MIS" extends "Sales Invoice Subform"
{


    actions
    {
        addlast(processing)
        {
            action(ViewMISReport)
            {
                Caption = 'View MIS Details';
                Image = View;
                ApplicationArea = all;

                RunObject = page "KRIZ MIS Details";
                RunPageLink = "Order No" = field("Document No."), "Line No" = field("Line No.");
            }
        }
    }

    var
        myInt: Integer;
}
