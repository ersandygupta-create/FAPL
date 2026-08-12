report 50031 "KrizAgedAccountReceivable"
{
    ProcessingOnly = true;
    Caption = 'Aged Account Receivable Excel New';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            trigger OnAfterGetRecord()
            begin
                CalcFields("Remaining Amount");
                CalcFields("Original Amount");
                CustomerRecord.Reset();
                CustomerRecord.SetRange("No.", "Cust. Ledger Entry"."Customer No.");
                if CustomerRecord.FindFirst() then begin
                    txtData[1] := "Customer No.";
                    txtData[2] := CustomerRecord.Name;
                    txtData[3] := CustomerRecord."Search Name";
                    // txtData[4] := CustomerRecord."Customer Code";
                    txtData[5] := Format("Due Date" - 30); //Period Start
                    txtData[6] := Format("Due Date"); //Period End
                    txtData[7] := Format("Remaining Amount");
                    //  txtData[8] := Format("Original Amount");
                    TdsLedgerEntry.Reset();
                    TdsLedgerEntry.SetRange("Document No.", "Document No.");
                    if TdsLedgerEntry.Find('-') then
                        txtData[9] := Format(abs(TdsLedgerEntry."TDS Amount"))
                    else
                        txtData[9] := Format(0);
                    txtData[10] := "Cust. Ledger Entry"."Global Dimension 1 Code";
                    txtData[11] := CustomerRecord."Global Dimension 2 Code";
                    txtData[12] := "Currency Code";
                    txtData[13] := "Document No.";
                    txtData[14] := Format("Posting Date");
                    txtData[15] := "External Document No.";
                    txtData[16] := Format("Document Date");
                    txtData[17] := Format("Due Date");
                    txtData[18] := Format(TODAY);
                    txtData[19] := Format(Date2DMY(TODAY, 2) - Date2DMY("Due Date", 2)); //Reporting Date Month
                    txtData[20] := Format(Date2DMY(TODAY, 1) - Date2DMY("Due Date", 1)); //Reporting Date Quarter
                    txtData[21] := Format(Date2DMY(TODAY, 3) - Date2DMY("Due Date", 3)); //Reportting Date Year
                    txtData[22] := Format("Entry No.");
                    txtData[23] := Format(TODAY - "Due Date"); //No of Days Due
                    MakeExcelDataBody();
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (CustomerNo <> '') then
                    SetRange("Customer No.", CustomerNo);
                SetFilter("Posting Date", '<=%1', DueDateFilter);
                SetCurrentKey("Customer No.");
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
                    field(CustomerNo; CustomerNo)
                    {
                        TableRelation = Customer."No.";
                        Caption = 'Customer No.';
                        ApplicationArea = all;
                    }
                    field(DueDateFilter; DueDateFilter)
                    {
                        Caption = 'Due Date Filter';
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnInit()
        begin
        end;
    }


    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        MakeExcelInfo();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        txtData: array[255] of Text[200];
        CustomerNo: Code[20];
        DueDateFilter: Date;
        CustomerRecord: Record Customer;
        TdsLedgerentry: Record "TDS Entry";


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

        TempExcelBuffer.AddColumn('Customer No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[1]
        TempExcelBuffer.AddColumn('Customer Name ', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[2]
        TempExcelBuffer.AddColumn('Customer Search Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[3]
                                                                                                                                             // TempExcelBuffer.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[4]

        TempExcelBuffer.AddColumn('Period Start', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[5]
        TempExcelBuffer.AddColumn('Period End', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);         //txtData[6]

        TempExcelBuffer.AddColumn('Remaining Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);       //txtData[7]
        TempExcelBuffer.AddColumn('TDS Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);        //txtData[8]
                                                                                                                             // TempExcelBuffer.AddColumn('TDS Amount', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[9]

        TempExcelBuffer.AddColumn('Dimension Code 1', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[10]
        TempExcelBuffer.AddColumn('Dimension Code 2', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[11]
        TempExcelBuffer.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);              //txtData[12]
        TempExcelBuffer.AddColumn('Voucher No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[13]

        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);             //txtData[14]
        TempExcelBuffer.AddColumn('Document No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[15]
        TempExcelBuffer.AddColumn('Document Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[16]
        TempExcelBuffer.AddColumn('Due Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);            //txtData[17]
        TempExcelBuffer.AddColumn('Reporting Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);          //txtData[18]
        TempExcelBuffer.AddColumn('Reporting Date Month', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[19]
        TempExcelBuffer.AddColumn('Reporting Date Quarter', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[20]
        TempExcelBuffer.AddColumn('Reportting Date Year', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                 //txtData[21]
        TempExcelBuffer.AddColumn('Entry No', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);               //txtData[22]
        TempExcelBuffer.AddColumn('No of Days Due', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);          //txtData[23]








        //Sandeep
    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();

        /*1*/
        TempExcelBuffer.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);

        // TempExcelBuffer.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        //Sandeep
        TempExcelBuffer.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[15], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[17], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[18], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(txtData[19], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[20], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[21], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[22], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(txtData[23], FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);




        // sandeep
    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'Aged Account Payable Excel New';
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text003, 'Purchase Register new', COMPANYNAME, USERID)
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}