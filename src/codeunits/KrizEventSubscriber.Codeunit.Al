codeunit 50002 "Kriz Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure CopyFlowFieldToPostedCrMemo(
        var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header")
    var
        SourceHeader: Record "Sales Header";
    begin
        // Load the original sales header to access the FlowField
        if SourceHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
            // CALCFIELDS required to read FlowField

            // Write FlowField value into normal field on posted document
            SalesCrMemoHeader."Kriz Reference Doc. No" :=
                SourceHeader."Kriz Reference Doc. No";
            // SalesCrMemoHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchCrMemoHeaderInsert', '', false, false)]
    local procedure CopyFlowFieldToPostedCrMemoPurchase(
       var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
       PurchHeader: Record "Purchase Header")
    var
        SourceHeader: Record "Purchase Header";
    begin
        // Load the original purchase header to access the FlowField
        if SourceHeader.Get(PurchHeader."Document Type", PurchHeader."No.") then begin
            PurchCrMemoHdr."Kriz Reference Doc. No" :=
                SourceHeader."Kriz Reference Doc. No";
            PurchCrMemoHdr."Kriz Reference Doc. Date" :=
            SourceHeader."Kriz Reference Doc. Date";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure HandleOnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header")
    begin
        TransShptHeader."Kriz Shipping Id" := TransHeader."Kriz Shipping Id";
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Condition Mgmt.", 'OnBeforeCalcDecimal', '', false, false)]
    //     // [EventSubscriber(
    //     //     ObjectType::Codeunit,
    //     //     Codeunit::"Condition Mgmt."
    //     //     'OnBeforeCalcDecimal')]
    //     local procedure OnBeforeCalcDecimal(
    //         Value1: Decimal;
    //         Value2: Variant;
    //         Operator: Enum "Arithmetic Operator";
    //         Swap: Boolean;
    //         var OutputValue: Variant;
    //         var IsHandled: Boolean)
    //     var
    //         Value2Decimal: Decimal;
    //     begin
    //         if Operator <> Operator::"divided by" then
    //             exit;

    //         if not Value2.IsDecimal() then
    //             exit;

    //         Value2Decimal := Value2;

    //         if (not Swap) and (Value2Decimal = 0) then begin
    //             OutputValue := 0;
    //             IsHandled := true;
    //         end;

    //         if Swap and (Value1 = 0) then begin
    //             OutputValue := 0;
    //             IsHandled := true;
    //         end;
    //     end;

}