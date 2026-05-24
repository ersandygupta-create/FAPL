table 50001 "KRIZ Item Balance Table"
{
    Caption = 'Item Balance';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Item Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Technical Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line Discount Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Item Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Item Type"; Option)
        {
            OptionMembers = Inventory,Service,NonInventory;
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Conversion Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Opening Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Receipt Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Issue Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Purchase Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Purchase Ret Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Sales Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Sales Return Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Negative Adjustment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Positive Adjustment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Transfer Shipment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Transfer Receipt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Closing Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Item No.", "Item Group", "Item Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


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