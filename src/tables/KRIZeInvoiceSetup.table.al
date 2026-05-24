table 50150 "KRIZ e-Invoice Setup"
{
    Caption = 'e-Invoice Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Integration Mode"; Option)
        {
            Caption = 'Integration Mode';
            OptionMembers = Sandbox,Production;
            OptionCaption = 'Sandbox, Production';
            DataClassification = CustomerContent;
        }

        field(2; "Demo GSTIN"; Text[25])
        {
            Caption = 'Demo GSTIN';
            DataClassification = CustomerContent;
        }

        field(3; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            DataClassification = CustomerContent;
        }

        field(4; "E-Waybill by IRN Enabled"; Boolean)
        {
            Caption = 'E-Waybill by IRN Enabled';
            DataClassification = CustomerContent;
        }

        field(5; "Demo City"; Text[50])
        {
            Caption = 'Demo City';
            DataClassification = CustomerContent;
        }

        field(6; "Demo Post Code"; Text[50])
        {
            Caption = 'Demo Post Code';
            DataClassification = CustomerContent;
        }

        field(7; "Generate IRN API"; Text[250])
        {
            Caption = 'Generate IRN API';
            DataClassification = CustomerContent;
        }

        field(8; "Show Schema Message"; Boolean)
        {
            Caption = 'Show Schema Message';
            DataClassification = CustomerContent;
        }

        field(9; "User ID"; Text[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }

        field(10; "Password"; Text[50])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }

        field(11; "Cancel IRN API"; Text[250])
        {
            Caption = 'Cancel IRN API';
            DataClassification = CustomerContent;
        }
        field(12; "Generate E-Waybill by IRN API"; Text[250])
        {
            Caption = 'Generate E-Waybill by IRN API';
            DataClassification = CustomerContent;
        }

        field(13; "Get Invoice by IRN API"; Text[250])
        {
            Caption = 'Generate IRN API';
            DataClassification = CustomerContent;
        }
        field(15; "Generate E-Waybill"; Text[250])
        {
            Caption = 'Generate E-Waybill';
            DataClassification = CustomerContent;
        }
        field(14; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = CustomerContent;
        }
        field(16; "Generate Token"; Text[250])
        {
            Caption = 'Generate Token';
            DataClassification = CustomerContent;
        }
        field(20; "Is Production"; Boolean)
        {
            Caption = 'Is Production';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Integration Mode")
        {
            Clustered = true;
        }
    }
}
