pageextension 50151 "KRIZ Posted Purch Cr MemoExt" extends "Posted Purchase Credit Memo"
{
    layout
    {

        addlast(Content)
        {
            group("Additional Fields")
            {
                Caption = 'Additional Fields';
                field("Cancelled Invoice"; rec."Cancelled Invoice")
                {
                    ApplicationArea = all;
                    ToolTip = 'Cancelled Invoice';
                    Editable = true;
                }

                field("Eway Bill No."; rec."Eway Bill No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'EWay Bill No.';
                    Editable = true;
                }


                field("Eway Bill Date"; rec."Eway Bill Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'EWay Bill Date.';
                }
                field("E-Waybill Valid Till"; rec."E-Waybill Valid Till")
                {
                    ApplicationArea = all;
                    ToolTip = 'E-Waybill Valid Till';
                }
                field("IRN No."; rec."IRN No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'IRN No.';
                    Editable = true;
                }


                field("LR No."; rec."LR No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'LR No.';
                    Editable = true;
                }

                field("LR Date"; rec."LR Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'LR Date';
                    Editable = true;
                }

            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            group("E-Invoice Options")
            {
                Caption = 'Krizzan E-Invoice';

                action("GenerateEWaybill")
                {
                    ApplicationArea = All;
                    Caption = 'Generate e-Waybill';
                    Image = Export;
                    ToolTip = 'Generate Ewaybill';
                    trigger OnAction()
                    var
                        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        PurchCrMemoHeader.Get(Rec."No.");
                        EInvHandler.SetPurchCrMemoHeader(PurchCrMemoHeader);
                        EInvHandler.Run() // Call the OnRun method for processing
                    end;
                }
            }
        }
    }
}

