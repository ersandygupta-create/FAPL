report 50014 "Sales Register"
{
    ProcessingOnly = true;
    Caption = 'Sales Register';
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("Posting Date");
            RequestFilterFields = "Posting Date", "No.", "Sell-to Customer No.";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
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
                    DetailedGSTLedgEntry.SETRANGE("Transaction Type", DetailedGSTLedgEntry."Transaction Type"::Sales);
                    DetailedGSTLedgEntry.SETRANGE("Document Type", DetailedGSTLedgEntry."Document Type"::Invoice);
                    DetailedGSTLedgEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgEntry.SETRANGE("No.", "No.");
                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'CGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        CGSTAmt := -DetailedGSTLedgEntry."GST Amount";
                        CGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'IGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        IGSTAmt := -DetailedGSTLedgEntry."GST Amount";
                        IGSTRate := DetailedGSTLedgEntry."GST %";
                    END;

                    DetailedGSTLedgEntry.SETRANGE("GST Component Code", 'SGST');
                    IF DetailedGSTLedgEntry.FINDFIRST() THEN BEGIN
                        SGSTAmt := -DetailedGSTLedgEntry."GST Amount";
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
                    "Total GST Amount" := SGSTAmt + CGSTAmt + IGSTAmt;
                    "Amount To Customer" := Amount + "Total GST Amount";

                    txtData[15] := FORMAT(Type);
                    txtData[16] := "No.";
                    txtData[17] := Description + '' + "Description 2";
                    txtData[31] := Item."Item Category Code";
                    txtData[32] := ItemCat.Description;
                    txtData[18] := "HSN/SAC Code";
                    txtData[19] := 'Nos';
                    txtData[20] := Format("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price");
                    txtData[21] := Format("Sales Invoice line"."Line Amount");







                    txtData[22] := FORMAT(SGSTRate);
                    txtData[23] := FORMAT(ROUND(SGSTAmt, 0.01));
                    txtData[24] := FORMAT(CGSTRate);
                    txtData[25] := FORMAT(ROUND(CGSTAmt, 0.01));
                    txtData[26] := FORMAT(IGSTRate);
                    txtData[27] := FORMAT(ROUND(IGSTAmt, 0.01));

                    txtData[28] := FORMAT(ROUND("GST %", 0.01));
                    txtData[29] := FORMAT(ROUND("Total GST Amount", 0.01));
                    txtData[30] := FORMAT(ROUND("Amount To Customer", 0.01));
                    txtData[42] := Format("Sales Invoice Line".Quantity);
                    //
                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(recLocation);
                CLEAR(recCustomer);
                CLEAR(SalespersonPurchaser);
                IF recLocation.GET("Location Code") THEN;
                IF recCustomer.GET("Sell-to Customer No.") THEN;
                IF SalespersonPurchaser.GET("Salesperson Code") THEN;
                IF billToCustomer.GET("Bill-to Customer No.") THEN;

                if recState.Get(recCustomer."State Code") THEN;

                txtData[33] := 'Invoice';
                txtData[1] := FORMAT("Posting Date");
                txtData[2] := "No.";
                txtData[5] := "Sell-to Customer No.";
                txtData[6] := recCustomer.Name;
                txtData[10] := recstate."State Code (GST Reg. No.)"; //
                txtdata[11] := billToCustomer."GST Registration No.";
                txtData[12] := billToCustomer.City;
                if ("Ship-to GST Reg. No." <> '') then
                    txtData[13] := "Ship-to GST Reg. No."
                else
                    txtData[13] := billToCustomer."GST Registration No.";
                txtData[14] := "Ship-to City";
                txtData[8] := recCustomer."Customer Posting Group";
                txtData[9] := recCustomer."State Code";
                txtData[34] := "Location Code";

                txtData[35] := FORMAT("Invoice Type");
                txtData[36] := "External Document No.";




                txtData[7] := '';
                txtData[37] := '';
                txtData[38] := Format('');
                IF "Location Code" <> ''
                then begin
                    if recLocation.Get("Location Code") then
                        Txtdata[40] := recLocation."GST Registration No.";
                end;

                txtData[41] := '';
                txtData[43] := "Order No.";
                txtData[44] := Format("Order Date");
                txtData[51] := "IRN Hash";
                txtData[52] := Format("Acknowledgement Date");
                //
                Clear(BudgetType);
                Clear(BusinessUnit);
                Clear(CostCenter);
                Clear(Crop);
                DimSetEntry.SetRange("Dimension Set ID", "Sales Invoice Header"."Dimension Set ID");
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
                        end;
                    until DimSetEntry.Next() = 0;

                txtData[45] := BusinessUnit;
                txtData[46] := CostCenter;
                txtData[47] := "External Document No.";
                txtData[48] := '';
                txtData[49] := Crop;
                txtData[50] := BudgetType;



                //
                if ("Ship-to Code" <> '')
                then
                    txtData[3] := "Ship-to Code"
                else
                    txtData[3] := billToCustomer."No.";

                // Sahil            // txtData[39] := "IRN No.";

                txtData[4] := billToCustomer.Name;
            end;


        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = sorting("Document No.", "Line No.")
                                    where(Quantity = filter(<> 0),
                                    "System-Created Entry" = const(false));//, Type = const(item));

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
                    DetailedGSTLedgEntry.SETRANGE("Transaction Type", DetailedGSTLedgEntry."Transaction Type"::Sales);
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
                    "Amount To Customer" := Amount + "Total GST Amount";

                    txtData[15] := FORMAT(Type);
                    txtData[16] := "No.";
                    txtData[17] := Description + '' + "Description 2";
                    txtData[31] := Item."Item Category Code";
                    txtData[32] := ItemCat.Description;
                    txtData[18] := "HSN/SAC Code";
                    txtData[19] := 'Nos';
                    txtData[20] := Format("Sales Cr.Memo Line".Quantity * "Sales Invoice Line"."Unit Price");
                    txtData[21] := Format("Sales Cr.Memo Line"."Line Amount");
                    txtData[22] := FORMAT(SGSTRate);
                    txtData[23] := FORMAT(-ROUND(SGSTAmt, 0.01));
                    txtData[24] := FORMAT(CGSTRate);
                    txtData[25] := FORMAT(-ROUND(CGSTAmt, 0.01));
                    txtData[26] := FORMAT(IGSTRate);
                    txtData[27] := FORMAT(-ROUND(IGSTAmt, 0.01));

                    txtData[28] := FORMAT(ROUND("GST %", 0.01));
                    txtData[29] := FORMAT(-ROUND("Total GST Amount", 0.01));
                    txtData[30] := FORMAT(-ROUND("Amount To Customer", 0.01));
                    txtdata[42] := Format("Sales Cr.Memo Line".Quantity);

                    //
                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(recLocation);
                CLEAR(recCustomer);
                CLEAR(SalespersonPurchaser);
                if recLocation.GET("Location Code") then;
                if recCustomer.GET("Sell-to Customer No.") then;
                if SalespersonPurchaser.GET("Salesperson Code") then;
                IF billToCustomer.GET("Bill-to Customer No.") THEN;

                if recState.Get(recCustomer."State Code") THEN;

                txtData[33] := 'Credit Memo';
                txtData[1] := FORMAT("Posting Date");
                txtData[2] := "No.";
                txtData[5] := "Sell-to Customer No.";
                txtData[6] := recCustomer.Name;
                txtData[8] := recCustomer."Customer Posting Group";
                txtData[9] := recCustomer."State Code";
                txtData[34] := "Location Code";



                txtData[35] := FORMAT("Invoice Type");
                txtData[36] := "External Document No.";
                txtData[10] := recstate."State Code (GST Reg. No.)"; //
                txtdata[11] := billToCustomer."GST Registration No.";
                txtData[12] := billToCustomer.City;
                if ("Ship-to GST Reg. No." <> '') then
                    txtData[13] := "Ship-to GST Reg. No."
                else
                    txtData[13] := billToCustomer."GST Registration No.";
                txtData[14] := "Ship-to City";


                txtData[7] := '';
                txtData[37] := "Reference Invoice No.";
                clear(recsalesinvHead);
                recsalesinvHead.Reset();
                recsalesinvHead.SetRange("No.", "Reference Invoice No.");
                if recsalesinvHead.FindFirst() then
                    txtData[38] := Format(recsalesinvHead."Posting Date");
                IF "Location Code" <> ''
                then begin
                    if recLocation.Get("Location Code") then
                        Txtdata[40] := recLocation."GST Registration No.";
                end;
                Clear(BudgetType);
                Clear(BusinessUnit);
                Clear(CostCenter);
                Clear(Crop);
                DimSetEntry.SetRange("Dimension Set ID", "Sales Invoice Header"."Dimension Set ID");
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
                        end;
                    until DimSetEntry.Next() = 0;

                txtData[45] := BusinessUnit;
                txtData[46] := CostCenter;
                txtData[47] := "External Document No.";
                txtData[48] := '';
                txtData[49] := Crop;
                txtData[50] := BudgetType;
                txtData[51] := "IRN Hash";
                txtData[52] := Format("Acknowledgement Date");


                //
                if ("Ship-to Code" <> '')
                then
                    txtData[3] := "Ship-to Code"
                else
                    txtData[3] := billToCustomer."No.";

                //Sahil                txtData[39] := "IRN No.";

                txtData[4] := billToCustomer.Name;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Cr.Memo Header".SETCURRENTKEY("Posting Date");
                SETFILTER("Posting Date", "Sales Invoice Header".GETFILTER("Posting Date"));
                SETFILTER("Sell-to Customer No.", "Sales Invoice Header".GETFILTER("Sell-to Customer No."));
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
        RecLotInfo: Record "Lot No. Information";
        recsalesinvHead: Record "Sales Invoice Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        recLocation: Record "Location";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        recCustomer: Record "Customer";
        ShipAgent: Record "Shipping Agent";
        billToCustomer: Record "Customer";
        recState: Record State;
        Item: Record "Item";
        ItemCat: Record "Item Category";
        recItemUOM: Record "Item Unit of Measure";
        DetailedGSTLedgEntry: Record "Detailed GST Ledger Entry";
        DimSetEntry: Record "Dimension Set Entry";
        BudgetType: Code[20];
        BusinessUnit: Code[20];
        CostCenter: Code[20];
        Crop: Code[20];

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
        "Amount To Customer": Decimal;


    procedure MakeExcelInfo()
    begin
        TempExcelBuffer.SetUseInfoSheet();
        TempExcelBuffer.AddInfoColumn(COMPANYNAME, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(USERID, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(TODAY, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.ClearNewRow();
        MakeExcelDataHeader();
    end;

    procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Document No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[2]
        TempExcelBuffer.AddColumn('Ship To Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                //txtData[3]
        TempExcelBuffer.AddColumn('Ship To Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                //txtData[4]
        TempExcelBuffer.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[5]
        TempExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[6]
        TempExcelBuffer.AddColumn('Return Reason Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);   //txtData[7]
        TempExcelBuffer.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);      //txtData[8]
        TempExcelBuffer.AddColumn('Customer State Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[9]
        // sandeep

        TempExcelBuffer.AddColumn('State No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);        //txtData[10]
        TempExcelBuffer.AddColumn('Bill To GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);      //txtData[11]
        TempExcelBuffer.AddColumn('Bill To City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[12]
        TempExcelBuffer.AddColumn('Ship To GST', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);      //txtData[13]
        TempExcelBuffer.AddColumn('Ship To City', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[14]

        // sandeep

        TempExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[15]
        TempExcelBuffer.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[16]
        TempExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);     //txtData[17]        
        TempExcelBuffer.AddColumn('HSN/SAC Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[18]
        TempExcelBuffer.AddColumn('Base Unit of Measure', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //txtData[19]

        TempExcelBuffer.AddColumn('Line Amount', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[22]   
        TempExcelBuffer.AddColumn('Tax Base Amount', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);            //txtData[43]

        TempExcelBuffer.AddColumn('SGST/UGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[23]
        TempExcelBuffer.AddColumn('SGST/UGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[24]
        TempExcelBuffer.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                    //txtData[25]
        TempExcelBuffer.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[26]
        TempExcelBuffer.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                    //txtData[27]
        TempExcelBuffer.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[28]
        TempExcelBuffer.AddColumn('Total GST%', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                   //txtData[29]
        TempExcelBuffer.AddColumn('Total GST Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[30]
        TempExcelBuffer.AddColumn('Amount To Customer', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[31]
        TempExcelBuffer.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[32]
        TempExcelBuffer.AddColumn('Item Category Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);    //txtData[33]
        TempExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[34]
        TempExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[35]
        TempExcelBuffer.AddColumn('Invoice Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[36]
        TempExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);        //txtData[37]
        TempExcelBuffer.AddColumn('Invoice Ref Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);           //txtData[38]
        TempExcelBuffer.AddColumn('Invoice Ref Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[39]
        TempExcelBuffer.AddColumn('IRN', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                          //txtData[40]
        //
        TempExcelBuffer.AddColumn('Warehouse GST', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                //txtData[41]
        TempExcelBuffer.AddColumn('Mark Up', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                      //txtData[42]
        TempExcelBuffer.AddColumn('Qty. in Case', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[21]

        TempExcelBuffer.AddColumn('Sales Order No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);              //txtData[44]
        TempExcelBuffer.AddColumn('Sales Order Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);             //txtData[45]
        TempExcelBuffer.AddColumn('Business Central', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);           //txtData[46]
        TempExcelBuffer.AddColumn('Cost Center', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);                //txtData[47]
        TempExcelBuffer.AddColumn('Customer PO Number', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);           //txtData[48]
        TempExcelBuffer.AddColumn('Customer PO Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);             //txtData[49]
        TempExcelBuffer.AddColumn('Crop', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                         //txtData[50]
        TempExcelBuffer.AddColumn('Budget Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                  //txtData[62]
        TempExcelBuffer.AddColumn('IRN No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);              //txtData[44]
        TempExcelBuffer.AddColumn('IRN Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);             //txtData[45]

    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        // Sandeep

        TempExcelBuffer.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        // Sandeep

        TempExcelBuffer.AddColumn(txtData[15], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[17], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[18], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[19], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[20], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);      //22
        TempExcelBuffer.AddColumn(txtData[21], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[22], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);    //23
        TempExcelBuffer.AddColumn(txtData[23], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[24], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[25], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[26], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[27], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[28], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[29], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[30], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[31], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[32], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[33], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[34], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[35], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[36], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[37], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[38], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[39], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //
        TempExcelBuffer.AddColumn(txtData[40], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[41], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[42], FALSE, '', FALSE, FALSE, FALSE, '0.00', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.AddColumn(txtData[43], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[44], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[45], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[46], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[47], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[48], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[49], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[50], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[51], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[52], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);




    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Sales Register';
    begin
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}