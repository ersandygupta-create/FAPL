report 50025 "Purchase Order Print TM"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/KrizPurchaseOrderGSTTM.rdl';
    Caption = 'Purchase Order Report GST';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Purchase Order Print';

            column(CompanyName; compinfo.Name)
            {
            }
            column(CompanyCINNo; compinfo.CompanyCINNo) { }
            column(No_; "No.") { }
            column(DocumentNo; "No." + ' ' + Brand) { }
            column(LocAdd; LocAdd[1] + ' ' + LocAdd[2] + ',' + LocAdd[3])
            {
            }
            column(BillAdd; BillAdd[1] + ' ' + BillAdd[2] + ',' + BillAdd[3])
            {
            }
            column(LocGSTIN; LocAdd[4])
            {
            }
            column(LocTAN; LocAdd[5])
            {
            }
            column(LocPh; locadd[6])
            {
            }
            column(LocEmail; locadd[7])
            {
            }
            column(CompanyName2;
            CompInfo."Name 2")
            {
            }
            column(CompanyAddress; CompAdd)
            {
            }
            column(CompanyPicture; CompInfo.Picture) { }
            column(ComPANNo; compinfo."P.A.N. No.")
            {
            }
            column(ComWebSite; compinfo."Home Page")
            {
            }
            column(Email; Email)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(GSTIN; GSTIN)
            {
            }
            column(txtcomment; txtcomment)
            {

            }
            column(txtcommentNote; txtcommentNote)
            {

            }
            column(txtVendorComment; txtVendorComment)
            {
            }
            column(PayTerms; PayTerms)
            {
            }
            column(DrugLigNo; DrugLigNo)
            {
            }
            column(LocationAdd; LocationAdd)
            {
            }
            column(ContactPerson; PurchaseHeader."Buy-from Contact")
            {
            }
            column(ContactNumber; PurchaseHeader."Buy-from Contact No.")
            {
            }
            column(LocationEmail; LocationEmail)
            {
            }
            column(LocationPhoneNo; LocationPhoneNo)
            {
            }
            column(LocationGSTIN; LocationGSTIN)
            {
            }
            column(LocationWebsite; LocationWebsite)
            {

            }
            column(Document_Type; "Document Type")
            {
            }
            column(PurchInvNo; "No.")
            {
            }
            column(PurchInvPostingDate; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(OrderDate; Format(PurchaseHeader."Order Date", 0, '<Day,2>-<Month,2>-<Year4>')) { }
            column(POValidityDate; Format(POValidityDate, 0, '<Day,2>-<Month,2>-<Year4>')) { }

            column(Status; Status)
            {
            }
            column(Vendor_GST_RegistrationNo; Vendor."GST Registration No.") { }
            column(PaymentTermsDesc; PaymentTerms.Description) { }
            column(BuyFromAddr1; BuyFromAddr[1]) { }
            column(BuyFromAddr2; BuyFromAddr[2]) { }
            column(BuyFromAddr3; BuyFromAddr[3]) { }
            column(BuyFromAddr4; BuyFromAddr[4]) { }
            column(BuyFromAddr5; BuyFromAddr[5]) { }
            column(BuyFromAddr6; BuyFromAddr[6]) { }
            column(BuyFromAddr7; BuyFromAddr[7]) { }
            column(BuyFromAddr8; BuyFromAddr[8]) { }
            column(SystemCreatedBy; userc."User Name")
            {
            }
            column(SystemModifiedBy; userm."User Name")
            {
            }
            column(ApprovedBy; userId)
            {
            }
            column(CreatedBy; PreparedBy)
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SupplierAdd; PurchaseHeader."Buy-from Address" + ', ' + PurchaseHeader."Buy-from Address 2" + ', ' + PurchaseHeader."Buy-from City" + ', ' + PurchaseHeader."Buy-from Post Code")
            {
            }
            column(SupplierPhoneNo; SupplierPhoneNo)
            {
            }
            column(SupplierName; SupplierName)
            {
            }
            column(SupplierCode; Purchaseheader."Buy-from Vendor No.")
            {
            }
            column(IGSTRsAmount_Var; IGSTRsAmount_Var)
            {
            }
            column(CGSTRsAmount_Var; CGSTRsAmount_Var)
            {
            }
            column(SGSTRsAmount_Var; SGSTRsAmount_Var)
            {
            }
            column(SupplierEmail; SupplierEmail)
            {
            }
            column(SupplierGSTIN; PurchaseHeader."Vendor GST Reg. No.")
            {
            }
            column(OrderaddGSTIN; PurchaseHeader."Order Address GST Reg. No.")
            {
            }
            column(SupplierPANNo; SupplierPANNo)
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(AmtWords; AmtWords[1])
            {
            }
            column(TotalAmttoVendor; TotalAmttoVendor)
            {
            }
            column(txtPurchaseHeader; txtPurchaseHeader)
            {

            }
            column(TotalTDS; TotalTDS)
            {
            }
            column(TotalGSTAmount; TotalInclTaxAmount)
            {

            }
            column(Currency_Code; CdCurrencyCode)
            {

            }
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            trigger OnAfterGetRecord()
            begin
                Vendor.Get("Buy-from Vendor No.");
                IF Status = Status::Open then begin
                    txtPurchaseHeader := 'Approval Pending'
                end else
                    if status = status::"Pending Approval" then begin
                        txtPurchaseHeader := 'Approval Pending '
                    end else
                        if status = status::Released then begin
                            txtPurchaseHeader := 'Approved'
                        end;


                SupplierName := '';
                SupplierAdd := '';
                SupplierEmail := '';
                SupplierPhoneNo := '';
                SupplierGSTIN := '';
                IF Customer.Get("Buy-from Vendor No.") THEN begin
                    SupplierName := Customer.Name + '' + Customer."Name 2";
                    IF recState.Get(Customer."State Code") THEN;
                    IF CountryRegion.Get(Customer."Country/Region Code") THEN;
                    SupplierAdd := Customer.Address + ', ' + Customer."Address 2" + ', ' + Customer.City + ', ' + FORMAT(Customer."Post Code") + ', ' + FORMAT(recState.Description) + ', ' + CountryRegion.Name;
                    SupplierEmail := Customer."E-Mail";
                    SupplierPhoneNo := Customer."Phone No.";
                    SupplierGSTIN := Customer."GST Registration No.";
                    SupplierPANNo := Customer."P.A.N. No.";
                end;

                LocationAdd := '';
                LocationEmail := '';
                LocationPhoneNo := '';
                LocationGSTIN := '';
                LocationName := '';
                Location.Get(PurchaseHeader."Location Code");
                LocAdd[1] := Location.Address + ' ' + Location."Address 2";
                LocAdd[2] := Location.City + '-' + Location."Post Code";
                LocAdd[3] := Location."State Code" + ',' + Location."Country/Region Code";
                LocAdd[4] := Location."GST Registration No.";
                LocAdd[5] := Location."T.A.N. No.";
                LocAdd[6] := Location."Phone No.";
                LocAdd[7] := Location."E-Mail";

                VendorBill.get(PurchaseHeader."Pay-to Vendor No.");
                BillAdd[1] := locadd[1];//PurchaseHeader."Pay-to Address" + ' ' + PurchaseHeader."Pay-to Address 2";
                BillAdd[2] := locadd[2];//PurchaseHeader."Pay-to City" + '-' + PurchaseHeader."Pay-to Post Code";
                BillAdd[3] := locadd[3];//VendorBill."State Code" + ',' + PurchaseHeader."Pay-to Country/Region Code";

                // BillAdd[1] := PurchaseHeader."Pay-to Address" + ' ' + PurchaseHeader."Pay-to Address 2";
                // BillAdd[2] := PurchaseHeader."Pay-to City" + '-' + PurchaseHeader."Pay-to Post Code";
                // BillAdd[3] := VendorBill."State Code" + ',' + PurchaseHeader."Pay-to Country/Region Code";



                POValidityDate := CalcDate('<1M>', "Order Date");

                DimSetEntry1.Reset();
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                DimSetEntry1.SetFilter("Dimension Code", '%1', 'BUDGETTYPE');
                if DimSetEntry1.Find('-') then
                    Brand := DimSetEntry1."Dimension Value Name";

                // FormatAdd.PurchHeaderBuyFrom(BuyFromAddr, PurchaseHeader);
                // if "Buy-from Vendor No." <> "Pay-to Vendor No." then
                //     FormatAdd.PurchHeaderPayTo(VendAddr, PurchaseHeader);

                BuyFromAddr[1] := PurchaseHeader."Buy-from Vendor Name";
                buyfromaddr[2] := PurchaseHeader."Buy-from Vendor Name 2";
                BuyFromAddr[3] := PurchaseHeader."Buy-from Contact";
                BuyFromAddr[4] := PurchaseHeader."Buy-from Address";
                BuyFromAddr[5] := PurchaseHeader."Buy-from Address 2";
                BuyFromAddr[6] := PurchaseHeader."Buy-from City";
                BuyFromAddr[7] := PurchaseHeader."Buy-from Post Code";
                BuyFromAddr[8] := PurchaseHeader."Buy-from country/Region Code";
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;



                decAmountoVendor := 0;
                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Document Type");
                recPurchaseLine.SetRange("Document No.", "No.");
                IF recPurchaseLine.FindFirst() then begin
                    repeat
                        decAmountoVendor += recPurchaseLine.Amount;
                    until recPurchaseLine.Next() = 0;
                end;

                IF PurchaseHeader."Currency Code" <> '' then
                    CdCurrencyCode := PurchaseHeader."Currency Code"
                else
                    CdCurrencyCode := 'INR';

                CalcStatistics.GetPurchaseStatisticsAmount(PurchaseHeader, TotalAmttoVendor);
                CalcStatistics.OnGetPurchaseHeaderGSTAmount(PurchaseHeader, TotalInclTaxAmount);
                CalcStatistics.OnGetPurchaseHeaderTDSAmount(PurchaseHeader, TotalTDS);

                if TotalInclTaxAmount = 0 then begin
                    GetGSTAmounts(PurchaseHeader);
                    TotalInclTaxAmount := CGST_Amt + SGST_Amt + IGST_Amt;
                    if TotalInclTaxAmount <> 0 then
                        TotalAmttoVendor += TotalInclTaxAmount + decAmountoVendor
                    else
                        TotalAmttoVendor := decAmountoVendor;

                end;

                Customer.get("Buy-from Vendor No.");
                IF (Customer."State Code" = "Location State Code") and (TotalInclTaxAmount <> 0) then begin
                    CGSTRsAmount_Var := (TotalInclTaxAmount / 2);
                    SGSTRsAmount_Var := (TotalInclTaxAmount / 2);
                END ELSE
                    IGSTRsAmount_Var := TotalInclTaxAmount;
                //   LocAdd[5] := Customer."P.A.N. No.";

                PostedVoucher.InitTextVariable;
                PostedVoucher.FormatNoText(AmtWords, Round(TotalAmttoVendor, 1), PurchaseHeader."Currency Code");

                txtcomment := '';
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", "Document Type");
                //PurchCommentLine.SetRange(Type, PurchCommentLine.Type::"Term & Condition");
                PurchCommentLine.SetRange("No.", "No.");
                IF PurchCommentLine.FindSet() then begin
                    repeat
                        txtcomment += PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;
                end;

                txtcommentNote := '';
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", "Document Type");
                PurchCommentLine.SetRange("Document Line No.", PurchCommentLine."Document Line No.");
                PurchCommentLine.SetRange("No.", "No.");
                IF PurchCommentLine.FindSet() then begin
                    repeat
                        txtcommentNote += PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;

                end;
                txtDescription := '';
                ExtendedTextLine.Reset();
                ExtendedTextLine.SetRange("Table Name", ExtendedTextLine."Table Name"::Item);
                ExtendedTextLine.SetRange("No.", PurchaseLine."Vendor Item No.");
                IF ExtendedTextLine.FINDFIRST THEN BEGIN
                    repeat
                        txtDescription += ExtendedTextLine.Text;
                    UNTIL ExtendedTextLine.NEXT() = 0;

                    // END ELSE
                    //txtDescription := "Purchase Line".Description + '' + "Purchase Line"."Description 2";
                end;
                PayTerms := '';
                PaymentTerms.SetRange(Code, PurchaseHeader."Payment Terms Code");
                if PaymentTerms.FindFirst() then begin
                    repeat
                        PayTerms += PaymentTerms.Description;
                    until PaymentTerms.Next() = 0;
                end;

                txtVendorComment := '';
                VendorComment.Reset();
                VendorComment.SetRange("Table Name", VendorComment."Table Name"::Vendor);
                //VendorComment.SetRange(Type, VendorComment.Type::"Term & Condition");
                VendorComment.SetRange("No.", "Buy-from Vendor No.");
                IF VendorComment.FindFirst() then begin
                    repeat
                        txtVendorComment += VendorComment.Comment;
                    until VendorComment.Next() = 0;

                end;

                userId := '';
                PreparedBy := '';
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Table ID", 38);
                ApprovalEntry.SETRANGE("Document No.", "No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                IF ApprovalEntry.FINDLAST THEN
                    userId := ApprovalEntry."Last Modified By User ID";
                PreparedBy := ApprovalEntry."Sender ID";

            end;

        }
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            DataItemLinkReference = purchaseHeader;
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")

            ;
            column(LineNo_PurchaseLine; PurchaseLine."Line No.") { }
            column(Description; Description + ', ' + PurchaseLine."Description 2")
            {
            }
            column(TotalAmount; TotalAmount)
            {
                AutoFormatExpression = PurchaseHeader."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalTaxAmount; TotalTaxAmount)
            {
            }

            column(DirectUnitCost_PurchaseLine; PurchaseLine."Direct Unit Cost")
            {
                AutoFormatExpression = PurchaseHeader."Currency Code";
                AutoFormatType = 2;
            }
            column(PurchaseLineDescription; PurchaseLine.Description) { }
            column(PurchaseLineHSN; PurchaseLine."HSN/SAC Code") { }
            column(Quantity_PurchaseLine; PurchaseLine.Quantity) { }
            column(UnitofMeasure_PurchaseLine; PurchaseLine."Unit of Measure Code") { }
            column(LineDiscAmt_PurchaseLine; PurchaseLine."Line Discount Amount") { }
            column(PurchLineLineAmount; PurchaseLine."Line Amount") { }


            column(No_PurchaseLine; PurchaseLine."No.") { }
            column(ExttxtDesc; txtDescription)
            {
            }
            column(Line_No_; PurchaseLine."Line No.")
            {
            }
            column(UOM; PurchaseLine."Unit of Measure Code")
            {
            }
            column(HSN_SAC_Code;
            "HSN/SAC Code")
            {
            }
            column(Quantity;
            Quantity)
            {
            }
            column(Direct_Unit_Cost;
            "Direct Unit Cost")
            {
            }
            column(freeQty; freeQty)
            {
            }
            column(Line_Amount; "Line Amount")
            {
            }
            column(Line_Discount__; "Line Discount %")
            {
            }
            column(IGSTRatePercnt_Var;
            IGSTRatePercnt_Var)
            {
            }

            column(CGSTRatePercnt_Var;
            CGSTRatePercnt_Var)
            {
            }
            column(SGSTRatePercnt_Var;
            SGSTRatePercnt_Var)
            {
            }
            column(Line_Discount_Amount;
            "Line Discount Amount")
            {
            }
            column(Inv__Discount_Amount;
            "Inv. Discount Amount" + "Line Discount Amount")
            {
            }
            column(Amount; Amount)
            {
            }
            column(SNo; SNo)
            {
            }
            column(decGSTPer;
            decGSTPer)
            {
            }
            column(ItemCode;
            PurchaseLine."No.")
            {
            }
            column(LineGSTAmount;
            LineGSTAmount)
            {
            }
            column(LineAmount_PurchaseLine; PurchaseLine."Line Amount")
            {
                AutoFormatExpression = PurchaseHeader."Currency Code";
                AutoFormatType = 1;
            }

            column(Warrnty; Warrnty)
            {
            }
            column(Parts; Parts)
            {
            }


            trigger OnPreDataItem()
            begin
                SNo := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                //  if "PurchaseLine"."No." <> GLAccountNo then begin
                TotalSubTotal += PurchaseLine."Line Amount";
                // TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                TotalAmount += PurchaseLine.Amount;

                SNo += 1;
                decGSTPer := 0;
                LineGSTAmount := 0;
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', PurchaseLine.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                TaxTransactionValue.SetFilter("Tax Type", '%1', 'GST');
                TaxTransactionValue.SetRange("Visible on Interface", TRUE);
                if TaxTransactionValue.FindSet() then
                    repeat
                        IF TaxTransactionValue.Percent <> 0 then begin
                            decGSTPer += TaxTransactionValue.Percent;
                        end;
                    until TaxTransactionValue.Next() = 0;
                if (decGSTPer <> 0) then
                    LineGSTAmount := PurchaseLine."Line Amount" + PurchaseLine."Line Amount" * decGSTPer / 100
                else
                    LineGSTAmount := PurchaseLine."Line Amount";

                if userc.Get(SystemCreatedBy) then;
                if userm.Get(SystemModifiedBy) then;

            End;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
        recState.Get(CompInfo."State Code");
        CountryRegion.Get(CompInfo."Country/Region Code");
        CompAdd := CompInfo.Address + ', ' + CompInfo."Address 2" + ', ' + CompInfo.City + ', ' + FORMAT(CompInfo."Post Code") + ', ' + FORMAT(recState.Description) + ', ' + CountryRegion.Name;
        Email := CompInfo."E-Mail";
        PhoneNo := CompInfo."Phone No.";
        GSTIN := CompInfo."GST Registration No.";
        DrugLigNo := CompInfo."Registration No.";
    end;

    var
        CompInfo: Record "Company Information";
        Customer: Record "Vendor";
        CompAdd: Text[500];
        recState: Record State;
        CountryRegion: Record "Country/Region";
        Email: Code[100];
        PhoneNo: Code[50];
        GSTIN: Code[15];
        DrugLigNo: Code[200];
        Location: Record Location;
        LocationName: Text[100];
        LocationEmail: Code[100];
        LocationPhoneNo: Code[50];
        LocationGSTIN: Code[15];
        LocationWebsite: Text[200];
        LocationAdd: Code[200];
        SupplierName: Text[300];
        SupplierAdd: Text[500];
        TotalAmount: Decimal;
        totaltaxamount: Decimal;
        TotalSubTotal: Decimal;
        SupplierEmail: Text[100];
        SupplierPhoneNo: Text[20];
        SupplierGSTIN: Code[20];
        SupplierPANNo: Code[10];
        freeQty: Decimal;
        LineGSTAmount: Decimal;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTRatePercnt_Var: Decimal;
        IGSTRsAmount_Var: Decimal;
        SGSTRatePercnt_Var: Decimal;
        SGSTRsAmount_Var: Decimal;
        CGSTRatePercnt_Var: Decimal;
        CGSTRsAmount_Var: Decimal;
        recPurchaseLine: Record "Purchase Line";
        Sno: Integer;
        decAmountoVendor: Decimal;
        CheckReport: Report "Check";
        AmtWords: array[2] of Text[500];
        TotalInclTaxAmount: Decimal;
        decGSTPer: Decimal;
        TotalTDS: Decimal;
        TotalAmttoVendor: Decimal;
        rpt: Report 18008;
        CalcStatistics: Codeunit "Calculate Statistics";
        RecordIDList: List of [RecordID];
        TaxTransactionValue: Record "Tax Transaction Value";
        ComponentJObject: JsonObject;
        ScriptDatatypeMgmt: Codeunit "Script Data Type Mgmt.";
        CdCurrencyCode: Code[20];
        PostedVoucher: Report "Posted Voucher";
        PurchCommentLine: Record "Purch. Comment Line";
        VendorComment: Record "Comment Line";
        txtcommentNote: Text;
        txtcomment: Text;
        txtVendorComment: Text;
        txtPurchaseHeader: Text[150];
        Vendor: Record "Vendor";
        userc: Record User;
        userm: Record User;
        userId: Text;
        PreparedBy: Text;
        ApprovalEntry: Record "Approval Entry";
        ExtendedTextLine: Record "Extended Text Line";
        txtDescription: Text;
        PaymentTerms: Record "Payment Terms";
        PayTerms: Text;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        CGST_Amt: Decimal;
        IGST_Amt: Decimal;
        SGST_Amt: Decimal;

        DT: Text;
        YOY: Decimal;
        PT: Text;
        PI: Text;
        AMC: Decimal;
        CMC: Decimal;
        FI: Decimal;
        FN: Text;
        WI: Text;
        WP: Text;
        AMCPer: Decimal;
        CMCPer: Decimal;
        YOYPer: Decimal;
        InstallChrg: Decimal;
        FreeItemValue: Text[100];
        GSTonAcc: Decimal;
        Model: Text[50];
        YOYAmount: Decimal;
        POValidityDate: Date;
        Warrnty: Text[100];
        PreInstallation: Text[100];
        DeliveryTerms: Text[100];
        FeturedReq: Text[100];
        FreightAmt: Decimal;
        InstalationAmt: Decimal;
        GSTOnAcc1: Decimal;
        TransportationChg: Decimal;
        LocAdd: array[7] of Text[300];
        VendorBill: Record Vendor;
        BillAdd: array[7] of Text[300];
        FormatAdd: Codeunit "Format Address";
        Parts: Text[100];
        ModelName: Text;
        RecCompanyName: Code[100];
        DimSetEntry1: Record "Dimension Set Entry";
        BuyFromAddr: array[8] of Text[50];
        Brand: Code[50];


    local procedure GetGSTAmounts(PurchHeader: Record "Purchase Header")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        Clear(IGST_Amt);
        Clear(SGST_Amt);
        Clear(CGST_Amt);

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
                    ComponentName := GetComponentName(PurchaseLine, GSTSetup);

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                    TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            case TaxTransactionValue."Value ID" of
                                6:
                                    SGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                2:
                                    CGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                3:
                                    IGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                            end;
                        until TaxTransactionValue.Next() = 0;
                end;
            until PurchaseLine.Next() = 0;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;


}
