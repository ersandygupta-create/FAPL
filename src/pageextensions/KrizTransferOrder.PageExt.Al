pageextension 50193 KrizTransferOrder extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Kriz Shipping Id"; Rec."Kriz Shipping Id")
            {
                ApplicationArea = All;
                Caption = 'Shipping Id';
                ToolTip = 'Specifies the Kriz Shipping Id for the transfer order.';
            }
        }

    }
}