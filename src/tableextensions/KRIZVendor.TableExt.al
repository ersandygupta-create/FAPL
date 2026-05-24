tableextension 50103 KRIZVendorTableExtension extends Vendor
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

    }
}