report 50004 "Vendor Ledger Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    ShowPrintStatus = true;
    Caption = 'Vendor Ledger Excel';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            CalcFields = Amount;
            trigger OnPreDataItem()
            begin
                if (FromDate <> 0D) and (ToDate <> 0D) THEN
                    "Vendor Ledger Entry".SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            begin
                Txtdata[1] := "Vendor No.";
                Txtdata[2] := "Vendor Name";
                Txtdata[3] := Format("Posting Date");
                Txtdata[4] := Format("Due Date");
                Txtdata[5] := format("Document Type");
                Txtdata[6] := "Document No.";
                Txtdata[7] := Description;
                Txtdata[8] := '';
                Txtdata[9] := '';
                OpeningBalance := 0;
                DebitAmount := 0;
                CreditAmount := 0;
                ClosingBalance := 0;
                OpeningBalance := RunningBalance;
                if Amount < 0
                then
                    CreditAmount := Amount
                else
                    DebitAmount := Abs(Amount);
                RunningBalance := OpeningBalance + CreditAmount - DebitAmount;
                ClosingBalance := RunningBalance;

                OpeningBalance := ClosingBalance;
                if PrintToExcel then
                    MakeExcelBodyData();
            end;


        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print To Excel';
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        Editable = true;
                        ApplicationArea = all;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'ToDate';
                        Editable = true;
                        ApplicationArea = all;
                    }
                    field(CustomerNoLookup; CustomerNoLookup)
                    {
                        ApplicationArea = all;
                        Caption = 'Vendor Account';
                        Editable = true;
                        TableRelation = Vendor;
                    }
                }
            }
        }
        trigger OnInit()
        begin
            PrintToExcel := true;
        end;
    }
    trigger OnPreReport()
    begin
        if PrintToExcel then
            MakeExcelHeaderData();
        RunningBalance := 0;
    end;

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelBook();
    end;


    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        myInt: Integer;
        Txtdata: array[250] of Text[200];
        OpeningBalance: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        ClosingBalance: Decimal;
        FromDate: Date;
        ToDate: Date;
        PrintToExcel: Boolean;
        RunningBalance: Decimal;
        CustomerNoLookup: Code[20];


    procedure MakeExcelHeaderData()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Vendor Ledger Excel', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('From Date -' + Format(FromDate), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('To Date -' + Format(ToDate), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Vendor Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn('Due Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn('Doc. Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Number', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Ch./DD No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Ch./DD Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn('Running Opening', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Debit', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Credit', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Running Closing', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
    end;

    procedure MakeExcelBodyData()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Txtdata[1], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[2], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Txtdata[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Txtdata[5], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[6], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[7], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[8], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[9], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(OpeningBalance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DebitAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CreditAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ClosingBalance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateExcelBook()
    var
        TxtRpl: Label 'Vendor Ledger Excel';
    begin
        TempExcelBuffer.CreateNewBook(TxtRpl);
        TempExcelBuffer.WriteSheet(TxtRpl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRpl);
        TempExcelBuffer.OpenExcel();
    end;
}