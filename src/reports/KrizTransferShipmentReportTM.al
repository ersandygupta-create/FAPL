report 50026 "Kriz GST-Transfer Shipment TM"           //Remarks = Some Fields and Tables not present error
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/KrizTransferShipmentReportTM.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "Transfer Order No.";
            column(Comp_state_description; Comp_state_description)
            {
            }
            column(TONum; "Transfer Shipment Header"."Transfer Order No.") { }
            column(TransShipDate; "Transfer Shipment Header"."Posting Date") { }
            column(Copm_stateCode; Copm_stateCode)
            {
            }
            column(ReceiverGSTIN; ReceiverGSTIN)
            {
            }
            column(SenderGSTIN; SenderGSTIN) { }
            column(SenderStateCode; SenderStateCode) { }
            column(SenderStateDesc; SenderStateDesc) { }
            column(LocStateDesc; LocStateDesc)
            {
            }
            column(SenderPLNo; SenderPLNo)
            {
            }
            column(SenderFLNo; SenderFLNo)
            {
            }
            column(ContactPerson; ContactPerson)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(ShipFLNo; ShipFLNo)
            {
            }
            column(ShipPLNo; ShipPLNo)
            {
            }

            column(ShipmentId; ShipmentId)
            {
            }
            column(Eway_Bill_No_; "Eway Bill No.")
            {

            }
            column(LocCode; LocCode)
            {
            }
            column(LocState; LocState)
            {
            }
            column(companyInfo_Name; companyInfo.Name)
            {
            }
            column(CINNo; companyInfo.CompanyCINNo)
            {
            }
            column(companyInfo_Address; companyInfo.Address + ' ' + companyInfo."Address 2")
            {
            }
            column(companyInfo_City; companyInfo.City)
            {
            }
            /*    column(Comp_State; companyInfo.State)
                {
                }
                column(companyInfo_State; companyInfo.State + companyInfo.County)
                {
                } */ //WIN541
            column(CompanyPicture; companyInfo.Picture)
            {
            }
            column(County; companyInfo.County)
            {
            }
            column(CompanyHomePage; companyInfo."Home Page")
            {
            }
            column(CompanyEmail; companyInfo."E-Mail")
            {
            }
            column(CompanyPhone; companyInfo."Phone No.")
            {
            }
            column(CompanyFax; companyInfo."Fax No.")
            {
            }
            column(ComGStReg; companyInfo."GST Registration No.")
            {
            }
            column(CompanyPAN; companyinfo."P.A.N. No.")
            { }

            column(Comp_PCode; companyInfo."Post Code")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(Title; Title)
                    {
                    }
                    column(No; "Transfer Shipment Header"."No.")
                    {
                    }
                    column(IRN; "Transfer Shipment Header"."IRN Hash")
                    {
                    }
                    column(QRCode; "Transfer Shipment Header"."QR Code")
                    {
                    }

                    column(AckDate; "Transfer Shipment Header"."Acknowledgement Date")
                    {

                    }
                    column(Transfer_from_Code; "Transfer Shipment Header"."Transfer-from Code")
                    {
                    }
                    column(Transfer_from_name; "Transfer Shipment Header"."Transfer-from Name")
                    {
                    }
                    column(Transfer_from_address; "Transfer Shipment Header"."Transfer-from Address")
                    {
                    }
                    column(Transfer_from_City; "Transfer Shipment Header"."Transfer-from City")
                    {
                    }
                    column(Transfer_order_no; "Transfer Shipment Header"."Transfer Order No.")
                    {
                    }
                    column(Transfer_from_address2; "Transfer Shipment Header"."Transfer-from Address 2")
                    {
                    }
                    column(Transfer_from_PostCode; "Transfer Shipment Header"."Transfer-from Post Code")
                    {
                    }
                    column(Transfer_to_PostCode; "Transfer Shipment Header"."Transfer-to Post Code")
                    {
                    }

                    column(Transfer_To_Code; "Transfer Shipment Header"."Transfer-to Code")
                    {
                    }
                    column(Transfer_To_Name; "Transfer Shipment Header"."Transfer-to Name")
                    {
                    }
                    column(Transfer_To_Address; "Transfer Shipment Header"."Transfer-to Address")
                    {
                    }

                    column(Transfer_To_Address2; "Transfer Shipment Header"."Transfer-to Address 2")
                    {
                    }
                    column(Trans_To_city; "Transfer Shipment Header"."Transfer-to City")
                    {
                    }
                    column(Date_of_Supply; "Transfer Shipment Header"."Posting Date")
                    {
                    }
                    column(Transport_Method; "Transfer Shipment Header"."Transport Method")
                    {
                    }
                    column(Vechicle_no; "Transfer Shipment Header"."Vehicle No.")
                    {
                    }
                    column(MOde_of_Transport; "Transfer Shipment Header"."Mode of Transport")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }

                    dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Shipment Header";
                        column(SrNo; "Sr.No")
                        {
                        }
                        column(Item_No_; "Transfer Shipment Line"."Item No.")
                        { }
                        column(Item_Description; "Transfer Shipment Line".Description)
                        {
                        }
                        column(BatchNo; BatchNo) { }
                        column(HSN_SACCode; "Transfer Shipment Line"."HSN/SAC Code")
                        {
                        }
                        column(Unit_of_Measure_Code; "Transfer Shipment Line"."Unit of Measure Code")
                        {
                        }
                        column(transQuantity; "Transfer Shipment Line".Quantity)
                        {
                        }
                        column(Trans_Unit_price; "Transfer Shipment Line"."Unit Price")
                        {
                        }
                        column(TransAmount; TransAmount)
                        {
                        }
                        column(rate3; rate3)
                        {
                        }
                        column(amt3; ABS(amt3))
                        {
                        }
                        column(GST_Base_amnt; abs(GSTBaseAmount))//WIN541 "Transfer Shipment Line"."GST Base Amount")
                        {
                        }
                        column(Total_GST_amnt; abs(amt3)) //WIN541 "Transfer Shipment Line"."Total GST Amount")
                        {
                        }//WIN541

                        column(AmountInWord; AmountInWord[1])
                        {
                        }
                        column(TotalInvoiceAmt; TotalInvoiceAmt)
                        {
                        }
                        column(Am; "Transfer Shipment Line".Amount)
                        {
                        }
                        column(MfgDate; MfgDate) { }
                        column(ExpiryDate; ExpiryDate) { }
                        column(MRPLotInfo; MRPLotInfo) { }
                        column(Numbertext; numberText[1])
                        {
                        }
                        column(AmountToText; AmountToText[1] + AmountToText[2]) { }
                        column(GSTAmtToText; GSTAmtToText[1] + GSTAmtToText[2]) { }
                        column(NoofCasesLine; NoofCasesLine)
                        { }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Transfer Shipment Line"."Item No." <> '' THEN
                                "Sr.No" := "Sr.No" + 1;

                            NoofCasesLine := 0;
                            recItemCase.Get("Transfer Shipment Line"."item No.");
                            // if recItemCase." SPQ" <> 0 then
                            //     NoofCasesLine := ROUND("Transfer Shipment Line".Quantity / recitemcase."EDC SPQ", 1, '>')
                            // else
                            //     NoofCasesLine := Round("Transfer Shipment Line".Quantity, 1, '>');
                            ILE.Reset();
                            ILE.SetRange("Document Type", ILE."Document Type"::"Transfer Shipment");
                            ILE.SetRange("Document No.", "Transfer Shipment Line"."Document No.");
                            ILE.SetRange("Document Line No.", "Transfer Shipment Line"."Line No.");
                            ILE.SetFilter("Lot No.", '<>%1', '');
                            if ILE.FindSet() then
                                repeat
                                    MfgDate := 0D;
                                    ExpiryDate := 0D;
                                    MRPLotInfo := 0;
                                    if LotInfo.get(ILE."Item No.", ILE."Variant Code", ILE."Lot No.") then begin
                                        MfgDate := LotInfo."Kriz Manufacturing Date";
                                        ExpiryDate := LotInfo."Kriz Expiry Date";
                                        MRPLotInfo := LotInfo."Kriz MRP";
                                        BatchNo := LotInfo."Lot No.";
                                        TransAmount := "Transfer Shipment Line"."Unit Price" * "Transfer Shipment Line".Quantity;
                                        //For IGST Win349++
                                        GSTBaseAmount := 0;
                                        TotalGSTAMT := 0;
                                        amt3 := 0;
                                        TotalAmnt := 0;
                                        GSTDetailLeger.RESET();
                                        GSTDetailLeger.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                                        GSTDetailLeger.SETRANGE("Document Line No.", "Transfer Shipment Line"."Line No.");
                                        IF GSTDetailLeger.FINDFIRST() THEN
                                            REPEAT
                                                GSTDetailLeger."GST Component Code" := 'IGST';
                                                CLEAR(rate3);
                                                //CLEAR(amt3);
                                                rate3 := GSTDetailLeger."GST %";
                                                amt3 := GSTDetailLeger."GST Amount";
                                                GSTBaseAmount := GSTDetailLeger."GST Base Amount"; //WIN541 added

                                            UNTIL GSTDetailLeger.NEXT() = 0;
                                        if (GSTBaseAmount = 0) then
                                            GSTBaseAmount := "Transfer Shipment Line"."Unit Price" * "Transfer Shipment Line".Quantity;

                                        //WIN541   TotalAmnt += "Transfer Shipment Line"."GST Base Amount" + ABS(amt3);
                                        if ("Item No." <> '') then begin
                                            TotalAmnt += Abs(GSTBaseAmount) + ABS(amt3); //WIN541 added 
                                            TotalGSTAMT += abs(amt3);
                                            Check.InitTextVariable();
                                            Check.FormatNoText(AmountToText, TotalAmnt, '');
                                            Check1.InitTextVariable();
                                            Check1.FormatNoText(GSTAmtToText, TotalGSTAMT, '');
                                        end;




                                    end;
                                until ILe.Next() = 0;
                        end;
                    }


                }


                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := Text16502;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;


                    //Win 275
                    IF OutputNo = 1 THEN BEGIN
                        Title := Text1;
                        "Sr.No" := 0;
                    END;

                    IF OutputNo = 2 THEN BEGIN
                        Title := Text2;
                        "Sr.No" := 0;
                    END;

                    IF OutputNo = 3 THEN BEGIN
                        Title := Text3;
                        "Sr.No" := 0;
                    END;

                end;

                trigger OnPostDataItem()
                begin
                    /*IF NOT CurrReport.PREVIEW THEN
                      SalesInvCountPrinted.RUN("Sales Invoice Header");
                      */

                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies);//;+ cust."Invoice Copies";
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemTableView = sorting("Location  Reg. No.", "Document Type", "Document No.", "HSN/SAC Code", "GST %") where("Entry Type" = filter("Initial Entry"));

                column(DGLE_HSN_SAC_Code; "HSN/SAC Code")
                {
                }
                column(GST_Component_Code; "GST Component Code")
                {
                }
                column(GST_Base_Amount; ABS(GSTBaseAmount))
                {
                }
                column(GST__; "GST %")
                {
                }
                column(GST_Amount; ABS("GST Amount"))
                {
                }
                trigger OnAfterGetRecord()
                begin
                    GSTBaseAmount := 0;
                    IF "GST Component Code" IN ['SGST', 'CGST'] then
                        GSTBaseAmount := "GST Base Amount" / 2
                    else
                        if "GST Component Code" = 'IGST' then
                            GSTBaseAmount := "GST Base Amount";
                end;
            }


            trigger OnAfterGetRecord()
            begin
                // sandeep shipment id
                TransferHeader.Reset();
                TransferHeader.SetRange("No.", "Transfer Shipment Header"."Transfer Order No.");
                if TransferHeader.Find('-') then;
                ShipmentId := TransferHeader."Kriz Shipping Id";

                //For Receivers GSTIN No and State code Win349++
                RecLoc.RESET();
                RecLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-to Code");
                IF RecLoc.FINDFIRST() THEN BEGIN
                    ReceiverGSTIN := RecLoc."GST Registration No.";
                    LocState := RecLoc."State Code";
                    ShipPLNo := RecLoc."Kriz PL Number";
                    ShipFLNo := RecLoc."Kriz FL Number";
                END;
                StateRec.RESET();
                StateRec.SETRANGE(StateRec.Code, LocState);
                IF StateRec.FINDFIRST() THEN
                    LocStateDesc := StateRec.Description;

                LocSender.Reset();
                LocSender.SetRange(Code, "Transfer Shipment Header"."Transfer-from Code");
                if LocSender.FindFirst() then begin
                    SenderGSTIN := LocSender."GST Registration No.";
                    SenderStateCode := LocSender."State Code";
                    SenderPLNo := LocSender."Kriz PL Number";
                    SenderFLNo := LocSender."Kriz FL Number";
                    ContactPerson := LocSender.Contact;
                    PhoneNo := LocSender."Phone No.";
                end;
                StateSender.Reset();
                StateSender.SetRange(Code, SenderStateCode);
                if StateSender.FindFirst() then
                    SenderStateDesc := StateSender.Description;
                Check.InitTextVariable();
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
                    // field(NoOfCopies; NoOfCopies)
                    // {
                    //     Caption = 'No. of Copies';
                    // }
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
        companyInfo.GET();
        companyInfo.CALCFIELDS(Picture);
        //Win349+
        RecState.RESET();
        //WIN541   RecState.SETRANGE(Code, companyInfo.State);
        IF RecState.FINDFIRST() THEN BEGIN
            Copm_stateCode := RecState."State Code (GST Reg. No.)";
            Comp_state_description := RecState.Description;
        END;
        //Win349-
    end;

    var
        GSTDetailLeger: Record "Detailed GST Ledger Entry";
        LotInfo: Record "Lot No. Information";
        ILE: Record "Item Ledger Entry";
        companyInfo: Record "Company Information";
        StateRec: Record "State";
        rate3: Decimal;
        amt3: Decimal;
        "Sr.No": Integer;
        From_Name: Text[50];
        From_Address: Text;
        From_StateCode: Code[20];
        To_Address: Text;
        To_StateCode: Code[20];
        To_State: Text;
        To_GSTIN: Code[20];
        Fromcust: Record "Customer";
        ToCust: Record "Customer";
        TotalInvoiceAmt: Decimal;
        Check: Report "Posted Voucher";
        Check1: Report "Posted Voucher";
        AmountInWord: array[2] of Text;
        recSalesInvoiceLine: Record "Sales Invoice Line";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        TotalInvoiceAmt1: Decimal;
        ChargesAmount: Decimal;
        GlbInsCharge: Decimal;
        GlbOtherCharge: Decimal;
        GlbFrtCharge: Decimal;
        //WIN541    StructureLineDetails: Record "Posted Str Order Line Details";
        //WIN541    ServTaxEntry_L: Record "Service Tax Entry";
        GlbPackCharge: Integer;
        RecLoc: Record "Location";
        TransferHeader: Record "Transfer Header";
        ShipmentId: Text[20];
        LocName: Text;
        LocAddr: Text;
        LocState: Text;
        LocCity: Text;
        LocGSTRegNo: Text;
        LocStateDesc: Text;
        decAmount: Decimal;
        recSalesInvLine: Record "Sales Invoice Line";
        numberText: array[2] of Text[250];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        PageGroupNo: Integer;
        recItem: Record "Item";
        BatchNo: Text[50];
        PackSize: Text[10];
        ValueEntryRec: Record "Value Entry";
        ItemLedgerRec: Record "Item Ledger Entry";
        NosLines: Integer;
        LocTin: Code[20];
        recitem1: Record "Item";
        UnitNo: Integer;
        locGSTNo: Code[20];
        recSIL: Record "Sales Invoice Line";
        recItemCase: Record Item;
        totQty: Decimal;
        LocCode: Code[20];
        StateRec1: Record "State";
        StateRec2: Record "State";
        LocCode1: Code[20];
        LocCode2: Code[20];
        recSIL1: Record "Sales Invoice Line";
        Qty: Decimal;
        amt4: Decimal;
        QtyText: Text;
        packSize1: Text;
        FSS: Code[20];
        TINNo: Code[20];
        CityName: Text[50];
        recLocation: Record "Location";
        INVType: Text[100];
        SelToTicyName: Text[80];
        Shiptocityname: Text[80];
        TaxableValue: Decimal;
        TotalAmount: Decimal;
        TotGST: Decimal;
        Dispatch_Location: Text[50];
        Loc_addr: Text[50];
        Loc_addr_2: Text[50];
        City: Text[50];
        Phone_no: Text[30];
        postcode: Code[20];
        Comp_state_description: Text[50];
        Copm_stateCode: Code[20];
        State_description: Text;
        RecState: Record "State";
        Cust_Sate_No: Code[10];
        From_State_NO: Code[10];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        Title: Text[50];
        i: Integer;
        Text16502: Label 'COPY';
        Text1: Label 'ORIGINAL FOR RECIPIENT ';
        Text2: Label 'DUPLICATE FOR TRANSPORTER';
        Text3: Label 'TRIPLICATE FOR SUPPLIER';
        ReceiverGSTIN: Code[20];
        SenderGSTIN: Code[20];
        SenderFLNo: Code[50];
        SenderPLNo: Code[50];
        ShipFLNo: Code[50];
        ShipPLNo: Code[50];
        ContactPerson: Text[50];
        PhoneNo: Text[30];
        LocSender: Record Location;
        StateSender: record State;
        SenderStateDesc: text[50];
        SenderStateCode: Text[20];
        TransAmount: Decimal;
        TotalAmnt: Decimal;
        TotalGSTAMT: Decimal;
        AmountToText: array[2] of Text[80];
        GSTAmtToText: array[2] of Text[80];
        SumTotal: Decimal;
        GSTBaseAmount: Decimal;
        CompanyPAN: Text[20];
        NoofCasesLine: Decimal;
        MfgDate: Date;
        ExpiryDate: Date;
        MRPLotInfo: Decimal;


}

