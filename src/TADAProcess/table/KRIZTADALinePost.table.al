table 50158 KRIZTADALinePost
{
    Caption = 'TADA Line Post';
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
            TableRelation = "Post Code";
        }
        field(62013; "ToCity"; Text[30])
        {
            Caption = 'To City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
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
        }
        field(62052; "Closing Reading"; Integer)
        {
            Caption = 'Closing Reading';
            DataClassification = ToBeClassified;
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
}