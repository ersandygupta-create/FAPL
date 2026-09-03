pageextension 50194 KrixPostedTransferShipment extends 5743
{

    actions
    {
        addafter("&Shipment")
        {
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
                        TransferShipmentHeader: Record "Transfer Shipment Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        TransferShipmentHeader.Get(Rec."No.");
                        EInvHandler.SetTransferShipment(TransferShipmentHeader);
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
                        TransferShipmentHeader: Record "Transfer Shipment Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        TransferShipmentHeader.Get(Rec."No.");
                        EInvHandler.SetTransferShipment(TransferShipmentHeader);
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
                        TransferShipmentHeader: Record "Transfer Shipment Header";
                        EInvHandler: Codeunit "KRIZ e-Invoice Integration";
                    begin
                        TransferShipmentHeader.Get(Rec."No.");
                        EInvHandler.SetTransferShipment(TransferShipmentHeader);
                        EInvHandler.GenerateCanceledInvoice(); // Call the OnRun method for processing
                    end;
                }

            }
        }
    }


}