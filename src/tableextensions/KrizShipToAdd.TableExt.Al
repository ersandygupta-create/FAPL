tableextension 50165 KrizShipToAdd extends "ship-to Address"
{
    fields
    {
        field(50100; "Kriz GST Registration No"; Code[20])
        {
            Caption = 'GST Registration No.';
            DataClassification = CustomerContent;


            trigger OnValidate()
            var
                StateTable: Record "State";
            begin
                TestField(rec.State);
                StateTable.Reset();
                StateTable.Get(rec.State);
                if (CopyStr(rec."Kriz GST Registration No", 1, 2) <> StateTable."State Code (GST Reg. No.)") then begin
                    Error('GST Registration No. state code does not match the selected state.');

                end;
                if (StrLen(rec."Kriz GST Registration No") <> 15) then begin
                    Error('GST Registration No. must be exactly 15 characters long.');
                end;
            end;
        }
    }
    trigger OnAfterInsert()
    begin
        Rec."GST Registration No." := Rec."Kriz GST Registration No";
    end;

    trigger OnAfterModify()
    begin
        Rec."GST Registration No." := Rec."Kriz GST Registration No";
    end;
}