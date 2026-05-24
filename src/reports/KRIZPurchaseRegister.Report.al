report 50015 "Purchase Register"
{
    ProcessingOnly = true;
    Caption = 'Purchase Register';
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("Posting Date");
            RequestFilterFields = "Posting Date", "No.", "Buy-from Vendor No.";

            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    WHERE(Quantity = FILTER(<> 0),
                                    "System-Created Entry" = const(false));

                trigger OnAfterGetRecord()
                begin
                    CLEAR(Item);
                    CLEAR(ItemCat);
                    IF Item.GET("No.") THEN
                        IF ItemCat.GET(Item."Item Category Code") THEN;


                    CLEAR(IGSTAmt);
                    CLEAR(SGSTAmt);
                    CLEAR(CGSTAmt);
                    CLEAR(IGSTRate);
                    CLEAR(SGSTRate);
                    CLEAR(CGSTRate);
                    CLEAR(CESSRate);
                    CLEAR(CESSAmt);

                    DetailedGSTLedgEntry.RESET();
                    DetailedGSTLedgEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.");
                    DetailedGSTLedgEntry.SETRANGE("Transaction Type", DetailedGSTLedgEntry."Transaction Type"::Purchase);
                    DetailedGSTLedgEntry.SETRANGE("Document Type", DetailedGSTLedgEntry."Document Type"::Invoice);
                    DetailedGSTLedgEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgEntry.SETRANGE("No.", "No.");
                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'CGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        CGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        CGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'IGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        IGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        IGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'SGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        SGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        SGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'UGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        SGSTAmt := -DetailedGSTLedgEntry."GST Amount";
                        SGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'CESS');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        CESSAmt := -DetailedGSTLedgEntry."GST Amount";
                        CESSRate := DetailedGSTLedgEntry."GST %";
                    END;

                    "GST %" := SGSTRate + CGSTRate + IGSTRate;
                    "Total GST Amount" := Abs(SGSTAmt + CGSTAmt + IGSTAmt);
                    "Amount To Vendor" := Amount + "Total GST Amount";


                    txtData[42] := FORMAT(Type);
                    txtData[52] := "No.";
                    txtData[43] := Description + '' + "Description 2";
                    txtData[53] := Item."Item Category Code";
                    txtData[54] := ItemCat.Description;

                    txtData[14] := "HSN/SAC Code";
                    txtData[55] := Item."Base Unit of Measure";
                    txtData[27] := Format("Amount To Vendor" - TDSAmount);
                    txtData[15] := Format("Purch. Inv. Line".Quantity * "Purch. Inv. Line"."Direct Unit Cost");



                    txtData[17] := FORMAT(SGSTRate);
                    txtData[18] := FORMAT(ROUND(SGSTAmt, 0.01));
                    txtData[19] := FORMAT(CGSTRate);
                    txtData[20] := FORMAT(ROUND(CGSTAmt, 0.01));
                    txtData[21] := FORMAT(IGSTRate);
                    txtData[22] := FORMAT(ROUND(IGSTAmt, 0.01));
                    txtData[16] := FORMAT(ROUND("GST %", 0.01));
                    txtData[23] := FORMAT(ROUND("Total GST Amount", 0.01));
                    txtData[24] := FORMAT(ROUND("Amount To Vendor", 0.01));
                    txtData[56] := Format(Quantity);

                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(recLocation);
                CLEAR(recVendor);
                CLEAR(SalespersonPurchaser);
                Clear(TDSAmount);

                IF recLocation.GET("Location Code") THEN;
                IF recVendor.GET("Buy-from Vendor No.") THEN;
                IF SalespersonPurchaser.GET("Purchaser Code") THEN;

                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", "No.");
                if TDSEntry.FindSet() then
                    repeat
                        TDSAmount += TDSEntry."TDS Amount";
                    until TDSEntry.Next = 0;

                if (docno <> "No.") then begin
                    docno := "No.";
                    TDSAmount := TDSAmount
                end
                else
                    TDSAmount := 0;

                txtData[58] := recLocation."GST Registration No.";//CompanyInfo."GST Registration No.";

                txtData[1] := 'Invoice';
                txtData[2] := FORMAT("Posting Date");
                txtData[3] := "No.";
                txtData[4] := "Buy-from Vendor No.";
                txtData[5] := recVendor.Name;
                txtData[48] := recVendor."Vendor Posting Group";
                txtData[8] := recVendor."State Code";
                txtData[57] := "Location Code";

                txtData[40] := "Payment Terms Code";
                txtData[41] := FORMAT("Due Date");
                txtData[39] := FORMAT("Invoice Type");
                txtData[38] := "Vendor Order No.";

                if recState.Get(recVendor."State Code") THEN;
                if payVendor.Get("Pay-to Vendor No.") THEN;
                txtData[9] := recstate."State Code (GST Reg. No.)";


                if
               (payVendor."GST Registration No." <> '')
               then
                    txtdata[10] := payVendor."GST Registration No."
                else
                    txtData[10] := 'UnRegistered';
                txtData[11] := recVendor.City;
                if
                (recVendor."GST Registration No." <> '')
                then
                    txtdata[12] := recVendor."GST Registration No."
                else
                    txtData[12] := 'UnRegistered';
                txtData[13] := payVendor.City;
                txtData[6] := "Vendor Invoice No."; //vendor invoice no
                txtData[8] := Format("Document Date"); // vendor Invoice date
                txtData[47] := '';// return reason description
                txtData[49] := ''; // invoice ref num
                txtData[50] := Format('');// Invoice Ref Date
                txtData[26] := Format(TDSAmount);
                txtData[28] := "Posting Description";

                txtData[51] := '';//Cancelled Invoice
                txtData[44] := '';//Ineligible ITC
                txtData[45] := '';//RCM
                txtData[46] := '';
                Clear(BudgetType);
                Clear(BusinessUnit);
                Clear(CostCenter);
                Clear(Crop);
                DimSetEntry.SetRange("Dimension Set ID", "Purch. Inv. Header"."Dimension Set ID");
                if DimSetEntry.FindSet() then
                    repeat
                        case DimSetEntry."Dimension Code" of
                            'BUDGETTYPE':
                                BudgetType := DimSetEntry."Dimension Value Code";
                            'BU':
                                BusinessUnit := DimSetEntry."Dimension Value Code";
                            'CC':
                                CostCenter := DimSetEntry."Dimension Value Code";
                            'CROP':
                                Crop := DimSetEntry."Dimension Value Code";
                            'SEASON':
                                Season := DimSetEntry."Dimension Value Code";
                            'EMPLOYEE':
                                Employee := DimSetEntry."Dimension Value Code";
                        end;
                    until DimSetEntry.Next() = 0;

                txtData[30] := BusinessUnit;
                txtData[31] := CostCenter;
                txtData[33] := Crop;
                txtData[32] := BudgetType;
                txtData[29] := Brand;
                txtData[34] := Season;
                txtData[35] := Employee;
                txtData[36] := 'Purchase order number';
                txtData[36] := 'Purchase order Date';



            end;

        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = sorting("Document No.", "Line No.")
                                    where(Quantity = filter(<> 0),
                                    "System-Created Entry" = const(false));

                trigger OnAfterGetRecord()
                begin
                    IF Item.GET("No.") THEN
                        IF ItemCat.GET(Item."Item Category Code") THEN;

                    CLEAR(IGSTAmt);
                    CLEAR(SGSTAmt);
                    CLEAR(CGSTAmt);
                    CLEAR(IGSTRate);
                    CLEAR(SGSTRate);
                    CLEAR(CGSTRate);
                    CLEAR(CESSRate);
                    CLEAR(CESSAmt);

                    DetailedGSTLedgEntry.RESET();
                    DetailedGSTLedgEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.");
                    DetailedGSTLedgEntry.SETRANGE("Transaction Type", DetailedGSTLedgEntry."Transaction Type"::Purchase);
                    DetailedGSTLedgEntry.SETRANGE("Document Type", DetailedGSTLedgEntry."Document Type"::"Credit Memo");
                    DetailedGSTLedgEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgEntry.SETRANGE("No.", "No.");
                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'CGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        CGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        CGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'IGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        IGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        IGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'SGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        SGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        SGSTRate := DetailedGSTLedgEntry."GST %";
                    END;
                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'CESS');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        CESSAmt := DetailedGSTLedgEntry."GST Amount";
                        CESSRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'UGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        SGSTAmt := DetailedGSTLedgEntry."GST Amount";
                        SGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    "GST %" := SGSTRate + CGSTRate + IGSTRate;
                    "Total GST Amount" := SGSTAmt + CGSTAmt + IGSTAmt;
                    "Amount To Vendor" := (-Amount) + "Total GST Amount";

                    txtData[42] := FORMAT(Type);
                    txtData[52] := "No.";
                    txtData[43] := Description + '' + "Description 2";
                    txtData[53] := Item."Item Category Code";
                    txtData[54] := ItemCat.Description;

                    txtData[14] := "HSN/SAC Code";
                    txtData[55] := Item."Base Unit of Measure";



                    txtData[17] := FORMAT(SGSTRate);
                    txtData[18] := FORMAT(ROUND(SGSTAmt, 0.01));
                    txtData[19] := FORMAT(CGSTRate);
                    txtData[20] := FORMAT(ROUND(CGSTAmt, 0.01));
                    txtData[21] := FORMAT(IGSTRate);
                    txtData[22] := FORMAT(ROUND(IGSTAmt, 0.01));
                    txtData[16] := FORMAT(ROUND("GST %", 0.01));
                    txtData[23] := FORMAT(ROUND("Total GST Amount", 0.01));
                    txtData[24] := FORMAT(ROUND("Amount To Vendor", 0.01));
                    txtData[56] := Format(-Quantity);
                    txtData[15] := Format(-("Purch. Cr. Memo Line".Quantity * "Purch. Cr. Memo Line"."Direct Unit Cost"));



                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(recLocation);
                CLEAR(recVendor);
                CLEAR(SalespersonPurchaser);
                if recLocation.GET("Location Code") then;
                if recVendor.GET("Buy-from Vendor No.") then;
                if SalespersonPurchaser.GET("Purchaser Code") then;

                txtData[58] := recLocation."GST Registration No.";//CompanyInfo."GST Registration No.";
                txtData[1] := 'Credit Memo';
                txtData[2] := FORMAT("Posting Date");
                txtData[3] := "No.";
                txtData[4] := "Buy-from Vendor No.";
                txtData[5] := recVendor.Name;
                txtData[48] := recVendor."Vendor Posting Group";
                txtData[7] := recVendor."State Code";
                txtData[57] := "Location Code";

                txtData[40] := "Payment Terms Code";
                txtData[41] := FORMAT("Due Date");
                txtData[39] := FORMAT("Invoice Type");
                txtData[38] := "Vendor Cr. Memo No.";

                if recState.Get(recVendor."State Code") THEN;
                if payVendor.Get("Pay-to Vendor No.") THEN;
                txtData[9] := recstate."State Code (GST Reg. No.)"; //
                if
               (payVendor."GST Registration No." <> '')
               then
                    txtdata[10] := payVendor."GST Registration No."
                else
                    txtData[10] := 'UnRegistered';
                txtData[11] := recVendor.City;
                if
                (recVendor."GST Registration No." <> '')
                then
                    txtdata[12] := recVendor."GST Registration No."
                else
                    txtData[12] := 'UnRegistered';
                txtData[13] := payVendor.City;
                txtData[6] := "Vendor Cr. Memo No."; //vendor invoice no
                txtData[7] := Format("Document Date"); // vendor Invoice date
                txtData[47] := '';// return reason description
                txtData[49] := "Reference Invoice No."; // invoice ref num
                clear(recPurchInvoiceHead);
                recPurchInvoiceHead.Reset();
                recPurchInvoiceHead.SetRange("No.", "Reference Invoice No.");
                if recPurchInvoiceHead.FindFirst() then
                    txtData[50] := Format(recPurchInvoiceHead."Posting Date");// Invoice Ref Date
                txtData[25] := format(0);//Format("TDS Percentage");
                txtData[51] := format("Cancelled Invoice");
                txtData[44] := '';//Ineligible ITC
                txtData[45] := '';//RCM
                txtData[27] := Format("Amount To Vendor" - TDSAmount);
                txtData[28] := "Posting Description";
                txtData[46] := "IRN No.";
                Clear(BudgetType);
                Clear(BusinessUnit);
                Clear(CostCenter);
                Clear(Crop);
                DimSetEntry.SetRange("Dimension Set ID", "Purch. Inv. Header"."Dimension Set ID");
                if DimSetEntry.FindSet() then
                    repeat
                        case DimSetEntry."Dimension Code" of
                            'BUDGETTYPE':
                                BudgetType := DimSetEntry."Dimension Value Code";
                            'BU':
                                BusinessUnit := DimSetEntry."Dimension Value Code";
                            'CC':
                                CostCenter := DimSetEntry."Dimension Value Code";
                            'CROP':
                                Crop := DimSetEntry."Dimension Value Code";
                            'SEASON':
                                Season := DimSetEntry."Dimension Value Code";
                            'EMPLOYEE':
                                Employee := DimSetEntry."Dimension Value Code";
                        end;
                    until DimSetEntry.Next() = 0;

                txtData[30] := BusinessUnit;
                txtData[31] := CostCenter;
                txtData[33] := Crop;
                txtData[32] := BudgetType;
                txtData[29] := Brand;
                txtData[34] := Season;
                txtData[35] := Employee;
                txtData[36] := 'Purchase order number';
                txtData[36] := 'Purchase order Date';
            end;

            trigger OnPreDataItem()
            begin
                "Purch. Cr. Memo Hdr.".SETCURRENTKEY("Posting Date");
                SETFILTER("Posting Date", "Purch. Inv. Header".GETFILTER("Posting Date"));
                SETFILTER("Buy-from Vendor No.", "Purch. Inv. Header".GETFILTER("Buy-from Vendor No."));
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
                    field(PrintToExcelCap; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Print to Excel field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnInit()
        begin
            PrintToExcel := TRUE;
        end;
    }


    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        IF PrintToExcel THEN
            MakeExcelInfo();
    end;

    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";

        recPurchInvoiceHead: Record "Purch. Inv. Header";
        recState: Record state;
        recLocation: Record "Location";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        recVendor: Record Vendor;
        ShipAgent: Record "Shipping Agent";
        payVendor: Record Vendor;
        Item: Record "Item";
        ItemCat: Record "Item Category";
        DetailedGSTLedgEntry: Record "Detailed GST Ledger Entry";
        txtData: array[255] of Text[200];
        PrintToExcel: Boolean;
        CGSTRate: Decimal;
        CGSTAmt: Decimal;
        SGSTRate: Decimal;
        SGSTAmt: Decimal;
        IGSTRate: Decimal;
        IGSTAmt: Decimal;
        CESSRate: Decimal;
        CESSAmt: Decimal;
        "GST %": Decimal;
        "Total GST Amount": Decimal;
        "Amount To Vendor": Decimal;
        "TDSAmount": Decimal;
        TDSEntry: Record "TDS Entry";
        docno: Text;
        DimSetEntry: Record "Dimension Set Entry";
        BudgetType: Code[20];
        BusinessUnit: Code[20];
        CostCenter: Code[20];
        Crop: Code[20];
        Brand: Code[20];
        Season: code[20];
        Employee: Code[20];


    procedure MakeExcelInfo()
    begin
        TempExcelBuffer.SetUseInfoSheet();
        TempExcelBuffer.AddInfoColumn(COMPANYNAME, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(USERID, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(TODAY, false, false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.ClearNewRow();
        MakeExcelDataHeader();
    end;

    procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[1]
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[2]
        TempExcelBuffer.AddColumn('Document No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[3]
        TempExcelBuffer.AddColumn('Vendor Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[4]
        TempExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[5]
        TempExcelBuffer.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[6]
        TempExcelBuffer.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);       //txtData[7]
        TempExcelBuffer.AddColumn('Vendor State Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);        //txtData[8]
        TempExcelBuffer.AddColumn('State No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[9]
        TempExcelBuffer.AddColumn('Vendor GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[10]
        TempExcelBuffer.AddColumn('Vendor City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[11]
        TempExcelBuffer.AddColumn('Ship To GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[12]
        TempExcelBuffer.AddColumn('Ship To City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[13]

        TempExcelBuffer.AddColumn('HSN/SAC Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[14]
        TempExcelBuffer.AddColumn('Line amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[15]
        TempExcelBuffer.AddColumn('Total GST%', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[16]
        TempExcelBuffer.AddColumn('SGST/UGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);            //txtData[17]
        TempExcelBuffer.AddColumn('SGST/UGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);          //txtData[18]
        TempExcelBuffer.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[19]
        TempExcelBuffer.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[20]
        TempExcelBuffer.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[21]
        TempExcelBuffer.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[22]
        TempExcelBuffer.AddColumn('Total GST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);          //txtData[23]
        TempExcelBuffer.AddColumn('Amount To Vendor', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);          //txtData[24]
        TempExcelBuffer.AddColumn('TDS Percentage', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[25]
        TempExcelBuffer.AddColumn('TDS Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);              //txtData[26]
        TempExcelBuffer.AddColumn('Amount Payable to Vendor', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//txtData[27]
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[28]
        TempExcelBuffer.AddColumn('Brand', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                     //txtData[29]
        TempExcelBuffer.AddColumn('Business unit', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[30]
        TempExcelBuffer.AddColumn('Cost Center', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[31]
        TempExcelBuffer.AddColumn('Budget Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[32]
        TempExcelBuffer.AddColumn('Crop', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                      //txtData[33]
        TempExcelBuffer.AddColumn('Season', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                    //txtData[34]
        TempExcelBuffer.AddColumn('Employee', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[35]
        TempExcelBuffer.AddColumn('Purchase Order Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[36]
        TempExcelBuffer.AddColumn('Purchase Order Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);       //txtData[37]
        TempExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[38]
        TempExcelBuffer.AddColumn('Invoice Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[39]
        TempExcelBuffer.AddColumn('Payment Term Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[40]
        TempExcelBuffer.AddColumn('Due Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[41]
        TempExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                     //txtData[42]
        TempExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[43]
        TempExcelBuffer.AddColumn('ineligible ITC', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[44]
        TempExcelBuffer.AddColumn('RCM', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                    //txtData[45]
        TempExcelBuffer.AddColumn('IRN No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                 //txtData[46]
        TempExcelBuffer.AddColumn('Return Reason Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//txtData[47]
        TempExcelBuffer.AddColumn('Vendor Posting Group', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[48]
        TempExcelBuffer.AddColumn('Invoice Ref Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);       //txtData[49]
        TempExcelBuffer.AddColumn('Invoice Ref Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[50]
        TempExcelBuffer.AddColumn('Cancellation Remark', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);      //txtData[51]
        TempExcelBuffer.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[52]

        TempExcelBuffer.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);       //txtData[53]
        TempExcelBuffer.AddColumn('Item Category Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//txtData[54]
        TempExcelBuffer.AddColumn('Base Unit of Measure', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[55]
        TempExcelBuffer.AddColumn('GSTIN', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[57]







        //  TempExcelBuffer.AddColumn('Purchase Person', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[]









        //Sandeep
    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();

        /*1*/
        TempExcelBuffer.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //Sandeep
        TempExcelBuffer.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[15], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[17], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[18], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[19], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[20], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[21], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[22], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[23], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[24], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[25], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[26], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[27], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[28], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[29], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[30], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[31], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[32], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[33], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[34], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[35], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[36], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[37], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);

        TempExcelBuffer.AddColumn(txtData[38], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[39], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[40], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[41], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);

        //sandeep
        TempExcelBuffer.AddColumn(txtData[42], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[43], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[44], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[45], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[46], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[47], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[48], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[49], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[50], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[51], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.AddColumn(txtData[52], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[53], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[54], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[55], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[56], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[58], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[57], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);




        // sandeep
    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Purchase Register';
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text003, 'Purchase Register new', COMPANYNAME, USERID)
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}