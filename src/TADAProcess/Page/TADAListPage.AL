page 50190 TADAListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = KRIZTADAHeaderPre;
    CardPageId = 50187;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Receiving Date"; Rec."Receiving Date")
                {
                    ToolTip = 'Receiving Date';
                }
                field(Voucher; Rec.Voucher)
                {
                    ToolTip = 'Voucher No';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Document Date';
                }
                field(PersonnelNumber; Rec.PersonnelNumber)
                {
                    ToolTip = 'Employee No';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Employee Name';
                }
                field("TADA Period"; Rec."TADA Period")
                {
                    ToolTip = 'TADA Period';
                }
            }
        }
    }




}