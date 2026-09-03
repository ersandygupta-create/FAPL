pageextension 50006 KRIZCompanyInformationPageExt extends "Company Information"
{
    layout
    {
        addafter("State Code")
        {
            field(CompanyCINNo; rec.CompanyCINNo)
            {
                ApplicationArea = all;
            }
            field(MSMEUANNo; rec.MSMEUANNo)
            {
                ApplicationArea = all;
            }
        }

    }




}