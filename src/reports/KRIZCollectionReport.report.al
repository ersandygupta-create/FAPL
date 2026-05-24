report 50003 "KRIZ Collection Report"
{
    ProcessingOnly = true;
    Caption = 'Collection Report';
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            CalcFields = Amount, "Original Amount", "Remaining Amount";
            DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                                ORDER(Ascending)
            //WHERE(Amount = FILTER(> 0));
            WHERE("Document Type" = const(Payment), Reversed = const(false));
            ;
            RequestFilterFields = "Customer No.";
            trigger OnPreDataItem()
            begin
                if ((FromDate <> 0D) and (ToDate <> 0D)) then
                    "Cust. Ledger Entry".SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(Customer);
                Customer.Get("Customer No.");

                bankaccountledgerentries.Reset();
                bankaccountledgerentries.SetRange("Document No.", "Document No.");
                if bankaccountledgerentries.FindSet() then;

                txtData[1] := "Customer No.";
                txtData[2] := Customer.Name;
                txtData[3] := Format("Cust. Ledger Entry"."Document Type");
                txtData[4] := "Cust. Ledger Entry"."Document No.";
                txtData[5] := Format("Cust. Ledger Entry"."Posting Date");
                txtData[6] := Format("Cust. Ledger Entry"."Document Date");
                txtData[7] := Format(bankaccountledgerentries.Description);
                txtData[8] := Format("Cust. Ledger Entry"."Original Amount");
                txtData[9] := Format("Cust. Ledger Entry"."Remaining Amount");
                txtData[10] := Format("Cust. Ledger Entry"."Payment Method Code");
                txtData[11] := Format(bankaccountledgerentries."Bank Account No.");
                txtData[12] := Format(bankaccountledgerentries."Cheque No.");
                txtData[13] := Format(bankaccountledgerentries."Cheque Date");
                txtData[14] := Format("Cust. Ledger Entry"."Total TCS Including SHE CESS");


                IF PrintToExcel THEN
                    MakeExcelDataBody();




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
                    field(FromDate; FromDate)
                    {

                        Caption = 'From Date';
                        Editable = true;
                        ToolTip = 'Specify the value for From Date';
                        ApplicationArea = All;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        Editable = true;
                        ToolTip = 'Specify the value for To Date';
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

        Customer: Record Customer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        txtData: array[1024] of Text[1024];
        PrintToExcel: Boolean;
        FromDate: Date;
        ToDate: Date;
        bankaccountledgerentries: Record "Bank Account Ledger Entry";

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
        TempExcelBuffer.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //1
        TempExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //2
        TempExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //3
        TempExcelBuffer.AddColumn('Document No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);  //4
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date); //5
        TempExcelBuffer.AddColumn('Document Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date); //6
        TempExcelBuffer.AddColumn('Payment Reference', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//7
        TempExcelBuffer.AddColumn('Payment Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//8
        TempExcelBuffer.AddColumn('Remaining Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//9
        TempExcelBuffer.AddColumn('Method Of Payment', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//10
        TempExcelBuffer.AddColumn('Bank', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//11
        TempExcelBuffer.AddColumn('Cheque No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//12
        TempExcelBuffer.AddColumn('Cheque Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);//13
        TempExcelBuffer.AddColumn('TCS Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//14

    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(txtData[1], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //1
        TempExcelBuffer.AddColumn(txtData[2], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //2
        TempExcelBuffer.AddColumn(txtData[3], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);  //3
        TempExcelBuffer.AddColumn(txtData[4], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text); //4
        TempExcelBuffer.AddColumn(txtData[5], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);//5
        TempExcelBuffer.AddColumn(txtData[6], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);//6
        TempExcelBuffer.AddColumn(txtData[7], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//7
        TempExcelBuffer.AddColumn(txtData[8], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//8
        TempExcelBuffer.AddColumn(txtData[9], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//9
        TempExcelBuffer.AddColumn(txtData[10], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//10
        TempExcelBuffer.AddColumn(txtData[11], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//11
        TempExcelBuffer.AddColumn(txtData[12], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);//12
        TempExcelBuffer.AddColumn(txtData[13], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);//13
        TempExcelBuffer.AddColumn(txtData[14], FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);//14
    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Collection Report';
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text003, 'Sales Register', COMPANYNAME, USERID)
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}