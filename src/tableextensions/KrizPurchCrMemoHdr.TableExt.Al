tableextension 50006 "Kriz Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Kriz Reference Doc. No"; Code[20])
        {
            Caption = 'Kriz Reference Document No.';
        }
        field(50002; "Kriz Reference Doc. Date"; Date)
        {
            Caption = 'Kriz Reference Document Date';
        }
    }

}