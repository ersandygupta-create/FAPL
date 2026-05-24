tableextension 50005 "KRIZ Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50001; "GL Code"; Code[20])
        {
            Caption = 'GL Code';
            DataClassification = ToBeClassified;
        }

    }
}
