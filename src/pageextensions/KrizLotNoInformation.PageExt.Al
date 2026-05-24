pageextension 50017 "Kriz Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(content)
        {
            group(EDCDates)
            {
                Caption = 'MRP & Dates';
                field("Kriz MRP"; Rec."Kriz MRP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MRP field.', Comment = '%';
                }
                field("Kriz Manufacturing Date"; Rec."Kriz Manufacturing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturing Date field.', Comment = '%';
                }
                field("Kriz Expiry Date"; Rec."Kriz Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiry Date field.', Comment = '%';
                }
            }
        }
    }
}
