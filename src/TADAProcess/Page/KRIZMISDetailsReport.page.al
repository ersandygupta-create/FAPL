page 50012 "KRIZ MIS Report Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "KRIZ MIS Details";
    Caption = 'MIS Report';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Order No"; Rec."Order No")
                {
                    ApplicationArea = ALL;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = ALL;
                }
                field("LR No"; Rec."LR No")
                {
                    ApplicationArea = ALL;
                }
                field("LR Date"; Rec."LR Date")
                {
                    ApplicationArea = ALL;
                }
                field(Consignor; Rec.Consignor)
                {
                    ApplicationArea = ALL;
                }
                field("Pick Up"; Rec."Pick Up")
                {
                    ApplicationArea = ALL;
                }
                field("Pick Up GST"; Rec."Pick Up GST")
                {
                    ApplicationArea = ALL;
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ApplicationArea = ALL;
                }
                field("Drop Off Location"; Rec."Drop Off Location")
                {
                    ApplicationArea = ALL;
                }
                field("Drop Off GST"; Rec."Drop Off GST")
                {
                    ApplicationArea = ALL;
                }
                field("Ship To Pin"; Rec."Ship To Pin")
                {
                    ApplicationArea = ALL;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = ALL;
                }
                field("Truck Number"; Rec."Truck Number")
                {
                    ApplicationArea = ALL;
                }
                field("Truck Type"; Rec."Truck Type")
                {
                    ApplicationArea = ALL;
                }
                field("Weight of Shipment"; Rec."Weight of Shipment")
                {
                    ApplicationArea = ALL;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = ALL;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportMISReport)
            {
                Caption = 'Import MIS Report';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ImportReport: Report "Import MIS Details"; // Replace with your actual report name or ID
                begin
                    Report.RunModal(Report::"Import MIS Details", true, true);
                end;
            }
        }
    }
    var
        myInt: Integer;
}
