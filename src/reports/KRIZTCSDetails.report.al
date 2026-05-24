REPORT 50002 "TCS Details"
{
    ProcessingOnly = true;
    Caption = 'TCS Details';
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("TCS Entry"; "TCS Entry")
        {
            RequestFilterFields = "Customer No.";
            trigger OnPreDataItem()
            begin
                if ((FromDate <> 0D) and (ToDate <> 0D)) then
                    "TCS Entry".SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
            end;

            trigger OnAfterGetRecord()

            begin
                //To Skip the data where TCS=0
                if "TCS Amount" = 0
                then
                    CurrReport.Skip();
                // if recState.Get(recCustomer."State Code") THEN;
                Txtdata[1] := "Customer P.A.N. No.";
                Txtdata[2] := "Customer No.";
                RecCustomer.get("Customer No.");
                Txtdata[3] := RecCustomer.Name;
                RecCustomer.get("Customer No.");
                Txtdata[4] := RecCustomer.Address + ' ' + RecCustomer."Address 2" + ' ' + RecCustomer.City;
                Txtdata[5] := RecCustomer."State Code";
                Txtdata[6] := RecCustomer."Post Code";
                Txtdata[7] := Format("TCS Base Amount");
                Txtdata[8] := Format("Posting Date");
                Txtdata[9] := "TCS Nature of Collection";
                dectcs := 0;
                //Txtdata[10] := Format("TCS %", 0, '<Precision,2:2>');
                dectcs := Round("TCS %");
                //Txtdata[11] := Format("TCS Amount");
                Dectcsamount := 0;
                Dectcsamount := Round("TCS Amount");
                Txtdata[12] := "Document No.";
                Txtdata[13] := 'No';
                Txtdata[14] := "Assessee Code";
                Txtdata[15] := "User ID";
                RecCustLedgerEntries.Reset();
                RecCustLedgerEntries.SetRange(RecCustLedgerEntries."Document No.", "Document No.");
                if RecCustLedgerEntries.FindSet()
                then begin
                    Txtdata[16] := Format(RecCustLedgerEntries."Document Date");
                end;
                Txtdata[17] := Description;

                If PrintToExcel
                then
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
                    field(CustomerNoLookup; CustomerNoLookup)
                    {
                        Caption = 'Customer No';
                        Editable = true;
                        ApplicationArea = all;
                        TableRelation = Customer."No.";
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
        RecCustomer: Record Customer;
        RecState: Record State;
        Txtdata: array[250] of Text[200];
        PrintToExcel: Boolean;
        FromDate: Date;
        ToDate: Date;
        CustomerNoLookup: Code[20];
        dectcs: Decimal;
        Dectcsamount: Decimal;
        RecCustLedgerEntries: Record "Cust. Ledger Entry";


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
        TempExcelBuffer.AddColumn('PAN of Deductee', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                      //txtdata[1]
        TempExcelBuffer.AddColumn('Customer Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                        //txtdata[2]
        TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                        //txtdata[3]
        TempExcelBuffer.AddColumn('Customer Address', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                     //txtdata[4]
        TempExcelBuffer.AddColumn('State', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                                //txtdata[5]
        TempExcelBuffer.AddColumn('PIN Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);                           //txtdata[6]
        TempExcelBuffer.AddColumn('Amount of payment (Rs.)', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);            //txtdata[7]
        TempExcelBuffer.AddColumn('Posted Voucher Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);   //txtdata[8]
        TempExcelBuffer.AddColumn('TCS Nature of Collection', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);             //txtdata[9]
        TempExcelBuffer.AddColumn('Assessee Code', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                        //txtdata[14]
        TempExcelBuffer.AddColumn('Rate at which tax deducted', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);         //txtdata[10]
        TempExcelBuffer.AddColumn('TCS(Rs.)', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);                           //txtdata[11]
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                         //txtdata[12]
        TempExcelBuffer.AddColumn('Document Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                        //txtdata[16]
        TempExcelBuffer.AddColumn('Document Cancelled', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                   //txtdata[13]
        TempExcelBuffer.AddColumn('User Id', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);                              //txtdata[15]
        TempExcelBuffer.AddColumn('Document Reference No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);               //txtdata[17]

    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Txtdata[1], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[2], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[5], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[6], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Txtdata[7], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Txtdata[8], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Txtdata[9], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[14], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(dectcs, false, '', false, false, false, '0.00', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Dectcsamount, false, '', false, false, false, '0.00', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Txtdata[12], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[16], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[13], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[15], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Txtdata[17], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'TCS Details';
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text003, 'Sales Register', COMPANYNAME, USERID)
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;

}