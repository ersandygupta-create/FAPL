report 50021 "Kri Sales Tax Invoice Batch TM"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/KrizSalesTaxInvoiceBatchTM.rdl';
    Caption = 'Truemart Sales Tax Invoice (Batch Detials)';
    Permissions = TableData "Sales Shipment buffer" = rimd;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';

            column(No_SalesInvHdr; "No.")
            {
            }
            column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
            {
            }
            column(VATPercentageCaption; VATPercentageCaptionLbl)
            {
            }
            column(VATAmountCaption; VATAmountCaptionLbl)
            {
            }
            column(Duedt; "Sales Invoice Header"."Due Date")
            {
            }
            column(Paytrm; "Sales Invoice Header"."Payment Terms Code")
            {
            }
            column(VATIdentifierCaption; VATIdentifierCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote; DisplayAddFeeNote)
            {
            }
            column(RoundoffValue; RoundoffValue)
            {

            }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(OutputNo; OutputNo)
                {
                }
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number)
                                        where(Number = const(1));

                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(IFSCCode; CompanyInfo."SWIFT Code")
                    {

                    }
                    column(DocumentCaptionCopyText; DocCaption)
                    {
                    }
                    column(CompanyRegistrationLbl; CompanyRegistrationLbl)
                    {
                    }
                    column(CompanyInfo_GST_RegistrationNo; 'GSTIN: ' + "Sales Invoice Header"."Location GST Reg. No.")
                    {
                    }
                    column(CustomerRegistrationLbl; CustomerRegistrationLbl)
                    {
                    }
                    column(CustomerPLNo; Customer."Cost Center")
                    {
                    }
                    column(CustomerPLDate; '')//Customer."EDC PL Validity")
                    {
                    }
                    column(CustomerFLNo; '')//Customer."EDC FL Number")
                    {
                    }
                    column(CustomerFLDate; '')//Customer."EDC FL Validity")
                    {
                    }
                    column(CustomerPLNoShip; '')//ShipToAddRec."SG PL Number")
                    {
                    }
                    column(CustomerPLDateShip; '')//ShipToAddRec."SG PL Validity")
                    {
                    }
                    column(CustomerFLNoShip; '')//ShipToAddRec."SG FL Number")
                    {
                    }
                    column(CustomerFLDateShip; '')//ShipToAddRec."SG FL Validity")
                    {
                    }
                    column(Customer_GST_RegistrationNo; 'GSTIN: ' + Customer."GST Registration No.")
                    {
                    }
                    column(GSTComponentCode1; GSTComponentCode[1] + ' Amount')
                    {
                    }
                    column(GSTComponentCode2; GSTComponentCode[2] + ' Amount')
                    {
                    }
                    column(GSTComponentCode3; GSTComponentCode[3] + ' Amount')
                    {
                    }
                    column(GSTComponentCode4; GSTComponentCode[4] + 'Amount')
                    {
                    }
                    column(GSTCompAmount1; Abs(GSTCompAmount[1]))
                    {
                    }
                    column(GSTCompAmount2; Abs(GSTCompAmount[2]))
                    {
                    }
                    column(GSTCompAmount3; Abs(GSTCompAmount[3]))
                    {
                    }
                    column(GSTCompAmount4; Abs(GSTCompAmount[4]))
                    {
                    }
                    column(IsGSTApplicable; IsGSTApplicable)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; Loc.Address)
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; Loc."Address 2")
                    {
                    }
                    column(LocationGSTIN; loc."GST Registration No.")
                    {

                    }
                    column(LocationPAN; CompanyInfo."P.A.N. No.")//loc."GST Registration No.")
                    {

                    }
                    column(CustAddr4; CustAddr[4] + ' ' + CustAddr[5])
                    {
                    }
                    column(CompanyAddr4; Loc.City + '-' + Loc."Post Code" + ',' + HdrState.Description)//CompanyAddr[4])
                    {
                    }

                    column(CustAddr5; CustAddr[6])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[7])
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail; 'E-Mail: ' + EMailID + '  Ph. : ' + PhoneNo)
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CIN; CompanyInfo.CompanyCINNo)
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BillToContact_SalesInvHdr; Customer."Phone No.")
                    {
                    }
                    column(OrderDate_SalesInvHdr; customer."Agreement Date")
                    {
                    }
                    column(PLNo_Location; Loc."Kriz PL Number")
                    {
                    }
                    column(PLDate_Location; '')//Loc."EDC PL Validity")
                    {
                    }
                    column(FLNo_Location; Loc."Kriz FL Number")
                    {
                    }
                    column(FLDate_Location; '')//Loc."SG FL Validity")
                    {
                    }
                    column(ShipToContact_SalesInvHdr; ShipToContactNo)
                    {
                    }
                    column(BillToCustNo_SalesInvHdr; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format("Sales Invoice Header"."Posting Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                    {
                    }
                    column(VATNoText; 'PAN: ' + CompanyInfo."P.A.N. No.")
                    {
                    }
                    column(VATRegNo_SalesInvHdr; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvoiceHdr; Format("Sales Invoice Header"."Due Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_SalesInvoiceHdr; "Sales Invoice Header"."PO No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(HeadOfficeAdd; HeadOfficeAdd)
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; 'GSTIN: ' + ShiptoGSTIN)
                    {
                    }
                    column(SellerState; SellerState)
                    {
                    }
                    column(LocationName; LocationName)
                    {
                    }
                    column(BuyerState; BuyerState)
                    {
                    }
                    column(ShiptoState; ShiptoState)
                    {
                    }
                    column(AmountToText; AmountToText[1] + AmountToText[2])
                    {
                    }
                    column(TotalGSTAmount; TotalGSTAmount)
                    {
                    }
                    column(GSTAmtToText; GSTAmtToText[1] + GSTAmtToText[2])
                    {
                    }
                    column(DocDate_SalesInvHeader; Format("Sales Invoice Header"."Document Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "Sales Invoice Header"."Prices Including VAT")
                    {
                    }

                    column(PricesInclVATYesNo; Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption; PageCaptionCapLbl)
                    {
                    }
                    column(PLAEntryNo_SalesInvHdr; '')
                    {
                    }
                    column(SupplementaryText; SupplementaryText)
                    {
                    }
                    column(RG23AEntryNo_SalesInvHdr; '')
                    {
                    }
                    column(RG23CEntryNo_SalesInvHdr; '')
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionCapLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(PLAEntryNoCaption; PLAEntryNoCaptionLbl)
                    {
                    }
                    column(RG23AEntryNoCaption; RG23AEntryNoCaptionLbl)
                    {
                    }
                    column(RG23CEntryNoCaption; RG23CEntryNoCaptionLbl)
                    {
                    }
                    column(ServiceTaxRegistrationNoCaption; ServiceTaxRegistrationNoLbl)
                    {
                    }
                    column(ServiceTaxRegistrationNo; ServiceTaxRegistrationNo)
                    {
                    }
                    column(BillToCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(ActualWeight; ActualWeight)
                    {
                    }
                    column(NoOfCases; customer."Valid Upto")
                    {
                    }
                    column(CategoryNameQty; CategoryNameQty)
                    {
                    }
                    column(RRLRNo; RRLRNo)
                    {
                    }
                    column(RRLRDate; RRLRDate)
                    {
                    }
                    column(VehicleNo; VehicleNo)
                    {
                    }
                    column(EWaybillNo; EWaybillNo)
                    {
                    }
                    column(Transport; Transport)
                    {
                    }
                    column(IRN; "Sales Invoice Header"."IRN Hash")
                    {
                    }
                    column(QRCode; "Sales Invoice Header"."QR Code")
                    {
                    }
                    column(AckDate; "Sales Invoice Header"."Acknowledgement Date")
                    {

                    }

                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));

                        column(DimText; DimText)
                        {
                        }
                        column(Number_Integer; Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()


                        begin
                            HdrLoc.get("Sales Invoice Header"."Location Code");
                            HdrState.Reset();
                            HdrState.SetRange(Code, HdrLoc."State Code");
                            if HdrState.Find('-') then;

                            if RecState.get("Sales Invoice Header"."Location Code") then;
                            DimText := GetDimensionText(DimSetEntry1, Number, Continue);
                            if not Continue then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document No.", "Line No.") where("System-Created Entry" = const(false));
                        UseTemporary = true;

                        column(LineAmount_SalesInvLine; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; Description)
                        {
                        }
                        column(Descrip_SalesInvoiceLine; "Description 2")
                        {
                        }
                        column(MRP; '')//"EDC MRP")
                        {
                        }
                        column(NoOfCasesLine; NoOfCasesLine)
                        {
                        }
                        column(ExpiryDate; "Tax Group Code")
                        {
                        }
                        column(MfgDate; "VAT Clause Code")
                        {
                        }
                        column(No_SalesInvLine; "Sales Invoice Line"."No.")
                        {
                        }
                        column(Qty_SalesInvLine; Quantity)
                        {
                        }
                        column(UOM_SalesInvoiceLine; "Unit of Measure Code")
                        {
                        }
                        column(HSN_SAC_Code; "HSN/SAC Code")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesInvLine; "Line Discount %")
                        {
                        }
                        column(LineDiscount_SalesInvLineAmount; "Line Discount Amount")
                        {
                        }
                        column(PostedShipmentDate; Format(PostedShipmentDate))
                        {
                        }
                        column(SalesLineType; Format("Sales Invoice Line".Type))
                        {
                        }
                        column(DirectDebitPLARG_SalesInvLine; '')
                        {
                        }
                        column(SourceDocNo_SalesInvLine; '')
                        {
                        }
                        column(Supplementary; '')
                        {
                        }
                        column(InvDiscountAmount; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalesInvoiceLineAmount; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine; "Sales Invoice Line".Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }

                        column(TaxAmount_SalesInvLine; '"Tax Amount"')
                        {
                            AutoFormatType = 1;
                        }
                        column(ChargesAmount; ChargesAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmount; OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(SalesInvLineTotalTDSTCSInclSHECESS; TotalTCSAmount)
                        {
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                        }
                        column(LineNo_SalesInvLine; "Line No.")
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption; DiscountCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(LineDiscountCaption; LineDiscountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(ChargesAmountCaption; ChargesAmountCaptionLbl)
                        {
                        }
                        column(OtherTaxesAmountCaption; OtherTaxesAmountCaptionLbl)
                        {
                        }
                        column(TCSAmountCaption; TCSAmountCaptionLbl)
                        {
                        }
                        column(PaymentDiscVATCaption; PaymentDiscVATCaptionLbl)
                        {
                        }
                        column(Description_SalesInvLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvoiceLineCaption; 'GL Code')
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesInvoiceLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(DirectDebitPLARG_SalesInvLineCaption; 'Direct Debit To PLA / RG')
                        {
                        }
                        column(CGSTAmt; CGSTAmt)
                        {
                        }
                        column(SGSTAmt; SGSTAmt)
                        {
                        }
                        column(IGSTAmt; IGSTAmt)
                        {
                        }
                        column(CessAmt; CessAmt)
                        {
                        }
                        column(TCSAmt; TCSAmt)
                        {
                        }
                        dataitem("Sales Shipment Buffer"; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            column(SalesShpBufferPostingDate; Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShipmentBufferQty; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption; ShipmentCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    SalesShipmentBuffer.FindFirst()
                                else
                                    SalesShipmentBuffer.Next();
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");

                                SetRange(Number, 1, SalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));

                            column(DimText_DimensionLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                DimText := GetDimensionText(DimSetEntry2, Number, Continue);
                                if not Continue then
                                    CurrReport.Break();
                            end;

                            trigger OnPreDataItem()
                            begin
                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            column(TempPostedAsmLineNo; BlanksForIndent() + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent() + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineVariantCode; BlanksForIndent() + TempPostedAsmLine."Variant Code")
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet()
                                else
                                    TempPostedAsmLine.Next();

                                if ItemTranslation.Get(TempPostedAsmLine."No.",
                                     TempPostedAsmLine."Variant Code",
                                     "Sales Invoice Header"."Language Code")
                                then
                                    TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break();

                                CollectAsmInformation();
                                Clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            Item: Record Item;
                            recItemUOM: Record "Item Unit of Measure";
                        begin
                            No += 1;
                            NoofCasesLine := 0;
                            if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                                Item.Get("Sales Invoice Line"."No.");
                                recItemUOM.Get("Sales Invoice Line"."No.", "Sales Invoice Line"."Unit of Measure Code");
                                // if Item."EDC SPQ" <> 0 then
                                //     //NoofCasesLine := ROUND("Sales Invoice Line".Quantity / Item."EDC SPQ", 1, '>')
                                //     NoofCasesLine := ROUND((("Sales Invoice Line".Quantity * recItemUOM."Qty. per Unit of Measure") / Item."EDC SPQ"), 1, '>')

                                // else
                                //rav   NoofCasesLine := ROUND((("Sales Invoice Line".Quantity * recItemUOM."Qty. per Unit of Measure") / Item."EDC SPQ"), 1, '>')

                                //NoofCasesLine := Round("Sales Invoice Line".Quantity, 1, '>');
                            end;
                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate();

                            //  if No = 1 then begin
                            GetSalesGSTAmount("Sales Invoice Header", "Sales Invoice Line");

                            GetTCSAmt("Sales Invoice Header", "Sales Invoice Line");
                            //end;
                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CessAmt + TCSAmt;
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                        end;

                        trigger OnPreDataItem()
                        begin
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;

                            // MoreLines := Find('+');
                            // while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                            //     MoreLines := Next(-1) <> 0;

                            // if not MoreLines then
                            //     CurrReport.Break();

                            SetRange("Line No.", 0, "Line No.");
                        end;

                        trigger OnPostDataItem()
                        begin
                        end;
                    }

                    dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
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
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(VATAmtLineVATBase; 0)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; 0)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; 0)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; 0)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; 0)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounter; 0)
                        {
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; 0)
                        {
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmountCaption; LineAmountCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count);
                        end;
                    }
                    dataitem(VatCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VatCounterLCY; 0)
                        {
                        }
                        column(VATAmtLineVATIdentifier_VatCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Invoice Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, VATAmountLine.Count);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := VAtAmtSpecLbl + LocaCurrLbl
                            else
                                VALSpecLCYHeader := VAtAmtSpecLbl + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(ExchangRateLbl, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := CopyLbl;
                        OutputNo += 1;
                    end;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                    CGSTAmt := 0;
                    SGSTAmt := 0;
                    IGSTAmt := 0;
                    CessAmt := 0;
                    TCSAmt := 0;
                    OtherTaxesAmount := 0;
                    ChargesAmount := 0;
                    TotalTCSAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        SalesInvCountPrinted.Run("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopy) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;

                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CompanyStatev.Get(CompanyInfo."State Code");
                HeadOfficeAdd := 'Regd. Office : ' + CompanyInfo.Address + CompanyInfo."Address 2" + ' , ' + CompanyInfo.City + '-' + CompanyInfo."Post Code" + ' ' + CompanyStatev.Description;// + ' E-Mail: ' + CompanyInfo."E-Mail";
                RRLRNo := '';
                RRLRDate := 0D;
                VehicleNo := '';
                EWaybillNo := '';
                CalcFields("QR Code");

                IsGSTApplicable := CheckGSTDoc("Sales Invoice Line");
                //CalcFields("QR Code");
                Customer.Get("Bill-to Customer No.");
                Customer1.Get("Sell-to Customer No.");

                ShipToAddRec.Reset();
                ShipToAddRec.SetRange(Code, "Sales Invoice Header"."Ship-to Code");
                if ShipToAddRec.Find('-') then;

                ShipToContactNo := Customer1."Phone No.";
                if ShipToAddress.Get("Sell-to Customer No.", "Ship-to Code") then
                    ShipToContactNo := ShipToAddress."Phone No.";

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := CopyStr(FieldCaption("Order No."), 1, 80);

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := SalesPerLbl;
                end;

                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := CopyStr(FieldCaption("Your Reference"), 1, 80);

                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := CopyStr(FieldCaption("VAT Registration No."), 1, 80);

                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(TotalLbl, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(TotalIncTaxLbl, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(TotalExclTaxLbl, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(TotalLbl, "Currency Code");
                    TotalInclVATText := StrSubstNo(TotalIncTaxLbl, "Currency Code");
                    TotalExclVATText := StrSubstNo(TotalExclTaxLbl, "Currency Code");
                end;

                FormatAddr.SalesInvBillTo(CustAddr, "Sales Invoice Header");
                if Contact.Get("Sales Invoice Header"."Bill-to Contact No.") then;
                // if Contact.Get("Sales Invoice Header"."Ship-to Contact") then;
                IF FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, "Sales Invoice Header") Then;

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                //ShowShippingAddr := False; //"Sell-to Customer No." <> "Bill-to Customer No.";

                Loc.Get("Location Code");
                LocationName := "Sales Invoice Header"."Shipping from Location";


                if Loc."E-Mail" <> '' then begin
                    EMailID := Loc."E-Mail";
                    PhoneNo := Loc."Phone No."
                end else begin
                    EMailID := CompanyInfo."E-Mail";
                    PhoneNo := Loc."Phone No.";
                end;
                if RecState.get(loc."State Code") then
                    SellerState := RecState.Description + '(' + RecState."State Code (GST Reg. No.)" + ')';

                if RecState.get("GST Bill-to State Code") then
                    //BuyerState := 'State & Code ' + RecState.Description + '(' + RecState."State Code (GST Reg. No.)" + ')';
    BuyerState := RecState.Description;

                if "Ship-to Code" <> '' then begin
                    if RecState.get("GST Ship-to State Code") then
                        ShiptoState := 'State & Code ' + RecState.Description + '(' + RecState."State Code (GST Reg. No.)" + ')';
                    ShiptoGSTIN := "Ship-to GST Reg. No.";
                end else begin
                    ShiptoState := BuyerState;
                    ShiptoGSTIN := "Customer GST Reg. No.";
                end;

                Transport := '';
                if "Shipping Agent Code" <> '' then
                    if ShippingAgent.get("Shipping Agent Code") then
                        Transport := ShippingAgent.Name;
                Transport := cust."Vendor Code";
                RRLRNo := "Sales Invoice Header"."LR No.";
                RRLRDate := "Sales Invoice Header"."LR Date";
                VehicleNo := "Sales Invoice Header"."Vehicle No.";

                EWaybillNo := "Sales Invoice Header"."Eway Bill No.";
                //Message();

                // if "E-Way Bill No." <> '' then
                //     EWaybillNo := "E-Way Bill No." + ' Dt: ' + format("EDC E-Waybill Date")
                // else
                //     EWaybillNo := '';

                GetSalesInvoiceLine("No.");
                GetLineFeeNoteOnReportHist("No.");
                GetLineAmount("Sales Invoice Header");
                GetSalesGSTAmount("Sales Invoice Header");
                GetTCSAmt("Sales Invoice Header");
                TextTotalAmount := TotLineAmount + SGSTAmt + CGSTAmt + IGSTAmt + CessAmt + TCSAmt;
                Cheque.InitTextVariable();
                Cheque.FormatNoText(AmountToText, TextTotalAmount, "Currency Code");
                Clear(Cheque);
                TotalGSTAmount := SGSTAmt + CGSTAmt + IGSTAmt + CessAmt;
                Cheque.InitTextVariable();
                Cheque.FormatNoText(GSTAmtToText, TotalGSTAmount, "Currency Code");

                if K <> 0 then
                    for L := 1 to K do
                        CategoryNameQty := CategoryNameQty + CategoryName[L] + ' : ' + Format(CategoryQty[L]) + '; '
                else
                    CategoryNameQty := '';

                // if LogIntaction then
                //     if not CurrReport.Preview then
                //         if "Bill-to Contact No." <> '' then
                //             SegManagement.LogDocument(
                //               SegManagement.SalesInvoiceInterDocType(),
                //               "No.",
                //               0,
                //               0,
                //               Database::Contact,
                //               "Bill-to Contact No.",
                //               "Salesperson Code",
                //               "Campaign No.",
                //               "Posting Description",
                //               '')
                //         else
                //             SegManagement.LogDocument(
                //               SegManagement.SalesInvoiceInterDocType(),
                //               "No.",
                //               0,
                //               0,
                //               Database::Customer,
                //               "Bill-to Customer No.",
                //               "Salesperson Code",
                //               "Campaign No.",
                //               "Posting Description",
                //               '');
            end;

            trigger OnPreDataItem()
            begin
                DocumentCaption();
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
                    field(NoOfCopies; NoOfCopy)
                    {
                        Caption = 'No. of Copies';
                        Visible = false;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the number of copies that need to be printed.';
                    }
                    field(LogInteraction; LogIntaction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the log Interaction for archived document to be done or not.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies whether assembly components need to be printed or not.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAddFeeNote)
                    {
                        Caption = 'Show Additional Fee Note';
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the additional fee note is displayed or not';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := True;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := LogIntaction;
        end;
    }

    labels
    {
    }


    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();
        CompanyInfo1.Get();
        CompanyInfo1.CalcFields(Picture);

    end;

    trigger OnPreReport()
    begin
        if not CurrReport.USEREQUESTPAGE then
            InitLogInteraction();
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipToAddRec: Record "Ship-to Address";
        CompanyInfo1: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        Customer1: Record Customer;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        Loc: Record Location;
        HdrLocation: Record Location;
        PaymentTerms: Record "Payment Terms";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        SalesShipmentBuffer: Record "Sales Shipment Buffer";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgent: Record "Shipping Agent";
        RecState: Record State;
        HdrState: Record State;
        HdrLoc: Record Location;
        Contact: Record Contact;
        ShipToContact: Record Contact;
        VATAmountLine: Record "VAT Amount Line";
        Cheque: Report "Posted Voucher"; //Check;
        FormatAddr: Codeunit "Format Address";
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        Continue: Boolean;
        LocationName: Text[60];
        DisplayAddFeeNote: Boolean;
        DisplayAssemblyInformation: Boolean;
        IsGSTApplicable: Boolean;
        LogIntaction: Boolean;
        LogInteractionEnable: Boolean;
        GSTComponentCode: array[10] of Code[10];
        CategoryName: array[100] of Code[20];
        ServiceTaxRegistrationNo: Code[20];
        ShiptoGSTIN: Code[20];
        ShipToContactNo: Text;
        PostedShipmentDate: Date;
        RRLRDate: Date;
        ActualWeight: Decimal;
        CalculatedExchRate: Decimal;
        CategoryQty: array[100] of Decimal;
        CessAmt: Decimal;
        CGSTAmt: Decimal;
        ChargesAmount: Decimal;
        GSTBaseAmount: Decimal;
        HeadOfficeAdd: Text[300];
        CompanyStatev: Record State;
        GSTCompAmount: array[20] of Decimal;
        IGSTAmt: Decimal;
        NoOfCases: Integer;
        NoofCasesLine: Integer;
        OtherTaxesAmount: Decimal;
        RoundoffValue: Decimal;
        SGSTAmt: Decimal;
        TCSAmt: Decimal;
        TextTotalAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalGSTAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        TotalSubTotal: Decimal;
        TotalTCSAmount: Decimal;
        TotLineAmount: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        FirstValueEntryNo: Integer;
        K: Integer;
        L: Integer;
        NextEntryNo: Integer;
        No: Integer;
        NoOfCopy: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        AmountCaptionLbl: Label 'Amount';
        BankAccNoCaptionLbl: Label 'Bank Account No. : ';
        BankNameCaptionLbl: Label 'Bank Name : ';
        CessLbl: Label 'CESS';
        CGSTLbl: Label 'CGST';
        ChargesAmountCaptionLbl: Label 'Charges Amount';
        CompanyRegistrationLbl: Label 'Company Registration No.';
        CopyLbl: Label ' COPY';
        CustomerRegistrationLbl: Label 'Customer GST Reg No.';
        DiscountCaptionLbl: Label 'Discount %';
        DocumentDateCaptionLbl: Label 'Document Date';
        DueDateCaptionLbl: Label 'Due Date';
        EMailCaptionLbl: Label 'E-Mail';
        ExchangRateLbl: Label 'Exchange rate: %1/%2', comment = '%1 Currency code, %2 LCY Amt';
        GiroNoCaptionLbl: Label 'IFSC Code : ';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        HomePageCaptionCapLbl: Label 'Home Page';
        IGSTLbl: Label 'IGST';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        InvDiscountAmountCaptionLbl: Label 'Invoice Discount Amount';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        LineAmountCaptionLbl: Label 'Line Amount';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        LineDiscountCaptionLbl: Label 'Line Discount Amount';
        LocaCurrLbl: Label 'Local Currency', Locked = True;
        OtherTaxesAmountCaptionLbl: Label 'Other Taxes Amount';
        PageCaptionCapLbl: Label 'Page %1 of %2 ', Comment = '%1 of %2 Caption';
        PaymentDiscVATCaptionLbl: Label 'Payment Discount on VAT';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        PLAEntryNoCaptionLbl: Label 'PLA Entry No.';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        PostingDateCaptionLbl: Label 'Posting Date';
        RG23AEntryNoCaptionLbl: Label 'RG23A Entry No.';
        RG23CEntryNoCaptionLbl: Label 'RG23C Entry No.';
        SalesInvLbl: Label 'Sales - Invoice %1', Comment = '%1 Caption';
        SalesPerLbl: Label 'Salesperson';
        SalesPrepInvLbl: Label 'Sales - Prepayment Invoice %1', Comment = '%1 Amt';
        ServiceTaxRegistrationNoLbl: Label 'Service Tax Registration No.';
        SGSTLbl: Label 'SGST';
        ShipmentCaptionLbl: Label 'Shipment';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        SubtotalCaptionLbl: Label 'Subtotal';
        TCSAmountCaptionLbl: Label 'TCS Amount';
        TotalCaptionLbl: Label 'Total';
        TotalExclTaxLbl: Label 'Total %1 Excl. Taxes', Comment = '%1 Amt';
        TotalIncTaxLbl: Label 'Total %1 Incl. Taxes', Comment = '%1 Amt';
        TotalLbl: Label 'Total %1', Comment = '%1 Amt';
        UnitPriceCaptionLbl: Label 'Rate Per Unit';
        VATAmountCaptionLbl: Label 'VAT Amount';
        VATAmountSpecificationCaptionLbl: Label 'VAT Amount Specification';
        VAtAmtSpecLbl: Label 'VAT Amount Specification in', Locked = True;
        VATBaseCaptionLbl: Label 'VAT Base';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        VATPercentageCaptionLbl: Label 'VAT %';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        BuyerState: Text;
        CategoryNameQty: Text;
        DocCaption: Text;
        SellerState: Text;
        ShiptoState: Text;
        CopyText: Text[30];
        RRLRNo: Text[30];
        SalesPersonText: Text[30];
        SupplementaryText: Text[30];
        VehicleNo: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        EWaybillNo: Text[50];
        ShipToAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        VALExchRate: Text[50];
        AmountToText: array[2] of Text[80];
        GSTAmtToText: array[2] of Text[80];
        OrderNoText: Text[80];
        ReferenceText: Text[80];
        VALSpecLCYHeader: Text[80];
        VATNoText: Text[80];
        Transport: Text[100];
        DimText: Text[120];
        EMailID: Text[200];
        PhoneNo: Text;

    procedure InitLogInteraction()
    begin
        //LogIntaction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentBuffer2: Record "Sales Shipment Buffer";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
            if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then
                exit(SalesShipmentHeader."Posting Date");

        if "Sales Invoice Header"."Order No." = '' then
            exit("Sales Invoice Header"."Posting Date");

        case "Sales Invoice Line".Type of
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account",
            "Sales Invoice Line".Type::Resource,
            "Sales Invoice Line".Type::"Charge (Item)",
            "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
            "Sales Invoice Line".Type::" ":
                exit(0D);
        end;

        SalesShipmentBuffer.Reset();
        SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.FindFirst() then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next() = 0 then begin
                SalesShipmentBuffer.Get(
                  SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete();
                exit(SalesShipmentBuffer2."Posting Date");
            end;

            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll();
                exit("Sales Invoice Header"."Posting Date");
            end;
        end else
            exit("Sales Invoice Header"."Posting Date");
    end;

    procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.FindSet() then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";

                    AddBufferEntry(SalesInvoiceLine2, -Quantity, ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;

                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next() = 0;
            until SalesInvoiceHeader.Next() = 0;

        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
        if SalesShipmentLine.FindFirst() then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;

                    Quantity := SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
                        AddBufferEntry(SalesInvoiceLine, Quantity, SalesShipmentHeader."Posting Date");
                end;
            until (SalesShipmentLine.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentKey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next() = 0;
    end;

    procedure AddBufferEntry(
        SalesInvoiceLine: Record "Sales Invoice Line";
        QtyOnShipment: Decimal;
        PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.FindFirst() then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify();
            exit;
        end;

        SalesShipmentBuffer.Init();
        SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
        SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
        SalesShipmentBuffer."Entry No." := NextEntryNo;
        SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
        SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
        SalesShipmentBuffer.Quantity := QtyOnShipment;
        SalesShipmentBuffer."Posting Date" := PostingDate;
        SalesShipmentBuffer.Insert();
        NextEntryNo := NextEntryNo + 1
    end;

    procedure InitializeRequest(
        NewNoOfCopies: Integer;
        NewShowInternalInfo: Boolean;
        NewLogInteraction: Boolean;
        DisplayAsmInfo: Boolean)
    begin
        NoOfCopy := NewNoOfCopies;
        LogIntaction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    procedure CollectAsmInformation()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        ValueEntry: Record "Value Entry";
    begin
        TempPostedAsmLine.DeleteAll();
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
            exit;

        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        ValueEntry.SetRange(Adjustment, false);
        if not ValueEntry.FindSet() then
            exit;

        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet() then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst() then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify();
        end else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert();
        end;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);

        exit(CopyStr(UnitOfMeasure.Description, 1, 10));
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Invoice Header"."Prepayment Invoice" then
            DocCaption := StrSubstNo(SalesPrepInvLbl, CopyText)
        else
            DocCaption := StrSubstNo(SalesInvLbl, CopyText);
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustRec: Record Customer;
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst() then
            exit;

        if not CustRec.Get(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", CustRec."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then
            repeat
                TempLineFeeNoteOnReportHist.Init();
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert();
            until LineFeeNoteOnReportHist.Next() = 0
        else
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    TempLineFeeNoteOnReportHist.Init();
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert();
                until LineFeeNoteOnReportHist.Next() = 0;
    end;

    local procedure CheckGSTDoc(SalesLine: Record "Sales Invoice Line"): Boolean
    var
        TaxTransactionValue: Record "Tax Transaction Value";
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", SalesLine.RecordId);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        if not TaxTransactionValue.IsEmpty then
            exit(true);
    end;

    local procedure GetDimensionText(var DimSetEntry: Record "Dimension Set Entry"; Number: Integer; var IsContinue: Boolean): Text[120]
    var
        DimensionLbl: Label '%1 - %2', Comment = '%1 = Dimension Code, %2 = Dimension Value Code';
        DimensionTextLbl: Label '%1; %2 - %3', Comment = ' %1 = DimText, %2 = Dimension Code, %3 = Dimension Value Code';
        PrevDimText: Text[75];
        DimensionText: Text[120];
    begin
        IsContinue := false;
        if Number = 1 then
            if not DimSetEntry.FindSet() then
                exit;

        repeat
            PrevDimText := CopyStr((DimensionText), 1, 75);
            if DimensionText = '' then
                DimensionText := StrSubstNo(DimensionLbl, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
            else
                DimensionText := CopyStr(
                    StrSubstNo(
                        DimensionTextLbl,
                        DimensionText,
                        DimSetEntry."Dimension Code",
                        DimSetEntry."Dimension Value Code"),
                    1,
                    120);

            if StrLen(DimensionText) > MaxStrLen(PrevDimText) then begin
                IsContinue := true;
                exit(PrevDimText);
            end;
        until DimSetEntry.Next() = 0;

        exit(DimensionText)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        GSTSetup: Record "GST Setup";
        TaxComponent: Record "Tax Component";
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

    local procedure GetSalesGSTAmount(SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line")
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(CessAmt);
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then
                        CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then
                        SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

                if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    IGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) then
                        IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) then
                        CessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    local procedure GetSalesGSTAmount(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        Clear(IGSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(CessAmt);
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then
                        CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                //   Message(format(CGSTAmt));
                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then
                        SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

                if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    IGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) then
                        IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And (SalesInvoiceHeader."Currency Code" <> '') then
                    CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * SalesInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                else
                    if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) then
                        CessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    local procedure GetTCSAmt(SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line")
    var
        TCSEntry: Record "TCS Entry";
    begin
        Clear(TCSAmt);
        TCSEntry.Reset();
        TCSEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
        if TCSEntry.FindSet() then
            repeat
                if SalesInvoiceHeader."Currency Code" <> '' then
                    TCSAmt += SalesInvoiceHeader."Currency Factor" * TCSEntry."Total TCS Including SHE CESS"
                else
                    TCSAmt += TCSEntry."Total TCS Including SHE CESS";
                TCSAmt := Round(TCSAmt, 1);
            until TCSEntry.Next() = 0;
    end;

    local procedure GetTCSAmt(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        TCSEntry: Record "TCS Entry";
    begin
        Clear(TCSAmt);
        TCSEntry.Reset();
        TCSEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        if TCSEntry.FindSet() then
            repeat
                if SalesInvoiceHeader."Currency Code" <> '' then
                    TCSAmt += SalesInvoiceHeader."Currency Factor" * TCSEntry."Total TCS Including SHE CESS"
                else
                    TCSAmt += TCSEntry."Total TCS Including SHE CESS";
                TCSAmt := Round(TCSAmt, 1);
            until TCSEntry.Next() = 0;
    end;

    local procedure GetLineAmount(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        RecItem: Record item;
        ItemCat: Record "Item Category";
        ItemUOM: Record "Item Unit of Measure";
        SalesInvLine: Record "Sales Invoice Line";
        Found: Boolean;
        PackUOM: Code[10];
        J: Integer;
    begin
        Clear(TotLineAmount);
        Clear(ActualWeight);
        Clear(NoOfCases);
        Clear(RoundoffValue);

        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvLine.SetRange("System-Created Entry", true);
        if SalesInvLine.FindSet() then
            repeat
                RoundoffValue += SalesInvLine.Amount;
            until SalesInvLine.Next() = 0;

        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                if SalesInvoiceHeader."Currency Code" <> '' then
                    TotLineAmount += SalesInvoiceHeader."Currency Factor" * SalesInvLine."Line Amount"
                else
                    TotLineAmount += SalesInvLine."Line Amount";

                if SalesInvLine.Type = SalesInvLine.Type::Item then begin
                    RecItem.get(SalesInvLine."No.");

                    // if RecItem."Packing Unit of Measure" <> '' then
                    //     PackUOM := RecItem."Packing Unit of Measure"
                    // else
                    PackUOM := SalesInvLine."Unit of Measure Code";
                    if ItemUOM.get(SalesInvLine."No.", PackUOM) then begin
                        // IF RecItem."EDC SPQ" <> 0 then
                        //     NoOfCases := NoOfCases + ROUND(((SalesInvLine.Quantity * ItemUOM."Qty. per Unit of Measure") / RecItem."EDC SPQ"), 1, '>')
                        // else
                        //     NoOfCases := NoOfCases + ROUND(((SalesInvLine.Quantity * ItemUOM."Qty. per Unit of Measure") / RecItem."EDC SPQ"), 1, '>');

                        //NoOfCases := NoOfCases + ROUND(SalesInvLine.Quantity, 1, '>');

                        if PackUOM <> SalesInvLine."Unit of Measure Code" then
                            ActualWeight := ActualWeight + ((SalesInvLine.Quantity / ItemUOM."Qty. per Unit of Measure") * ItemUOM.Weight)

                        else
                            ActualWeight := ActualWeight + (SalesInvLine.Quantity * ItemUOM.Weight);

                        Found := false;
                        if SalesInvLine."Item Category Code" <> '' then begin
                            ItemCat.get(SalesInvLine."Item Category Code");
                            if K = 0 then begin
                                K += 1;
                                CategoryName[K] := ItemCat."Parent Category";
                                if ItemUOM.Code <> SalesInvLine."Unit of Measure Code" then
                                    CategoryQty[K] := (SalesInvLine.Quantity / ItemUOM."Qty. per Unit of Measure")
                                else
                                    CategoryQty[K] := SalesInvLine.Quantity;
                            end else begin
                                for J := 1 to K Do
                                    if ItemCat."Parent Category" = CategoryName[J] then begin
                                        Found := true;
                                        if ItemUOM.Code <> SalesInvLine."Unit of Measure Code" then
                                            CategoryQty[J] := CategoryQty[J] + (SalesInvLine.Quantity / ItemUOM."Qty. per Unit of Measure")
                                        else
                                            CategoryQty[J] := CategoryQty[J] + SalesInvLine.Quantity;
                                    end;
                                if not Found then begin
                                    K += 1;
                                    CategoryName[K] := ItemCat."Parent Category";
                                    if ItemUOM.Code <> SalesInvLine."Unit of Measure Code" then
                                        CategoryQty[K] := (SalesInvLine.Quantity / ItemUOM."Qty. per Unit of Measure")
                                    else
                                        CategoryQty[K] := SalesInvLine.Quantity;
                                end;
                            end;
                        end;
                    end;
                end;
            until SalesInvLine.Next() = 0;
        TotLineAmount := Round(TotLineAmount, 0.01);
    end;

    local procedure GetSalesInvoiceLine(DocumentNo: Code[20])
    var
        ILE: Record "Item Ledger Entry";
        LotInfo: Record "Lot No. Information";
        SInvLine: Record "Sales Invoice Line";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        MfgDate: Date;
        ExpiryDate: Date;
        NextLine: Integer;
        MRPLotInfo: Decimal;
    begin
        "Sales Invoice Line".DeleteAll();

        SInvLine.Reset();
        SInvLine.SetRange("Document No.", DocumentNo);
        if SInvLine.FindSet() then
            repeat
                "Sales Invoice Line".Init();
                "Sales Invoice Line" := SInvLine;
                "Sales Invoice Line".Insert();

                TempSalesShptLine.DeleteAll();
                if SInvLine.Type = SInvLine.Type::Item then begin
                    SInvLine.GetSalesShptLines(TempSalesShptLine);
                    NextLine := 0;

                    if TempSalesShptLine.FindSet() then
                        repeat
                            ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
                            ILE.SetRange("Document No.", TempSalesShptLine."Document No.");
                            ILE.SetRange("Document Line No.", TempSalesShptLine."Line No.");
                            ILE.SetFilter("Lot No.", '<>%1', '');
                            if ILE.FindSet() then
                                repeat
                                    MfgDate := 0D;
                                    if LotInfo.get(ILE."Item No.", ILE."Variant Code", ILE."Lot No.") then begin
                                        // MfgDate := LotInfo."EDC Manufacturing Date";
                                        // ExpiryDate := LotInfo."EDC Expiry Date";
                                        // MRPLotInfo := LotInfo."EDC MRP";
                                    end;
                                    NextLine += 1;
                                    if NextLine = 1 then begin
                                        "Sales Invoice Line"."Description 2" := Ile."Lot No.";
                                        "Sales Invoice Line"."Tax Group Code" := format(ExpiryDate, 0, '<Closing><Day,2>-<Month,2>-<Year4>');
                                        "Sales Invoice Line"."VAT Clause Code" := format(MfgDate, 0, '<Closing><Day,2>-<Month,2>-<Year4>');
                                        // "Sales Invoice Line"."EDC MRP" := MRPLotInfo;
                                        "Sales Invoice Line".Modify();
                                    end else begin
                                        "Sales Invoice Line".Init();
                                        "Sales Invoice Line"."Document No." := SInvLine."Document No.";
                                        "Sales Invoice Line"."Line No." := SInvLine."Line No." + NextLine - 1;
                                        "Sales Invoice Line".Type := "Sales Invoice Line".Type::" ";
                                        "Sales Invoice Line"."Description 2" := Ile."Lot No.";
                                        "Sales Invoice Line"."Tax Group Code" := format(ExpiryDate, 0, '<Closing><Day,2>-<Month,2>-<Year4>');
                                        "Sales Invoice Line"."VAT Clause Code" := format(MfgDate, 0, '<Closing><Day,2>-<Month,2>-<Year4>');
                                        // "Sales Invoice Line"."EDC MRP" := MRPLotInfo;
                                        "Sales Invoice Line"."Attached to Line No." := SInvLine."Line No.";
                                        "Sales Invoice Line".Insert();
                                    end;
                                until ile.Next() = 0;
                        until TempSalesShptLine.Next() = 0;
                end;
            until SInvLine.Next() = 0;
    end;

}