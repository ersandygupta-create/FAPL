codeunit 50001 "Sales Validations"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reference Invoice No. Mgt.", 'OnBeforeCheckRefInvoiceNoSalesHeader', '', false, false)]
    local procedure BypassRefInvoiceNo(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reference Invoice No. Mgt.", 'OnBeforeCheckRefInvNoPurchaseHeader', '', false, false)]
    local procedure BypassRefInvoiceNoPurch(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::"Return Order", PurchaseHeader."Document Type"::"Credit Memo"] then
            IsHandled := true;
    end;

    /*
        // New: Validate Mandatory Fields on Customer Insert
        [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
        local procedure OnBeforeInsertCustomer(var Rec: Record Customer)
        var
        begin
            ValidateMandatoryFields(Rec);
        end;

        // New: Validate Mandatory Fields on Customer Modify
        [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
        local procedure OnBeforeModifyCustomer(var Rec: Record Customer; xRec: Record Customer)
        var
        begin
            ValidateMandatoryFields(Rec);
        end;

        procedure ValidateMandatoryFields(CustomerRec: Record Customer)
        begin
            if (CustomerRec."Agreement Date" = 0D) then
                Error('Agreement Date must not be empty.');

            if (CustomerRec."Valid Upto" = 0D) then
                Error('Valid Upto Date must not be empty.');

            // Add more validations as needed
        end; */
}