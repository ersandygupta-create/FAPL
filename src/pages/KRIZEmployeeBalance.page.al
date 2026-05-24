Page 50004 "Employee Balance"

{
    PageType = Card;
    SourceTable = Employee;
    ApplicationArea = all;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group("Filters")
            {
                field(ToDate; ToDate)
                {
                    Caption = 'To Date';
                    ApplicationArea = All;
                }
                field(GLAccountFilter; GLAccountFilter)
                {
                    Caption = 'G/L Account';
                    ApplicationArea = All;
                    TableRelation = "G/L Account"."No.";
                }
            }
            repeater(group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Employee Code';
                    ApplicationArea = All;
                    ToolTip = 'Employee Number';
                }
                field(FullName; Rec.FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    ToolTip = 'Employee Full Name';
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    Caption = 'Worker Group';
                    ApplicationArea = all;
                    ToolTip = 'Employee Worker Group';

                }
                field(Amount; Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;

                }
            }
        }
    }
    actions
    {
        Area(Processing)
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
                    Calculate := True;
                    CurrPage.Update();
                end;
            }
            action(ExportToExcel)
            {
                ApplicationArea = all;
                Caption = 'Export To Excel';
                Image = Export;
                Promoted = True;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    TempExcelBuffer: Record "Excel Buffer" temporary;
                    GLEntry: Record "G/L Entry";
                    TempEmployee: Record Employee;
                    TotalAmt: Decimal;

                begin
                    If (Todate = 0D) then
                        Error('Please Fill the ToDate');

                    TempExcelBuffer.DeleteAll();
                    TempExcelBuffer.SetUseInfoSheet();
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('Employee Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Employee Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Worker Group', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);

                    TempEmployee.Reset();
                    if TempEmployee.FindSet() then
                        repeat
                            Amount := 0;
                            // TotalAmt := 0;
                            GLEntry.Reset();
                            GLEntry.SetFilter("Posting Date", '..%1', Todate);
                            if GLAccountFilter <> '' then
                                GLEntry.SetRange("G/L Account No.", GLAccountFilter);
                            GLEntry.SetRange("Shortcut Dimension 6 Code", TempEmployee."No.");
                            if
                            GLEntry.FindSet() then
                                repeat
                                    Amount += GLentry.Amount;
                                until GLEntry.Next() = 0;

                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn(TempEmployee."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(TempEmployee.FullName(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(TempEmployee."Statistics Group Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        until
                        TempEmployee.Next() = 0;
                    TempExcelBuffer.CreateNewBook('Employee Balance');
                    TempExcelBuffer.Writesheet('Sheet1', CompanyName, UserId);
                    TempExcelBuffer.CloseBook();
                    TempExcelBuffer.OpenExcel();
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        GLEntry: Record "G/L Entry";
        TotalAmt: Decimal;
    begin
        if not Calculate then
            exit;

        TotalAmt := 0;
        GLEntry.Reset();
        GLEntry.SetFilter("Posting Date", '..%1', ToDate);
        if GLAccountFilter <> '' then
            GLEntry.SetRange("G/L Account No.", GLAccountFilter);

        GLEntry.SetRange("Shortcut Dimension 6 Code", Rec."No.");
        if GLEntry.FindSet() then
            repeat
                TotalAmt += GLEntry.Amount;
            until GLEntry.Next() = 0;

        Amount := TotalAmt;
    end;

    var
        Todate: DATE;
        GLAccountFilter: Code[20];
        Amount: Decimal;
        Calculate: Boolean;

}
