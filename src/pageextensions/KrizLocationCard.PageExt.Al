pageextension 50002 "Kriz Location Card" extends "Location Card"
{
    layout
    {
        addlast(general)
        {
            field("Kriz PL Number"; Rec."Kriz PL Number")
            {
                ApplicationArea = All;
                Caption = 'Pesticide License Number';
            }

            field("Kriz FL Number"; Rec."Kriz FL Number")
            {
                ApplicationArea = All;
                Caption = 'Fertilizer License Number';
            }
        }
    }
}