tableextension 50013 "Kriz Lot No. Information" extends "Lot No. Information"
{
    fields
    {
        field(50001; "Kriz Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50002; "Kriz MRP"; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }
        field(50003; "Kriz Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
    }
}
