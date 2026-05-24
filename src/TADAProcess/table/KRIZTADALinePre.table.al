table 50156 KRIZTADALinePre
{
    Caption = 'TADA Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(62002; "ExpenseDate"; Date)
        {
            Caption = 'Expense Date';
            DataClassification = ToBeClassified;
        }

        field(62014; "TotalCost"; Decimal)
        {
            Caption = 'Total Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(62003; "FromCity"; Text[30])
        {
            Caption = 'From City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;

            // trigger OnLookup()
            // var
            //     PostCodeRec: Record "Post Code";
            // begin
            //     if Page.RunModal(Page::"Post Codes", PostCodeRec) = Action::LookupOK then
            //         Rec."FromCity" := PostCodeRec.City;
            // end;



            trigger OnValidate()
            begin
                if (fromCity <> ToCity) then begin
                    // Try to find cost by Personnel Number

                    kriztadaheaderper.Reset();
                    kriztadaheaderper.SetRange(kriztadaheaderper.Voucher, rec.Voucher);
                    if kriztadaheaderper.FindFirst() then;
                    KrizWorkerCostRec.Reset();
                    KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::Worker);
                    KrizWorkerCostRec.SetRange(Code, kriztadaheaderper.PersonnelNumber);
                    KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                    KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                    IsWorkerFound := KrizWorkerCostRec.FindFirst();

                    // If not found by worker, try by Worker Group
                    if not IsWorkerFound then begin
                        KrizWorkerCostRec.Reset();
                        KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::"Worker Group");
                        KrizWorkerCostRec.SetRange(Code, kriztadaheaderper."Worker Group Id");
                        KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                        KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                        IsWorkerFound := KrizWorkerCostRec.FindFirst();
                    end;

                    if IsWorkerFound then begin
                        "LodgingBoarding" := KrizWorkerCostRec."UnitCost";
                        "DAFactor" := true;
                        DADaysLimit := 1;
                    end;
                end else begin
                    "LodgingBoarding" := 0;
                    "DAFactor" := false;
                    DADaysLimit := 0;
                end;
            end;

        }
        field(62013; "ToCity"; Text[30])
        {
            Caption = 'To City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;

            trigger OnValidate()
            begin
                if (fromCity <> ToCity) then begin
                    // Try to find cost by Personnel Number

                    kriztadaheaderper.Reset();
                    kriztadaheaderper.SetRange(kriztadaheaderper.Voucher, rec.Voucher);
                    if kriztadaheaderper.FindFirst() then;
                    KrizWorkerCostRec.Reset();
                    KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::Worker);
                    KrizWorkerCostRec.SetRange(Code, kriztadaheaderper.PersonnelNumber);
                    KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                    KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                    IsWorkerFound := KrizWorkerCostRec.FindFirst();

                    // If not found by worker, try by Worker Group
                    if not IsWorkerFound then begin
                        KrizWorkerCostRec.Reset();
                        KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::"Worker Group");
                        KrizWorkerCostRec.SetRange(Code, kriztadaheaderper."Worker Group Id");
                        KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                        KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                        IsWorkerFound := KrizWorkerCostRec.FindFirst();
                    end;

                    if IsWorkerFound then begin
                        "LodgingBoarding" := KrizWorkerCostRec."UnitCost";
                        "DAFactor" := true;
                        DADaysLimit := 1;
                    end;
                end else begin
                    "LodgingBoarding" := 0;
                    "DAFactor" := false;
                    DADaysLimit := 0;
                end;
            end;



        }

        field(62025; "TransportationConveyanceExp"; Decimal)
        {
            Caption = 'Transportation or Conveyance Expense';
            DataClassification = ToBeClassified;
        }

        field(62022; "LodgingBoarding"; Decimal)
        {
            Caption = 'Lodging and Boarding';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                KrizWorkerCostRec: Record "KrizworkerCost";
                MaxAllowedUnitCost: Decimal;
                IsWorkerFound: Boolean;
            begin
                // Check if LodgingBoarding is being increased
                if ("LodgingBoarding" > xRec."LodgingBoarding") then begin

                    // First, try to find cost for the individual worker
                    KrizWorkerCostRec.Reset();
                    KrizWorkerCostRec.SetRange(Code, PersonnelNumber);
                    KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                    KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                    KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::Worker);
                    IsWorkerFound := KrizWorkerCostRec.FindFirst();

                    // If not found, check based on Worker Group
                    if not IsWorkerFound then begin
                        KrizWorkerCostRec.Reset();
                        KrizWorkerCostRec.SetRange(Code, WorkerGroupId);
                        KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                        KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                        KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::"Worker Group");
                        IsWorkerFound := KrizWorkerCostRec.FindFirst();
                    end;

                    // If cost found, compare
                    if IsWorkerFound then begin
                        MaxAllowedUnitCost := KrizWorkerCostRec."UnitCost";
                        if ("LodgingBoarding" > MaxAllowedUnitCost) then
                            Error('Lodging & Boarding Expense cannot be greater than Worker Cost %1', MaxAllowedUnitCost);
                    end;
                end;
            end;

        }
        field(62019; "CourierExpense"; Decimal)
        {
            Caption = 'Courier Expense';
            DataClassification = ToBeClassified;
        }
        field(62027; "MedicalExpense"; Decimal)
        {
            Caption = 'Medical Expense';
            DataClassification = ToBeClassified;
        }
        field(62032; "FoodExpense"; Decimal)
        {
            Caption = 'Food Expense';
            DataClassification = ToBeClassified;
        }
        field(62004; "FuelCashMemoNum"; Text[20])
        {
            Caption = 'Fuel Cash Memo No.';
            DataClassification = ToBeClassified;
        }

        field(62021; "FuelExpense"; Decimal)
        {
            Caption = 'Fuel Expense';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if FuelCashMemoNum = '' then
                    Error('Fuel Memo No. is Empty');
            end;
        }

        field(62008; "MaintenanceCashMemoNum"; Text[20])
        {
            Caption = 'Maintenance Cash Memo No.';
            DataClassification = ToBeClassified;
        }

        field(62023; "MaintenanceExpense"; Decimal)
        {
            Caption = 'Maintenance Expense';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if MaintenanceCashMemoNum = '' then
                    Error('Maintainance Memo No. is empty');
            end;
        }
        field(62011; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(62024; "PhoneExpense"; Decimal)
        {
            Caption = 'Phone Expense';
            DataClassification = ToBeClassified;
        }
        field(62031; "PhoneExpenseInvoiceNum"; Text[20])
        {
            Caption = 'Phone Expense Invoice Number';
            DataClassification = ToBeClassified;
        }
        field(62033; "CabExpense"; Decimal)
        {
            Caption = 'CAB TAXI Hire Charges SIO or MKT';
            DataClassification = ToBeClassified;
        }

        field(62034; "MeetingExpense"; Decimal)
        {
            Caption = 'Meeting Expense';
            DataClassification = ToBeClassified;
        }
        field(62035; "TravelExpense"; Decimal)
        {
            Caption = 'Travel Expense';
            DataClassification = ToBeClassified;
        }
        field(62036; "SalesandMarketingMonthMetting"; Decimal)
        {
            Caption = 'SALES or MARKETING MONTHLY MEETING';
            DataClassification = ToBeClassified;
        }
        field(62038; "Helmet"; Decimal)
        {
            Caption = 'Helmet';
            DataClassification = ToBeClassified;
        }
        field(62039; "CNIO"; Decimal)
        {
            Caption = 'CNIO';
            DataClassification = ToBeClassified;
        }
        field(62040; "HiredVehicle"; Decimal)
        {
            Caption = 'Hired Vehicle';
            DataClassification = ToBeClassified;
        }

        field(62041; "NameofHotel"; Text[60])
        {
            Caption = 'Name of Hotel';
            DataClassification = ToBeClassified;
        }
        field(62005; "HotelExpense"; Decimal)
        {
            Caption = 'Hotel Expense';
            DataClassification = ToBeClassified;
        }



        field(62007; "LineNum"; Decimal)
        {
            Caption = 'Line number';
            DataClassification = ToBeClassified;
        }


        field(62010; "PersonnelNumber"; Text[25])
        {
            Caption = 'Personnel number';
            DataClassification = ToBeClassified;
        }
        field(62018; "Voucher"; Text[20])
        {
            Caption = 'Voucher';
            DataClassification = ToBeClassified;
        }


        field(62020; "DADaysLimit"; Integer)
        {
            Caption = 'DA Days Limit';
            DataClassification = ToBeClassified;
        }

        field(62026; "DAFactor"; Boolean)
        {
            Caption = 'DA Factor';
            DataClassification = ToBeClassified;
        }

        field(62037; "WorkerGroupId"; Text[10])
        {
            Caption = 'Worker Designation Group';
            DataClassification = ToBeClassified;
            TableRelation = "Employee Statistics Group";
        }
        field(62050; employeeid; Text[25])
        {
            Caption = 'Employee Id';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(62051; "Starting Reading"; Integer)
        {
            Caption = 'Starting Reading';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if ("Closing Reading" < "Starting Reading") and ("Closing Reading" <> 0) then
                    Error('Closing Reading Cannot be Less than Starting Reading');

                "Net KM Covered" := "Closing Reading" - "Starting Reading";
            end;
        }
        field(62052; "Closing Reading"; Integer)
        {
            Caption = 'Closing Reading';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Starting Reading" = 0) then
                    Error('Starting Reading Cannot be zero');
                if ("Closing Reading" < "Starting Reading") then
                    Error('Closing Reading Cannot be Less than Starting Reading');

                "Net KM Covered" := "Closing Reading" - "Starting Reading";
            end;
        }
        field(62053; "Net KM Covered"; Integer)
        {
            Caption = 'Net KM Covered';
            DataClassification = ToBeClassified;
            Editable = false;
        }


    }

    keys
    {
        key(PK; LineNum, Voucher)
        {
            Clustered = true;
        }
    }

    var
        KrizWorkerCostRec: Record "KrizworkerCost";
        IsWorkerFound: Boolean;
        kriztadaheaderper: Record KRIZTADAHeaderPre;
        MaxAllowedUnitCost: Decimal;

    trigger OnModify()
    begin
        if ("LodgingBoarding" > xRec."LodgingBoarding") then begin

            kriztadaheaderper.Reset();
            kriztadaheaderper.SetRange(kriztadaheaderper.Voucher, rec.Voucher);
            if kriztadaheaderper.FindFirst() then;
            // First, try to find cost for the individual worker
            KrizWorkerCostRec.Reset();
            KrizWorkerCostRec.SetRange(Code, kriztadaheaderper.PersonnelNumber);
            KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
            KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
            KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::Worker);
            IsWorkerFound := KrizWorkerCostRec.FindFirst();

            // If not found, check based on Worker Group
            if not IsWorkerFound then begin
                KrizWorkerCostRec.Reset();
                KrizWorkerCostRec.SetRange(Code, kriztadaheaderper."Worker Group Id");
                KrizWorkerCostRec.SetRange("TA/DACost of", "KrizTA/DACostof"::"lodging Boarding");
                KrizWorkerCostRec.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                KrizWorkerCostRec.SetRange(Type, KrizWorkerCostType::"Worker Group");
                IsWorkerFound := KrizWorkerCostRec.FindFirst();
            end;

            // If cost found, compare
            if IsWorkerFound then begin
                MaxAllowedUnitCost := KrizWorkerCostRec."UnitCost";
                if ("LodgingBoarding" > KrizWorkerCostRec."UnitCost") then
                    Error('Lodging & Boarding Expense cannot be greater than Worker Cost %1', MaxAllowedUnitCost);
            end;
        end;

        rec.TotalCost := rec.TransportationConveyanceExp
                       + rec.LodgingBoarding
                       + rec.CourierExpense
                       + rec.MedicalExpense
                       + rec.FoodExpense
                       + rec.FuelExpense
                       + rec.MaintenanceExpense
                       + rec.PhoneExpense
                       + rec.HotelExpense
                       + rec.CabExpense
                       + rec.TravelExpense
                       + rec.MeetingExpense
                       + rec.SalesandMarketingMonthMetting
                       + rec.Helmet
                       + rec.CNIO
                       + rec.HiredVehicle

    end;


}