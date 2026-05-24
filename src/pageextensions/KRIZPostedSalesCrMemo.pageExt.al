pageextension 50152 "KRIZ Posted Sales Cr MemoExt" extends "Posted Sales Credit Memo"
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
                field("E-Invoice Status"; rec."E-Invoice Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'E-Invoice Status';
                    Editable = false;
                }

                field("LR No.";
                rec."LR No.")
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
                Caption = 'Krizzan e-Invoice';

                action("Generate Einvoice")
                {
                    ApplicationArea = All;
                    Caption = 'Generate e-Invoice';
                    Image = Export;

                    trigger OnAction()
                    var
                        salescreditMemoHeader: Record "Sales Cr.Memo Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        salescreditMemoHeader.Get(Rec."No.");
                        EInvHandler.SetCrMemoHeader(salescreditMemoHeader);
                        EInvHandler.run(); // Call the OnRun method for processing
                    end;
                }


            }

        }
    }

}

