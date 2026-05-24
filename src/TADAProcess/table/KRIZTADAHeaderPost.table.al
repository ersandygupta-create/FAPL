table 50157 KRIZTADAHeaderPost

{

    Caption = 'TADA Header Post';
    DataClassification = ToBeClassified;

    fields
    {

        field(63014; "Receiving Date"; Date)

        {

            Caption = 'Receiving Date';

            DataClassification = ToBeClassified;

        }
        field(63015; "Document Date"; Date)

        {

            Caption = 'Document Date';

            DataClassification = ToBeClassified;

        }
        field(63016; "Voucher"; Code[20])

        {

            Caption = 'Voucher';

            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(63007; "PersonnelNumber"; Code[25])

        {

            Caption = 'Personnel number';

            DataClassification = ToBeClassified;

            TableRelation = Employee;

            trigger OnValidate()

            Var

                EmployeeRec: Record Employee;

            begin

                if EmployeeRec.Get(Rec.PersonnelNumber) then begin
                    Rec.Name := EmployeeRec.FullName();
                    rec."Worker Group Id" := EmployeeRec."Statistics Group Code"

                end else
                    Error('Employee not found for the given ID.');

            end;

        }
        field(63006; Name; Text[100])

        {

            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(63013; "TADA Period"; Code[20])

        {

            Caption = 'TADA Period';

            DataClassification = ToBeClassified;

            TableRelation = "krizTADAPeriod";

        }


        field(63008; "PostedVoucherDate"; Date)

        {

            Caption = 'Posted Voucher Date';

            DataClassification = ToBeClassified;

        }

        field(63009; "Posted Voucher No"; Code[20])

        {

            Caption = 'Posted Voucher No';

            DataClassification = ToBeClassified;

        }

        field(63023; "KrizAutoSMSNo"; Code[10])

        {

            Caption = 'Auto SMS No.';

            DataClassification = ToBeClassified;

        }
        field(63024; "Worker Group Id"; Code[10])

        {

            Caption = 'Worker Group Id';

            DataClassification = ToBeClassified;
            TableRelation = "Employee Statistics Group";
            Editable = false;

        }
        field(63025; "Total Amount"; Decimal)
        {

            Caption = 'Total Amount';

            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(63026; "Posting Date"; Date)

        {

            Caption = 'Posting Date';

            DataClassification = ToBeClassified;

        }
        field(63050; "Penalty Amount"; Decimal)

        {

            Caption = 'Penalty Amount';

            DataClassification = ToBeClassified;

        }



    }

    keys

    {
        key(PK; "Receiving Date", Voucher)

        {

            Clustered = true;

        }


    }


}

