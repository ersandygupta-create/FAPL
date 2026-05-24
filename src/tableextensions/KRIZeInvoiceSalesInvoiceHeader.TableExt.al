tableextension 50151 "KRIZ Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Cancelled Invoice"; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;
        }

        field(50101; "Eway Bill No."; Code[50])
        {
            Caption = 'Eway Bill No.';
            DataClassification = ToBeClassified;
        }

        field(50102; "Eway Bill Date"; Date)
        {
            Caption = 'Eway Bill Date';
            DataClassification = ToBeClassified;
        }

        field(50103; "IRN No."; Code[120])
        {
            Caption = 'IRN No.';
            DataClassification = ToBeClassified;
        }

        field(50104; "LR No."; Code[20])
        {
            Caption = 'LR No.';
            DataClassification = ToBeClassified;
        }

        field(50105; "LR Date"; Date)
        {
            Caption = 'LR Date';
            DataClassification = ToBeClassified;
        }

        field(50106; "E-Invoice Status"; Option)
        {
            Caption = 'E-Invoice Status';
            OptionMembers = " ",Generated,Cancelled,Error;
            OptionCaption = ' ,Generated,Cancelled,Error';
            DataClassification = CustomerContent;
        }
        field(50107; "E-Waybill Valid Till"; Date)
        {
            Caption = 'E-Waybill Valid Till';
            DataClassification = ToBeClassified;
        }
        field(50109; "SMSSent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SMS Sent';
        }
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
        field(50203; "Kriz External Documet No."; Code[20])
        {
            Caption = 'Kriz External Document No.';
            DataClassification = CustomerContent;

        }

    }

}

