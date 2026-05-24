tableextension 50101 EmployeeTableExtension extends Employee
{
 
    fields
    {
        field(50001; VehicleCode; Code[30])
        {
            Caption = 'Vehicle Code';
            DataClassification = ToBeClassified;
        }
        field(50002; State; Code[10])
        {
            Caption = 'State';
	        TableRelation = State; 
            DataClassification = ToBeClassified;	
        }
        field(50003; BankBranch; Text[60])
        {
            Caption = 'Bank Branch';
            DataClassification = ToBeClassified;
        }
        field(50004; BankName; Text[60])
        {
            Caption = 'Bank Name';
            DataClassification = ToBeClassified;
        }
        field(50005; VehicleType; Enum VehicleType)
        {
            Caption = 'Vehicle Type';
            DataClassification = ToBeClassified;
        }
        field(50006; IFSCCode; Text[60])
        {
            Caption = 'IFSC Code';
            DataClassification = ToBeClassified;
        }
        field(50007; AllDaysMandatory; Boolean)
        {
            Caption = 'All Days Mandatory';
            DataClassification = ToBeClassified;
        }
        field(50008; HRCode; Code[20])
        {
            Caption = 'HR Code';
            DataClassification = ToBeClassified;
        }
        field(50009; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
        }
        field(50010; DateOfConfirmation; Date)
        {
            Caption = 'Date Of Confirmation';
            DataClassification = ToBeClassified;
        }
       
    }
 
   
}
 