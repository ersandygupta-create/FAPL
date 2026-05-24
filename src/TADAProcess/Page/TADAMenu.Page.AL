pageextension 50189 TADAMenu extends 9022
{

    actions
    {
        addlast(sections)
        {
            group(TADA)
            {
                group(Common)
                {
                    action("Employee")
                    {
                        RunObject = page "Employee List";
                        ApplicationArea = all;
                    }
                    action(TER)
                    {
                        RunObject = page 50190;
                        ApplicationArea = all;
                    }
                }

                group(Setup)
                {
                    action("TADA Parameter")
                    {
                        RunObject = page KRIZTADAParameter;
                        ApplicationArea = all;
                    }
                    action("Worker Cost")
                    {
                        RunObject = page KrizworkerCost;
                        ApplicationArea = all;
                    }
                    action("Worker Group")
                    {
                        RunObject = page "Employee Statistics Groups";
                        ApplicationArea = all;
                    }
                    action("TADA Period")
                    {
                        RunObject = page krizTADAPeriod;
                        ApplicationArea = all;
                    }

                    action("Hotel Master")
                    {
                        RunObject = page KRIZTADAHotel;
                        ApplicationArea = all;
                    }

                }
                group(Posted)
                {
                    action("Posted TADA")
                    {
                        RunObject = page TADAPostedListPage;
                        ApplicationArea = all;
                    }

                }


            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}