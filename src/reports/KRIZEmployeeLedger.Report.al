report 50006 "Employee Ledger"
{
    RDLCLayout = './src/reports/EmployeeLedger.rdl';
    Caption = 'Employee Ledger Report';
    DefaultLayout = RDLC;
    PreviewMode = Normal;
    ShowPrintStatus = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Date Filter";
            column(DMSCode_Customer; Employee."No.")
            {
            }
            column(CustomerGETFILTER; CustomerGETFILTER)
            { }

            column(CustomerAddress; Employee.Address + ' ' + Employee."Address 2" + ' ' + Employee.City)
            { }
            column(CustomerName; Employee.FullName())
            { }
            column(CustomerPhoneNo; Employee."Mobile Phone No.")
            { }
            column(CutomerPAN; '') { }
            column(CustomerGSTIN; '') { }
            column(TodayDate; FORMAT(TODAY, 0, 4))
            {
            }
            column(Todaytime; FORMAT(TIME))
            {
            }
            column(ClosingDRorCR; ClosingDRorCR)
            {
            }
            column(OpeningDRorCR; OpeningDRorCR)
            {
            }
            column(ReferenceDocCap; ReferenceDocCap)
            {
            }
            column(CustomerContact; '') { }
            column(DateFilter; GETFILTER("Date Filter"))
            {
            }
            column(DateFilterCaption; DateFilterCaption)
            {
            }
            column(No_GLAccount; Employee."No.")
            {
            }
            column(Name_GLAccount; Employee.FullName())
            {
            }
            column(OpenBal; OpenBal)
            {
            }
            column(BalAtDate; CloseBal)
            {
            }
            column(PdateCaption; PdateCaption)
            {
            }
            column(DDateCaption; DDateCaption)
            {
            }
            column(DocNoCaption; DocNoCaption)
            {
            }
            column(DocTypeCaption; DocTypeCaption)
            {
            }
            column(BalAccTypeCap; BalAccTypeCap)
            {
            }
            column(BalAccNoCaption; BalAccNoCaption)
            {
            }
            column(LineNarrCaption; LineNarrCaption)
            {
            }
            column(DrAmtCaption; DrAmtCaption)
            {
            }
            column(CrAmtCaption; CrAmtCaption)
            {
            }
            column(RunBalCaption; RunBalCaption)
            {
            }
            column(UserIDCaption; UserIDCaption)
            {
            }
            column(SourceNoCaption; SourceNoCaption)
            {
            }
            column(SourceNameCaption; SourceNameCaption)
            {
            }
            column(OpenBalCap; OpenBalCap)
            {
            }
            column(CloseBalCap; CloseBalCap)
            {
            }
            column(COMPANYNAME; CompanyInformation.Name)
            {
            }
            column(CompanyImage; CompanyInformation.Picture)
            {

            }
            column(CompanyAddress1; CompanyInformation.Address) { }
            column(CompanyAddress2; CompanyInformation."Address 2") { }
            column(CompanyCity; companyinformation.City) { }
            column(CompanyState; CompanyState) { }
            column(CompanyCountry; CompanyCountry) { }
            column(companyPostCode; CompanyInformation."Post Code") { }

            column(ReportCap; ReportCap)
            {
            }
            column(AmtCaption; AmtCaption)
            {
            }
            column(OpenBal1; OpenBal1)
            {
            }
            column(CloseBal1; CloseBal1)
            {
            }
            column(PendingDisbursementAmount; abs(PendingDisbursementAmount) + ABS(InsuranceChargesAmount))
            { }
            column(BPI; BPI)
            { }
            column(Overdueifany; Overdueifany)
            { }
            dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
            {
                CalcFields = "Amount", "Debit Amount", "Credit Amount";
                DataItemLink = "Employee No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Employee No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending) where(Reversed = filter(false));
                RequestFilterFields = Reversed;
                column(SRNo; SrNo)
                {
                }
                column(EMIAmount; EMIAmount)
                { }
                column(ProductItemCategory; ProductItemCategory)
                { }
                column(LoanTenure; Format(LoanTenure) + ' ' + 'Month')
                { }
                column(DisbursementDate; Format(DisbursementDate, 0, '<day,2>.<month,2>.<year4>'))
                { }
                column(EMIDuedate; Format(EMIDuedate))
                { }
                column(EMIStartDate; Format(StartDate, 0, '<day,2>.<month,2>.<year4>'))
                { }
                column(EMIendDate; Format(endDate, 0, '<day,2>.<month,2>.<year4>'))
                { }
                column(MoratoriumPeriod; MoratoriumPeriod)
                { }
                column(LoanStatus; LoanStatus)
                { }
                column(EntryNo_; "Entry No.")
                {
                }
                column(CustNo; "Employee No.")
                {
                }
                column(GlobalDimension1Code_CustLedgerEntry; "Employee Ledger Entry"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_CustLedgerEntry; "Employee Ledger Entry"."Global Dimension 2 Code")
                {
                }
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount")
                {
                }
                column(PostingDate_GLEntry; "Posting Date")
                {
                }
                column(DocumentType_GLEntry; DocumentType)
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(Amount_GLEntry; Amount)
                {
                }
                column(DocumentDate_GLEntry; "Posting Date")
                {
                }
                column(BalAccountType_GLEntry; "Bal. Account Type")
                {
                }
                column(BalAccountNo_GLEntry; "Bal. Account No.")
                {
                }
                column(LineNarration_GLEntry; LineNarration)
                {
                }
                column(RunningBal; RunningBal)
                {
                }
                column(RunningBal1; RunningBal1)
                {
                }
                column(UserID_GLEntry; "User ID")
                {
                }
                column(RunningBalanceCRorDR; RunningBalanceCRorDR)
                {
                }
                column(TotalDebitAmt; TotalDebitAmt)
                {
                }
                column(TotalCredittAmt; TotalCredittAmt)
                {
                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(DocNo_TempGL; TempGL."Document No.")
                    {
                    }
                    column(GLAccount; TempGL."G/L Account No.")
                    {
                    }
                    column(GLAccountName; TempGL."G/L Account Name")
                    {
                    }
                    column(DebitTemp; TempGL.Amount)
                    {
                    }
                    column(CreditTemp; TempGL."Credit Amount")
                    {
                    }
                    column(AccountNo; AccountNo)
                    {
                    }
                    column(AccountName; AccountName)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 then
                            TempGL.FIND('-')
                        ELSE
                            TempGL.NEXT;
                        DocumentType := Format("Employee Ledger Entry"."Document Type");
                        if (DocumentType = ' ') then
                            DocumentType := 'General Journal';
                        TempGL.CALCFIELDS("G/L Account Name");
                        CLEAR(AccountNo);
                        CLEAR(AccountName);
                        GLEntryRec.RESET();
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", VendorFilter);
                        IF GLEntryRec.FINDFIRST() then begin
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::Vendor then begin
                                AccountNo := GLEntryRec."Source No.";
                                IF T23.GET(AccountNo) then
                                    AccountName := T23.Name;
                            end;
                        end;

                        GLEntryRec.RESET();
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", CustomerFilter);
                        IF GLEntryRec.FINDFIRST() then begin
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::Employee then begin
                                AccountNo := GLEntryRec."Source No.";
                                IF T18.GET(AccountNo) then
                                    AccountName := T18.Name;
                            end;
                        end;

                        GLEntryRec.RESET();
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", BankFilter);
                        IF GLEntryRec.FINDFIRST() then begin
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::"Bank Account" then begin
                                AccountNo := GLEntryRec."Source No.";
                                IF T270.GET(AccountNo) then
                                    AccountName := T270.Name;
                            end;
                        end;

                        GLEntryRec.RESET();
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", ImprestFilter);
                        IF GLEntryRec.FINDFIRST() then begin
                            IF T480.GET(GLEntryRec."Dimension Set ID", 'BRANCH') then begin
                                T480.CALCFIELDS("Dimension Value Name");
                                AccountNo := T480."Dimension Value Code";
                                AccountName := T480."Dimension Value Name";
                            end;
                        end;

                        IF T480.GET("Employee Ledger Entry"."Dimension Set ID", 'BRANCH') then begin
                            T480.CALCFIELDS("Dimension Value Name");
                            AccountNo := T480."Dimension Value Code";
                            AccountName := T480."Dimension Value Name";
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, TempGL.COUNT);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    Customer: Record Employee;
                    CustName: Text;
                begin
                    SrNo += 1;
                    CLEAR(RunningBalanceCRorDR);
                    CLEAR(VendInvNo);
                    Clear(LineNarration);

                    IF T112.GET("Document No.") then begin
                        VendInvNo := T112."External Document No.";
                        //LineNarration := T112.Remarks;
                    end ELSE
                        IF T114.GET("Document No.") then
                            VendInvNo := T114."External Document No.";


                    IF "Employee Ledger Entry"."Document Type" = "Employee Ledger Entry"."Document Type"::" " then begin

                        LineNarration := "Employee Ledger Entry".Description;
                    end;

                    IF "Employee Ledger Entry"."Document Type" = "Employee Ledger Entry"."Document Type"::Payment then begin
                        LineNarration := "Employee Ledger Entry".Description;
                    end;

                    //   LineNarration := "Cust. Ledger Entry".SG_Narration;

                    Temp17.DELETEALL;
                    TempGL.DELETEALL;
                    T17.RESET();
                    //T17.SETCURRENTKEY("Document No.");
                    T17.SETRANGE("Document No.", "Document No.");
                    IF Customer.GETFILTER("Global Dimension 1 Filter") <> '' then
                        T17.SETRANGE(T17."Global Dimension 1 Code", "Global Dimension 1 Code");
                    IF Customer.GETFILTER("Global Dimension 2 Filter") <> '' then
                        T17.SETRANGE(T17."Global Dimension 2 Code", "Global Dimension 2 Code");
                    T17.SETRANGE("Posting Date", "Posting Date");
                    IF T17.FINDFIRST() then begin
                        REPEAT
                            IF T17."Entry No." = "Entry No." then begin
                                RunningBal := ((RunningBal + "Debit Amount") - "Credit Amount");
                                // IF T17."Line Narration" <> '' then begin
                                //   CLEAR(LineNarration);
                                //   LineNarration := T17."Line Narration";
                                // end;
                            end ELSE begin
                                IF NOT Temp17.GET(T17."Entry No.") then begin
                                    Temp17.INIT;
                                    Temp17.TRANSFERFIELDS(T17);
                                    Temp17.INSERT;
                                end;
                            end;
                        UNTIL T17.NEXT = 0;
                    end
                    ELSE
                        CurrReport.SKIP;

                    CLEAR(VoucherNarr);
                    //  VoucherNarr := "Cust. Ledger Entry".SG_Narration;
                    CLEAR(GLAccNo);
                    Temp17.RESET();
                    Temp17.SETCURRENTKEY("G/L Account No.");
                    Temp17.SETRANGE("Document No.", "Document No.");
                    Temp17.SETFILTER("G/L Account No.", NoAccountsFilter);
                    IF Temp17.FINDFIRST() then
                        REPEAT
                            IF Temp17."G/L Account No." = GLAccNo then begin
                                TempGL."Debit Amount" := TempGL."Debit Amount" + Temp17."Debit Amount";
                                TempGL."Credit Amount" := TempGL."Credit Amount" + Temp17."Credit Amount";
                                TempGL.Amount := TempGL.Amount + Temp17.Amount;
                                TempGL.MODIFY;
                            end
                            ELSE begin
                                TempGL.INIT;
                                TempGL.TRANSFERFIELDS(Temp17);
                                TempGL.INSERT;
                            end;
                            GLAccNo := Temp17."G/L Account No."
                    UNTIL Temp17.NEXT = 0;

                    Temp17.RESET();
                    Temp17.SETCURRENTKEY("G/L Account No.");
                    Temp17.SETRANGE("Document No.", "Document No.");
                    Temp17.SETFILTER("G/L Account No.", AccountsFilter);
                    IF Temp17.FINDFIRST() then
                        REPEAT
                            IF NOT TempGL.GET("Entry No.") then begin
                                TempGL.INIT;
                                TempGL.TRANSFERFIELDS(Temp17);
                                TempGL.INSERT;
                            end;
                        UNTIL Temp17.NEXT = 0;

                    // PRU_AS - start
                    IF RunningBal <> 0 then begin
                        IF RunningBal > 0 then
                            RunningBalanceCRorDR := 'Dr'
                        ELSE
                            RunningBalanceCRorDR := 'Cr';
                    end;
                    // PRU_AS - end

                    RunningBal1 := ABS(RunningBal);

                    //Pru Raj
                    IF ("Employee Ledger Entry"."Document Type" = "Employee Ledger Entry"."Document Type"::" ") AND ("Employee Ledger Entry"."Debit Amount" <> 0) then
                        DocType := 'Debit Note'
                    ELSE
                        DocType := FORMAT("Employee Ledger Entry"."Document Type");

                    TotalDebitAmt += "Employee Ledger Entry"."Debit Amount";
                    TotalCredittAmt += "Employee Ledger Entry"."Credit Amount";
                end;


                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", StartDate, endDate);
                    CLEAR(RunningBal);
                    RunningBal := OpenBal;
                    SrNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CustomerGETFILTER := Employee.GetFilters;

                CLEAR(OpenBal);
                CLEAR(CloseBal);
                T21.RESET();
                T21.SETRANGE(T21."Employee No.", "No.");
                T21.SETFILTER("Posting Date", '<%1', GETRANGEMIN("Date Filter"));
                IF GETFILTER("Global Dimension 1 Filter") <> '' then
                    T21.SETFILTER("Global Dimension 1 Code", '%1', GETFILTER("Global Dimension 1 Filter"));
                IF GETFILTER(Employee."Global Dimension 2 Filter") <> '' then
                    T21.SETFILTER("Global Dimension 2 Code", '%1', GETFILTER("Global Dimension 2 Filter"));
                T21.SETAUTOCALCFIELDS(Amount);
                IF T21.FINDFIRST() then
                    REPEAT
                        OpenBal := OpenBal + T21.Amount;
                    UNTIL T21.NEXT = 0;

                // PRU_AS - start
                IF OpenBal <> 0 then begin
                    IF OpenBal > 0 then
                        OpeningDRorCR := 'Dr'
                    ELSE
                        OpeningDRorCR := 'Cr';
                end;
                // PRU_AS - end
                OpenBal1 := ABS(OpenBal);

                T21.RESET();
                T21.SETRANGE(T21."Employee No.", "No.");
                T21.SETFILTER("Posting Date", '<=%1', GETRANGEMAX("Date Filter"));
                IF GETFILTER("Global Dimension 1 Filter") <> '' then
                    T21.SETFILTER("Global Dimension 1 Code", '%1', GETFILTER("Global Dimension 1 Filter"));
                IF GETFILTER(Employee."Global Dimension 2 Filter") <> '' then
                    T21.SETFILTER("Global Dimension 2 Code", '%1', GETFILTER("Global Dimension 2 Filter"));
                T21.SETAUTOCALCFIELDS(Amount);
                IF T21.FINDFIRST() then
                    REPEAT
                        CloseBal := CloseBal + T21.Amount;
                    UNTIL T21.NEXT = 0;

                // PRU_AS - start
                IF CloseBal <> 0 then begin
                    IF CloseBal > 0 then
                        ClosingDRorCR := 'Dr'
                    ELSE
                        ClosingDRorCR := 'Cr';
                end;
                // PRU_AS - end

                CloseBal1 := ABS(CloseBal);
            end;

            trigger OnPreDataItem()
            begin
                IF GETFILTER("Date Filter") = '' then
                    ERROR('Please Enter the Date Filter');
                StartDate := GETRANGEMIN("Date Filter");
                endDate := GETRANGEMAX("Date Filter");
                Row := 4;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }


    trigger OnPreReport()
    begin
        AccountsFilter := '32011000000..32011888888|52000000000..52012999999|32014990000..32016888888|53012000000..53012888888|31011000000..31011188888';
        NoAccountsFilter := '<31011000000|>31011188888&<32011000000|>32011888888&<32014990000|>32016888888&<52000000000|>52012999999&<53012000000|>53012888888';
        VendorFilter := '32011000000..32011888888';
        ImprestFilter := '32014990000..32016888888|34011100019';
        CustomerFilter := '52000000000..52012999999';
        BankFilter := '53012000000..53012888888|31011000000..31011188888';

        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        State.RESET();
        State.Setrange(Code, CompanyInformation."State Code");
        if State.FINDFIRST() then
            CompanyState := State.Description;

        Country.RESET();
        Country.Get(CompanyInformation."Country/Region Code");
        if Country.FINDFIRST() then
            CompanyCountry := Country.Name;
    end;

    var
        T21: Record "Employee Ledger Entry";
        CompanyState: Text[60];
        CompanyCountry: Text[60];
        CompanyInformation: Record "Company Information";
        State: Record State;
        Country: record "Country/Region";
        OpenBal: Decimal;
        StartDate: Date;
        endDate: Date;
        RunningBal: Decimal;
        PdateCaption: Label 'Posting Date';
        DDateCaption: Label 'Document Date';
        DocNoCaption: Label 'Document No.';
        DocTypeCaption: Label 'Document Type';
        BalAccTypeCap: Label 'Bal. Account No.';
        InsuranceChargesAmount: decimal;
        BalAccNoCaption: Label 'Bal. Account Name';
        LineNarrCaption: Label 'Line Narration';
        DrAmtCaption: Label 'Debit Amount';
        CrAmtCaption: Label 'Credit Amount';
        RunBalCaption: Label 'Running Balance';
        UserIDCaption: Label 'User ID';
        OpenBalCap: Label 'Opening Balance';
        CloseBalCap: Label 'Closing Balance';
        ReportCap: Label 'Customer Ledger ';
        CloseBal: Decimal;
        LoanTenure: Integer;
        DisbursementDate: Date;
        EMIDuedate: text;
        EMIStartDate: Date;
        EMIendDate: Date;
        MoratoriumPeriod: text;
        BPI: Decimal;
        PresentOutstanding: Decimal;
        Overdueifany: Decimal;
        LoanStatus: Text;
        T17: Record "G/L Entry";
        LineNarration: Text;
        T112: Record "Sales Invoice Header";
        T114: Record "Sales Cr.Memo Header";
        VendInvNo: Code[35];
        Temp17: Record 17 temporary;
        TempGL: Record 17 temporary;
        VoucherNarr: Text;
        GLAccNo: Code[20];
        Row: Integer;
        ExcelBuf: Record 370 temporary;
        EMIAmount: decimal;
        CellTypeVar: Option Number,Text,Date,Time;
        VendorInvNoCap: Label 'Reference Doc. No.';
        CircleCodeCap: Label 'Branch Code';
        AmtCaption: Label 'Amount';
        AccountsFilter: Text[250];
        NoAccountsFilter: Text[250];
        VendorFilter: Text[250];
        CustomerFilter: Text[250];
        BankFilter: Text[250];
        ImprestFilter: Text[250];
        GLEntryRec: Record 17;
        AccountNo: Code[20];
        AccountName: Text[50];
        T23: Record 23;
        T18: Record 18;
        T270: Record 270;
        T480: Record 480;
        SourceNoCaption: Label 'Source No.';
        SourceNameCaption: Label 'Source Name';
        DateFilterCaption: Label 'Date Filter:';
        T271: Record 271;
        RunningBalanceCRorDR: Text;
        ReferenceDocCap: Label 'Loan No.';
        OpeningDRorCR: Text;
        ClosingDRorCR: Text;
        SrNo: Integer;
        RunningBal1: Decimal;
        TotalDebitAmt: Decimal;
        TotalCredittAmt: Decimal;
        CloseBal1: Decimal;
        OpenBal1: Decimal;
        decLoanAmt: Decimal;
        PendingDisbursementAmount: Decimal;
        DocType: Text;
        SalesInvHeader: Record 112;
        SalesCrMeHder: Record 114;
        ItemCategory: Record "Item Category";
        CustomerName: Text;
        CustomerAddress: Text;
        CustomerCity: Text;
        CustomerState: Text;
        CustomerPhoneNo: Text;
        CustomerMobileNo: Text;
        ProductItemCategory: text;
        CustomerGETFILTER: Text;
        DocumentType: Text[20];
}

