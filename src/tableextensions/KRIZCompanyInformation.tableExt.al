tableextension 50002 KRIZCompanyInformation extends "Company Information"
{
    fields
    {

        field(50001; CompanyCINNo; Code[21])
        {
            DataClassification = ToBeClassified;

            ToolTip = 'CIN No';
            Caption = 'CIN No.';

        }
        field(50002; MSMEUANNo; Code[21])
        {
            DataClassification = ToBeClassified;

            ToolTip = 'MSME No';
            Caption = 'MSME No.';

        }
    }





}