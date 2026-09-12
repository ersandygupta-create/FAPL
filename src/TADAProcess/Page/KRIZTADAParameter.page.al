page 50182 "KRIZTADAParameter"
{
    ApplicationArea = All;
    SourceTable = KrizTADAParameter;
    Caption = 'Tada Parameter';
    UsageCategory = Administration;
    DeleteAllowed = true;
    //InsertAllowed = false;

    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(BalanceAccount; Rec.BalanceAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Balance Account.';
                }
                field(CabExpenseAccount; Rec.CabExpenseAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Cab Expense Account.';
                }
                field(CourierAccount; Rec.CourierAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Courier Expense Account.';
                }
                field(FuelLedger; Rec.FuelAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Fuel Account for FBT.';
                }
                field(HotelLedger; Rec.HotelAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Hotel Expense Account.';
                }
                field(LodgingLedger; Rec.LodgingAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Lodging Expense Account.';
                }
                field(MaintFBTLedger; Rec.MaintenanceAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Maintenance Expense Account.';
                }
                field(MedicalExpenseAccount; Rec.MedicalExpenseAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Medical Expense Account.';
                }
                field(MeetingExpenseAccount; Rec.MeetingExpenseAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Meeting Expense Account.';
                }
                field(PhoneLedger; Rec.PhoneAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Phone Expense Account.';
                }
                field(TransportConveyanceLedger; Rec.TransportConveyanceAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Transport Conveyance Account.';
                }
                field(TravelExpenseAccount; Rec.TravelExpenseAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Travel Expense Account.';
                }
                field(SalesMarketingMonthly; Rec.SalesMarketingAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Sales and Marketing Monthly Account.';
                }
                field(HelmetLedger; Rec.HelmetAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Helmet Purchase/Expense Account.';
                }
                field(CNIOLedger; Rec.CNIOAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the CNIO (Customer Non-Inventory Orders) Account.';
                }
                field(FoodLedger; Rec.FoodAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Food Expense Account.';
                }
                field(MaintainanceLedger; Rec.MainTainceAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Maintainance Account.';
                }
                field(HiredVehicleLedger; Rec.HiredVehicleAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Hired Vehicle Expense Account.';
                }
                field(JournalName; Rec.JournalName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the default Journal Name for TADA Posting.';
                }
                field(TADAPosting; Rec.TADAPosting)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable or disable TADA Posting functionality.';
                }
                field(RoundOffLedger; Rec.RoundOffAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Round-Off Ledger Account.';
                }
                field(PenaltyLedger; Rec.PenaltyAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Penalty Expense Account.';
                }
                field(NumberSequenceSeries; REC.NumberSequenceSeries)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Voucher Number Sequence';

                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            // Add actions here if required
        }
    }
}
