pageextension 50101 EmloyeePageExtension extends "Employee Card"
{
    layout
    {
        addafter(Payments)
        {
            group("Additional Fields")
            {

                field(VehicleCode; Rec.VehicleCode)
                {
                    ApplicationArea = all;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = all;
                }
                field("BankBranch"; Rec.BankBranch)
                {
                    ApplicationArea = all;
                }
                field(BankName; Rec.BankName)
                {
                    ApplicationArea = all;
                }
                field(VehicleType; Rec.VehicleType)
                {
                    ApplicationArea = all;
                }
                field(IFSCCode; Rec.IFSCCode)
                {
                    ApplicationArea = all;
                }

                field(AllDaysMandatory; Rec.AllDaysMandatory)
                {
                    ApplicationArea = all;
                }

                field(HRCode; Rec.HRCode)
                {
                    ApplicationArea = all;
                }

                field(Closed; Rec.Closed)
                {
                    ApplicationArea = all;
                }

                field(DateOfConfirmation; Rec.DateOfConfirmation)
                {
                    ApplicationArea = all;
                }

            }
        }
        // Add changes to page layout here
    }

    actions
    {

        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
