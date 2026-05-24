page 50181 KrizworkerCost
{
    PageType = List;
    Caption = 'Worker Cost';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = KrizworkerCost;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(Group)
                {
                    field(EffectiveDate; Rec.EffectiveDate)
                    {
                        ApplicationArea = all;
                    }

                    field("Type"; Rec.Type)
                    {
                        ApplicationArea = all;
                    }
                    field("Code"; Rec.Code)
                    {
                        ApplicationArea = all;
                    }
                    field("TA/DACost of"; Rec."TA/DACost of")
                    {
                        ApplicationArea = all;
                    }
                    field("TA/DA Period"; Rec."TA/DA Period")
                    {
                        ApplicationArea = all;
                    }

                    field(NumberOfDays; Rec.NumberOfDays)
                    {
                        ApplicationArea = all;
                    }
                    field(UnitCost; Rec.UnitCost)
                    {
                        ApplicationArea = all;
                    }

                    field(EndingDate; Rec.EndingDate)
                    {
                        ApplicationArea = all;
                    }
                    field(carryForward; Rec."carry Forward")
                    {
                        ApplicationArea = all;
                    }
                }


            }

        }
    }
}