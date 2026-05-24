codeunit 50150 "KRIZ e-Invoice Integration"
{

    Access = Internal;
    Permissions = tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Transfer Shipment Header" = rm,
                  tabledata "Purch. Cr. Memo Hdr." = rm;
    //

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";

        //NG begin
        TransferShipmentHeader: Record "Transfer Shipment Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        EInvoiceSetup: Record "KRIZ e-Invoice Setup";

        InvObject: JsonObject;
        InvArrayData: JsonArray;

        IsTransfer: Boolean;
        IsPurchase: Boolean;
        UserGSTIN: Code[20];
        GlobalStcd: Text[3];

        BuyerGSTIN: Text[20];
        BuyerAdd1: Text[100];
        BuyerAdd2: Text[100];
        BuyerLoc: Text[100];
        BuyerPin: Text[6];
        BuyerStcd: Text[2];
        BuyerLglNm: Text[100];
        //NG End
        JObject: JsonObject;
        JsonArrayData: JsonArray;


        JsonText: Text;
        generatetoken: text;
        DocumentNo: Text[20];
        //RndOffAmt: Decimal;
        IsInvoice: Boolean;

        eInvoiceNotApplicableCustErr: Label 'E-Invoicing is not applicable for Unregistered Customer.';
        DocumentNoBlankErr: Label 'E-Invoicing is not supported if document number is blank in the current document.';
        SalesLinesMaxCountLimitErr: Label 'E-Invoice allowes only 100 lines per Invoice. Current transaction is having %1 lines.', Comment = '%1 = Sales Lines count';
        CGSTLbl: Label 'CGST', Locked = true;
        SGSTLbl: label 'SGST', Locked = true;
        IGSTLbl: Label 'IGST', Locked = true;
        CESSLbl: Label 'CESS', Locked = true;

    trigger OnRun()
    begin
        //EInvoiceSetup.get();
        EInvoiceSetup.Reset();
        EInvoiceSetup.SetRange("Is Production", true);
        if not EInvoiceSetup.FindFirst() then begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", false);
            EInvoiceSetup.FindFirst();
        end else begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", true);
            EInvoiceSetup.FindFirst();
        end;
        Initialize();

        if IsTransfer then
            RunTransferShipment()
        else
            if IsPurchase then
                RunPurchCreditMemo()
            else
                if IsInvoice then
                    RunSalesInvoice()
                else
                    RunSalesCrMemo();


        if (IsPurchase = false) then
            if (DocumentNo <> '') then
                if EInvoiceSetup."Integration Enabled" then
                    SendJsonClearTaxPortal(DocumentNo, UserGSTIN)
                else
                    ExportAsJson(DocumentNo)
            else
                Error(DocumentNoBlankErr);

        if (IsPurchase = true) then
            if (DocumentNo <> '') then
                if EInvoiceSetup."Integration Enabled" then
                    SendEWBJsonToCleartaxPortal(DocumentNo, UserGSTIN)
                else
                    ExportAsJson(DocumentNo)
            else
                Error(DocumentNoBlankErr);


    end;

    local procedure Initialize()
    var
        FromLoc: Record Location;
    begin
        Clear(JObject);
        Clear(InvObject);
        Clear(InvArrayData);
        Clear(JsonArrayData);
        Clear(JsonText);
        //EInvoiceSetup.Get();
        EInvoiceSetup.Reset();
        EInvoiceSetup.SetRange("Is Production", true);
        if not EInvoiceSetup.FindFirst() then begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", false);
            EInvoiceSetup.FindFirst();
        end else begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", true);
            EInvoiceSetup.FindFirst();
        end;
        if IsPurchase then begin
            DocumentNo := PurchCrMemoHeader."No.";
            if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                UserGSTIN := EInvoiceSetup."Demo GSTIN"
            else
                UserGSTIN := PurchCrMemoHeader."Location GST Reg. No.";
        end else if IsTransfer then begin
            DocumentNo := TransferShipmentHeader."No.";
            FromLoc.get(TransferShipmentHeader."Transfer-from Code");
            if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                UserGSTIN := EInvoiceSetup."Demo GSTIN"
            else
                UserGSTIN := FromLoc."GST Registration No.";
        end else
            if IsInvoice then begin
                DocumentNo := SalesInvoiceHeader."No.";
                if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                    UserGSTIN := EInvoiceSetup."Demo GSTIN"
                else
                    UserGSTIN := SalesInvoiceHeader."Location GST Reg. No.";
            end else begin
                DocumentNo := SalesCrMemoHeader."No.";
                if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                    UserGSTIN := EInvoiceSetup."Demo GSTIN"
                else
                    UserGSTIN := SalesCrMemoHeader."Location GST Reg. No.";

            end;
    end;

    procedure SetSalesInvHeader(SalesInvoiceHeaderBuff: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader := SalesInvoiceHeaderBuff;
        IsInvoice := true;
        IsTransfer := false;
        IsPurchase := false;
    end;

    procedure SetCrMemoHeader(SalesCrMemoHeaderBuff: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader := SalesCrMemoHeaderBuff;
        IsInvoice := false;
        IsTransfer := false;
        IsPurchase := false;
    end;

    procedure SetPurchCrMemoHeader(PurchCrMemoeHeaderBuff: Record "Purch. Cr. Memo Hdr.")
    begin
        PurchCrMemoHeader := PurchCrMemoeHeaderBuff;
        IsPurchase := true;
        IsTransfer := false;
        IsInvoice := false;
    end;

    procedure SetTransferShipment(TransferShipBuff: Record "Transfer Shipment Header")
    begin
        TransferShipmentHeader := TransferShipBuff;
        IsTransfer := true;
        IsInvoice := false;
        IsPurchase := false;
    end;

    procedure GenerateCanceledInvoice()
    var
        FromLoc: Record Location;
    begin
        Initialize();
        if IsTransfer then begin
            DocumentNo := TransferShipmentHeader."No.";
            FromLoc.get(TransferShipmentHeader."Transfer-from Code");
            if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                UserGSTIN := EInvoiceSetup."Demo GSTIN"
            else
                UserGSTIN := FromLoc."GST Registration No.";
            WriteCancellationJSON(
              TransferShipmentHeader."IRN Hash", TransferShipmentHeader."Cancel Reason", Format(TransferShipmentHeader."Cancel Reason"));
        end else
            if IsInvoice then begin
                DocumentNo := SalesInvoiceHeader."No.";
                //NG Begin
                if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                    UserGSTIN := EInvoiceSetup."Demo GSTIN"
                else
                    UserGSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                //NG end
                WriteCancellationJSON(
                  SalesInvoiceHeader."IRN Hash", SalesInvoiceHeader."Cancel Reason", Format(SalesInvoiceHeader."Cancel Reason"))
            end else begin
                DocumentNo := SalesCrMemoHeader."No.";
                if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                    UserGSTIN := EInvoiceSetup."Demo GSTIN"
                else
                    UserGSTIN := SalesCrMemoHeader."Location GST Reg. No.";
                WriteCancellationJSON(
                       SalesCrMemoHeader."IRN Hash", SalesCrMemoHeader."Cancel Reason", Format(SalesCrMemoHeader."Cancel Reason"));
            end;
        if DocumentNo <> '' then
            if (EInvoiceSetup."Integration Enabled") then
                SendCancelIRNToClearTax(DocumentNo, UserGSTIN)
            else
                ExportAsJson(DocumentNo);
    end;

    local procedure WriteCancellationJSON(IRNHash: Text[64]; CancelReason: Enum "e-Invoice Cancel Reason"; CancelRemark: Text[100])
    var
        CancelJsonObject: JsonObject;
    begin
        //WriteCancelJsonFileHeader();
        JObject.Add('user_gstin', UserGSTIN);
        //CancelJsonObject.Add('Canceldtls', '');
        JObject.Add('irn', IRNHash);
        //JObject.Add('cancel_reason', Format(CancelReason));
        JObject.Add('cancel_reason', '1');
        JObject.Add('cancel_remarks', 'Wrong entry');
        // JObject.Add('cancel_remarks', CancelRemark);
        JObject.Add('ewaybill_cancel', '');

        //JsonArrayData.Add(CancelJsonObject);
        //JObject.Add('ExpDtls', JsonArrayData);
    end;

    local procedure WriteCancelJsonFileHeader()
    begin
        JObject.Add('Version', '1.1');
        JsonArrayData.Add(JObject);
    end;

    local procedure ExportAsJson(FileName: Text[20])
    var
        TempBlob: Codeunit "Temp Blob";
        ToFile: Variant;
        InStream: InStream;
        OutStream: OutStream;
    begin
        //JObject.WriteTo(JsonText);
        JsonArrayData.Add(JObject);
        JsonArrayData.WriteTo(JsonText);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(JsonText);
        ToFile := FileName + '.json';
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'e-Invoice', '', '', ToFile);
    end;

    local procedure SendCancelIRNToClearTax(DocuentNo: Code[20]; GSTIN: Code[20])
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        HttpWebClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        LocJObject: JsonObject;
        JToken: JsonToken;
        JsonResponse: Text;
        RespMsg: Text;
        Authoriztion: Text;
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        //ResponseErrorText: Text;
        CancelledDateText: text;
        FieldRef: FieldRef;
        RecRef: RecordRef;
        StatusMessage: Label 'E-Invoice: IRN Successfully Cancelled.';
        Authorization: Text;
    begin
        JObject.WriteTo(JsonText);

        EInvoiceSetup.TestField("Cancel IRN API");
        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonText);

        HttpWebContent.WriteFrom(JsonText);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        Authoriztion := GetAuthorizationText;
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('gstin', UserGSTIN);
        HttpWebClient.DefaultRequestHeaders().Add('Authorization', Authoriztion);
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(EInvoiceSetup."Cancel IRN API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then
            error(ConnectionMsg,
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        HttpWebContent := ResponseMessage.Content;

        HttpWebContent.ReadAs(JsonResponse);

        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonResponse);

        LocJObject.ReadFrom(JsonResponse);

        IF LocJObject.SelectToken('results.status', JToken) then begin
            RespMsg := JToken.AsValue().AsText();
            if UpperCase(RespMsg) = 'SUCCESS' then
                if LocJObject.SelectToken('results.message.CancelDate', JToken) then
                    CancelledDateText := JToken.AsValue().AsText();
        end;

        IF UPPERCASE(RespMsg) = 'SUCCESS' THEN BEGIN
            if IsTransfer then begin
                Clear(RecRef);
                RecRef.GetTable(TransferShipmentHeader);
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Invoice Status"));
                FieldRef.Value := TransferShipmentHeader."E-Invoice Status"::Cancelled;
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Inv. Cancelled Date"));
                FieldRef.Value := GetDateTimeFromText(CancelledDateText);
                RecRef.Modify();
            end else
                IF IsInvoice THEN begin
                    Clear(RecRef);
                    RecRef.GetTable(SalesInvoiceHeader);
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Invoice Status"));
                    FieldRef.Value := SalesInvoiceHeader."E-Invoice Status"::Cancelled;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Inv. Cancelled Date"));
                    FieldRef.Value := GetDateTimeFromText(CancelledDateText);
                    RecRef.Modify();
                end else begin
                    Clear(RecRef);
                    RecRef.GetTable(SalesCrMemoHeader);
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("E-Invoice Status"));
                    FieldRef.Value := SalesCrMemoHeader."E-Invoice Status"::Cancelled;
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("E-Inv. Cancelled Date"));
                    FieldRef.Value := GetDateTimeFromText(CancelledDateText);
                    RecRef.Modify();
                end;
            Message(StatusMessage);
        END else
            Message(RespMsg);
    end;

    //Ng Begin
    local procedure GetDateTimeFromText(DateTimeValue: Text): DateTime
    var
        YYYYText: Text[10];
        MMText: Text[10];
        DDText: text[10];
        TimeText: text[10];
        YYYY: Integer;
        MM: Integer;
        DD: Integer;
        TimeValue: time;
    begin
        IF DateTimeValue = '' THEN
            EXIT(0DT);

        YYYYText := COPYSTR(DateTimeValue, 1, 4);
        MMText := COPYSTR(DateTimeValue, 6, 2);
        DDText := COPYSTR(DateTimeValue, 9, 2);
        IF STRLEN(DateTimeValue) > 10 THEN
            TimeText := COPYSTR(DateTimeValue, 12, 8);

        IF NOT EVALUATE(YYYY, YYYYText) THEN
            EXIT(0DT);

        IF NOT EVALUATE(MM, MMText) THEN
            EXIT(0DT);

        IF NOT EVALUATE(DD, DDText) THEN
            EXIT(0DT);

        IF NOT EVALUATE(TimeValue, TimeText) THEN
            TimeValue := 0T;

        EXIT(CREATEDATETIME(DMY2DATE(DD, MM, YYYY), TimeValue));

    end;

    local procedure GetAuthorizationText(): Text
    var
        //Base64Converter: Codeunit "Base64 Convert";
        //BasicCred: Text;
        Authorization: Text;
    begin
        EInvoiceSetup.Reset();
        EInvoiceSetup.SetRange("Is Production", true);
        if not EInvoiceSetup.FindFirst() then begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", false);
            EInvoiceSetup.FindFirst();
        end else begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", true);
            EInvoiceSetup.FindFirst();
        end;
        //EInvoiceSetup.get();
        EInvoiceSetup.TestField("User ID");
        EInvoiceSetup.TestField(Password);

        Authorization := 'JWT ' + GeneratetokenfromMI(EInvoiceSetup."User ID", EInvoiceSetup.Password);

        exit(Authorization);
    end;
    //Ng End
    local procedure WriteJsonFileHeader()
    begin
        // InvObject.Add('Version', '1.1');
        // JsonArrayData.Add(InvObject);
    end;

    local procedure ReadInvoiceTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        NatureOfSupplyCategory: Text[7];
        SupplyType: Text[3];
        IgstOnIntra: Text[3];
    begin
        if not IsInvoice then
            exit;

        case GSTCustType of
            SalesInvoiceHeader."GST Customer Type"::Registered, SalesInvoiceHeader."GST Customer Type"::Exempted:
                NatureOfSupplyCategory := 'B2B';

            SalesInvoiceHeader."GST Customer Type"::Export:
                if SalesInvoiceHeader."GST Without Payment of Duty" then
                    NatureOfSupplyCategory := 'EXPWOP'
                else
                    NatureOfSupplyCategory := 'EXPWP';

            SalesInvoiceHeader."GST Customer Type"::"Deemed Export":
                NatureOfSupplyCategory := 'DEXP';

            SalesInvoiceHeader."GST Customer Type"::"SEZ Development", SalesInvoiceHeader."GST Customer Type"::"SEZ Unit":
                IF SalesInvoiceHeader."GST Without Payment of Duty" THEN
                    NatureOfSupplyCategory := 'SEZWOP'
                ELSE
                    NatureOfSupplyCategory := 'SEZWP';
        end;

        if ShipToCode <> '' then begin
            SalesInvoiceLine.SetRange("Document No.", DocumentNo);
            if SalesInvoiceLine.FindSet() then
                repeat
                    if SalesInvoiceLine."GST Place of Supply" <> SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" then
                        SupplyType := 'SHP'
                    else
                        SupplyType := 'REG';
                until SalesInvoiceLine.Next() = 0;
        end else
            SupplyType := 'REG';

        if SalesInvoiceHeader."POS Out Of India" then
            IgstOnIntra := 'Y'
        else
            IgstOnIntra := 'N';

        WriteTransactionDetails(NatureOfSupplyCategory, 'N', SupplyType, 'false', 'Y', '', IgstOnIntra);
    end;

    local procedure WriteTransactionDetails(
        SupplyCategory: Text[10];
        RegRev: Text[2];
        SupplyType: Text[3];
        EcmTrnSel: Text[5];
        EcmTrn: Text[1];
        EcmGstin: Text[15];
        IgstOnIntra: Text[3])
    var
        JTranDetails: JsonObject;
    begin
        JTranDetails.Add('supply_type', SupplyCategory);
        JTranDetails.Add('charge_type', RegRev);
        JTranDetails.Add('igst_on_intra', IgstOnIntra);
        JTranDetails.Add('ecommerce_gstin', EcmGstin);
        InvObject.Add('transaction_details', JTranDetails);
    end;

    local procedure ReadDocumentHeaderDetails()
    var
        InvoiceType: Text[3];
        PostingDate: Text[10];
        OriginalInvoiceNo: Text[16];
    //ReturnPeriod: Text[20];
    begin
        Clear(JsonArrayData);
        if IsTransfer then begin
            InvoiceType := 'INV';
            PostingDate := FORMAT(TransferShipmentHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
            //ReturnPeriod := '12' + FORMAT(TransferShipmentHeader."Posting Date", 0, '<Year4>');
        end else
            if IsPurchase then begin
                InvoiceType := 'INV';
                PostingDate := FORMAT(PurchCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
            end else
                if IsInvoice then begin
                    if (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::"Debit Note") or
                       (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::Supplementary)
                    then
                        InvoiceType := 'DBN'
                    else
                        InvoiceType := 'INV';
                    PostingDate := Format(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    //ReturnPeriod := '12' + FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Year4>');
                end else begin
                    InvoiceType := 'CRN';
                    PostingDate := Format(SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    //ReturnPeriod := '12' + FORMAT(SalesCrMemoHeader."Posting Date", 0, '<Year4>');
                end;

        OriginalInvoiceNo := CopyStr(GetReferenceInvoiceNo(DocumentNo), 1, 16);
        WriteDocumentHeaderDetails(InvoiceType, CopyStr(DocumentNo, 1, 16), PostingDate, OriginalInvoiceNo);
    end;

    local procedure GetReferenceInvoiceNo(DocNo: Code[20]) RefInvNo: Code[20]
    var
        ReferenceInvoiceNo: Record "Reference Invoice No.";
    begin
        ReferenceInvoiceNo.SetRange("Document No.", DocNo);
        if ReferenceInvoiceNo.FindFirst() then
            RefInvNo := ReferenceInvoiceNo."Reference Invoice Nos."
        else
            RefInvNo := '';
    end;

    local procedure WriteDocumentHeaderDetails(InvoiceType: Text[3]; DocNo: Text[16]; PostingDate: Text[10]; OriginalInvoiceNo: Text[16])
    var
        JDocumentHeaderDetails: JsonObject;
    begin
        JDocumentHeaderDetails.Add('document_type', InvoiceType);
        JDocumentHeaderDetails.Add('document_number', DocNo);
        JDocumentHeaderDetails.Add('document_date', PostingDate);
        InvObject.Add('document_details', JDocumentHeaderDetails);
    end;

    local procedure ReadDocumentSellerDetails()
    var
        CompanyInformationBuff: Record "Company Information";
        LocationBuff: Record "Location";
        StateBuff: Record "State";
        GSTRegistrationNo: Text[20];
        CompanyName: Text[100];
        LglNm: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Flno: Text[60];
        Loc: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
    begin
        Clear(JsonArrayData);
        if IsTransfer then begin
            LocationBuff.Get(TransferShipmentHeader."Transfer-from Code");
            GSTRegistrationNo := LocationBuff."GST Registration No.";
        end else
            if IsPurchase then begin
                LocationBuff.Get(PurchCrMemoHeader."Location Code");
                GSTRegistrationNo := LocationBuff."GST Registration No.";
            end else
                if IsInvoice then begin
                    GSTRegistrationNo := SalesInvoiceHeader."Location GST Reg. No.";
                    LocationBuff.Get(SalesInvoiceHeader."Location Code");

                end else begin
                    GSTRegistrationNo := SalesCrMemoHeader."Location GST Reg. No.";
                    LocationBuff.Get(SalesCrMemoHeader."Location Code");
                end;

        if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
            UserGSTIN := EInvoiceSetup."Demo GSTIN"
        else
            UserGSTIN := GSTRegistrationNo;
        CompanyInformationBuff.Get();
        CompanyName := CompanyInformationBuff.Name;
        //LglNm := LocationBuff.Name;
        LglNm := CompanyInformationBuff.Name;
        Address := LocationBuff.Address;
        Address2 := LocationBuff."Address 2";
        Flno := '';
        Loc := LocationBuff.City;
        City := LocationBuff.City;
        PostCode := CopyStr(LocationBuff."Post Code", 1, 6);
        StateBuff.Get(LocationBuff."State Code");
        StateCode := StateBuff."State Code (GST Reg. No.)";
        PhoneNumber := CopyStr(LocationBuff."Phone No.", 1, 10);
        Email := CopyStr(LocationBuff."E-Mail", 1, 50);

        if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then begin
            GlobalStcd := StateCode;
            GSTRegistrationNo := EInvoiceSetup."Demo GSTIN";
            if EInvoiceSetup."Demo City" <> '' then begin
                City := EInvoiceSetup."Demo City";
                Loc := EInvoiceSetup."Demo City";
            end;
            if EInvoiceSetup."Demo Post Code" <> '' then
                PostCode := EInvoiceSetup."Demo Post Code";
        end;
        if IsPurchase then
            WriteSellerDetailsPurchase(GSTRegistrationNo, CompanyName, Address, Address2, Flno, Loc, City, PostCode, StateCode, PhoneNumber, Email, LglNm)
        else
            WriteSellerDetails(GSTRegistrationNo, CompanyName, Address, Address2, Flno, Loc, City, PostCode, StateCode, PhoneNumber, Email, LglNm);
    end;

    local procedure WriteSellerDetails(
        GSTRegistrationNo: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Flno: Text[60];
        Loc: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        LglNm: text[100])
    var
        JSellerDetails: JsonObject;
    begin
        JSellerDetails.Add('gstin', GSTRegistrationNo);
        JSellerDetails.Add('legal_name', LglNm);
        JSellerDetails.Add('trade_name', CompanyName);
        JSellerDetails.Add('address1', Address);
        JSellerDetails.Add('address2', Address2);
        JSellerDetails.Add('location', Loc);
        JSellerDetails.Add('pincode', PostCode);
        JSellerDetails.Add('state_code', StateCode);
        JSellerDetails.Add('phone_number', PhoneNumber);
        JSellerDetails.Add('email', Email);
        InvObject.Add('seller_details', JSellerDetails);
    end;

    local procedure WriteSellerDetailsPurchase(
        GSTRegistrationNo: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Flno: Text[60];
        Loc: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        LglNm: text[100])
    var
        JSellerDetails: JsonObject;
    begin
        InvObject.Add('gstin_of_consignor', GSTRegistrationNo);
        InvObject.Add('legal_name_of_consignor', LglNm);
        //JSellerDetails.Add('trade_name', CompanyName);
        InvObject.Add('address1_of_consignor', Address);
        InvObject.Add('address2_of_consignor', Address2);
        InvObject.Add('place_of_consignor', Loc);
        InvObject.Add('pincode_of_consignor', PostCode);
        InvObject.Add('state_of_consignor', StateCode);
        InvObject.Add('actual_from_state_name', StateCode);
        //JSellerDetails.Add('phone_number', PhoneNumber);
        //JSellerDetails.Add('email', Email);
        //InvObject.Add('seller_details', JSellerDetails);
    end;

    local procedure ReadDocumentBuyerDetails()
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceBuyerDetails()
        else
            ReadCrMemoBuyerDetails();
    end;

    local procedure ReadInvoiceBuyerDetails()
    var
        Contact: Record Contact;
        SalesInvoiceLine: Record "Sales Invoice Line";
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        GstPOS: Text[10];
        Cust: Record Customer;
    begin
        BuyerGSTIN := '';
        BuyerAdd1 := '';
        BuyerAdd2 := '';
        BuyerLoc := '';
        BuyerPin := '';
        BuyerStcd := '';
        BuyerLglNm := '';

        IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
            GSTRegistrationNumber := 'URP'
        ELSE
            GSTRegistrationNumber := SalesInvoiceHeader."Customer GST Reg. No.";
        CompanyName := SalesInvoiceHeader."Bill-to Name";
        Address := SalesInvoiceHeader."Bill-to Address";
        Address2 := SalesInvoiceHeader."Bill-to Address 2";
        Floor := '';
        AddressLocation := SalesInvoiceHeader."Ship-to City";
        Cust.GET(SalesInvoiceHeader."Sell-to Customer No.");
        City := Cust.City;
        PostCode := CopyStr(SalesInvoiceHeader."Bill-to Post Code", 1, 6);

        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SetFilter(Quantity, '<>0');
        if SalesInvoiceLine.FindFirst() then
            case SalesInvoiceLine."GST Place of Supply" of
                SalesInvoiceLine."GST Place of Supply"::"Bill-to Address":
                    begin
                        if not (SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(SalesInvoiceHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code (GST Reg. No.)";
                            GstPOS := StateBuff."State Code (GST Reg. No.)";
                        end else begin
                            GstPOS := '96';
                            StateCode := '96';
                            PostCode := '';
                        end;

                        if Contact.Get(SalesInvoiceHeader."Bill-to Contact No.") then begin
                            PhoneNumber := ''; //CopyStr(Contact."Phone No.", 1, 10);
                            Email := ''; //CopyStr(Contact."E-Mail", 1, 50);
                        end else begin
                            PhoneNumber := '';
                            Email := '';
                        end;
                    end;

                SalesInvoiceLine."GST Place of Supply"::"Ship-to Address":
                    begin
                        if not (SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(SalesInvoiceHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code (GST Reg. No.)";
                            StateBuff.Get(SalesInvoiceHeader."GST Ship-to State Code");
                            GstPOS := StateBuff."State Code (GST Reg. No.)";
                        end else begin
                            GstPOS := '96';
                            StateCode := '96';
                            PostCode := '';
                        end;

                        if ShiptoAddress.Get(SalesInvoiceHeader."Sell-to Customer No.", SalesInvoiceHeader."Ship-to Code") then begin
                            PhoneNumber := ''; //CopyStr(ShiptoAddress."Phone No.", 1, 10);
                            Email := ''; //CopyStr(ShiptoAddress."E-Mail", 1, 50);
                        end else begin
                            PhoneNumber := '';
                            Email := '';
                        end;
                    end;
                else begin
                    if not (SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export) then begin
                        StateBuff.Get(SalesInvoiceHeader."GST Bill-to State Code");
                        StateCode := StateBuff."State Code (GST Reg. No.)";
                        GstPOS := StateBuff."State Code (GST Reg. No.)";
                    end else begin
                        GstPOS := '96';
                        StateCode := '96';
                        PostCode := '';
                    end;
                    PhoneNumber := '';
                    Email := '';
                end;
            end;


        BuyerGSTIN := GSTRegistrationNumber;
        BuyerLglNm := CompanyName;
        BuyerAdd1 := Address;
        BuyerAdd2 := Address2;
        BuyerLoc := City;
        BuyerPin := PostCode;
        BuyerStcd := StateCode;

        WriteBuyerDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email, GstPOS);
    end;

    local procedure ReadCrMemoBuyerDetails()
    var
        Contact: Record Contact;
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        GstPOS: Text[10];
    begin
        GSTRegistrationNumber := SalesCrMemoHeader."Customer GST Reg. No.";
        CompanyName := SalesCrMemoHeader."Bill-to Name";
        Address := SalesCrMemoHeader."Bill-to Address";
        Address2 := SalesCrMemoHeader."Bill-to Address 2";
        Floor := '';
        AddressLocation := SalesCrMemoHeader."Bill-to City";
        City := SalesCrMemoHeader."Bill-to City";
        PostCode := CopyStr(SalesCrMemoHeader."Bill-to Post Code", 1, 6);
        StateCode := '';
        PhoneNumber := '';
        Email := '';

        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetFilter(Quantity, '<>0');
        if SalesCrMemoLine.FindFirst() then
            case SalesCrMemoLine."GST Place of Supply" of

                SalesCrMemoLine."GST Place of Supply"::"Bill-to Address":
                    begin
                        if not (SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(SalesCrMemoHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code (GST Reg. No.)";
                            GstPOS := StateBuff."State Code (GST Reg. No.)";
                        end else begin
                            StateCode := '96';
                            GstPOS := '96';
                        end;

                        if Contact.Get(SalesCrMemoHeader."Bill-to Contact No.") then begin
                            PhoneNumber := ''; //CopyStr(Contact."Phone No.", 1, 10);
                            Email := ''; //CopyStr(Contact."E-Mail", 1, 50);
                        end;
                    end;

                SalesCrMemoLine."GST Place of Supply"::"Ship-to Address":
                    begin
                        if not (SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(SalesCrMemoHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code (GST Reg. No.)";
                            StateBuff.Get(SalesCrMemoHeader."GST Ship-to State Code");
                            GstPOS := StateBuff."State Code (GST Reg. No.)";
                        end else begin
                            StateCode := '96';
                            GstPOS := '96';
                        end;

                        if ShiptoAddress.Get(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code") then begin
                            PhoneNumber := ''; //CopyStr(ShiptoAddress."Phone No.", 1, 10);
                            Email := ''; //CopyStr(ShiptoAddress."E-Mail", 1, 50);
                        end;
                    end;
            end;

        BuyerGSTIN := GSTRegistrationNumber;
        BuyerLglNm := CompanyName;
        BuyerAdd1 := Address;
        BuyerAdd2 := Address2;
        BuyerLoc := City;
        BuyerPin := PostCode;
        BuyerStcd := StateCode;

        WriteBuyerDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email, GstPOS);
    end;

    local procedure WriteBuyerDetails(
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50];
        GstPOS: Text[10])
    var
        JBuyerDetails: JsonObject;
    begin
        JBuyerDetails.Add('gstin', GSTRegistrationNumber);
        JBuyerDetails.Add('legal_name', CompanyName);
        JBuyerDetails.Add('trade_name', CompanyName);
        JBuyerDetails.Add('address1', Address);
        JBuyerDetails.Add('address2', Address2);
        JBuyerDetails.Add('location', AddressLocation);
        JBuyerDetails.Add('pincode', PostCode);
        JBuyerDetails.Add('place_of_supply', GstPOS);
        JBuyerDetails.Add('state_code', StateCode);
        JBuyerDetails.Add('phone_number', PhoneNumber);
        JBuyerDetails.Add('email', EmailID);
        InvObject.Add('buyer_details', JBuyerDetails);
    end;

    local procedure WriteBuyerDetailsPurchase(
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50];
        GstPOS: Text[10])
    var
        JBuyerDetails: JsonObject;
    begin
        InvObject.Add('gstin_of_consignee', GSTRegistrationNumber);
        InvObject.Add('legal_name_of_consignee', CompanyName);
        //JBuyerDetails.Add('trade_name', CompanyName);
        InvObject.Add('address1_of_consignee', Address);
        InvObject.Add('address2_of_consignee', Address2);
        InvObject.Add('place_of_consignee', AddressLocation);
        InvObject.Add('pincode_of_consignee', PostCode);
        //JBuyerDetails.Add('place_of_supply', GstPOS);
        InvObject.Add('state_of_supply', StateCode);
        InvObject.Add('actual_to_state_name', StateCode);
        InvObject.Add('transaction_type', '2');
        //JBuyerDetails.Add('phone_number', PhoneNumber);
        //JBuyerDetails.Add('email', EmailID);
        //InvObject.Add('buyer_details', JBuyerDetails);
    end;

    local procedure ReadDocumentShippingDetails()
    var
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50];
        reccustomer: Record Customer;
    begin
        Clear(JsonArrayData);
        IF IsTransfer THEN BEGIN
            GSTRegistrationNumber := BuyerGSTIN;
            CompanyName := BuyerLglNm;
            Address := BuyerAdd1;
            Address2 := BuyerAdd2;
            City := BuyerLoc;
            StateCode := BuyerStcd;
            PostCode := BuyerPin;
        END ELSE
            if IsPurchase THEN BEGIN
                GSTRegistrationNumber := BuyerGSTIN;
                CompanyName := BuyerLglNm;
                Address := BuyerAdd1;
                Address2 := BuyerAdd2;
                City := BuyerLoc;
                StateCode := BuyerStcd;
                PostCode := BuyerPin;
            end else
                if IsInvoice then begin
                    if (SalesInvoiceHeader."Ship-to Code" <> '') then begin
                        ShiptoAddress.Get(SalesInvoiceHeader."Sell-to Customer No.", SalesInvoiceHeader."Ship-to Code");
                        StateBuff.Get(SalesInvoiceHeader."GST Ship-to State Code");
                        //reccustomer.get(SalesInvoiceHeader."Sell-to Customer No.");
                        CompanyName := SalesInvoiceHeader."Ship-to Name";
                        Address := SalesInvoiceHeader."Ship-to Address";
                        Address2 := SalesInvoiceHeader."Ship-to Address 2";
                        City := SalesInvoiceHeader."Ship-to City";
                        PostCode := CopyStr(SalesInvoiceHeader."Ship-to Post Code", 1, 6);

                        GSTRegistrationNumber := ShiptoAddress."GST Registration No.";
                        Floor := '';
                        AddressLocation := City;
                        StateCode := StateBuff."State Code (GST Reg. No.)";
                        PhoneNumber := ''; //CopyStr(ShiptoAddress."Phone No.", 1, 10);
                        EmailID := ''; //CopyStr(ShiptoAddress."E-Mail", 1, 50);
                    end else begin
                        GSTRegistrationNumber := BuyerGSTIN;
                        CompanyName := BuyerLglNm;
                        Address := BuyerAdd1;
                        Address2 := BuyerAdd2;
                        reccustomer.GET(SalesInvoiceHeader."Sell-to Customer No.");
                        AddressLocation := reccustomer.City;
                        City := AddressLocation;
                        StateCode := BuyerStcd;
                        PostCode := BuyerPin;
                    end;
                end else
                    if SalesCrMemoHeader."Ship-to Code" <> '' then begin
                        ShiptoAddress.Get(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code");
                        StateBuff.Get(SalesCrMemoHeader."GST Ship-to State Code");
                        reccustomer.get(SalesCrMemoHeader."Sell-to Customer No.");
                        CompanyName := SalesCrMemoHeader."Ship-to Name";
                        Address := SalesCrMemoHeader."Ship-to Address";
                        Address2 := SalesCrMemoHeader."Ship-to Address 2";
                        //City := SalesCrMemoHeader."Ship-to City";
                        City := reccustomer.City;
                        PostCode := CopyStr(SalesCrMemoHeader."Ship-to Post Code", 1, 6);

                        GSTRegistrationNumber := ShiptoAddress."GST Registration No.";
                        Floor := '';
                        AddressLocation := City;
                        StateCode := StateBuff."State Code (GST Reg. No.)";
                        PhoneNumber := ''; //CopyStr(ShiptoAddress."Phone No.", 1, 10);
                        EmailID := ''; //CopyStr(ShiptoAddress."E-Mail", 1, 50);
                                       //WriteShippingDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, EmailID);
                    end else begin
                        GSTRegistrationNumber := BuyerGSTIN;
                        CompanyName := BuyerLglNm;
                        Address := BuyerAdd1;
                        Address2 := BuyerAdd2;
                        reccustomer.GET(SalesCrMemoHeader."Sell-to Customer No.");
                        AddressLocation := reccustomer.City;
                        StateCode := BuyerStcd;
                        PostCode := BuyerPin;
                    end;
        WriteShippingDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, EmailID);
    end;

    local procedure WriteShippingDetails(
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50])
    var
        JShippingDetails: JsonObject;
    begin
        JShippingDetails.Add('gstin', GSTRegistrationNumber);
        JShippingDetails.Add('legal_name', CompanyName);
        JShippingDetails.Add('trade_name', CompanyName);
        JShippingDetails.Add('address1', Address);
        JShippingDetails.Add('address2', Address2);
        JShippingDetails.Add('location', AddressLocation);
        JShippingDetails.Add('pincode', PostCode);
        JShippingDetails.Add('state_code', StateCode);
        InvObject.Add('ship_details', JShippingDetails);
    end;

    local procedure ReadTransferToDetails()
    var
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        GstPOS: Text[10];
        RecLoc: Record Location;
    begin
        BuyerGSTIN := '';
        BuyerAdd1 := '';
        BuyerAdd2 := '';
        BuyerLoc := '';
        BuyerPin := '';
        BuyerStcd := '';
        BuyerLglNm := '';

        RecLoc.get(TransferShipmentHeader."Transfer-to Code");
        GSTRegistrationNumber := RecLoc."GST Registration No.";
        CompanyName := RecLoc.Name;
        Address := RecLoc.Address;
        Address2 := RecLoc."Address 2";
        Floor := '';
        AddressLocation := RecLoc.City;
        City := RecLoc.City;
        PostCode := CopyStr(RecLoc."Post Code", 1, 6);
        StateBuff.Get(RecLoc."State Code");
        StateCode := StateBuff."State Code (GST Reg. No.)";
        GstPOS := StateBuff."State Code (GST Reg. No.)";

        BuyerGSTIN := GSTRegistrationNumber;
        BuyerLglNm := CompanyName;
        BuyerAdd1 := Address;
        BuyerAdd2 := Address2;
        BuyerLoc := City;
        BuyerPin := PostCode;
        BuyerStcd := StateCode;

        WriteBuyerDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email, GstPOS);
    end;

    local procedure ReadPurchaseCrMemoToDetails()
    var
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
        GstPOS: Text[10];
        recvendor: Record Vendor;
    begin
        BuyerGSTIN := '';
        BuyerAdd1 := '';
        BuyerAdd2 := '';
        BuyerLoc := '';
        BuyerPin := '';
        BuyerStcd := '';
        BuyerLglNm := '';

        recvendor.get(PurchCrMemoHeader."Buy-from Vendor No.");
        GSTRegistrationNumber := recvendor."GST Registration No.";
        CompanyName := recvendor.Name;
        Address := recvendor.Address;
        Address2 := recvendor."Address 2";
        Floor := '';
        AddressLocation := recvendor.City;
        City := recvendor.City;
        PostCode := CopyStr(recvendor."Post Code", 1, 6);
        StateBuff.Get(recvendor."State Code");
        StateCode := StateBuff."State Code (GST Reg. No.)";
        GstPOS := StateBuff."State Code (GST Reg. No.)";

        BuyerGSTIN := GSTRegistrationNumber;
        BuyerLglNm := CompanyName;
        BuyerAdd1 := Address;
        BuyerAdd2 := Address2;
        BuyerLoc := City;
        BuyerPin := PostCode;
        BuyerStcd := StateCode;

        WriteBuyerDetailsPurchase(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email, GstPOS);
    end;

    local procedure ReadTransferTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        NatureOfSupplyCategory: Text[10];
        SupplyType: Text[3];
        IgstOnIntra: Text[1];
    begin
        if not IsTransfer then
            exit;

        NatureOfSupplyCategory := 'B2B';
        SupplyType := 'REG';
        IgstOnIntra := 'N';

        WriteTransactionDetails(NatureOfSupplyCategory, 'N', SupplyType, 'false', 'Y', '', IgstOnIntra);
    end;

    local procedure ReadPurchaseCrMemoTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        NatureOfSupplyCategory: Text[10];
        SupplyType: Text[3];
        IgstOnIntra: Text[1];
    begin
        if not IsPurchase then
            exit;

        NatureOfSupplyCategory := 'B2B';
        SupplyType := 'REG';
        IgstOnIntra := 'N';

        WriteTransactionDetails(NatureOfSupplyCategory, 'N', SupplyType, 'false', 'Y', '', IgstOnIntra);
    end;

    local procedure ReadDocumentItemList()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
        UnitofMeasure: Record "Unit of Measure";
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CessRate: Decimal;
        CesNonAdval: Decimal;
        StateCess: Decimal;
        FreeQuantity: Decimal;
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
        SlNo: Integer;
        IsServc: Text[2];
        UQC: Code[10];
        StCessAmt: Decimal;
        CESSValue: Decimal;
    //LineDiscount: Decimal;
    begin
        Clear(JsonArrayData);
        SlNo := 0;
        IF IsTransfer THEN BEGIN
            if DocumentNo <> '' then
                TransferShipmentLine.SETRANGE("Document No.", DocumentNo)
            else
                TransferShipmentLine.SETRANGE("Document No.", TransferShipmentHeader."No.");
            TransferShipmentLine.SETFILTER(Quantity, '<>0');
            IF TransferShipmentLine.FINDSET() THEN
                if TransferShipmentLine.Count > 1000 then
                    Error(SalesLinesMaxCountLimitErr, TransferShipmentLine.Count);
            repeat
                SlNo += 1;
                AssessableAmount := TransferShipmentLine.Amount;
                FreeQuantity := 0;

                IF TransferShipmentLine."Unit of Measure Code" <> '' THEN BEGIN
                    UnitofMeasure.GET(TransferShipmentLine."Unit of Measure Code");
                    UQC := UnitofMeasure."International Standard Code";
                END ELSE
                    UQC := 'NOS';

                IsServc := 'N';

                FreeQuantity := 0;
                GetGSTComponentRate(
                    TransferShipmentLine."Document No.",
                    TransferShipmentLine."Line No.",
                    CGSTRate,
                    SGSTRate,
                    IGSTRate,
                    CessRate,
                    CesNonAdval,
                    StateCess,
                    StCessAmt);

                GetGSTValueForLine(TransferShipmentLine."Line No.", CGSTValue, SGSTValue, IGSTValue, CESSValue);
                WriteItem(
                  TransferShipmentLine.Description + TransferShipmentLine."Description 2", '',
                  TransferShipmentLine."HSN/SAC Code", '',
                  TransferShipmentLine.Quantity, FreeQuantity,
                  CopyStr(UQC, 1, 3),
                  Round(TransferShipmentLine."Unit Price", 0.001),
                  TransferShipmentLine.Amount,
                  0, 0,
                  AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                  AssessableAmount + CGSTValue + SGSTValue + IGSTValue + CESSValue,
                  format(SlNo), CGSTValue, SGSTValue, IGSTValue, IsServc, CESSValue);

            UNTIL TransferShipmentLine.NEXT() = 0;

            InvObject.Add('items', JsonArrayData);
        END else IF IsPurchase then begin

            if DocumentNo <> '' then
                PurchaseCrMemoLine.SETRANGE("Document No.", DocumentNo)
            else
                PurchaseCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
            PurchaseCrMemoLine.SETFILTER(Quantity, '<>0');
            IF PurchaseCrMemoLine.FINDSET() THEN BEGIN
                if PurchaseCrMemoLine.Count > 1000 then
                    Error(SalesLinesMaxCountLimitErr, PurchaseCrMemoLine.Count);
                repeat
                    SlNo += 1;
                    AssessableAmount := PurchaseCrMemoLine."Line Amount";
                    FreeQuantity := 0;

                    IF PurchaseCrMemoLine."Unit of Measure Code" <> '' THEN BEGIN
                        UnitofMeasure.GET(PurchaseCrMemoLine."Unit of Measure Code");
                        UQC := UnitofMeasure."International Standard Code";
                    END ELSE
                        UQC := 'NOS';

                    IsServc := 'N';

                    FreeQuantity := 0;
                    GetGSTComponentRate(
                        PurchaseCrMemoLine."Document No.",
                        PurchaseCrMemoLine."Line No.",
                        CGSTRate,
                        SGSTRate,
                        IGSTRate,
                        CessRate,
                        CesNonAdval,
                        StateCess,
                        StCessAmt);

                    GetGSTValueForLine(PurchaseCrMemoLine."Line No.", CGSTValue, SGSTValue, IGSTValue, CESSValue);
                    WriteItem(
                      PurchaseCrMemoLine.Description + PurchaseCrMemoLine."Description 2", '',
                      PurchaseCrMemoLine."HSN/SAC Code", '',
                      PurchaseCrMemoLine.Quantity, FreeQuantity,
                      CopyStr(UQC, 1, 3),
                      Round(PurchaseCrMemoLine."Direct Unit Cost", 0.001),
                      PurchaseCrMemoLine.Amount,
                      0, 0,
                      AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                      AssessableAmount + CGSTValue + SGSTValue + IGSTValue + CESSValue,
                      format(SlNo), CGSTValue, SGSTValue, IGSTValue, IsServc, CESSValue);

                UNTIL PurchaseCrMemoLine.NEXT() = 0;
            end;
            InvObject.Add('item_list', JsonArrayData);
        END
        ELSE
            if IsInvoice then begin
                SalesInvoiceLine.SetRange("Document No.", DocumentNo);
                SalesInvoiceLine.SETFILTER(Quantity, '<>0');
                SalesInvoiceLine.SETRANGE("System-Created Entry", FALSE);
                if SalesInvoiceLine.FindSet() then begin
                    if SalesInvoiceLine.Count > 1000 then
                        Error(SalesLinesMaxCountLimitErr, SalesInvoiceLine.Count);
                    repeat
                        SlNo += 1;
                        if SalesInvoiceLine."GST Assessable Value (LCY)" <> 0 then
                            AssessableAmount := SalesInvoiceLine."GST Assessable Value (LCY)"
                        else
                            AssessableAmount := SalesInvoiceLine.Amount;

                        IF SalesInvoiceLine."Unit of Measure Code" <> '' THEN BEGIN
                            UnitofMeasure.GET(SalesInvoiceLine."Unit of Measure Code");
                            UQC := UnitofMeasure."International Standard Code";
                        END ELSE
                            UQC := 'NOS';

                        IF SalesInvoiceLine."GST Group Type" = SalesInvoiceLine."GST Group Type"::Service THEN
                            IsServc := 'Y'
                        ELSE
                            IsServc := 'N';

                        FreeQuantity := 0;
                        GetGSTComponentRate(
                            SalesInvoiceLine."Document No.",
                            SalesInvoiceLine."Line No.",
                            CGSTRate,
                            SGSTRate,
                            IGSTRate,
                            CessRate,
                            CesNonAdval,
                            StateCess,
                            StCessAmt);

                        GetGSTValueForLine(SalesInvoiceLine."Line No.", CGSTValue, SGSTValue, IGSTValue, CESSValue);

                        WriteItem(
                          SalesInvoiceLine.Description + SalesInvoiceLine."Description 2", '',
                          SalesInvoiceLine."HSN/SAC Code", '',
                          SalesInvoiceLine.Quantity, FreeQuantity,
                          CopyStr(UQC, 1, 3),
                          Round(SalesInvoiceLine."Unit Price", 0.001),
                          SalesInvoiceLine."Line Amount" + SalesInvoiceLine."Line Discount Amount",
                          SalesInvoiceLine."Line Discount Amount" + SalesInvoiceLine."Inv. Discount Amount", 0,
                          AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                          AssessableAmount + CGSTValue + SGSTValue + IGSTValue + CESSValue,
                          format(SlNo), CGSTValue, SGSTValue, IGSTValue, IsServc, CESSValue);
                    until SalesInvoiceLine.Next() = 0;
                end;

                InvObject.Add('item_list', JsonArrayData);
            end else begin
                SalesCrMemoLine.SetRange("Document No.", DocumentNo);
                SalesCrMemoLine.SETFILTER(Quantity, '<>0');
                SalesCrMemoLine.SETRANGE("System-Created Entry", FALSE);
                if SalesCrMemoLine.FindSet() then begin
                    if SalesCrMemoLine.Count > 1000 then
                        Error(SalesLinesMaxCountLimitErr, SalesCrMemoLine.Count);

                    repeat
                        SlNo += 1;
                        if SalesCrMemoLine."GST Assessable Value (LCY)" <> 0 then
                            AssessableAmount := SalesCrMemoLine."GST Assessable Value (LCY)"
                        else
                            AssessableAmount := SalesCrMemoLine.Amount;

                        IF SalesCrMemoLine."Unit of Measure Code" <> '' THEN BEGIN
                            UnitofMeasure.GET(SalesCrMemoLine."Unit of Measure Code");
                            UQC := UnitofMeasure."International Standard Code";
                        END ELSE
                            UQC := 'NOS';

                        IF SalesCrMemoLine."GST Group Type" = SalesCrMemoLine."GST Group Type"::Service THEN
                            IsServc := 'Y'
                        ELSE
                            IsServc := 'N';

                        FreeQuantity := 0;
                        GetGSTComponentRate(
                            SalesCrMemoLine."Document No.",
                            SalesCrMemoLine."Line No.",
                            CGSTRate,
                            SGSTRate,
                            IGSTRate,
                            CessRate,
                            CesNonAdval,
                            StateCess,
                            StCessAmt);

                        GetGSTValueForLine(SalesCrMemoLine."Line No.", CGSTValue, SGSTValue, IGSTValue, CESSValue);

                        WriteItem(
                          SalesCrMemoLine.Description + SalesCrMemoLine."Description 2", '',
                          SalesCrMemoLine."HSN/SAC Code", '',
                          SalesCrMemoLine.Quantity, FreeQuantity,
                          CopyStr(UQC, 1, 3),
                          Round(SalesCrMemoLine."Unit Price", 0.001),
                          SalesCrMemoLine."Line Amount" + SalesCrMemoLine."Line Discount Amount",
                          SalesCrMemoLine."Line Discount Amount" + SalesCrMemoLine."Inv. Discount Amount", 0,
                          AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                          AssessableAmount + CGSTValue + SGSTValue + IGSTValue + CESSValue,
                          format(SlNo), CGSTValue, SGSTValue, IGSTValue, IsServc, CESSValue);
                    until SalesCrMemoLine.Next() = 0;
                end;

                InvObject.Add('item_list', JsonArrayData);
            end;
    end;


    local procedure WriteItem(
        ProductName: Text;
        ProductDescription: Text;
        HSNCode: Text[20];
        BarCode: Text[30];
        Quantity: Decimal;
        FreeQuantity: Decimal;
        Unit: Text[3];
        UnitPrice: Decimal;
        TotAmount: Decimal;
        Discount: Decimal;
        OtherCharges: Decimal;
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CESSRate: Decimal;
        CessNonAdvanceAmount: Decimal;
        StateCess: Decimal;
        TotalItemValue: Decimal;
        SlNo: text[20];
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
        IsServc: Text[2];
        CessAmt: Decimal)
    var
        JItem: JsonObject;
    begin
        JItem.Add('item_serial_number', SlNo);
        JItem.Add('product_description', ProductName); //ProductDescription);
        JItem.Add('is_service', IsServc);
        JItem.Add('hsn_code', HSNCode);
        JItem.Add('bar_code', BarCode);

        JItem.Add('quantity', Quantity);
        JItem.Add('free_quantity', FreeQuantity);
        JItem.Add('unit', Unit);
        JItem.Add('unit_price', UnitPrice);
        JItem.Add('total_amount', TotAmount);
        JItem.Add('pre_tax_value', AssessableAmount);
        JItem.Add('discount', Discount);
        JItem.Add('other_charge', OtherCharges);
        JItem.Add('assessable_value', AssessableAmount);
        JItem.Add('gst_rate', (IGSTRate + SGSTRate + CGSTRate));
        JItem.Add('igst_amount', IGSTValue);
        JItem.Add('cgst_amount', CGSTValue);
        JItem.Add('sgst_amount', SGSTValue);
        JItem.Add('state_cess_rate', CESSRate);
        JItem.Add('state_cess_amount', CessAmt);
        JItem.Add('cess_nonadvol_amount', CessNonAdvanceAmount);
        //JItem.Add('stateCessAmt', StateCess);
        JItem.Add('state_cess_nonadvol_amount', 0);

        JItem.Add('total_item_value', TotalItemValue);
        JsonArrayData.Add(JItem);
    end;

    local procedure GetGSTComponentRate(
        DocNo: Code[20];
        LineNo: Integer;
        var CGSTRate: Decimal;
        var SGSTRate: Decimal;
        var IGSTRate: Decimal;
        var CessRate: Decimal;
        var CessNonAdvanceAmount: Decimal;
        var StateCess: Decimal;
        var StateCessAmt: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SetRange("Document No.", DocNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", LineNo);

        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            CGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            CGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            SGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            SGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            IGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            IGSTRate := 0;

        CessRate := 0;
        CessNonAdvanceAmount := 0;
        StateCessAmt := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            if DetailedGSTLedgerEntry."GST %" > 0 then
                CessRate := DetailedGSTLedgerEntry."GST %"
            else
                CessNonAdvanceAmount := Abs(DetailedGSTLedgerEntry."GST Amount");

        StateCess := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if not (DetailedGSTLedgerEntry."GST Component Code" in [CGSTLbl, SGSTLbl, IGSTLbl, CESSLbl])
                then begin
                    StateCess := DetailedGSTLedgerEntry."GST %";
                    StateCessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                end;
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    local procedure GetGSTValue(
        var AssessableAmount: Decimal;
        var CGSTAmount: Decimal;
        var SGSTAmount: Decimal;
        var IGSTAmount: Decimal;
        var CessAmount: Decimal;
        var StateCessValue: Decimal;
        var CessNonAdvanceAmount: Decimal;
        var DiscountAmount: Decimal;
        var OtherCharges: Decimal;
        var TotalInvoiceValue: Decimal;
        var TotInvAddCurr: Decimal;
        var RoundOff: Decimal)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PurchCrediMemoLine: Record "Purch. Cr. Memo Line";
        TotGSTAmt: Decimal;
    begin
        IF IsTransfer THEN
            GSTLedgerEntry.SETRANGE("Source Type", GSTLedgerEntry."Source Type"::Transfer)
        ELSE
            if IsPurchase then
                GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::"Credit Memo")
            else
                IF IsInvoice THEN
                    GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::Invoice)
                ELSE
                    GSTLedgerEntry.SETRANGE("Document Type", GSTLedgerEntry."Document Type"::"Credit Memo");

        GSTLedgerEntry.SetRange("Document No.", DocumentNo);

        GSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                CGSTAmount += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0
        else
            CGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                SGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            SGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                IGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            IGSTAmount := 0;

        CessAmount := 0;
        CessNonAdvanceAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                CessAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            CessAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            repeat
                if DetailedGSTLedgerEntry."GST %" < 0 then
                    CessNonAdvanceAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;

        GSTLedgerEntry.SetFilter("GST Component Code", '<>CGST&<>SGST&<>IGST&<>CESS');
        if GSTLedgerEntry.FindSet() then
            repeat
                StateCessValue += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;

        IF IsTransfer THEN BEGIN
            TransferShipmentLine.RESET();
            TransferShipmentLine.SETRANGE("Document No.", DocumentNo);
            IF TransferShipmentLine.FINDSET() THEN
                REPEAT
                    RoundOff += 0;
                    AssessableAmount += TransferShipmentLine.Amount;
                    DiscountAmount += 0;
                UNTIL TransferShipmentLine.NEXT() = 0;


            TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;
            TotalInvoiceValue := AssessableAmount + TotGSTAmt;
            OtherCharges := 0;
        END ELSE
            IF IsPurchase THEN BEGIN
                PurchCrediMemoLine.RESET();
                PurchCrediMemoLine.SETRANGE("Document No.", DocumentNo);
                IF PurchCrediMemoLine.FINDSET() THEN
                    REPEAT
                        IF PurchCrediMemoLine."System-Created Entry" THEN
                            RoundOff += PurchCrediMemoLine.Amount
                        else begin
                            AssessableAmount += PurchCrediMemoLine.Amount;
                            DiscountAmount += 0;
                        end;
                    UNTIL PurchCrediMemoLine.NEXT() = 0;

                TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;
                TotalInvoiceValue := AssessableAmount + TotGSTAmt;
                OtherCharges := 0;
            END ELSE BEGIN
                if IsInvoice then begin
                    SalesInvoiceLine.SetRange("Document No.", DocumentNo);
                    if SalesInvoiceLine.FindSet() then
                        repeat
                            IF SalesInvoiceLine."System-Created Entry" THEN
                                RoundOff += SalesInvoiceLine.Amount
                            else begin
                                AssessableAmount += SalesInvoiceLine.Amount;
                                DiscountAmount += SalesInvoiceLine."Inv. Discount Amount";
                            end;
                        until SalesInvoiceLine.Next() = 0;
                    TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;

                    if SalesInvoiceHeader."Currency Code" <> '' then
                        TotInvAddCurr := AssessableAmount + TotGSTAmt - DiscountAmount;

                    AssessableAmount := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                          WorkDate(), SalesInvoiceHeader."Currency Code", AssessableAmount, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
                    TotGSTAmt := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                          WorkDate(), SalesInvoiceHeader."Currency Code", TotGSTAmt, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
                    DiscountAmount := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                          WorkDate(), SalesInvoiceHeader."Currency Code", DiscountAmount, SalesInvoiceHeader."Currency Factor"), 0.01, '=');
                end else begin
                    SalesCrMemoLine.SetRange("Document No.", DocumentNo);
                    if SalesCrMemoLine.FindSet() then begin
                        repeat
                            IF SalesCrMemoLine."System-Created Entry" THEN
                                RoundOff += SalesCrMemoLine.Amount
                            ELSE BEGIN
                                AssessableAmount += SalesCrMemoLine.Amount;
                                DiscountAmount += SalesCrMemoLine."Inv. Discount Amount";
                            end;
                        until SalesCrMemoLine.Next() = 0;
                        TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;
                    end;

                    if SalesCrMemoHeader."Currency Code" <> '' then
                        TotInvAddCurr := AssessableAmount + TotGSTAmt - DiscountAmount;

                    AssessableAmount := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                            WorkDate(),
                            SalesCrMemoHeader."Currency Code",
                            AssessableAmount,
                            SalesCrMemoHeader."Currency Factor"),
                            0.01,
                            '=');

                    TotGSTAmt := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                            WorkDate(),
                            SalesCrMemoHeader."Currency Code",
                            TotGSTAmt,
                            SalesCrMemoHeader."Currency Factor"),
                            0.01,
                            '=');

                    DiscountAmount := Round(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                            WorkDate(),
                            SalesCrMemoHeader."Currency Code",
                            DiscountAmount,
                            SalesCrMemoHeader."Currency Factor"),
                            0.01,
                            '=');
                end;

                CustLedgerEntry.SetCurrentKey("Document No.");
                CustLedgerEntry.SetRange("Document No.", DocumentNo);
                if IsInvoice then begin
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                    CustLedgerEntry.SetRange("Customer No.", SalesInvoiceHeader."Bill-to Customer No.");
                end else begin
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
                    CustLedgerEntry.SetRange("Customer No.", SalesCrMemoHeader."Bill-to Customer No.");
                end;

                if CustLedgerEntry.FindFirst() then begin
                    CustLedgerEntry.CalcFields("Amount (LCY)");
                    TotalInvoiceValue := Abs(CustLedgerEntry."Amount (LCY)");
                end;

                OtherCharges := TotalInvoiceValue - (AssessableAmount + TotGSTAmt + RoundOff);
            end;
    end;

    local procedure GetGSTValueForLine(
        DocumentLineNo: Integer;
        var CGSTLineAmount: Decimal;
        var SGSTLineAmount: Decimal;
        var IGSTLineAmount: Decimal;
        var CESSLineAmount: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        CGSTLineAmount := 0;
        SGSTLineAmount := 0;
        IGSTLineAmount := 0;
        CESSLineAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", DocumentLineNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                CGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                SGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                IGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                CESSLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;

    end;

    local procedure ReadDocumentTotalDetails()
    var
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CESSNonAvailmentAmount: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceValue: Decimal;
        RoundOff: Decimal;
        TotInvAddCurr: Decimal;
    begin
        Clear(JsonArrayData);
        GetGSTValue(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue, TotInvAddCurr, RoundOff);
        WriteDocumentTotalDetails(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue, TotInvAddCurr, RoundOff);
    end;

    local procedure WriteDocumentTotalDetails(
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CessNonAdvanceVal: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceAmount: Decimal;
        TotInvAddCurr: Decimal;
        RoundOff: Decimal)
    var
        JDocTotalDetails: JsonObject;
    begin
        JDocTotalDetails.Add('total_assessable_value', AssessableAmount);
        JDocTotalDetails.Add('total_cgst_value', CGSTAmount);
        JDocTotalDetails.Add('total_sgst_value', SGSTAmount);
        JDocTotalDetails.Add('total_igst_value', IGSTAmount);
        JDocTotalDetails.Add('total_cess_value_of_state', StateCessAmount);
        JDocTotalDetails.Add('total_discount', 0); //DiscountAmount);
        JDocTotalDetails.Add('total_other_charge', OtherCharges);
        JDocTotalDetails.Add('total_invoice_value', TotalInvoiceAmount);
        JDocTotalDetails.Add('round_off_amount', RoundOff);
        if TotInvAddCurr <> 0 then
            JDocTotalDetails.Add('total_invoice_value_additional_currency', TotInvAddCurr);
        InvObject.Add('value_details', JDocTotalDetails);
    end;

    local procedure ReadEWaybillDetails(ByIRN: Boolean)
    var

        Transporter: Record "Shipping Agent"; //Vendor;
        EWayObject: JsonObject;
        JArray: JsonArray;
    begin
        if IsTransfer then begin
            If TransferShipmentHeader."Shipping Agent Code" <> '' then
                if ByIRN then begin
                    JObject.Add('user_gstin', UserGSTIN);
                    JObject.Add('Irn', TransferShipmentHeader."IRN Hash");
                    Transporter.get(TransferShipmentHeader."Shipping Agent Code");
                    if Transporter."GST Registration No." <> '' then
                        JObject.Add('transporter_id', Transporter."GST Registration No.")
                    else
                        JObject.Add('transporter_id', 'URP');
                    JObject.Add('transporter_name', Transporter.Name);
                    JObject.Add('distance', TransferShipmentHeader."Distance (Km)");
                    JObject.Add('transporter_document_number', TransferShipmentHeader."LR/RR No.");
                    if TransferShipmentHeader."LR/RR Date" <> 0D then
                        JObject.Add('transporter_document_date', TransferShipmentHeader."LR/RR Date")
                    else
                        JObject.Add('transporter_document_date', '');
                    JObject.Add('vehicle_number', TransferShipmentHeader."Vehicle No.");
                    If TransferShipmentHeader."Vehicle Type" = TransferShipmentHeader."Vehicle Type"::" " then
                        JObject.Add('vehicle_type', '')
                    else
                        JObject.Add('vehicle_type', COPYSTR(FORMAT(TransferShipmentHeader."Vehicle Type"), 1, 1));
                    JObject.Add('transportation_mode', TransferShipmentHeader."Mode of Transport");
                    JObject.Add('data_source', 'ERP');
                end else begin
                    Transporter.get(TransferShipmentHeader."Shipping Agent Code");
                    if Transporter."GST Registration No." <> '' then
                        EWayObject.Add('ewb_transporter_id', Transporter."GST Registration No.")
                    else
                        EWayObject.Add('ewb_transporter_id', 'URP');
                    EWayObject.Add('ewb_transporterName', Transporter.Name);
                    EWayObject.Add('ewb_transDistance', TransferShipmentHeader."Distance (Km)");
                    EWayObject.Add('ewb_transDocNo', TransferShipmentHeader."LR/RR No.");
                    if TransferShipmentHeader."LR/RR Date" <> 0D then
                        EWayObject.Add('ewb_transDocDt', TransferShipmentHeader."LR/RR Date")
                    else
                        EWayObject.Add('ewb_transDocDt', '');
                    EWayObject.Add('ewb_vehicleNo', TransferShipmentHeader."Vehicle No.");
                    If TransferShipmentHeader."Vehicle Type" = TransferShipmentHeader."Vehicle Type"::" " then
                        EWayObject.Add('ewb_vehicleType', '')
                    else
                        EWayObject.Add('ewb_vehicleType', COPYSTR(FORMAT(TransferShipmentHeader."Vehicle Type"), 1, 1));
                    EWayObject.Add('ewb_transMode', TransferShipmentHeader."Mode of Transport");
                    InvObject.Add('ewaybill_information', EWayObject);
                end;

        end else
            if IsInvoice then
                If SalesInvoiceHeader."Shipping Agent Code" <> '' then
                    if ByIRN then begin
                        JObject.Add('user_gstin', UserGSTIN);
                        JObject.Add('Irn', SalesInvoiceHeader."IRN Hash");
                        Transporter.get(SalesInvoiceHeader."Shipping Agent Code");
                        if Transporter."GST Registration No." <> '' then
                            JObject.Add('transporter_id', Transporter."GST Registration No.")
                        else
                            JObject.Add('transporter_id', 'URP');
                        JObject.Add('transporter_name', Transporter.Name);
                        JObject.Add('distance', SalesInvoiceHeader."Distance (Km)");
                        JObject.Add('transporter_document_number', SalesInvoiceHeader."LR No.");
                        JObject.Add('transporter_document_date', SalesInvoiceHeader."LR Date");
                        /*if SalesInvoiceHeader."LR/RR Date" <> 0D then
                            JObject.Add('TransDocDt', SalesInvoiceHeader."LR/RR Date")
                        else
                            EWayObject.Add('ewb_transDocDt', ''); */
                        JObject.Add('vehicle_number', SalesInvoiceHeader."Vehicle No.");
                        If SalesInvoiceHeader."Vehicle Type" = SalesInvoiceHeader."Vehicle Type"::" " then
                            JObject.Add('vehicle_type', '')
                        else
                            JObject.Add('vehicle_type', COPYSTR(FORMAT(SalesInvoiceHeader."Vehicle Type"), 1, 1));
                        JObject.Add('transportation_mode', SalesInvoiceHeader."Mode of Transport");
                        JObject.Add('data_source', 'ERP');
                    end else begin
                        Transporter.get(SalesInvoiceHeader."Shipping Agent Code");
                        if Transporter."GST Registration No." <> '' then
                            EWayObject.Add('ewb_transporter_id', Transporter."GST Registration No.")
                        else
                            EWayObject.Add('ewb_transporter_id', 'URP');
                        EWayObject.Add('ewb_transporterName', Transporter.Name);
                        EWayObject.Add('ewb_transDistance', SalesInvoiceHeader."Distance (Km)");
                        EWayObject.Add('ewb_transDocNo', SalesInvoiceHeader."LR/RR No.");
                        if SalesInvoiceHeader."LR/RR Date" <> 0D then
                            EWayObject.Add('ewb_transDocDt', SalesInvoiceHeader."LR/RR Date")
                        else
                            EWayObject.Add('ewb_transDocDt', '');
                        EWayObject.Add('ewb_vehicleNo', SalesInvoiceHeader."Vehicle No.");
                        If SalesInvoiceHeader."Vehicle Type" = SalesInvoiceHeader."Vehicle Type"::" " then
                            EWayObject.Add('ewb_vehicleType', '')
                        else
                            EWayObject.Add('ewb_vehicleType', COPYSTR(FORMAT(SalesInvoiceHeader."Vehicle Type"), 1, 1));
                        EWayObject.Add('ewb_transMode', SalesInvoiceHeader."Mode of Transport");
                        InvObject.Add('ewaybill_information', EWayObject);
                    end;
        //JArray.Add(JObject);
    end;

    local procedure RunSalesInvoice()
    begin
        if not IsInvoice then
            exit;

        if SalesInvoiceHeader."GST Customer Type" in [
            SalesInvoiceHeader."GST Customer Type"::Unregistered,
            SalesInvoiceHeader."GST Customer Type"::" "]
        then
            Error(eInvoiceNotApplicableCustErr);

        DocumentNo := SalesInvoiceHeader."No.";
        WriteJsonFileHeader();
        InvObject.Add('user_gstin', UserGSTIN);
        InvObject.Add('data_source', 'erp');
        ReadTransactionDetails(SalesInvoiceHeader."GST Customer Type", SalesInvoiceHeader."Ship-to Code");
        ReadDocumentHeaderDetails();
        ReadDocumentSellerDetails();
        ReadDocumentBuyerDetails();
        ReadDocumentShippingDetails();
        ReadExportDetails();
        ReadDocumentItemList();
        ReadDocumentTotalDetails();


        if EInvoiceSetup."E-Waybill by IRN Enabled" then
            ReadEWaybillDetails(false);

        //InvArrayData.Add(InvObject);
        //JObject.Add('Inv', InvArrayData);
        //JObject.Add('transaction', InvObject);
        //InvArrayData.Add(JObject);
        //InvArrayData.Add(InvObject);
        //JObject.Add('transaction', InvArrayData);



    end;

    local procedure RunSalesCrMemo()
    begin
        if IsInvoice then
            exit;

        if SalesCrMemoHeader."GST Customer Type" in [
            SalesCrMemoHeader."GST Customer Type"::Unregistered,
            SalesCrMemoHeader."GST Customer Type"::" "]
        then
            Error(eInvoiceNotApplicableCustErr);

        DocumentNo := SalesCrMemoHeader."No.";
        WriteJsonFileHeader();
        InvObject.Add('Version', '1.1');

        ReadTransactionDetails(SalesCrMemoHeader."GST Customer Type", SalesCrMemoHeader."Ship-to Code");
        ReadDocumentHeaderDetails();
        ReadExportDetails();
        ReadDocumentSellerDetails();
        ReadDocumentBuyerDetails();
        ReadDocumentShippingDetails();
        ReadDocumentItemList();
        ReadDocumentTotalDetails();

        //InvArrayData.Add(InvObject);
        //JObject.Add('Inv', InvArrayData);
        JObject.Add('transaction', InvObject);
        InvArrayData.Add(JObject);


    end;

    local procedure RunTransferShpt()
    var
        TransferFromLocation: Record Location;
        TransferToLocation: Record Location;
    begin
        if not IsTransfer then
            exit;

        TransferFromLocation.get(TransferShipmentHeader."Transfer-from Code");
        TransferToLocation.get(TransferShipmentHeader."Transfer-to Code");
        if TransferFromLocation."State Code" = TransferToLocation."State Code" then
            exit;

        if SalesInvoiceHeader."GST Customer Type" in [
            SalesInvoiceHeader."GST Customer Type"::Unregistered,
            SalesInvoiceHeader."GST Customer Type"::" "]
        then
            Error(eInvoiceNotApplicableCustErr);

        DocumentNo := SalesInvoiceHeader."No.";
        WriteJsonFileHeader();
        ReadTransactionDetails(SalesInvoiceHeader."GST Customer Type", SalesInvoiceHeader."Ship-to Code");
        ReadDocumentHeaderDetails();
        ReadDocumentSellerDetails();
        ReadDocumentBuyerDetails();
        ReadDocumentShippingDetails();
        ReadDocumentItemList();
        ReadDocumentTotalDetails();
        ReadExportDetails();
        if EInvoiceSetup."E-Waybill by IRN Enabled" then
            ReadEWaybillDetails(false);
    end;

    local procedure ReadTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceTransactionDetails(GSTCustType, ShipToCode)
        else
            ReadCreditMemoTransactionDetails(GSTCustType, ShipToCode);
    end;

    local procedure ReadExportDetails()
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceExportDetails()
        else
            ReadCrMemoExportDetails();
    end;

    local procedure ReadCrMemoExportDetails()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ExportCategory: Text[3];
        WithPayOfDuty: Text[1];
        ShipmentBillNo: Text[16];
        ShipmentBillDate: Text[10];
        ExitPort: Text[10];
        DocumentAmount: Decimal;
        CurrencyCode: Text[3];
        CountryCode: Text[2];
    begin
        if IsInvoice then
            exit;

        if not (SalesCrMemoHeader."GST Customer Type" in [
            SalesCrMemoHeader."GST Customer Type"::Export,
            SalesCrMemoHeader."GST Customer Type"::"Deemed Export",
            SalesCrMemoHeader."GST Customer Type"::"SEZ Unit",
            SalesCrMemoHeader."GST Customer Type"::"SEZ Development"])
        then
            exit;

        case SalesCrMemoHeader."GST Customer Type" of
            SalesCrMemoHeader."GST Customer Type"::Export:
                ExportCategory := 'DIR';
            SalesCrMemoHeader."GST Customer Type"::"Deemed Export":
                ExportCategory := 'DEM';
            SalesCrMemoHeader."GST Customer Type"::"SEZ Unit":
                ExportCategory := 'SEZ';
            "GST Customer Type"::"SEZ Development":
                ExportCategory := 'SED';
        end;

        if SalesCrMemoHeader."GST Without Payment of Duty" then
            WithPayOfDuty := 'N'
        else
            WithPayOfDuty := 'Y';

        ShipmentBillNo := CopyStr(SalesCrMemoHeader."Bill Of Export No.", 1, 16);
        ShipmentBillDate := Format(SalesCrMemoHeader."Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
        ExitPort := SalesCrMemoHeader."Exit Point";

        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                DocumentAmount := DocumentAmount + SalesCrMemoLine.Amount;
            until SalesCrMemoLine.Next() = 0;

        CurrencyCode := CopyStr(SalesCrMemoHeader."Currency Code", 1, 3);
        CountryCode := CopyStr(SalesCrMemoHeader."Bill-to Country/Region Code", 1, 2);

        WriteExportDetails(WithPayOfDuty, ShipmentBillNo, ShipmentBillDate, ExitPort, CurrencyCode, CountryCode);
    end;

    local procedure ReadCreditMemoTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NatureOfSupply: Text[7];
        SupplyType: Text[3];
        IgstOnIntra: Text[3];
    begin
        if IsInvoice then
            exit;

        case GSTCustType of
            SalesInvoiceHeader."GST Customer Type"::Registered, SalesInvoiceHeader."GST Customer Type"::Exempted:
                NatureOfSupply := 'B2B';

            SalesInvoiceHeader."GST Customer Type"::Export:
                if SalesInvoiceHeader."GST Without Payment of Duty" then
                    NatureOfSupply := 'EXPWOP'
                else
                    NatureOfSupply := 'EXPWP';

            SalesInvoiceHeader."GST Customer Type"::"Deemed Export":
                NatureOfSupply := 'DEXP';

            SalesInvoiceHeader."GST Customer Type"::"SEZ Development", SalesInvoiceHeader."GST Customer Type"::"SEZ Unit":
                if SalesInvoiceHeader."GST Without Payment of Duty" then
                    NatureOfSupply := 'SEZWOP'
                else
                    NatureOfSupply := 'SEZWP';
        end;

        if ShipToCode <> '' then begin
            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
            if SalesCrMemoLine.FindSet() then
                repeat
                    if SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Ship-to Address" then
                        SupplyType := 'REG'
                    else
                        SupplyType := 'SHP';
                until SalesCrMemoLine.Next() = 0;
        end else
            SupplyType := 'REG';

        if SalesCrMemoHeader."POS Out Of India" then
            IgstOnIntra := 'Y'
        else
            IgstOnIntra := 'N';

        //WriteTransactionDetails(SupplyType, 'N', SupplyType, 'false', 'Y', 'null', IgstOnIntra);
        WriteTransactionDetails(NatureOfSupply, 'N', SupplyType, 'false', 'Y', '', IgstOnIntra);
    end;

    local procedure WriteExportDetails(
            WithPayOfDuty: Text[1];
            ShipmentBillNo: Text[16];
            ShipmentBillDate: Text[10];
            ExitPort: Text[10];
            CurrencyCode: Text[3];
            CountryCode: Text[2])
    var
        JExpDetails: JsonObject;
    begin
        JExpDetails.Add('ShipBNo', ShipmentBillNo);
        JExpDetails.Add('ShipBDt', ShipmentBillDate);
        JExpDetails.Add('Port', ExitPort);
        JExpDetails.Add('RefClm', WithPayOfDuty);
        JExpDetails.Add('ForCur', CurrencyCode);
        JExpDetails.Add('CntCode', CountryCode);

        JObject.Add('ExpDtls', JExpDetails);
    end;

    local procedure ReadInvoiceExportDetails()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        ExportCategory: Text[3];
        WithPayOfDuty: Text[1];
        ShipmentBillNo: Text[16];
        ShipmentBillDate: Text[10];
        ExitPort: Text[10];
        DocumentAmount: Decimal;
        CurrencyCode: Text[3];
        CountryCode: Text[2];
    begin
        if not IsInvoice then
            exit;

        if not (SalesInvoiceHeader."GST Customer Type" in [
            SalesInvoiceHeader."GST Customer Type"::Export,
            SalesInvoiceHeader."GST Customer Type"::"Deemed Export",
            SalesInvoiceHeader."GST Customer Type"::"SEZ Unit",
            SalesInvoiceHeader."GST Customer Type"::"SEZ Development"])
        then
            exit;

        case SalesInvoiceHeader."GST Customer Type" of
            SalesInvoiceHeader."GST Customer Type"::Export:
                ExportCategory := 'DIR';
            SalesInvoiceHeader."GST Customer Type"::"Deemed Export":
                ExportCategory := 'DEM';
            SalesInvoiceHeader."GST Customer Type"::"SEZ Unit":
                ExportCategory := 'SEZ';
            SalesInvoiceHeader."GST Customer Type"::"SEZ Development":
                ExportCategory := 'SED';
        end;

        if SalesInvoiceHeader."GST Without Payment of Duty" then
            WithPayOfDuty := 'N'
        else
            WithPayOfDuty := 'Y';

        ShipmentBillNo := CopyStr(SalesInvoiceHeader."Bill Of Export No.", 1, 16);
        ShipmentBillDate := Format(SalesInvoiceHeader."Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
        ExitPort := SalesInvoiceHeader."Exit Point";

        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                DocumentAmount := DocumentAmount + SalesInvoiceLine.Amount;
            until SalesInvoiceLine.Next() = 0;

        CurrencyCode := CopyStr(SalesInvoiceHeader."Currency Code", 1, 3);
        CountryCode := CopyStr(SalesInvoiceHeader."Bill-to Country/Region Code", 1, 2);

        WriteExportDetails(WithPayOfDuty, ShipmentBillNo, ShipmentBillDate, ExitPort, CurrencyCode, CountryCode);
    end;

    local procedure RunTransferShipment()
    var

        FromLoc: Record Location;
        ToLoc: Record Location;
        TransferShptLine: Record "Transfer Shipment Line";
        GSTCustType: Enum "GST Customer Type";

    begin
        if not IsTransfer then
            exit;

        FromLoc.GET(TransferShipmentHeader."Transfer-from Code");
        ToLoc.get(TransferShipmentHeader."Transfer-to Code");
        if FromLoc."State Code" = ToLoc."State Code" then
            exit;

        TransferShptLine.SetRange("Document No.", TransferShipmentHeader."No.");
        TransferShptLine.SetFilter(Quantity, '<>0');
        if TransferShptLine.FindFirst() then
            if not CheckGSTTransferDoc(TransferShptLine) then
                exit;

        DocumentNo := TransferShipmentHeader."No.";
        WriteJsonFileHeader();
        ReadDocumentSellerDetails();
        ReadTransferTransactionDetails(GSTCustType::Registered, '');
        ReadTransferToDetails();
        ReadDocumentShippingDetails();
        ReadDocumentHeaderDetails();
        ReadDocumentTotalDetails();
        ReadDocumentItemList();

        if EInvoiceSetup."E-Waybill by IRN Enabled" then
            ReadEWaybillDetails(false);

        InvArrayData.Add(InvObject);
        JObject.Add('inv', InvArrayData);
    end;

    local procedure CheckGSTTransferDoc(SalesLine: Record "Transfer Shipment Line"): Boolean
    var
        TaxTransactionValue: Record "Tax Transaction Value";
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", SalesLine.RecordId);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        if not TaxTransactionValue.IsEmpty then
            exit(true);
    end;

    local procedure RunPurchCreditMemo()
    var

        GSTCustType: Enum "GST Customer Type";

    begin
        if not IsPurchase then
            exit;


        DocumentNo := PurchCrMemoHeader."No.";
        WriteJsonFileHeader();
        ReadDocumentHeaderDetailsForPurch();
        ReadDocumentSellerDetails();
        //ReadTransferTransactionDetails(GSTCustType::Registered, '');
        ReadPurchaseCrMemoToDetails();
        ReadDocumentTotalDetailsforPurchase();

        //ReadDocumentShippingDetails();
        ReadDocumentItemListForPurchase();
        //ReadDocumentTotalDetails();
        //if EInvoiceSetup."E-Waybill by IRN Enabled" then
        //ReadEWaybillDetails(false);

        InvArrayData.Add(InvObject);
        //JObject.Add('inv', InvArrayData);
    end;

    local procedure SendJsonClearTaxPortal(DocuentNo: Code[20]; var UserGSTIN: Code[15])
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        HttpWebClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebContent: HttpContent;
        ResponseMessage: HttpResponseMessage;

        LocJObject: JsonObject;
        JToken: JsonToken;
        URLParameter: Text;
        JsonResponse: Text;
        RespMsg: Text;
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        ResponseErrorText: Text;
        TrnsIdentifier: Text[250];
        IRNNo: Text[250];
        SingedQR: Text;
        SingedInv: Text;
        AckNumber: Text[30];
        AckDateText: Text[30];
        EwbNo: Text[30];
        EwbDtText: Text[30];
        EwbValidTill: Text[30];
        ewbStatus: Text;
        QRGenerator: Codeunit "QR Generator";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        StatusMessage1: Label 'E-Invoice: IRN Successfully Generated.';
        StatusMessage2: Label 'E-Invoice & E-Waybill: Successfully Generated.';
        ErrorLbl: Label 'An error occured, please check e-Invoice Logs';
        Authoriztion: Text;
        JArray: JsonArray;
        ChildJToken: JsonToken;
        ChkToken: JsonToken;
        i: Integer;
        LocJArray: JsonArray;
        LocJObj: JsonObject;
        ErrorCode, ErrorMessage, ErrorSource : Text;
    begin
        Clear(IRNNo);
        Clear(AckDateText);
        Clear(AckNumber);
        Clear(EwbNo);
        Clear(EwbDtText);
        Clear(EwbValidTill);

        InvObject.WriteTo(JsonText);
        //JsonArrayData.Add(JObject);
        //JsonArrayData.WriteTo(JsonText);
        //EInvoiceSetup.get();
        EInvoiceSetup.Reset();
        EInvoiceSetup.SetRange("Is Production", true);
        if not EInvoiceSetup.FindFirst() then begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", false);
            EInvoiceSetup.FindFirst();
        end else begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", true);
            EInvoiceSetup.FindFirst();
        end;
        EInvoiceSetup.TestField("Generate IRN API");

        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonText);

        HttpWebContent.WriteFrom(JsonText);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        Authoriztion := GetAuthorizationText;
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('gstin', UserGSTIN);
        HttpWebClient.DefaultRequestHeaders().Add('Authorization', Authoriztion);
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(EInvoiceSetup."Generate IRN API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then
            error(ConnectionMsg,
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        HttpWebContent := ResponseMessage.Content;

        HttpWebContent.ReadAs(JsonResponse);

        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonResponse);


        LocJObject.ReadFrom(JsonResponse);
        if LocJObject.SelectToken('results.status', JToken) then begin
            RespMsg := JToken.AsValue().AsText();
            IF UpperCase(JToken.AsValue().AsText()) = 'SUCCESS' THEN begin
                if LocJObject.SelectToken('results.message.AckNo', JToken) then
                    if not JToken.AsValue().IsNull then
                        AckNumber := JToken.AsValue().AsText();

                if LocJObject.SelectToken('results.message.AckDt', JToken) then
                    if not JToken.AsValue().IsNull then
                        AckDateText := JToken.AsValue().AsText();

                if LocJObject.SelectToken('results.message.Irn', JToken) then
                    if not JToken.AsValue().IsNull then
                        IRNNo := JToken.AsValue().AsText();
                if LocJObject.SelectToken('results.message.SignedQRCode', JToken) then
                    If NOT JToken.AsValue().IsNull Then
                        SingedQR := JToken.AsValue().AsText();
                If LocJObject.SelectToken('results.message.EwbNo', JToken) then
                    If NOT JToken.AsValue().IsNull Then
                        If NOT JToken.AsValue().IsNull Then
                            EwbNo := JToken.AsValue().AsText();
                If LocJObject.SelectToken('results.message.EwbDt', JToken) then
                    If NOT JToken.AsValue().IsNull Then
                        EwbDtText := JToken.AsValue().AsText();
                If LocJObject.SelectToken('results.message.EwbValidTill', JToken) then
                    If NOT JToken.AsValue().IsNull Then
                        EwbValidTill := JToken.AsValue().AsText();

                //  end;
            end else
                IF UpperCase(JToken.AsValue().AsText()) = 'IRN_GENERATION_FAILED' THEN BEGIN
                    RespMsg := JToken.AsValue().AsText();
                    IF LocJObject.SelectToken('govt_response.Success', JToken) then
                        IF UpperCase(JToken.AsValue().AsText()) = 'N' THEN begin
                            IF LocJObject.SelectToken('govt_response.ErrorDetails', JToken) then
                                LocJArray := JToken.AsArray(); // ErrorDetails is an array
                            for i := 0 to LocJArray.Count() - 1 do begin
                                LocJArray.Get(i, JToken);
                                LocJObj := JToken.AsObject();
                                IF LocJObj.SelectToken('error_code', JToken) then
                                    ErrorCode := JToken.AsValue().AsText();

                                IF LocJObj.SelectToken('error_message', JToken) then
                                    ErrorMessage := JToken.AsValue().AsText();

                                IF LocJObj.SelectToken('error_source', JToken) then
                                    ErrorSource := JToken.AsValue().AsText();
                                ResponseErrorText := ResponseErrorText + '[' + ErrorCode + '] ' + ErrorMessage + ' (' + ErrorSource + '); ';
                            end;
                        end;
                end;
        end;


        // Update Record & Log
        IF UPPERCASE(RespMsg) = 'SUCCESS' THEN BEGIN
            if IsTransfer THEN begin
                Clear(RecRef);
                RecRef.GetTable(TransferShipmentHeader);
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("Acknowledgement No."));
                FieldRef.Value := AckNumber;
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("Acknowledgement Date"));
                FieldRef.Value := GetDateTimeFromText(AckDateText);
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                FieldRef.Value := IRNNo;
                if IRNNo <> '' then begin
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Invoice Status"));
                    FieldRef.Value := TransferShipmentHeader."E-Invoice Status"::Generated;
                end;
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("QR Code"));
                QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                TempBlob.ToRecordRef(RecRef, TransferShipmentHeader.FieldNo("QR Code"));
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                FieldRef.Value := IRNNo;
                FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                FieldRef.Value := IRNNo;
                if EwbNo <> '' then begin
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Way Bill No."));
                    FieldRef.Value := EwbNo;
                end;
                RecRef.Modify();
            end else
                IF IsInvoice THEN begin
                    Clear(RecRef);
                    RecRef.GetTable(SalesInvoiceHeader);
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement No."));
                    FieldRef.Value := AckNumber;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement Date"));
                    FieldRef.Value := GetDateTimeFromText(AckDateText);
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN No."));
                    FieldRef.Value := IRNNo;
                    if IRNNo <> '' then begin
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Invoice Status"));
                        FieldRef.Value := SalesInvoiceHeader."E-Invoice Status"::Generated;
                    end;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("QR Code"));
                    QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                    TempBlob.ToRecordRef(RecRef, SalesInvoiceHeader.FieldNo("QR Code"));
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    if EwbNo <> '' then begin
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Way Bill No."));
                        FieldRef.Value := EwbNo;
                    end;
                    RecRef.Modify();
                end else begin
                    Clear(RecRef);
                    RecRef.GetTable(SalesCrMemoHeader);
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement No."));
                    FieldRef.Value := AckNumber;
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement Date"));
                    FieldRef.Value := GetDateTimeFromText(AckDateText);
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN No."));
                    FieldRef.Value := IRNNo;
                    QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                    FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("QR Code"));
                    TempBlob.ToRecordRef(RecRef, SalesCrMemoHeader.FieldNo("QR Code"));
                    if IRNNo <> '' then begin
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Invoice Status"));
                        FieldRef.Value := SalesInvoiceHeader."E-Invoice Status"::Generated;
                    end;
                    RecRef.Modify();
                end;
        END ELSE BEGIN
            if IRNNo <> '' then begin
                if IsTransfer THEN begin
                    Clear(RecRef);
                    RecRef.GetTable(TransferShipmentHeader);
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("Acknowledgement No."));
                    FieldRef.Value := AckNumber;
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("Acknowledgement Date"));
                    FieldRef.Value := GetDateTimeFromText(AckDateText);
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    if IRNNo <> '' then begin
                        FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Invoice Status"));
                        FieldRef.Value := TransferShipmentHeader."E-Invoice Status"::Generated;
                    end;
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("QR Code"));
                    QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                    TempBlob.ToRecordRef(RecRef, TransferShipmentHeader.FieldNo("QR Code"));
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("IRN Hash"));
                    FieldRef.Value := IRNNo;
                    if EwbNo <> '' then begin
                        FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Way Bill No."));
                        FieldRef.Value := EwbNo;
                    end;
                    RecRef.Modify();
                end else
                    IF IsInvoice THEN begin
                        Clear(RecRef);
                        RecRef.GetTable(SalesInvoiceHeader);
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement No."));
                        FieldRef.Value := AckNumber;
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement Date"));
                        FieldRef.Value := GetDateTimeFromText(AckDateText);
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        if IRNNo <> '' then begin
                            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Invoice Status"));
                            FieldRef.Value := SalesInvoiceHeader."E-Invoice Status"::Generated;
                        end;
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("QR Code"));
                        QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                        TempBlob.ToRecordRef(RecRef, SalesInvoiceHeader.FieldNo("QR Code"));
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        if EwbNo <> '' then begin
                            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Way Bill No."));
                            FieldRef.Value := EwbNo;
                        end;
                        RecRef.Modify();
                    end else begin
                        Clear(RecRef);
                        RecRef.GetTable(SalesCrMemoHeader);
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement No."));
                        FieldRef.Value := AckNumber;
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement Date"));
                        FieldRef.Value := GetDateTimeFromText(AckDateText);
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        QRGenerator.GenerateQRCodeImage(SingedQR, TempBlob);
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("QR Code"));
                        TempBlob.ToRecordRef(RecRef, SalesCrMemoHeader.FieldNo("QR Code"));
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
                        FieldRef.Value := IRNNo;
                        RecRef.Modify();
                    end;
            end else begin
                if IsTransfer then begin
                    TransferShipmentHeader."E-Invoice Status" := TransferShipmentHeader."E-Invoice Status"::Error;
                    TransferShipmentHeader.Modify();
                end else
                    if IsInvoice then begin
                        SalesInvoiceHeader."E-Invoice Status" := SalesInvoiceHeader."E-Invoice Status"::Error;
                        SalesInvoiceHeader.Modify();
                    end else begin
                        SalesCrMemoHeader."E-Invoice Status" := SalesCrMemoHeader."E-Invoice Status"::Error;
                        SalesCrMemoHeader.Modify();
                    end;
            end;
        END;

        if IRNNo <> '' then
            if EwbNo <> '' then
                Message(StatusMessage2)
            else
                Message(StatusMessage1)
        else
            Message(ResponseErrorText);
    end;

    procedure GenerateEWaybillByIRN()
    var
        FromLoc: Record Location;
    begin
        //EInvoiceSetup.Get;
        EInvoiceSetup.Reset();
        EInvoiceSetup.SetRange("Is Production", true);
        if not EInvoiceSetup.FindFirst() then begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", false);
            EInvoiceSetup.FindFirst();
        end else begin
            EInvoiceSetup.Reset();
            EInvoiceSetup.SetRange("Is Production", true);
            EInvoiceSetup.FindFirst();
        end;
        Initialize();

        if IsTransfer then begin
            DocumentNo := TransferShipmentHeader."No.";
            FromLoc.get(TransferShipmentHeader."Transfer-from Code");
            if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                UserGSTIN := EInvoiceSetup."Demo GSTIN"
            else
                UserGSTIN := FromLoc."GST Registration No.";
            ReadEWaybillDetails(True);
        end else
            if IsInvoice then begin
                DocumentNo := SalesInvoiceHeader."No.";
                if EInvoiceSetup."Integration Mode" = EInvoiceSetup."Integration Mode"::Sandbox then
                    UserGSTIN := EInvoiceSetup."Demo GSTIN"
                else
                    UserGSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                ReadEWaybillDetails(True);
            end;

        if DocumentNo <> '' then
            if EInvoiceSetup."Integration Enabled" then
                SendEWBJsonToCleartaxPortal(DocumentNo, UserGSTIN)
            else
                ExportAsJsonEwaybill(DocumentNo);
    end;

    local procedure ExportAsJsonEwaybill(FileName: Text[20])
    var
        TempBlob: Codeunit "Temp Blob";
        ToFile: Variant;
        InStream: InStream;
        OutStream: OutStream;
    begin

        JObject.WriteTo(JsonText);
        //JsonArrayData.Add(InvObject);
        //JsonArrayData.WriteTo(JsonText);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(JsonText);
        ToFile := FileName + '.json';
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'E-Invoice', '', '', ToFile);

    end;

    local procedure SendEWBJsonToCleartaxPortal(DocuentNo: Code[20]; GSTIN: Code[15])
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        HttpWebClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        LocJObject: JsonObject;
        JToken: JsonToken;
        URLParameter: Text;
        JsonResponse: Text;
        RespMsg: Text;
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        ResponseErrorText: Text;
        TrnsIdentifier: Text[250];
        EwbNo: Text[30];
        EwbDtText: Text[30];
        EwbValidTill: Text[30];
        ewbStatus: Text;
        FieldRef: FieldRef;
        RecRef: RecordRef;
        StatusMessage: Label 'E-Waybill: Successfully Generated.';
        Authorization: Text;
        JArray: JsonArray;
        i: Integer;
        ChildJToken: JsonToken;
        ChkToken: JsonToken;
        Year: Integer;
        month: Integer;
        day: Integer;
        EwbDate: Date;
    begin
        Clear(EwbNo);
        Clear(EwbDtText);
        Clear(EwbValidTill);

        //JObject.WriteTo(JsonText);
        //JArray.WriteTo(JsonText);
        if IsPurchase then
            InvObject.WriteTo(JsonText)
        else begin
            JsonArrayData.Add(InvObject);
            JsonArrayData.WriteTo(JsonText);

        end;


        EInvoiceSetup.TestField("Generate E-Waybill by IRN API");

        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonText);

        HttpWebContent.WriteFrom(JsonText);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        Authorization := GetAuthorizationText;
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('gstin', UserGSTIN);
        HttpWebClient.DefaultRequestHeaders().Add('Authorization', Authorization);
        RequestMessage.Content := HttpWebContent;
        if IsPurchase then
            RequestMessage.SetRequestUri(EInvoiceSetup."Generate E-Waybill")
        else
            RequestMessage.SetRequestUri(EInvoiceSetup."Generate E-Waybill by IRN API");
        if IsPurchase then
            RequestMessage.Method := 'PUT'
        else
            RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then
            error(ConnectionMsg,
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        HttpWebContent := ResponseMessage.Content;

        HttpWebContent.ReadAs(JsonResponse);

        if EInvoiceSetup."Show Schema Message" then
            if GuiAllowed then
                Message(JsonResponse);

        if IsPurchase then
            JObject.ReadFrom(JsonResponse)
        else
            JArray.ReadFrom(JsonResponse);
        if IsPurchase then begin
            // Read ewb_status
            if JObject.SelectToken('results.status', JToken) then
                if not JToken.AsValue().IsNull then
                    RespMsg := JToken.AsValue().AsText();
            if UpperCase(RespMsg) = 'SUCCESS' then begin
                if JObject.SelectToken('results.message.EwbNo', JToken) then
                    if not JToken.AsValue().IsNull then
                        EwbNo := JToken.AsValue().AsText();

                if JObject.SelectToken('results.message.EwbDt', JToken) then
                    if not JToken.AsValue().IsNull then begin
                        EwbDtText := JToken.AsValue().AsText(); // e.g., "2025-05-05 09:42:00"

                        Evaluate(Year, CopyStr(EwbDtText, 1, 4));
                        Evaluate(Month, CopyStr(EwbDtText, 6, 2));
                        Evaluate(Day, CopyStr(EwbDtText, 9, 2));

                        EwbDate := DMY2DATE(Day, Month, Year); // This gives only the date part
                    end;
                if JObject.SelectToken('results.message.EwbValidTill', JToken) then
                    if not JToken.AsValue().IsNull then
                        EwbValidTill := JToken.AsValue().AsText();


                IF UPPERCASE(RespMsg) = 'SUCCESS' THEN BEGIN

                    Clear(RecRef);
                    RecRef.GetTable(PurchCrMemoHeader);
                    FieldRef := RecRef.Field(PurchCrMemoHeader.FieldNo("Eway Bill No."));
                    FieldRef.Value := EwbNo;
                    FieldRef := RecRef.Field(PurchCrMemoHeader.FieldNo("Eway Bill Date"));
                    FieldRef.Value := EwbDate;//GetDateTimeFromText(EwbDtText);
                    FieldRef := RecRef.Field(PurchCrMemoHeader.FieldNo("E-Waybill Valid Till"));
                    FieldRef.Value := GetDateTimeFromText(EwbValidTill);
                    RecRef.Modify();
                    Message(StatusMessage);
                END else
                    Message(ResponseErrorText);
            end;

        end else

            if JArray.Count > 0 then begin
                JArray.Get(0, JToken); // Get first object in array

                LocJObject := JToken.AsObject(); // Convert token to JsonObject

                if LocJObject.SelectToken('ewb_status', JToken) then
                    if not JToken.AsValue().IsNull then
                        RespMsg := JToken.AsValue().AsText(); // Declare: EWBStatus: Text;
                if LocJObject.SelectToken('govt_response.Success', JToken) then
                    if UpperCase(JToken.AsValue().AsText()) = 'Y' then begin

                        if LocJObject.SelectToken('govt_response.EwbNo', JToken) then
                            if not JToken.AsValue().IsNull then
                                EwbNo := JToken.AsValue().AsText();

                        if LocJObject.SelectToken('govt_response.EwbDt', JToken) then
                            if not JToken.AsValue().IsNull then
                                EwbDtText := JToken.AsValue().AsText();

                        Evaluate(Year, CopyStr(EwbDtText, 1, 4));
                        Evaluate(Month, CopyStr(EwbDtText, 6, 2));
                        Evaluate(Day, CopyStr(EwbDtText, 9, 2));

                        EwbDate := DMY2DATE(Day, Month, Year);

                        if LocJObject.SelectToken('govt_response.EwbValidTill', JToken) then
                            if not JToken.AsValue().IsNull then
                                EwbValidTill := JToken.AsValue().AsText();
                    end;


                IF UPPERCASE(RespMsg) = 'PARTA_GENERATED' THEN BEGIN
                    if IsTransfer then begin
                        Clear(RecRef);
                        RecRef.GetTable(TransferShipmentHeader);
                        FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Way Bill No."));
                        FieldRef.Value := EwbNo;
                        FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("Eway Bill Date"));
                        FieldRef.Value := EwbDate;//GetDateTimeFromText(EwbDtText);
                        FieldRef := RecRef.Field(TransferShipmentHeader.FieldNo("E-Waybill Valid Till"));
                        FieldRef.Value := GetDateTimeFromText(EwbValidTill);
                        RecRef.Modify();
                    end else
                        if IsPurchase then begin
                            Clear(RecRef);
                            RecRef.GetTable(PurchCrMemoHeader);
                            FieldRef := RecRef.Field(PurchCrMemoHeader.FieldNo("Eway Bill No."));
                            FieldRef.Value := EwbNo;
                            FieldRef := RecRef.Field(PurchCrMemoHeader.FieldNo("Eway Bill Date"));
                            FieldRef.Value := EwbDate;//GetDateTimeFromText(EwbDtText);
                            RecRef.Modify();
                        end else begin
                            Clear(RecRef);
                            RecRef.GetTable(SalesInvoiceHeader);
                            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Eway Bill No."));
                            FieldRef.Value := EwbNo;
                            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Eway Bill Date"));
                            FieldRef.Value := EwbDate;//GetDateTimeFromText(EwbDtText);
                            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("E-Waybill Valid Till"));
                            FieldRef.Value := GetDateTimeFromText(EwbValidTill);
                            RecRef.Modify();
                        end;

                    Message(StatusMessage);
                END else
                    Message(ResponseErrorText);
            end;

    end;

    local procedure ReadDocumentHeaderDetailsForPurch()
    var
        InvoiceType: Text[3];
        PostingDate: Text[10];
        docno: Text[20];
        OriginalInvoiceNo: Text[16];
        spTyp: Text[10];
    //ReturnPeriod: Text[20];
    begin
        Clear(JsonArrayData);

        docno := PurchCrMemoHeader."No.";
        InvoiceType := 'DELIVERY CHALLAN';
        PostingDate := FORMAT(PurchCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
        spTyp := 'Outward';
        WriteDocumentHeaderDetailsForPurch(InvoiceType, CopyStr(DocumentNo, 1, 16), PostingDate, spTyp);
    end;

    local procedure WriteDocumentHeaderDetailsForPurch(InvoiceType: Text[3]; DocNo: Text[16]; PostingDate: Text[10]; spTyp: Text[10])
    var
        JDocumentHeaderDetails: JsonObject;
    begin
        InvObject.Add('userGstin', UserGSTIN);
        InvObject.Add('document_number', DocNo);
        InvObject.Add('document_type', InvoiceType);
        InvObject.Add('document_date', PostingDate);
        InvObject.Add('supply_type', spTyp);
        InvObject.Add('sub_supply_type', 'OTHERS');
        InvObject.Add('sub_supply_description', 'Purchase Return');
        //InvObject.Add('TransactionType', 'Regular');
        //InvObject.Add('DocDtls', JDocumentHeaderDetails);
    end;

    local procedure ReadDocumentTotalDetailsforPurchase()
    var
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CESSNonAvailmentAmount: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceValue: Decimal;
        RoundOff: Decimal;
        TotInvAddCurr: Decimal;
    begin
        Clear(JsonArrayData);
        GetGSTValue(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue, TotInvAddCurr, RoundOff);
        WriteDocumentTotalDetailsForPurchase(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue, TotInvAddCurr, RoundOff);
    end;

    local procedure WriteDocumentTotalDetailsForPurchase(
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CessNonAdvanceVal: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceAmount: Decimal;
        TotInvAddCurr: Decimal;
        RoundOff: Decimal)
    var
        JDocTotalDetails: JsonObject;
        Transporter: Record "Shipping Agent"; //Vendor;

    begin
        InvObject.Add('other_value', OtherCharges);
        InvObject.Add('total_invoice_value', TotalInvoiceAmount);
        InvObject.Add('taxable_amount', AssessableAmount);
        InvObject.Add('cgst_amount', CGSTAmount);
        InvObject.Add('sgst_amount', SGSTAmount);
        InvObject.Add('igst_amount', IGSTAmount);
        if PurchCrMemoHeader."Shipping Agent Code" <> '' then begin
            Transporter.get(PurchCrMemoHeader."Shipping Agent Code");
            if Transporter."GST Registration No." <> '' then
                InvObject.Add('transporter_id', Transporter."GST Registration No.");
            InvObject.Add('transporter_name', Transporter.Name);
            if PurchCrMemoHeader."Vehicle No." <> '' then
                InvObject.Add('transportation_mode', '1')
            else
                InvObject.Add('transportation_mode', '');

            InvObject.Add('transportation_distance', PurchCrMemoHeader."Distance (Km)");
            InvObject.Add('vehicle_number', PurchCrMemoHeader."Vehicle No.");
            InvObject.Add('vehicle_type', '');
            InvObject.Add('generate_status', '1');
            InvObject.Add('data_source', 'ERP');
            InvObject.Add('vehicle_type', '');
            InvObject.Add('vehicle_type', '');

        end;
        // InvObject.Add('ValDtls', JDocTotalDetails);
    end;

    local procedure ReadDocumentItemListForPurchase()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
        UnitofMeasure: Record "Unit of Measure";
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CessRate: Decimal;
        CesNonAdval: Decimal;
        StateCess: Decimal;
        FreeQuantity: Decimal;
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
        SlNo: Integer;
        IsServc: Text[2];
        UQC: Code[10];
        StCessAmt: Decimal;
        CESSValue: Decimal;
    //LineDiscount: Decimal;
    begin
        Clear(JsonArrayData);
        SlNo := 0;
        IF IsPurchase then begin

            if DocumentNo <> '' then
                PurchaseCrMemoLine.SETRANGE("Document No.", DocumentNo)
            else
                PurchaseCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
            PurchaseCrMemoLine.SETFILTER(Quantity, '<>0');
            PurchaseCrMemoLine.SetRange("System-Created Entry", false);
            IF PurchaseCrMemoLine.FINDSET() THEN BEGIN
                if PurchaseCrMemoLine.Count > 1000 then
                    Error(SalesLinesMaxCountLimitErr, PurchaseCrMemoLine.Count);
                repeat
                    SlNo += 1;
                    AssessableAmount := PurchaseCrMemoLine."Line Amount";
                    FreeQuantity := 0;

                    IF PurchaseCrMemoLine."Unit of Measure Code" <> '' THEN BEGIN
                        UnitofMeasure.GET(PurchaseCrMemoLine."Unit of Measure Code");
                        UQC := UnitofMeasure."International Standard Code";
                    END ELSE
                        UQC := 'NOS';

                    IsServc := 'N';

                    FreeQuantity := 0;
                    GetGSTComponentRate(
                        PurchaseCrMemoLine."Document No.",
                        PurchaseCrMemoLine."Line No.",
                        CGSTRate,
                        SGSTRate,
                        IGSTRate,
                        CessRate,
                        CesNonAdval,
                        StateCess,
                        StCessAmt);

                    GetGSTValueForLine(PurchaseCrMemoLine."Line No.", CGSTValue, SGSTValue, IGSTValue, CESSValue);
                    WriteItemForPurchase(
                      PurchaseCrMemoLine.Description + PurchaseCrMemoLine."Description 2", '',
                      PurchaseCrMemoLine."HSN/SAC Code", '',
                      PurchaseCrMemoLine.Quantity, FreeQuantity,
                      CopyStr(UQC, 1, 3),
                      Round(PurchaseCrMemoLine."Direct Unit Cost", 0.001),
                      PurchaseCrMemoLine.Amount,
                      0, 0,
                      AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                      AssessableAmount + CGSTValue + SGSTValue + IGSTValue + CESSValue,
                      format(SlNo), CGSTValue, SGSTValue, IGSTValue, IsServc, CESSValue);

                UNTIL PurchaseCrMemoLine.NEXT() = 0;
            end;
            InvObject.Add('itemList', JsonArrayData);
        END
    end;

    local procedure WriteItemForPurchase(
        ProductName: Text;
        ProductDescription: Text;
        HSNCode: Text[20];
        BarCode: Text[30];
        Quantity: Decimal;
        FreeQuantity: Decimal;
        Unit: Text[3];
        UnitPrice: Decimal;
        TotAmount: Decimal;
        Discount: Decimal;
        OtherCharges: Decimal;
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CESSRate: Decimal;
        CessNonAdvanceAmount: Decimal;
        StateCess: Decimal;
        TotalItemValue: Decimal;
        SlNo: text[20];
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
        IsServc: Text[2];
        CessAmt: Decimal)
    var
        JItem: JsonObject;
    begin
        JItem.Add('product_name', ProductName); //ProductDescription);
        JItem.Add('product_description', ProductName); //ProductDescription);
        JItem.Add('hsn_code', HSNCode);
        JItem.Add('quantity', Quantity);
        JItem.Add('unit_of_product', Unit);
        JItem.Add('taxable_amount', AssessableAmount);
        JItem.Add('cgst_rate', CGSTRate);
        //JItem.Add('CgstAmt', CGSTValue);
        JItem.Add('sgst_rate', SGSTRate);
        //JItem.Add('SgstAmt', SGSTValue);
        JItem.Add('igst_rate', IGSTRate);
        //JItem.Add('IgstAmt', IGSTValue);
        JItem.Add('cess_rate', CESSRate);
        //JItem.Add('CesAmt', CessAmt);
        //JItem.Add('OthChrg', OtherCharges);
        JsonArrayData.Add(JItem);
    end;


    local procedure GeneratetokenfromMI(username: text[50]; password: text[50]): text
    var
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        HttpWebClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpWebContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        JsonResponse: Text;
        LocJObject: JsonObject;
        JToken: JsonToken;
        Token: Text;

    begin

        JsonObject.Add('username', username);
        JsonObject.Add('password', password);
        JsonObject.WriteTo(JsonText);
        HttpWebContent.WriteFrom(JsonText);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(EInvoiceSetup."Generate Token");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then
            error(ConnectionMsg,
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        HttpWebContent := ResponseMessage.Content;

        HttpWebContent.ReadAs(JsonResponse);

        LocJObject.ReadFrom(JsonResponse);
        if LocJObject.SelectToken('token', JToken) then begin
            Token := JToken.AsValue().AsText();
        end else
            Error('Token not found in response: %1', JsonResponse);
        exit(token);
    end;

}

