table 50161 "KrizTADAParameter"
{
    Caption = 'TADA Parameter';
    DataClassification = ToBeClassified;
 
    fields
    {
        field(70001; BalanceAccount; Code[20])
        {
            Caption = 'Balance Account';
            TableRelation = "G/L Account";
        }
        field(3; CabExpenseAccount; Code[20])
        {
            Caption = 'CAB/ TAXI Hire Charges- SIO or MKT';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(4; CourierAccount; Code[20])
        {
            Caption = 'Courier Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(7; FuelAccount; Code[20])
        {
            Caption = 'Fuel Main Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(8; HotelAccount; Code[20])
        {
            Caption = 'Hotel main account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(9; JournalName; Code[10])
        {
            Caption = 'TA / DA journal name';
            // TableRelation can be added here if necessary, for example to Journal Templates or similar.
        }
        field(11; LodgingAccount; Code[20])
        {
            Caption = 'Lodging And Boarding Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(12; MaintenanceAccount; Code[20])
        {
            Caption = 'Maintenance Main Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(13; MedicalExpenseAccount; Code[20])
        {
            Caption = 'Medical Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(14; MeetingExpenseAccount; Code[20])
        {
            Caption = 'Meeting Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(16; PenaltyAccount; Code[20])
        {
            Caption = 'Penalty Main Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(17; PhoneAccount; Code[20])
        {
            Caption = 'Phone Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(18; RoundOffAccount; Code[20])
        {
            Caption = 'Rounding off main account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(20; TADAPosting; Boolean)
        {
            Caption = 'TA/DA Post';
        }
        field(21; TransportConveyanceAccount; Code[20])
        {
            Caption = 'Transportation / Conveyance Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(22; TravelExpenseAccount; Code[20])
        {
            Caption = 'Travelling Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(23; SalesMarketingAccount; Code[20])
        {
            Caption = 'SALES MARKETING MONTHLY MEETING';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(24; HelmetAccount; Code[20])
        {
            Caption = 'Helmet Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(25; CNIOAccount; Code[20])
        {
            Caption = 'CNIO Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(26; HiredVehicleAccount; Code[20])
        {
            Caption = 'Hired Vehicle Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        field(27; NumberSequenceSeries; Code[20])
        {
            Caption = 'Number Series';
            TableRelation = "No. Series";
        }
         field(28; FoodAccount; Code[20])
        {
            Caption = 'Food Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
         field(29; MainTainceAccount; Code[20])
        {
            Caption = 'Maintain Expense Account';
            TableRelation = "G/L Account"; // Assuming this should relate to the G/L Account
        }
        
    }
 
    keys
    {
        key(PK; BalanceAccount)
        {
 
        }
    }
 
    fieldgroups
    {
 
    }
}
 
 