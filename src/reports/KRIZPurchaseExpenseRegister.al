report 50033 "Kriz Purchase Expense Register"
{
    ProcessingOnly = true;
    Caption = 'Purchase Expense Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            trigger OnAfterGetRecord()
            var
                PurchInvHeader: Record "Purch. Inv. Header";
                VendorRec: Record Vendor;
                TDSEntry: Record "TDS Entry";
                TDSAmount: Decimal;
                TDSPercent: Decimal;
                SGSTRate: Decimal;
                SGSTAmt: Decimal;
                CGSTRate: Decimal;
                CGSTAmt: Decimal;
                IGSTRate: Decimal;
                IGSTAmt: Decimal;
                TotalGSTAmt: Decimal;
                HSNCode: Code[20];
                StateRec: Record State;
            begin
                // Skip if a Posted Purchase Invoice Header exists for this Document No.
                if PurchInvHeader.Get("Vendor Ledger Entry"."Document No.") then
                    CurrReport.Skip();

                // Calculate ledger entry amounts
                CalcFields("Remaining Amount", "Original Amount");

                // Fetch Vendor details
                if not VendorRec.Get("Vendor Ledger Entry"."Vendor No.") then
                    Clear(VendorRec);
                if not StateRec.Get(VendorRec."State Code") then
                    Clear(StateRec);

                // Fetch TDS details if applicable
                TDSAmount := 0;
                TDSPercent := 0;
                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                if TDSEntry.FindFirst() then begin
                    TDSAmount := Abs(TDSEntry."TDS Amount");
                    TDSPercent := TDSEntry."TDS %";
                end;

                // Fetch GST Details from Detailed GST Ledger Entry
                GetGSTDetailsFromDocument(
                    "Vendor Ledger Entry"."Document No.",
                    0,
                    SGSTRate,
                    SGSTAmt,
                    CGSTRate,
                    CGSTAmt,
                    IGSTRate,
                    IGSTAmt,
                    TotalGSTAmt,
                    HSNCode
                );

                // Build Data Array for non-Purchase Invoice entries
                Clear(txtData);
                txtData[1] := Format("Vendor Ledger Entry"."Document Type");
                txtData[2] := Format("Vendor Ledger Entry"."Posting Date", 0, '<Day,2>-<Month,2>-<Year4>');
                txtData[3] := "Vendor Ledger Entry"."Document No.";
                txtData[4] := "Vendor Ledger Entry"."Vendor No.";
                txtData[5] := VendorRec.Name;
                txtData[6] := "Vendor Ledger Entry"."External Document No."; // Vendor Invoice No / Ref No
                txtData[7] := Format("Vendor Ledger Entry"."Document Date", 0, '<Day,2>-<Month,2>-<Year4>');
                txtData[8] := VendorRec."State Code";
                txtData[9] := staterec."State Code (GST Reg. No.)";
                txtData[10] := VendorRec."GST Registration No.";
                txtData[11] := VendorRec.City;
                txtData[12] := ''; // Ship To GST
                txtData[13] := ''; // Ship To City
                txtData[14] := HSNCode;
                txtData[15] := Format(abs("Vendor Ledger Entry"."Original Amount")); // Line/Original Amount

                // Populating GST values retrieved from Detailed GST Ledger Entry
                txtData[16] := Format(SGSTRate + CGSTRate + IGSTRate); // Total GST %
                txtData[17] := Format(SGSTRate);
                txtData[18] := Format(SGSTAmt);
                txtData[19] := Format(CGSTRate);
                txtData[20] := Format(CGSTAmt);
                txtData[21] := Format(IGSTRate);
                txtData[22] := Format(IGSTAmt);
                txtData[23] := Format(TotalGSTAmt);

                txtData[24] := Format(abs("Vendor Ledger Entry"."Original Amount" + TotalGSTAmt)); // Amount To Vendor
                txtData[25] := Format(TDSPercent);
                txtData[26] := Format(TDSAmount);
                txtData[27] := Format(Abs("Vendor Ledger Entry"."Remaining Amount"));
                txtData[28] := "Vendor Ledger Entry".Description;
                txtData[29] := "Vendor Ledger Entry"."Global Dimension 1 Code";
                txtData[30] := VendorRec."Global Dimension 2 Code";
                txtData[31] := '';
                txtData[32] := '';
                txtData[33] := '';
                txtData[34] := '';
                txtData[35] := '';
                txtData[36] := "Vendor Ledger Entry"."External Document No.";
                txtData[37] := '';
                txtData[38] := "Vendor Ledger Entry"."Payment Method Code";
                txtData[39] := Format("Vendor Ledger Entry"."Due Date", 0, '<Day,2>-<Month,2>-<Year4>');
                txtData[40] := '';
                txtData[41] := '';
                txtData[42] := '';
                txtData[43] := '';
                txtData[44] := '';
                txtData[45] := '';
                txtData[46] := "Vendor Ledger Entry"."Vendor Posting Group";
                txtData[47] := '';
                txtData[48] := '';
                txtData[49] := '';
                txtData[50] := '';
                txtData[51] := '';
                txtData[52] := '';
                txtData[53] := '';
                txtData[54] := VendorRec."GST Registration No.";
                txtData[55] := '';

                MakeExcelDataBody();
            end;

            trigger OnPreDataItem()
            begin
                setfilter("Document Type", '%1', "Document Type"::Invoice);
                if VendorNo <> '' then
                    SetRange("Vendor No.", VendorNo);

                if (FromDate <> 0D) and (ToDate <> 0D) then
                    SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(VendorNo; VendorNo)
                    {
                        TableRelation = Vendor."No.";
                        Caption = 'Vendor No.';
                        ApplicationArea = All;
                    }
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
        VendorNo: Code[20];
        FromDate: Date;
        ToDate: Date;

    procedure GetGSTDetailsFromDocument(
        DocNo: Code[20];
        DocLineNo: Integer;
        var SGSTRate: Decimal;
        var SGSTAmt: Decimal;
        var CGSTRate: Decimal;
        var CGSTAmt: Decimal;
        var IGSTRate: Decimal;
        var IGSTAmt: Decimal;
        var TotalGSTAmt: Decimal;
        var HSNCode: Code[20])
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        // Reset output variables
        SGSTRate := 0;
        SGSTAmt := 0;
        CGSTRate := 0;
        CGSTAmt := 0;
        IGSTRate := 0;
        IGSTAmt := 0;
        TotalGSTAmt := 0;
        HSnCode := '';

        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", DocNo);

        if DocLineNo <> 0 then
            DetailedGSTLedgerEntry.SetRange("Document Line No.", DocLineNo);

        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                case DetailedGSTLedgerEntry."GST Component Code" of
                    'SGST', 'UTGST':
                        begin
                            SGSTRate := DetailedGSTLedgerEntry."GST %";
                            SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                        end;
                    'CGST':
                        begin
                            CGSTRate := DetailedGSTLedgerEntry."GST %";
                            CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                        end;
                    'IGST':
                        begin
                            IGSTRate := DetailedGSTLedgerEntry."GST %";
                            IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                        end;
                end;
                hsnCode := DetailedGSTLedgerEntry."HSN/SAC Code";
            until DetailedGSTLedgerEntry.Next() = 0;

        TotalGSTAmt := SGSTAmt + CGSTAmt + IGSTAmt;
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
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor State Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('State No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Ship To GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Ship To City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('HSN/SAC Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Line amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total GST%', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST/UGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST/UGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total GST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount To Vendor', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Percentage', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount Payable to Vendor', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Brand', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Business unit', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cost Center', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Budget Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Crop', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Season', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Employee', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Payment Term Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Due Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ineligible ITC', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RCM', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IRN No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Return Reason Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Posting Group', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Ref Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Ref Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cancellation Remark', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Category Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Base Unit of Measure', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GSTIN', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    var
        i: Integer;
    begin
        TempExcelBuffer.NewRow();
        for i := 1 to 55 do
            TempExcelBuffer.AddColumn(txtData[i], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Purchase Expense Register';
    begin
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}