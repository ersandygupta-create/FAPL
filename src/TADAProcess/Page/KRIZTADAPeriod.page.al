page 50183 krizTADAPeriod
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "krizTADAPeriod";
    Caption = 'Tada Period';
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(Group)
                {
                    field(Code; Rec.Code)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the unique code for the TADA period.';
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Provides a description for the TADA period.';
                    }
                    field("From Date"; Rec."From Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the start date of the TADA period.';
                    }
                    field("To Date"; Rec."To Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the end date of the TADA period.';
                    }
                    field("Negative Only"; Rec."Negative Only")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Indicates whether only negative adjustments are allowed for this period.';
                    }
                    field("Penalty Date"; Rec.PenaltyDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the end date of the TADA period.';
                    }
                    field(PenaltyAmount; Rec.PenaltyAmount)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the penalty amount applicable for this TADA period.';
                    }

                }
            }
        }
    }




}
