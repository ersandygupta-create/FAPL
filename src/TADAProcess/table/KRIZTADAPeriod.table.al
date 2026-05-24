table 50162 "krizTADAPeriod"
{
    Caption = 'TADA Period';
    DataClassification = ToBeClassified;
    LookupPageId = krizTADAPeriod;
    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'TADA Period';
           
        }
        field(2; Description; Text[60])
        {
            Caption = 'Description';
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(4; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(5; "Negative Only"; Boolean)
        {
            Caption = 'Negative Only';
        }
        field(6; "PenaltyDate"; Date)
        {
            Caption = 'Penalty Date';
        }
        field(7; "PenaltyAmount"; Decimal)
        {
            Caption = 'Penalty Amount';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups{
        fieldgroup(DropDown;Code,Description,"From Date",PenaltyDate,"To Date",PenaltyAmount)
        {
 
        }
    }
}
 
 