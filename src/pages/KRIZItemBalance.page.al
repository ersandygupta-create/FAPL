page 50000 "Item Balance Page"
{
    PageType = Card;
    SourceTable = "KRIZ Item Balance Table";
    Caption = 'Item Balance';
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            group("Filters")  // Add Filters at the Top
            {
                field(FromDate; FromDate)
                {
                    Caption = 'From Date';
                    ToolTip = 'Enter the starting date for filtering.';
                    Enabled = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(ToDate; ToDate)
                {
                    Caption = 'To Date';
                    ToolTip = 'Enter the ending date for filtering.';
                    Enabled = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }

            }
            repeater(Group)
            {
                Editable = false;
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Technical Name"; Rec."Technical Name") { }
                field("Line Discount Group"; Rec."Line Discount Group") { }
                field("Item Group"; Rec."Item Group") { }
                field("Item Type"; Rec."Item Type") { }
                field("Unit Conversion Factor"; Rec."Unit Conversion Factor") { }
                field("Opening Balance"; Rec."Opening Balance") { }
                field("Closing Balance"; Rec."Closing Balance") { }
                field("Positive Adjustment"; Rec."Positive Adjustment") { }
                field("Negative Adjustment"; Rec."Negative Adjustment") { }
                field("Purchase Qty"; Rec."Purchase Qty") { }
                field("Purchase Ret Qty"; Rec."Purchase Ret Qty") { }
                field("Sales Qty"; Rec."Sales Qty") { }
                field("Sales Return Qty"; Rec."Sales Return Qty") { }
                field("Transfer Shipment"; Rec."Transfer Shipment") { }
                field("Transfer Receipt"; Rec."Transfer Receipt") { }

            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CalculateBalance)
            {
                Caption = 'Calculate Balance';
                Image = Calculate;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    //  if (FromDate = 0D) or (ToDate = 0D) then
                    //   Error('Please enter From Date and To Date.');   
                    CalculateItemBalance();
                end;
            }
            action(ExportToExcel)
            {
                Caption = 'Open in Excel';
                Image = Export;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer" temporary;
                begin
                    Clear(ExcelBuffer);
                    ExcelBuffer.SetUseInfoSheet();

                    // Add column headers
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn('Item No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Technical Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Line Discount Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Item Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Item Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Unit Conversion Factor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Opening Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Closing Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Positive Adjustment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Negative Adjustment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Purchase Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Purchase Return Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Sales Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Sales Return Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Transfer Shipment', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Transfer Recieve', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);


                    // Loop through records and add data
                    Rec.Reset();
                    if Rec.FindSet() then begin
                        repeat
                            ExcelBuffer.NewRow();
                            ExcelBuffer.AddColumn(Rec."Item No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Item Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Technical Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Line Discount Group", false, '', False, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(rec."Item Group", false, '', False, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(rec."Item Type", false, '', False, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Unit Conversion Factor", false, '', False, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Opening Balance", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Closing Balance", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Positive Adjustment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Negative Adjustment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Purchase Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Purchase Ret Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Sales Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Sales Return Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Transfer Shipment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Rec."Transfer Receipt", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                        until Rec.Next() = 0;
                    end;

                    // Create and open Excel file
                    ExcelBuffer.CreateNewBook('Item Balance');
                    ExcelBuffer.WriteSheet('Sheet1', CompanyName, UserId);
                    ExcelBuffer.CloseBook();
                    ExcelBuffer.OpenExcel();
                end;
            }
        }
    }



    var
        RecItemBalance: Record "KRIZ Item Balance Table" temporary;
        FromDate: Date;
        ToDate: Date;
        Site: Code[20];



    trigger OnOpenPage()
    begin

        LoadItemDetails();
    end;

    procedure CalculateItemBalance()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        OpeningBalance: Decimal;
        TotalInward: Decimal;
        TotalOutward: Decimal;
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            Error('Please enter From Date and To Date.');
        // Debug: Check the date filter values
        //Message('Filtering from %1 to %2', FromDate, ToDate);

        // Implement logic to calculate balance using Item Ledger Entry
        // Message('Balance calculation logic to be implemented.');
        Rec.Reset();
        if rec.FindSet()
        then
            repeat

                //Reset Value before calculating
                Rec."Opening Balance" := 0;
                Rec."Closing Balance" := 0;
                Rec."Purchase Qty" := 0;
                Rec."Purchase Ret Qty" := 0;
                Rec."Sales Qty" := 0;
                Rec."Sales Return Qty" := 0;
                Rec."Transfer Shipment" := 0;
                Rec."Transfer Receipt" := 0;
                Rec."Positive Adjustment" := 0;
                Rec."Negative Adjustment" := 0;


                OpeningBalance := 0;
                TotalInward := 0;
                TotalOutward := 0;

                // Calculate the Opening Balance
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", Rec."Item No.");
                ItemLedgerEntry.SetFilter("Posting Date", '<%1', FromDate);
                if
                ItemLedgerEntry.FindSet()
                then
                    repeat

                        case ItemLedgerEntry."Document Type" of
                            "Item Ledger Document Type"::"Purchase Receipt",
                            "Item Ledger Document Type"::"Sales Return Receipt",
                            "Item Ledger Document Type"::"Transfer Receipt",
                            "Item Ledger Document Type"::"Inventory Receipt":
                                OpeningBalance += ItemLedgerEntry.Quantity;

                            "Item Ledger Document Type"::"Purchase Return Shipment",
                                    "Item Ledger Document Type"::"Sales Shipment",
                                    "Item Ledger Document Type"::"Transfer Shipment",
                                    "Item Ledger Document Type"::"Inventory Shipment":
                                OpeningBalance -= ItemLedgerEntry.Quantity;

                        end;
                    until ItemLedgerEntry.Next() = 0;
                Rec."Opening Balance" := OpeningBalance;
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Item No.", rec."Item No.");
                ItemLedgerEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                if
                ItemLedgerEntry.FindSet()
                then
                    repeat
                        case ItemLedgerEntry."Document Type" of
                            "Item Ledger Document Type"::"Purchase Receipt":
                                Rec."Purchase Qty" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Purchase Return Shipment":
                                Rec."Purchase Ret Qty" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Sales Shipment":
                                Rec."sales Qty" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Sales Return Receipt":
                                Rec."Sales Return Qty" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Transfer Receipt":
                                Rec."Transfer Receipt" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Transfer Shipment":
                                Rec."Transfer Shipment" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Inventory Receipt":
                                Rec."positive Adjustment" += ItemLedgerEntry.Quantity;
                            "Item Ledger Document Type"::"Inventory Shipment":
                                Rec."Negative Adjustment" += ItemLedgerEntry.Quantity;

                        end;
                    until
                    ItemLedgerEntry.Next() = 0;
                TotalInward := Rec."Purchase Qty" + Rec."Sales Return Qty" + Rec."Transfer Receipt" + Rec."Positive Adjustment";
                TotalOutward := Abs(Rec."Sales Qty" + Rec."Purchase Ret Qty" + Rec."Transfer Shipment" + Rec."Negative Adjustment");
                Rec."Closing Balance" := Rec."Opening Balance" + TotalInward - TotalOutward;
                Rec.Modify()
                        until rec.Next() = 0;
        Message('Item Balance Updated Successfully');

    end;

    procedure LoadItemDetails()

    var
        RecItem: Record Item;
    begin
        Clear(Rec);
        rec.Reset();
        rec.DeleteAll();
        if
        RecItem.FindSet() then
            repeat
                rec.Init();
                rec."Item No." := RecItem."No.";
                rec."Item Name" := RecItem.Description;
                rec."Technical Name" := RecItem."Search Description";
                rec.Insert();
            until RecItem.Next() = 0

    end;

}
