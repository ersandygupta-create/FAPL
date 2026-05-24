report 50001 TDSDetails
{
    ProcessingOnly = true;
    Caption = 'TDS Details';
    ShowPrintStatus = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("TDS Entry"; "TDS Entry")
        {
            RequestFilterFields = "Vendor No.";

            trigger OnPreDataItem()
            begin
                if ((FromDate <> 0D) and (ToDate <> 0D)) then
                    "TDS Entry".SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            begin
                txtdata[1] := "Deductee PAN No.";
                txtdata[2] := "Vendor No.";
                RecVendor.get("Vendor No.");
                txtdata[3] := RecVendor.Name;
                txtdata[4] := RecVendor.Address;
                txtdata[5] := RecVendor."State Code";
                txtdata[6] := RecVendor."Post Code";
                txtdata[7] := Format("TDS Base Amount");
                txtdata[8] := Format("Posting Date");
                txtdata[9] := "Source Code";
                txtdata[10] := Section;
                //txtdata[11] := Format(Round("TDS %", 0.001));
                TDSPer := 0;
                TDSPer := "TDS %";
                TDSAmount := 0;
                TDSAmount := "TDS Amount";

                txtdata[13] := "Document No.";
                txtdata[14] := "Assessee Code";
                RecVendInc.Reset();
                RecVendInc.SetRange("Document No.", "Document No.");

                if RecVendInc.FindSet() then begin
                    txtdata[15] := RecVendInc."External Document No.";
                    txtdata[16] := Format(RecVendInc."Document Date");
                end;
                txtdata[17] := "Account No.";
                recGlAcc.Reset();
                recGlAcc.SetRange("No.", "Account No.");
                if recGlAcc.FindSet() then begin
                    txtdata[18] := recGlAcc.Name;
                end;
                txtdata[19] := 'No';
                // txtdata[20] := "Assessee Code";
                txtdata[21] := "User ID";
                RecGenLedger.Reset();
                RecGenLedger.SetFilter("Document No.", "Document No.");
                RecGenLedger.SetFilter("G/L Account No.", '<>%1', '41111670048');
                IF
                RecGenLedger.FindSet()
                then begin
                    repeat
                        if RecGenLedger."Gen. Posting Type" <> RecGenLedger."Gen. Posting Type"::" " then begin
                            txtdata[22] := RecGenLedger."G/L Account No.";

                            recGlAcc.Reset();
                            recGlAcc.SetFilter(recGlAcc."No.", txtdata[22]);
                            if
                            recGlAcc.FindFirst()
                            then
                                txtdata[23] := recGlAcc.Name;
                            break;

                        end;
                    until RecGenLedger.Next() = 0;
                end;

                if PrintToExcel
                then
                    MakeExcelDataBody();
            end;


        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(PrinToExcelCap; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Print to Excel field.';
                        ApplicationArea = All;

                    }
                    field(FromDate; Fromdate)
                    {
                        Caption = 'From Date';
                        Editable = true;
                        ToolTip = 'Specify the value for From Date';
                        ApplicationArea = All;
                    }
                    field(Todate; ToDate)
                    {
                        Caption = 'From Date';
                        Editable = true;
                        ToolTip = 'Specify the value for From Date';
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
        TempExcelBuffer: Record "Excel Buffer" temporary;
        myInt: Integer;
        txtdata: array[200] of Text[200];
        PrintToExcel: Boolean;
        RecVendor: Record Vendor;
        RecVendInc: Record "Vendor Ledger Entry";

        Fromdate: Date;
        ToDate: Date;
        recGlAcc: Record "G/L Account";
        TDSPer: Decimal;
        TDSAmount: Decimal;
        RecGenLedger: Record "G/L Entry";
    // RecGlName: Record "G/L Account";

    procedure MakeexcelInfo()
    begin
        TempExcelBuffer.SetUseInfoSheet();
        TempExcelBuffer.AddInfoColumn(CompanyName, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(UserId, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(Today, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.ClearNewRow();
        MakeExcelDataHeader();

    end;

    procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('PAN of deductee', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[1];
        TempExcelBuffer.AddColumn('Vendor Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[2];
        TempExcelBuffer.AddColumn('Vendor Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[3];
        TempExcelBuffer.AddColumn('Vendor Address', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[4];
        TempExcelBuffer.AddColumn('State', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[5];
        TempExcelBuffer.AddColumn('Pin Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[6];
        TempExcelBuffer.AddColumn('Amount of payment (Rs.)', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[7];
        TempExcelBuffer.AddColumn('Posted Voucher Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[8];
        TempExcelBuffer.AddColumn('Source code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[9];
        TempExcelBuffer.AddColumn('TDS Group', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[10];
        TempExcelBuffer.AddColumn('Rate at which tax deducted', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[11];
        TempExcelBuffer.AddColumn('TDS(Rs.)', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[12];
        TempExcelBuffer.AddColumn('Voucher No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[13];
        TempExcelBuffer.AddColumn('Company/Non-company', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[14];
        TempExcelBuffer.AddColumn('Vendor Invoice No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[15];
        TempExcelBuffer.AddColumn('Vendor Invoice Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[16];
        TempExcelBuffer.AddColumn('Ledger', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[17];
        TempExcelBuffer.AddColumn('Ledger name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[18];
        TempExcelBuffer.AddColumn('Document Cancelled', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[19];
        TempExcelBuffer.AddColumn('User ID', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text); //txtdata[21];
        TempExcelBuffer.AddColumn('GL Account No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GL Account Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(txtdata[1], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[2], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[5], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[6], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[7], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtdata[8], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtdata[9], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[10], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TDSPer, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TDSAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtdata[13], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[14], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[15], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[16], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtdata[17], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::text);
        TempExcelBuffer.AddColumn(txtdata[18], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtdata[19], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //  TempExcelBuffer.AddColumn(txtdata[20], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[21], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[22], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtdata[23], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateexcelBook()
    var
        TxtRptLbl1: Label 'TDS Details';
    begin
        TempExcelBuffer.CreateNewBook(TxtRptLbl1);
        TempExcelBuffer.WriteSheet(TxtRptLbl1, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl1);
        TempExcelBuffer.OpenExcel();
    end;

}