tableextension 50152 "KRIZ Purchase Cr Memo Hdr" extends "Purch. Cr. Memo Hdr."
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
        field(50106; "E-Waybill Valid Till"; Date)
        {
            Caption = 'E-Waybill Valid Till';
            DataClassification = ToBeClassified;
        }




    }
}
