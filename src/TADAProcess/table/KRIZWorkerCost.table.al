table 50160 KrizworkerCost
{
    Caption = 'Worker Cost';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnLookup()
            var
                EmployeeRec: Record "Employee"; // Replace with actual Employee Table name
                WorkerGroupRec: Record "Employee Statistics Group";
                Result: Boolean;
            begin
                // Check the value of the Type field
                case "Type" of
                    Enum::KrizWorkerCostType::Worker:
                        begin
                            // Open the Employee List page and populate the Code field with selected Employee No.
                            Result := PAGE.RUNMODAL(5201, EmployeeRec) = ACTION::LookupOK;
                            if Result then
                                "Code" := EmployeeRec."No."; // Replace 'No.' with the field from Employee Table
                        end;

                    Enum::KrizWorkerCostType::"Worker Group":
                        begin
                            // Open the Worker Group List page
                            Result := PAGE.RUNMODAL(5216, WorkerGroupRec) = ACTION::LookupOK;
                            if Result then
                                "Code" := WorkerGroupRec.code; // Replace 'Code' with Worker Group Table field
                        end;

                    else
                        Error('Please select a valid Type before performing a lookup.');
                end;


            end;


        }
        field(2; "TA/DACost of"; Enum "KrizTA/DACostof")
        {
            Caption = 'TA/DA Cost of';
        }
        field(3; EffectiveDate; Date)
        {
            Caption = 'Effective Date';
        }
        field(4; NumberOfDays; Integer)
        {
            Caption = 'Number Of Days';
        }
        field(5; "TA/DA Period"; Enum "KrizTA/DAPeriodof")
        {
            Caption = 'TA/DAPeriod';
        }
        field(6; "Type"; Enum KrizWorkerCostType)
        {
            Caption = 'Type';

        }
        field(7; UnitCost; Decimal)
        {
            Caption = 'Unit Price';
        }

        field(9; EndingDate; Date)
        {
            Caption = 'Ending Date';
        }
        field(10; "carry Forward"; Boolean)
        {
            Caption = 'Carry Forward';
        }
    }

    keys
    {
        key(PK; "Code", "TA/DACost of", "TA/DA Period", Type)
        {
            Clustered = true;
        }
    }



}