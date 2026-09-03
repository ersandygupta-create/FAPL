page 50002 "Customer Balance"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Customer;
    Caption = 'Customer Balance';

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

            repeater("Customer Balance")
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Customer Account';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Customer name';
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    Caption = 'Customer group';
                }
                field(PostingProfile; PostingProfile)
                {
                    Caption = 'Posting Profile';
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
                            GetCustomerbalances();
                            Rec.Modify();
                        until Rec.Next() = 0;
                    Message('Balance has calculated');

                    CurrPage.Update(false);
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
                    ExcelBuffer.AddColumn('Customer account', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Customer Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Posting Profile', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Opening Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Debit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Credit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Closing Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    //Loop through Record and add data
                    Rec.Reset();
                    if rec.FindSet() then begin

                        repeat
                            GetCustomerbalances();
                            ExcelBuffer.NewRow();
                            ExcelBuffer.AddColumn(Rec."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Customer Posting Group", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PostingProfile, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Format(Openingbalance), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Format(Debitamount), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(CreditAmount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(ClosingBalance, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                        until Rec.Next() = 0;
                    end;
                    //crete and open excel
                    ExcelBuffer.CreateNewBook('Customer Balance');
                    ExcelBuffer.WriteSheet('Sheet1', CompanyName, UserId);
                    ExcelBuffer.CloseBook();
                    ExcelBuffer.OpenExcel();


                end;
            }
        }
    }

    var
        myInt: Integer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PostingProfile: Code[20];
        Openingbalance: Decimal;
        ClosingBalance: Decimal;
        Debitamount: Decimal;
        CreditAmount: Decimal;
        FromDate: Date;
        ToDate: Date;


    trigger OnAfterGetRecord()
    begin
        PostingProfile := Rec."Customer Posting Group"; // Adjust based on your setup
        GetCustomerbalances();
    end;

    local procedure GetCustomerbalances()
    var
        StartDate: Date;
    begin
        // Reset variables
        Openingbalance := 0;
        Debitamount := 0;
        CreditAmount := 0;
        ClosingBalance := 0;

        // Calculate Opening Balance (before FromDate)
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", Rec."No.");
        if FromDate <> 0D then begin
            //CustLedgerEntry.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', FromDate));
            CustLedgerEntry.SetFilter("Posting Date", '<%1', FromDate);
            if CustLedgerEntry.FindSet() then
                repeat
                    CustLedgerEntry.CalcFields("Amount (LCY)");
                    Openingbalance += CustLedgerEntry."Amount (LCY)";
                until CustLedgerEntry.Next() = 0;
        end;

        // Calculate Debit and Credit Amounts (within FromDate..ToDate)
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", Rec."No.");
        if (FromDate <> 0D) and (ToDate <> 0D) then
            CustLedgerEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate)
        else if FromDate <> 0D then
            CustLedgerEntry.SetFilter("Posting Date", '%1..', FromDate)
        else if ToDate <> 0D then
            CustLedgerEntry.SetFilter("Posting Date", '..%1', ToDate);

        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Amount (LCY)");
                if CustLedgerEntry."Amount (LCY)" > 0 then
                    Debitamount += CustLedgerEntry."Amount (LCY)"
                else
                    CreditAmount += Abs(CustLedgerEntry."Amount (LCY)");
            until CustLedgerEntry.Next() = 0;

        // Calculate Closing Balance
        ClosingBalance := Openingbalance + Debitamount - CreditAmount;
    end;

}