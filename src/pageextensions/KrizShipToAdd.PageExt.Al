pageextension 50195 KrizShipToAdd extends "Ship-to Address"
{
    layout
    {
        addafter("GST Registration No.")
        {
            field("Kriz GST Registration No"; Rec."Kriz GST Registration No")
            {
                ApplicationArea = All;
                Caption = 'GST Registration No.';
            }
        }
        modify("GST Registration No.")
        {
            Visible = false;
        }
    }


}