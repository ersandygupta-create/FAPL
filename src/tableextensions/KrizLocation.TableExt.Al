tableextension 50104 "Kriz Location" extends Location
{
    fields
    {
        field(50000; "Kriz PL Number"; Code[50])
        {
            Caption = 'Pesticide License Number';
            DataClassification = CustomerContent;
        }

        field(50001; "Kriz FL Number"; Code[50])
        {
            Caption = 'Fertilizer License Number';
            DataClassification = CustomerContent;
        }


    }
}
