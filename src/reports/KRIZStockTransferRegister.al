report 50034 "Transfer Expense Register"
{
    ProcessingOnly = true;
    Caption = 'Transfer Expense Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        // -------------------------------------------------------------
        // DATAITEM 1: TRANSFER SHIPMENT
        // -------------------------------------------------------------
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            // trigger OnPreDataItem()
            // begin
            //     if (FromDate <> 0D) and (ToDate <> 0D) then
            //         SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            // end;

            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                var
                    ItemRec: Record Item;
                    LocationFrom: Record Location;
                    LocationTo: Record Location;
                    IGSTRate: Decimal;
                    IGSTAmt: Decimal;
                    TaxBaseAmt: Decimal;
                    NetAmt: Decimal;
                begin
                    if "Transfer Shipment Line".Quantity = 0 then
                        CurrReport.Skip();

                    // Fetch Item details
                    if not ItemRec.Get("Transfer Shipment Line"."Item No.") then
                        Clear(ItemRec);

                    // Fetch Location details for GSTIN
                    if not LocationFrom.Get("Transfer Shipment Header"."Transfer-from Code") then
                        Clear(LocationFrom);

                    if not LocationTo.Get("Transfer Shipment Header"."Transfer-to Code") then
                        Clear(LocationTo);

                    // Calculate Base Amount & Tax
                    TaxBaseAmt := "Transfer Shipment Line".Quantity * "Transfer Shipment Line"."Unit Price";

                    GetGSTDetailsFromDocument(
                        "Transfer Shipment Line"."Document No.",
                        "Transfer Shipment Line"."Line No.",
                        IGSTRate,
                        IGSTAmt
                    );

                    NetAmt := TaxBaseAmt + IGSTAmt;

                    // Build Data Array
                    Clear(txtData);
                    // txtData[1] := 'Transfer Shipment';
                    // txtData[2] := "Transfer Shipment Header"."No.";
                    // txtData[3] := Format("Transfer Shipment Header"."Posting Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    // txtData[4] := "Transfer Shipment Header"."Transfer-from Code";
                    // txtData[5] := "Transfer Shipment Header"."Transfer-to Code";
                    // txtData[6] := LocationFrom."GST Registration No.";
                    // txtData[7] := LocationTo."GST Registration No.";
                    // txtData[8] := "Transfer Shipment Line"."Item No.";
                    // txtData[9] := "Transfer Shipment Line".Description;
                    // txtData[10] := "Transfer Shipment Line"."HSN/SAC Code";
                    // txtData[11] := "Transfer Shipment Line"."Lot No.";
                    // txtData[12] := Format("Transfer Shipment Line"."Expiration Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    // txtData[13] := "Transfer Shipment Line"."Unit of Measure Code";
                    // txtData[14] := Format("Transfer Shipment Line".Quantity);
                    // txtData[15] := Format("Transfer Shipment Line"."Unit Price");
                    // txtData[16] := Format(TaxBaseAmt);
                    // txtData[17] := Format(IGSTRate);
                    // txtData[18] := Format(IGSTAmt);
                    // txtData[19] := Format(NetAmt);
                    // txtData[20] := "Transfer Shipment Header"."E-Way Bill No.";
                    // txtData[21] := Format("Transfer Shipment Header"."E-Way Bill Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    // txtData[22] := 'Stock transfer';
                    // txtData[23] := 'No';
                    // txtData[24] := "Transfer Shipment Header"."IRN Hash";
                    // txtData[25] := Format("Transfer Shipment Line"."MFG Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    // txtData[26] := "Transfer Shipment Header"."Shipment ID";
                    // txtData[27] := "Transfer Shipment Header"."User ID";

                    MakeExcelDataBody();
                end;
            }
        }

        // -------------------------------------------------------------
        // DATAITEM 2: TRANSFER RECEIPT
        // -------------------------------------------------------------
        //     dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        //     {
        //         trigger OnPreDataItem()
        //         begin
        //             if (FromDate <> 0D) and (ToDate <> 0D) then
        //                 SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
        //         end;

        //         dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
        //         {
        //             DataItemLink = "Document No." = FIELD("No.");
        //             DataItemTableView = SORTING("Document No.", "Line No.");

        //             trigger OnAfterGetRecord()
        //             var
        //                 ItemRec: Record Item;
        //                 LocationFrom: Record Location;
        //                 LocationTo: Record Location;
        //                 IGSTRate: Decimal;
        //                 IGSTAmt: Decimal;
        //                 TaxBaseAmt: Decimal;
        //                 NetAmt: Decimal;
        //             begin
        //                 if "Transfer Receipt Line".Quantity = 0 then
        //                     CurrReport.Skip();

        //                 // Fetch Item details
        //                 if not ItemRec.Get("Transfer Receipt Line"."Item No.") then
        //                     Clear(ItemRec);

        //                 // Fetch Location details for GSTIN
        //                 if not LocationFrom.Get("Transfer Receipt Header"."Transfer-from Code") then
        //                     Clear(LocationFrom);

        //                 if not LocationTo.Get("Transfer Receipt Header"."Transfer-to Code") then
        //                     Clear(LocationTo);

        //                 // Calculate Base Amount & Tax
        //                 TaxBaseAmt := "Transfer Receipt Line".Quantity * "Transfer Receipt Line"."Unit Price";

        //                 GetGSTDetailsFromDocument(
        //                     "Transfer Receipt Line"."Document No.", 
        //                     "Transfer Receipt Line"."Line No.", 
        //                     IGSTRate, 
        //                     IGSTAmt
        //                 );

        //                 NetAmt := TaxBaseAmt + IGSTAmt;

        //                 // Build Data Array
        //                 Clear(txtData);
        //                 txtData[1] := 'Transfer Receipt';
        //                 txtData[2] := "Transfer Receipt Header"."No.";
        //                 txtData[3] := Format("Transfer Receipt Header"."Posting Date", 0, '<Day,2>-<Month,2>-<Year4>');
        //                 txtData[4] := "Transfer Receipt Header"."Transfer-from Code";
        //                 txtData[5] := "Transfer Receipt Header"."Transfer-to Code";
        //                 txtData[6] := LocationFrom."GST Registration No.";
        //                 txtData[7] := LocationTo."GST Registration No.";
        //                 txtData[8] := "Transfer Receipt Line"."Item No.";
        //                 txtData[9] := "Transfer Receipt Line".Description;
        //                 txtData[10] := "Transfer Receipt Line"."HSN/SAC Code";
        //                 txtData[11] := "Transfer Receipt Line"."Lot No.";
        //                 txtData[12] := Format("Transfer Receipt Line"."Expiration Date", 0, '<Day,2>-<Month,2>-<Year4>');
        //                 txtData[13] := "Transfer Receipt Line"."Unit of Measure Code";
        //                 txtData[14] := Format("Transfer Receipt Line".Quantity);
        //                 txtData[15] := Format("Transfer Receipt Line"."Unit Price");
        //                 txtData[16] := Format(TaxBaseAmt);
        //                 txtData[17] := Format(IGSTRate);
        //                 txtData[18] := Format(IGSTAmt);
        //                 txtData[19] := Format(NetAmt);
        //                 txtData[20] := "Transfer Receipt Header"."E-Way Bill No.";
        //                 txtData[21] := Format("Transfer Receipt Header"."E-Way Bill Date", 0, '<Day,2>-<Month,2>-<Year4>');
        //                 txtData[22] := 'Transfer order';
        //                 txtData[23] := 'No';
        //                 txtData[24] := "Transfer Receipt Header"."IRN Hash";
        //                 txtData[25] := Format("Transfer Receipt Line"."MFG Date", 0, '<Day,2>-<Month,2>-<Year4>');
        //                 txtData[26] := "Transfer Receipt Header"."Shipment ID";
        //                 txtData[27] := "Transfer Receipt Header"."User ID";

        //                 MakeExcelDataBody();
        //             end;
        //         }
        //     }
        // }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date Filter';
                        ApplicationArea = All;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date Filter';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        MakeExcelInfo();
    end;

    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        txtData: array[100] of Text[250];
        FromDate: Date;
        ToDate: Date;

    procedure GetGSTDetailsFromDocument(
        DocNo: Code[20];
        LineNo: Integer;
        var IGSTRate: Decimal;
        var IGSTAmt: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        IGSTRate := 0;
        IGSTAmt := 0;

        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", DocNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", LineNo);

        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if DetailedGSTLedgerEntry."GST Component Code" = 'IGST' then begin
                    IGSTRate := DetailedGSTLedgerEntry."GST %";
                    IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                end;
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    procedure MakeExcelInfo()
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        MakeExcelDataHeader();
    end;

    procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('VoucherId', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transfer From Location', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transfer To Location', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transfer From GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transfer To GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Lot number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Exp Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit Of Measure', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Unit Price', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Tax Base Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Tax %', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Net Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('EWay Bill No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EWay Bill Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Transfer Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cancelled Transfer Order', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IRN', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('MFG Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Shipment Id', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('User Id', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    var
        i: Integer;
    begin
        TempExcelBuffer.NewRow();
        for i := 1 to 27 do begin
            if i in [14, 15, 16, 17, 18, 19] then
                TempExcelBuffer.AddColumn(txtData[i], FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(txtData[i], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        end;
    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Transfer Expense Register';
    begin
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}