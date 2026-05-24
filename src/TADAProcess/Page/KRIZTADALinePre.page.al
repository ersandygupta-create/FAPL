

page 50186 KRIZTADALinePrePage

{

    ApplicationArea = All;

    Caption = 'TADA Line Pre';

    PageType = ListPart;

    SourceTable = KRIZTADALinePre;

    //UsageCategory = Administration;


    layout

    {

        area(Content)

        {

            repeater(General)

            {

                field(ExpenseDate; Rec.ExpenseDate)

                {

                    ToolTip = 'Specifies the value of the Expense Date field.', Comment = '%';

                }

                field(TotalCost; Rec.TotalCost)

                {

                    ToolTip = 'Specifies the value of the Total Cost field.', Comment = '%';

                }

                field(FromCity; Rec.FromCity)

                {

                    ToolTip = 'Specifies the value of the From City field.', Comment = '%';

                }

                field(ToCity; Rec.ToCity)

                {

                    ToolTip = 'Specifies the value of the To City field.', Comment = '%';

                }

                field("Starting Reading"; Rec."Starting Reading")

                {

                    ToolTip = 'Specifies the value of the Starting Reading field.', Comment = '%';

                }
                field("Closing Reading"; Rec."Closing Reading")

                {

                    ToolTip = 'Specifies the value of the Closing Reading field.', Comment = '%';

                }
                field("Net KM Covered"; Rec."Net KM Covered")

                {

                    ToolTip = 'Specifies the value of the "Net KM Covered" field.', Comment = '%';

                }


                field(TransportationConveyanceExp; Rec.TransportationConveyanceExp)

                {

                    ToolTip = 'Specifies the value of the Transportation or Conveyance Expense field.', Comment = '%';

                }

                field(LodgingBoarding; Rec.LodgingBoarding)

                {

                    ToolTip = 'Specifies the value of the Lodging and Boarding field.', Comment = '%';

                }

                field(CourierExpense; Rec.CourierExpense)

                {

                    ToolTip = 'Specifies the value of the Courier Expense field.', Comment = '%';

                }

                field(MedicalExpense; Rec.MedicalExpense)

                {

                    ToolTip = 'Specifies the value of the Medical Expense field.', Comment = '%';

                }

                field(FoodExpense; Rec.FoodExpense)

                {

                    ToolTip = 'Specifies the value of the Food Expense field.', Comment = '%';

                }


                field(FuelCashMemoNum; Rec.FuelCashMemoNum)

                {

                    ToolTip = 'Specifies the value of the Fuel Cash Memo No. field.', Comment = '%';

                }

                field(FuelExpense; Rec.FuelExpense)

                {

                    ToolTip = 'Specifies the value of the Fuel Expense field.', Comment = '%';

                }

                field(MaintenanceCashMemoNum; Rec.MaintenanceCashMemoNum)

                {

                    ToolTip = 'Specifies the value of the Maintenance Cash Memo No. field.', Comment = '%';

                }

                field(MaintenanceExpense; Rec.MaintenanceExpense)

                {

                    ToolTip = 'Specifies the value of the Maintenance Expense field.', Comment = '%';

                }

                field(Remarks; Rec.Remarks)

                {

                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';

                }

                field(PhoneExpense; Rec.PhoneExpense)

                {

                    ToolTip = 'Specifies the value of the Phone Expense field.', Comment = '%';

                }

                field(PhoneExpenseInvoiceNum; Rec.PhoneExpenseInvoiceNum)

                {

                    ToolTip = 'Specifies the value of the Phone Expense Invoice Number field.', Comment = '%';

                }

                field(CabExpense; Rec.CabExpense)

                {

                    ToolTip = 'Specifies the value of the CAB TAXI Hire Charges SIO or MKT field.', Comment = '%';

                }

                field(MeetingExpense; Rec.MeetingExpense)

                {

                    ToolTip = 'Specifies the value of the Meeting Expense field.', Comment = '%';

                }

                field(TravelExpense; Rec.TravelExpense)

                {

                    ToolTip = 'Specifies the value of the Travel Expense field.', Comment = '%';

                }

                field(SalesandMarketingMonthMetting; Rec.SalesandMarketingMonthMetting)

                {

                    ToolTip = 'Specifies the value of the SALES or MARKETING MONTHLY MEETING field.', Comment = '%';

                }

                field(Helmet; Rec.Helmet)

                {

                    ToolTip = 'Specifies the value of the Helmet field.', Comment = '%';
                    Visible = false;
                }

                field(CNIO; Rec.CNIO)

                {

                    ToolTip = 'Specifies the value of the CNIO field.', Comment = '%';
                    Visible = false;
                }

                field(HiredVehicle; Rec.HiredVehicle)

                {

                    ToolTip = 'Specifies the value of the Hired Vehicle field.', Comment = '%';

                }

                field(NameofHotel; Rec.NameofHotel)

                {

                    ToolTip = 'Specifies the value of the Name of Hotel field.', Comment = '%';

                    TableRelation = krizHotelTable;
                    Visible = false;

                }

                field(HotelExpense; Rec.HotelExpense)

                {

                    ToolTip = 'Specifies the value of the Hotel Expense field.', Comment = '%';
                    Visible = false;
                }

            }

        }

    }

}

