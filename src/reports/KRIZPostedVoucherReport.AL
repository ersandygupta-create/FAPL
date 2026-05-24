reportextension 50007 PostedVoucherReports extends 18041
{

    dataset
    {
        add("G/L Entry")
        {
            column(AccountCode; AccountCode) { }
            column(EmpName; EmpName) { }
            column(ReportCaption; ReportCaption) { }
            column(ExternalDocNo; ExternalDocNo) { }
            column(ExtDocumentDate; ExtDocumentDate) { }
        }
        modify("G/L Entry")
        {

            trigger OnAfterAfterGetRecord()
            begin

                AccountCode := FindGLAccCode("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                if ("Source Code" <> '') then
                    case "G/L Entry"."Source Code" of
                        'SALES':
                            ReportCaption := 'Sales Invoice';
                        'SALESJNL':
                            ReportCaption := 'Sales Journal';
                        'PURCHASES':
                            begin
                                ReportCaption := 'Purchase Invoice';
                                PurchInvHeader.Reset();
                                PurchInvHeader.SetRange("No.", "G/L Entry"."Document No.");
                                if PurchInvHeader.Find('-') then begin
                                    ExternalDocNo := "External Document No.";
                                    ExtDocumentDate := "Document Date";
                                end;
                            end;

                        'PURCHJNL':
                            ReportCaption := 'Purchase Journal';
                        'GENJNL':
                            begin
                                ReportCaption := 'General Journal';
                                ExternalDocNo := "External Document No.";
                                ExtDocumentDate := "Document Date";
                                Emp.Reset();
                                Emp.SetRange(emp."No.", "G/L Entry"."Shortcut Dimension 4 Code");
                                if Emp.FindFirst() then
                                    EmpName := emp.FullName();
                            end;
                        'BANKREC':
                            ReportCaption := 'Bank Receipt Voucher';
                        'PAYMENTJNL':
                            ReportCaption := 'Bank PaymentVoucher';

                    end else begin
                    ReportCaption := 'General Journal';
                    ExternalDocNo := "External Document No.";
                    ExtDocumentDate := "Document Date";
                    GLEntry1.Reset();
                    GLEntry1.SetRange("Entry No.", "Entry No.");
                    if GLEntry1.FindFirst() then begin
                        DimSetEntry.Reset();
                        DimSetEntry.SetRange("Dimension Set ID", GLEntry1."Dimension Set ID");
                        if DimSetEntry.FindFirst() then begin
                            Emp.SetRange("No.", DimSetEntry."Dimension Value Code");
                            if Emp.FindFirst() then
                                EmpName := '(' + Emp."No." + '-' + emp.FullName() + ')';
                        end;
                    end;
                end;
            end;
        }
    }


    procedure FindGLAccCode(
         "Source Type": Enum "Gen. Journal Source Type";
                            "Entry No.": Integer;
                            "Source No.": Code[20];
                            "G/L Account No.": Code[20]): Text[100]
    var
        GLAccount: Record "G/L Account";
        Vendor: Record "Vendor";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccount: Record "Bank Account";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AccCode: Text[100];
    begin
        case "Source Type" of
            "Source Type"::Vendor:
                if VendorLedgerEntry.Get("Entry No.") then
                    if IsGSTDocument(VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No.") then begin
                        if Vendor.Get("Source No.") then
                            AccCode := Vendor."No."
                        else begin
                            GLAccount.Get("G/L Account No.");
                            AccCode := "G/L Account No.";
                        end;
                    end else begin
                        Vendor.Get("Source No.");
                        AccCode := Vendor."No.";
                    end
                else begin
                    GLAccount.Get("G/L Account No.");
                    AccCode := GLAccount."No.";
                end;
            "Source Type"::Customer:
                if CustLedgerEntry.Get("Entry No.") then
                    if IsGSTDocument(CustLedgerEntry."Document Type", CustLedgerEntry."Document No.") then begin
                        if Customer.Get("Source No.") then
                            AccCode := Customer."No."
                        else begin
                            GLAccount.Get("G/L Account No.");
                            AccCode := GLAccount."No.";
                        end;
                    end else begin
                        Customer.Get("Source No.");
                        AccCode := Customer."No.";
                    end
                else begin
                    GLAccount.Get("G/L Account No.");
                    AccCode := GLAccount."No.";
                end;
            "Source Type"::"Bank Account":
                if BankAccountLedgerEntry.Get("Entry No.") then begin
                    BankAccount.Get("Source No.");
                    AccCode := BankAccount."No.";
                end else begin
                    GLAccount.Get("G/L Account No.");
                    AccCode := GLAccount."No.";
                end
            else begin
                GLAccount.Get("G/L Account No.");
                AccCode := GLAccount."No.";
            end;
                GLAccount.Get("G/L Account No.");
                AccCode := GLAccount."No.";
        end;

        exit(AccCode);

    end;

    local procedure GetApplicationDocType(DocumentType: Enum "Gen. Journal Document Type"): Enum "Application Doc Type"
    var
        ApplicationDocType: Enum "Application Doc Type";
    begin
        case DocumentType of
            DocumentType::Invoice:
                exit(ApplicationDocType::Invoice);
            DocumentType::"Credit Memo":
                exit(ApplicationDocType::"Credit Memo");
            DocumentType::"Finance Charge Memo":
                exit(ApplicationDocType::"Finance Charge Memo");
            DocumentType::Refund:
                exit(ApplicationDocType::Refund);
            DocumentType::Payment:
                exit(ApplicationDocType::Payment);
            DocumentType::" ":
                exit(ApplicationDocType::" ")
        end;
    end;

    local procedure IsGSTDocument(DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]): Boolean
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        if DetailedGSTLedgerEntry.FindFirst() then
            exit(true);
        DetailedGSTLedgerEntry.SetRange("Document No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::Application);
        DetailedGSTLedgerEntry.SetRange("Application Doc. Type", GetApplicationDocType(DocumentType));
        DetailedGSTLedgerEntry.SetRange("Application Doc. No", DocumentNo);
        if not DetailedGSTLedgerEntry.IsEmpty then
            exit(true);
        exit(false);
    end;

    var
        PurchInvHeader: Record "Purch. Inv. Header";
        DimSetEntry: Record "Dimension Set Entry";
        GLEntry1: Record "G/L entry";
        Emp: Record Employee;
        AccountCode: Text[20];
        ReportCaption: Text[50];
        ExternalDocNo: Text[50];
        ExtDocumentDate: Date;
        EmpName: text[100];


}