tableextension 50102 KRIZCustomerTableExtension extends Customer
{

    fields
    {
        field(50001; "Agreement Date"; Date)
        {
            Caption = 'Agreement Date';
            DataClassification = ToBeClassified;
        }
        field(50002; "Valid Upto"; Date)
        {
            Caption = 'Valid Upto';
            DataClassification = ToBeClassified;
        }
        field(50003; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = ToBeClassified;
        }
        field(50004; "Security Deposit"; Decimal)
        {
            Caption = 'Security Deposit';
            DataClassification = ToBeClassified;
        }
        field(50005; "Cost Center"; Text[25])
        {
            Caption = 'Cost Center';
            DataClassification = ToBeClassified;
        }
    }
}