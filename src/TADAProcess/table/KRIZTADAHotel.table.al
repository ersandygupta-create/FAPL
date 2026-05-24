table 50163 krizHotelTable

{

    Caption = 'Hotel Table';

    DataClassification = ToBeClassified;

    fields

    {

        field(66000; NameofHotel; Text[60])

        {

            Caption = 'Name of Hotel';

        }

        field(66001; City; Text[100])

        {

            Caption = 'City';

            TableRelation = "Post Code";

        }

        field(66003; District; Text[30])

        {

            Caption = 'District';

        }

        field(66004; State; Text[10])

        {

            Caption = 'State';

        }

        field(66005; PANNo; Text[20])

        {

            Caption = 'PAN No';

        }

        field(66006; GST; Text[20])

        {

            Caption = 'GST';

        }

        field(66007; ContactNo; Text[10])

        {

            Caption = 'ContactNo';

        }

        field(66008; SecondaryContactNo; Text[10])

        {

            Caption = 'Secondary Contact No';

        }

        field(66009; Remarks; Text[100])

        {

            Caption = 'Remarks';

        }

    }

    keys

    {

        key(PK; NameofHotel, City, District, State)

        {

            Clustered = true;

        }

    }

    fieldgroups

    {

        fieldgroup(DropDown; NameofHotel, District)

        {

        }

    }

}

