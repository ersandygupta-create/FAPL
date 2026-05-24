page 50003 "Vendor Balance"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Vendor;
    Caption = 'Vendor Balance';
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

            repeater("Vendor Balance")
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Vendor Account';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Vendor name';
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor group';
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
                            GetVendorBalances();
                            Rec.Modify();
                        until Rec.Next() = 0;
                    Message('Balance has been calculated');
                    CurrPage.Update(false);
                end;
            }
            action(ExportToExcel)
            {
                Caption = 'Open in Excel';
                Image = Export;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer" temporary;
                begin
                    Clear(ExcelBuffer);
                    ExcelBuffer.SetUseInfoSheet();
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn('Vendor account', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Vendor Group', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Posting Profile', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Opening Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Debit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Credit Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Closing Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);

                    Rec.Reset();
                    if Rec.FindSet() then begin
                        repeat
                            GetVendorBalances();
                            ExcelBuffer.NewRow();
                            ExcelBuffer.AddColumn(Rec."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Rec."Vendor Posting Group", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PostingProfile, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Format(Openingbalance), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Format(Debitamount), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Format(CreditAmount), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Format(ClosingBalance), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                        until Rec.Next() = 0;
                    end;

                    ExcelBuffer.CreateNewBook('Vendor Balance');
                    ExcelBuffer.WriteSheet('Sheet1', CompanyName, UserId);
                    ExcelBuffer.CloseBook();
                    ExcelBuffer.OpenExcel();
                end;
            }
        }
    }

    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PostingProfile: Code[20];
        Openingbalance: Decimal;
        ClosingBalance: Decimal;
        Debitamount: Decimal;
        CreditAmount: Decimal;
        FromDate: Date;
        ToDate: Date;

    trigger OnAfterGetRecord()
    begin
        PostingProfile := Rec."Vendor Posting Group";
        GetVendorBalances();
    end;

    local procedure GetVendorBalances()
    begin
        Openingbalance := 0;
        Debitamount := 0;
        CreditAmount := 0;
        ClosingBalance := 0;

        VendLedgerEntry.Reset();
        VendLedgerEntry.SetRange("Vendor No.", Rec."No.");

        if FromDate <> 0D then begin
            VendLedgerEntry.SetFilter("Posting Date", '<%1', FromDate);
            if VendLedgerEntry.FindSet() then
                repeat
                    VendLedgerEntry.CalcFields("Amount (LCY)");
                    Openingbalance += VendLedgerEntry."Amount (LCY)";
                until VendLedgerEntry.Next() = 0;
        end;

        VendLedgerEntry.Reset();
        VendLedgerEntry.SetRange("Vendor No.", Rec."No.");
        if (FromDate <> 0D) and (ToDate <> 0D) then
            VendLedgerEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate)
        else if FromDate <> 0D then
            VendLedgerEntry.SetFilter("Posting Date", '%1..', FromDate)
        else if ToDate <> 0D then
            VendLedgerEntry.SetFilter("Posting Date", '..%1', ToDate);

        if VendLedgerEntry.FindSet() then
            repeat
                VendLedgerEntry.CalcFields("Amount (LCY)");
                if VendLedgerEntry."Amount (LCY)" < 0 then
                    CreditAmount += Abs(VendLedgerEntry."Amount (LCY)")
                else
                    Debitamount += VendLedgerEntry."Amount (LCY)";
            until VendLedgerEntry.Next() = 0;

        ClosingBalance := Openingbalance + Debitamount - CreditAmount;
    end;

}

