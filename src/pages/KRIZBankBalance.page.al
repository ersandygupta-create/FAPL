page 50016 "Bank Balance"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bank Account";
    Editable = true;

    layout
    {
        area(Content)
        {
            group("Date Filter")
            {
                Caption = 'Date Filter';
                field(FromDate; FromDate)
                {
                    ApplicationArea = All;
                    Caption = 'From Date';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        if (FromDate <> 0D) and (ToDate <> 0D) and (ToDate < FromDate) then
                            Error('To Date cannot be earlier than From Date.');
                    end;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = All;
                    Caption = 'To Date';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        if (FromDate <> 0D) and (ToDate <> 0D) and (ToDate < FromDate) then
                            Error('To Date cannot be earlier than From Date.');
                    end;
                }
            }

            repeater("Bank Balance")
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Bank Account';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Bank name';
                }
                field(Openingbalance; Openingbalance)
                {
                    Caption = 'Opening Balance';
                }
                field(Debitamount; Debitamount)
                {
                    Caption = 'Debit Amount';
                }
                field(CreditAmount; CreditAmount)
                {
                    Caption = 'Credit Amount';
                }
                field(ClosingBalance; ClosingBalance)
                {
                    Caption = 'Closing Balance';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateBalance)
            {
                ApplicationArea = All;
                Caption = 'Calculate Balance';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.FindSet() then
                        repeat
                            GetBankbalances();
                            Rec.Modify()
                        until Rec.Next() = 0;
                    CurrPage.Update(false);
                    Message('Balance has calculated');

                    //CurrPage.Update(false);
                end;
            }
            action(ExportToexcel)
            {
                Caption = 'Open in Excel';
                Image = Export;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer" temporary;
                begin
                    Clear(ExcelBuffer);
                    ExcelBuffer.SetUseInfoSheet();
                    //add coloumn header
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn('Bank account', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Bank Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Opening Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Debit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Credit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Closing Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    //Loop through Record and add data
                    Rec.Reset();
                    if rec.FindSet() then begin

                        repeat
                            GetBankbalances();
                            ExcelBuffer.NewRow();
                            ExcelBuffer.AddColumn(Rec."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Format(Openingbalance), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Format(Debitamount), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(CreditAmount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(ClosingBalance, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                        until Rec.Next() = 0;
                    end;
                    //crete and open excel
                    ExcelBuffer.CreateNewBook('Customer balance report');
                    ExcelBuffer.WriteSheet('Sheet1', CompanyName, UserId);
                    ExcelBuffer.CloseBook();
                    ExcelBuffer.OpenExcel();


                end;
            }
        }
    }

    var
        myInt: Integer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        PostingProfile: Code[20];
        Openingbalance: Decimal;
        ClosingBalance: Decimal;
        Debitamount: Decimal;
        CreditAmount: Decimal;
        FromDate: Date;
        ToDate: Date;


    trigger OnAfterGetRecord()
    begin

        GetBankbalances();
    end;

    local procedure GetBankbalances()
    var
        StartDate: Date;
        TempAmount: Decimal;
    begin
        // Reset variables
        Openingbalance := 0;
        Debitamount := 0;
        CreditAmount := 0;
        ClosingBalance := 0;

        // Calculate Opening Balance (before FromDate)
        BankLedgerEntry.Reset();
        BankLedgerEntry.SetRange("Bank Account No.", Rec."No.");
        if FromDate <> 0D then begin
            //BankLedgerEntry.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', FromDate));
            BankLedgerEntry.SetFilter("Posting Date", '..%1', FromDate);
            if BankLedgerEntry.FindSet() then
                repeat
                    //  BankLedgerEntry.CalcFields("Amount");
                    TempAmount := BankLedgerEntry.Amount;
                    Openingbalance += TempAmount;
                until BankLedgerEntry.Next() = 0;
        end;

        // Calculate Debit and Credit Amounts (within FromDate..ToDate)
        BankLedgerEntry.Reset();
        BankLedgerEntry.SetRange("Bank Account No.", Rec."No.");
        if (FromDate <> 0D) and (ToDate <> 0D) then
            BankLedgerEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate)
        else if FromDate <> 0D then
            BankLedgerEntry.SetFilter("Posting Date", '%1..', FromDate)
        else if ToDate <> 0D then
            BankLedgerEntry.SetFilter("Posting Date", '..%1', ToDate);

        if BankLedgerEntry.FindSet() then
            repeat
                //BankLedgerEntry.CalcFields("Amount");
                TempAmount := BankLedgerEntry.Amount;
                if TempAmount > 0 then
                    Debitamount += TempAmount
                else
                    CreditAmount += Abs(TempAmount);
            until BankLedgerEntry.Next() = 0;

        // Calculate Closing Balance
        ClosingBalance := Openingbalance + Debitamount - CreditAmount;
    end;
}