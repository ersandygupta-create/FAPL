table 50006 "KRIZ MIS Details"
{
    DataClassification = ToBeClassified;
    Caption = 'MIS Details';

    fields
    {
        field(1; "Order No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order No';

        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No';
        }
        field(3; "LR No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'LR No';
        }
        field(4; "LR Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'LR Date';
        }
        field(5; "Consignor"; Text[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Consignor';
        }
        field(6; "Pick Up"; Text[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Pick Up';
        }
        field(7; "Pick Up GST"; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Pick Up GST';
        }
        field(8; "Consignee Name"; Text[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Consignee Name';
        }
        field(9; "Drop Off Location"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Drop Off Location';
        }
        field(10; "Drop Off GST"; code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Drop Off GST';
        }
        field(11; "Ship To Pin"; code[6])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship to Pin';
        }
        field(12; "State"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'State';
        }
        field(13; "Truck Number"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Truck Number';
        }
        field(14; "Truck Type"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Truck Type';
        }
        field(15; "Weight of Shipment"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Weight of Shipment';
        }
        field(16; "Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Delivery Date';
        }

    }

    keys
    {
        key(PK; "Order No", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}