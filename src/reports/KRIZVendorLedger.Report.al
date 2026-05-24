report 50011 "Vendor Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/VendorLedger.rdl';
    Caption = 'Vendor Ledger Report';

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Date Filter";
            column(ReferenceCap; ReferenceCap)
            {
            }
            column(DateFilter; GETFILTER("Date Filter"))
            {
            }
            column(DateFilterCaption; DateFilterCaption)
            {
            }
            column(TodayDate; FORMAT(TODAY, 0, 4))
            {
            }
            column(Todaytime; FORMAT(TIME))
            {
            }
            column(No_GLAccount; Vendor."No.")
            {
            }
            column(Name_GLAccount; Vendor.Name)
            {
            }
            column(VendorAddress; VendorAddress) { }
            column(VendorPan; VendorPan) { }
            column(LocAdd; LocAdd) { }
            column(OpenBal; OpenBal)
            {
            }
            column(BalAtDate; CloseBal)
            {
            }
            column(OpeningDRorCR; OpeningDRorCR)
            {
            }
            column(ClosingDrorCR; ClosingDrorCR)
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
            column(CompanyCINNo; CompanyInformation.CompanyCINNo) { }
            column(ReportCap; ReportCap)
            {
            }
            column(AmtCapt; AmtCaption)
            {
            }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            column(OpenBal1; OpenBal1)
            {
            }
            column(CloseBal1; CloseBal1)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                CalcFields = "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amt. (LCY)";
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending);
                column(VendorNo_; "Vendor No.")
                {
                }
                column(SRNo; SRNo)
                {
                }
                column(VendInvNo; VendInvNo)
                {
                }
                column(EntryNo_VendorLedgerEntry; "Vendor Ledger Entry"."Entry No.")
                {
                }
                column(SG_Clearing_File_No_; '')//"SG_Clearing File No.")
                { }
                column(DebitAmount_GLEntry; "Debit Amount (LCY)")
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount (LCY)")
                {
                }
                column(DocumentType; DocumentType) { }
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)")
                { }
                column(TdsAmount; TdsAmount) { }
                column(GlobalDimension1Code_VendorLedgerEntry; "Vendor Ledger Entry"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_VendorLedgerEntry; "Vendor Ledger Entry"."Global Dimension 2 Code")
                {
                }
                column(PostingDate_GLEntry; "Posting Date")
                {
                }
                column(DocumentType_GLEntry; "Document Type")
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(Amount_GLEntry; "Amount (LCY)")
                {
                }
                column(DocumentDate_GLEntry; "Document Date")
                {
                }
                column(BalAccountType_GLEntry; "Bal. Account Type")
                {
                }
                column(BalAccountNo_GLEntry; "Bal. Account No.")
                {
                }
                column(LineNarration_GLEntry; LineNarrationValue)//SG_Narration)
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
                column(TotalCreditAmt; TotalCreditAmt)
                {
                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = SORTING(Number);
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
                    column(DocNo_TempGL; TempGL."Document No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN
                            TempGL.FIND('-')
                        ELSE
                            TempGL.NEXT;
                        TempGL.CALCFIELDS("G/L Account Name");
                        CLEAR(AccountNo);
                        CLEAR(AccountName);
                        GLEntryRec.RESET;
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", VendorFilter);
                        IF GLEntryRec.FINDFIRST THEN BEGIN
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::Vendor THEN BEGIN
                                AccountNo := GLEntryRec."Source No.";
                                IF T23.GET(AccountNo) THEN
                                    AccountName := T23.Name;
                            END;
                        END;

                        GLEntryRec.RESET;
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", CustomerFilter);
                        IF GLEntryRec.FINDFIRST THEN BEGIN
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::Customer THEN BEGIN
                                AccountNo := GLEntryRec."Source No.";
                                IF T18.GET(AccountNo) THEN
                                    AccountName := T18.Name;
                            END;
                        END;

                        GLEntryRec.RESET;
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", BankFilter);
                        IF GLEntryRec.FINDFIRST THEN BEGIN
                            IF GLEntryRec."Source Type" = GLEntryRec."Source Type"::"Bank Account" THEN BEGIN
                                AccountNo := GLEntryRec."Source No.";
                                IF T270.GET(AccountNo) THEN
                                    AccountName := T270.Name;
                            END;
                        END;

                        GLEntryRec.RESET;
                        GLEntryRec.SETRANGE("Entry No.", TempGL."Entry No.");
                        GLEntryRec.SETFILTER("G/L Account No.", ImprestFilter);
                        IF GLEntryRec.FINDFIRST THEN BEGIN
                            IF T480.GET(GLEntryRec."Dimension Set ID", 'EMPLOYEE') THEN BEGIN
                                T480.CALCFIELDS("Dimension Value Name");
                                AccountNo := T480."Dimension Value Code";
                                AccountName := T480."Dimension Value Name";
                            END;
                        END;

                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, TempGL.COUNT);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SRNo += 1;
                    CLEAR(LineNarrationValue);
                    CLEAR(VendInvNo);
                    CLEAR(RunningBalanceCRorDR);
                    // sandeep document ty
                    DocumentType := format("Document Type");
                    if (DocumentType = '') then
                        DocumentType := 'Payment';
                    //T122.RESET;
                    IF T122.GET("Document No.") THEN BEGIN
                        LineNarrationValue := T122."Posting Description";
                        VendInvNo := T122."Vendor Invoice No.";
                    END ELSE
                        IF T124.GET("Document No.") THEN BEGIN
                            VendInvNo := T124."Vendor Cr. Memo No.";
                            LineNarrationValue := T124."Posting Description";
                        END;

                    Temp17.DELETEALL;
                    TempGL.DELETEALL;
                    T17.RESET;
                    //T17.SETCURRENTKEY("Document No.");
                    T17.SETRANGE("Document No.", "Document No.");
                    IF Vendor.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                        T17.SETRANGE(T17."Global Dimension 1 Code", "Global Dimension 1 Code");
                    IF Vendor.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                        T17.SETRANGE(T17."Global Dimension 2 Code", "Global Dimension 2 Code");
                    T17.SETRANGE("Posting Date", "Posting Date");
                    IF T17.FINDFIRST THEN BEGIN
                        REPEAT
                            IF T17."Entry No." = "Entry No." THEN BEGIN
                                RunningBal := ((RunningBal + "Debit Amount (LCY)") - "Credit Amount (LCY)");
                                CLEAR(LineNarration);
                                LineNarration := T17."External Document No.";
                            END ELSE BEGIN
                                IF NOT Temp17.GET(T17."Entry No.") THEN BEGIN
                                    Temp17.INIT;
                                    Temp17.TRANSFERFIELDS(T17);
                                    Temp17.INSERT;
                                END;
                            END;
                        UNTIL T17.NEXT = 0;
                    END
                    ELSE
                        CurrReport.SKIP;
                    // TDS
                    TdsAmount := 0;
                    Clear(TDSEntry);
                    TDSEntry.SetRange("Vendor No.", "Vendor No.");
                    TDSEntry.SetRange("Document Type", TDSEntry."Document Type"::Invoice);
                    TDSEntry.SetRange("Document No.", "Document No.");
                    if TDSEntry.FindSet() then
                        repeat
                            TdsAmount := TdsAmount + TDSEntry."TDS Amount";
                        until TDSEntry.Next() = 0;


                    IF LineNarrationValue = '' THEN
                        LineNarrationValue := Description + ' ' + "Payment Reference";
                    // LineNarrationValue := LineNarration;


                    CLEAR(VoucherNarr);

                    CLEAR(GLAccNo);
                    Temp17.RESET;
                    Temp17.SETCURRENTKEY("G/L Account No.");
                    Temp17.SETRANGE("Document No.", "Document No.");
                    Temp17.SETFILTER("G/L Account No.", NoAccountsFilter);
                    IF Temp17.FINDFIRST THEN
                        REPEAT
                            IF Temp17."G/L Account No." = GLAccNo THEN BEGIN
                                TempGL."Debit Amount" := TempGL."Debit Amount" + Temp17."Debit Amount";
                                TempGL."Credit Amount" := TempGL."Credit Amount" + Temp17."Credit Amount";
                                TempGL.Amount := TempGL.Amount + Temp17.Amount;
                                TempGL.MODIFY;
                            END
                            ELSE BEGIN
                                TempGL.INIT;
                                TempGL.TRANSFERFIELDS(Temp17);
                                TempGL.INSERT;
                            END;
                            GLAccNo := Temp17."G/L Account No."
UNTIL Temp17.NEXT = 0;

                    Temp17.RESET;
                    Temp17.SETCURRENTKEY("G/L Account No.");
                    Temp17.SETRANGE("Document No.", "Document No.");
                    Temp17.SETFILTER("G/L Account No.", AccountsFilter);
                    IF Temp17.FINDFIRST THEN
                        REPEAT
                            IF NOT TempGL.GET("Entry No.") THEN BEGIN
                                TempGL.INIT;
                                TempGL.TRANSFERFIELDS(Temp17);
                                TempGL.INSERT;
                            END;
                        UNTIL Temp17.NEXT = 0;

                    // PRU_AS - start
                    IF RunningBal <> 0 THEN BEGIN
                        IF RunningBal > 0 THEN
                            RunningBalanceCRorDR := 'Dr'
                        ELSE
                            RunningBalanceCRorDR := 'Cr';
                    END;
                    // PRU_AS - End

                    RunningBal1 := ABS(RunningBal);
                    TotalDebitAmt += "Vendor Ledger Entry"."Debit Amount (LCY)";
                    TotalCreditAmt += "Vendor Ledger Entry"."Credit Amount (LCY)";


                end;

                trigger OnPostDataItem()
                begin

                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", StartDate, EndDate);
                    CLEAR(RunningBal);
                    RunningBal := OpenBal;
                    SRNo := 0;
                    TotalCreditAmt := 0;
                    TotalDebitAmt := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                // Sandeep for vendor 
                VendorRec.Reset();
                Vendorrec.SetRange("No.", "No.");
                If VendorRec.FindFirst() then begin
                    State.Get(VendorRec."State Code");
                    Country.Get(VendorRec."Country/Region Code");
                    VendorAddress := VendorRec.Address + ' ' + VendorRec."Address 2" + ' ' + VendorRec.City
                                    + ' ' + State.Description + ' - ' + VendorRec."Post Code" + ' ' + Country.Name;


                end;

                VendorPan := VendorRec."P.A.N. No.";
                Clear(Location);
                //Location.get(VendorRec."Location Code");
                Location.Reset();
                Location.SetRange(Code, "Location Code");
                if Location.FindFirst() then begin
                    Clear(State);
                    if State.get(Location."State Code") then;
                    Clear(Country);
                    if "Country/Region Code" <> '' then
                        Country.Get("Country/Region Code");
                    LocAdd := Location.Address + ' ' + Location."Address 2" + ' ' + Location.City
                        + ' ' + State.Description + ' - ' + Location."Post Code" + ' ' + Country.Name;
                end;

                CLEAR(OpenBal);
                CLEAR(CloseBal);
                T25.RESET;
                T25.SETRANGE(T25."Vendor No.", "No.");
                T25.SETFILTER("Posting Date", '<%1', GETRANGEMIN("Date Filter"));
                IF GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    T25.SETFILTER("Global Dimension 1 Code", '%1', GETFILTER("Global Dimension 1 Filter"));
                IF GETFILTER(Vendor."Global Dimension 2 Filter") <> '' THEN
                    T25.SETFILTER("Global Dimension 2 Code", '%1', GETFILTER("Global Dimension 2 Filter"));
                T25.SETAUTOCALCFIELDS("Amount (LCY)");
                IF T25.FINDFIRST THEN
                    REPEAT
                        OpenBal := OpenBal + T25."Amount (LCY)";
                    UNTIL T25.NEXT = 0;

                // PRU_AS - start
                IF OpenBal <> 0 THEN BEGIN
                    IF OpenBal > 0 THEN
                        OpeningDRorCR := 'Dr'
                    ELSE
                        OpeningDRorCR := 'Cr';
                END;
                // PRU_AS - End

                //Pru Raj
                OpenBal1 := ABS(OpenBal);

                //Pru Raj

                T25.RESET;
                T25.SETRANGE(T25."Vendor No.", "No.");
                T25.SETFILTER("Posting Date", '<=%1', GETRANGEMAX("Date Filter"));
                IF GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    T25.SETFILTER("Global Dimension 1 Code", '%1', GETFILTER("Global Dimension 1 Filter"));
                IF GETFILTER(Vendor."Global Dimension 2 Filter") <> '' THEN
                    T25.SETFILTER("Global Dimension 2 Code", '%1', GETFILTER("Global Dimension 2 Filter"));
                T25.SETAUTOCALCFIELDS("Amount (LCY)");
                IF T25.FINDFIRST THEN
                    REPEAT
                        CloseBal := CloseBal + T25."Amount (LCY)";
                    UNTIL T25.NEXT = 0;

                // PRU_AS - start
                IF CloseBal <> 0 THEN BEGIN
                    IF CloseBal > 0 THEN
                        ClosingDrorCR := 'Dr'
                    ELSE
                        ClosingDrorCR := 'Cr';
                END;
                // PRU_AS - End
                //Pru Raj
                CloseBal1 := ABS(CloseBal);

            end;


            trigger OnPreDataItem()
            begin

                //T25.COPYFILTERS("Vendor Ledger Entry");
                IF GETFILTER("Date Filter") = '' THEN
                    ERROR('Please Enter the Date Filter');
                StartDate := GETRANGEMIN("Date Filter");
                EndDate := GETRANGEMAX("Date Filter");
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
        State.SetRange(Code, CompanyInformation."State Code");
        if State.FIND('-') then
            CompanyState := State.Description;

        Country.RESET();
        Country.Get(CompanyInformation."Country/Region Code");
        if Country.FINDFIRST() then
            CompanyCountry := Country.Name;
    end;

    var
        VendorRec: Record Vendor;
        VendorAddress: Text[500];
        T25: Record 25;
        CompanyInformation: Record "Company Information";
        State: Record State;
        VendorPan: Code[20];
        CompanyState: Text[60];
        CompanyCountry: Text[60];
        Country: record "Country/Region";
        OpenBal: Decimal;
        StartDate: Date;
        EndDate: Date;
        RunningBal: Decimal;
        PdateCaption: Label 'Posting Date';
        DDateCaption: Label 'Document Date';
        DocNoCaption: Label 'Document No.';
        DocTypeCaption: Label 'Document Type';
        BalAccTypeCap: Label 'Bal. Account Name';
        BalAccNoCaption: Label 'Bal. Account No.';
        LineNarrCaption: Label 'Line Narration';
        DrAmtCaption: Label 'Debit Amount';
        CrAmtCaption: Label 'Credit Amount';
        RunBalCaption: Label 'Running Balance';
        UserIDCaption: Label 'User ID';
        OpenBalCap: Label 'Opening Balance';
        CloseBalCap: Label 'Closing Balance';
        ReportCap: Label 'Vendor Ledger ';
        CloseBal: Decimal;
        LineNarration: Text;
        T17: Record 17;
        BankAccountLedgerEntries: Record 271;
        GLEntry: Record 17;
        Temp17: Record 17 temporary;
        TempGL: Record 17 temporary;
        GLAccNo: Code[20];
        VoucherNarr: Text[150];
        ExcelBuf: Record 370 temporary;
        Row: Integer;
        VendorInvNoCap: Label 'Reference Doc. No.';
        CircleCodeCap: Label 'Circle Code';
        ExporttoExcel: Boolean;
        CellTypeVar: Option Number,Text,Date,Time;
        T122: Record 122;
        VendInvNo: Code[35];
        T124: Record 124;
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
        DocumentType: Text[30];
        SourceNoCaption: Label 'Source No.';
        SourceNameCaption: Label 'Source Name';
        PrintDate: Text[30];
        DateFilterCaption: Label 'Date Filter:';
        T271: Record 271;
        LineNarrationValue: Text;
        RunningBalanceCRorDR: Text;
        OpeningDRorCR: Text;
        ClosingDrorCR: Text;
        ReferenceCap: Label 'Reference Doc. No.';
        SRNo: Integer;
        RunningBal1: Decimal;
        OpenBal1: Decimal;
        CloseBal1: Decimal;
        TotalDebitAmt: Decimal;
        TotalCreditAmt: Decimal;
        TDSEntry: Record "TDS Entry";
        TdsAmount: Decimal;
        LocAdd: Text[500];
        Location: Record Location;
}

