pageextension 50153 "KRIZ Posted Sales InvoiceExt" extends "Posted Sales Invoice"
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
                field("E-Inv Cancelled Date"; rec."E-Inv. Cancelled Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'E-Inv. Cancelled Date';
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
            // Main Parent Menu
            group("E-Invoice Options")
            {
                Caption = 'Krizzan E-Invoice';

                // Submenu 1: Send e-Invoice to Velocis
                action("GenerateEInvoice")
                {
                    Caption = 'Generate EInvoice';
                    Image = Export;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        SalesInvoiceHeader.Get(Rec."No.");
                        EInvHandler.SetSalesInvHeader(SalesInvoiceHeader);
                        EInvHandler.Run(); // Call the OnRun method for processing
                    end;
                }
                action("GenerateEWaybill")
                {
                    ApplicationArea = All;
                    Caption = 'Generate e-Waybill';
                    Image = Export;

                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        SalesInvoiceHeader.Get(Rec."No.");
                        EInvHandler.SetSalesInvHeader(SalesInvoiceHeader);
                        EInvHandler.GenerateEWaybillByIRN(); // Call the OnRun method for processing
                    end;
                }
                action(CancelIRN)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel IRN';
                    Image = Cancel;
                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        SalesInvoiceHeader.Get(Rec."No.");
                        EInvHandler.SetSalesInvHeader(SalesInvoiceHeader);
                        EInvHandler.GenerateCanceledInvoice(); // Call the OnRun method for processing
                    end;
                }

            }
        }
    }
}

