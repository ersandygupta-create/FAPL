tableextension 50003 "KRIZ Sales Header" extends "Sales Header"
{
    fields
    {
        field(50200; "PO No."; Text[20])
        {
            Caption = 'PO No.';
            DataClassification = ToBeClassified;
        }

        field(50201; "PO Date"; Date)
        {
            Caption = 'PO Date';
            DataClassification = ToBeClassified;
        }
        field(50202; "Shipping from Location"; Text[20])
        {
            Caption = 'Shipping from Location';
            DataClassification = ToBeClassified;
        }
        field(50203; "Kriz Reference Doc. No"; Code[20])
        {
            Caption = 'Reference Document No';
            DataClassification = CustomerContent;

        }

    }
}