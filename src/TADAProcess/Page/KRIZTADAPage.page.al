page 50188 "Kriz TADA Card Page"
{
    PageType = List;
    Caption = 'TER';
    SourceTable = KRIZTADAHeaderPre; // Primary source table
    ApplicationArea = All;
    RefreshOnActivate = true;
    UsageCategory =Administration;
 
    layout
    {
        area(content)
        {
 
            part(KrizHeaderPart; KRIZTADAHeaderPrePage)
            {
                ApplicationArea = ALL;
 
            }
            part("Create Lines"; KRIZTADALinePrePage)
            {
                ApplicationArea = all;
            }
 
 
        }
    }
 
    actions
    {
        area(Processing)
        {
 
            action("Create Line")
            {
                ApplicationArea = all;
                ToolTip = 'Create Line';
                Image = AddAction;
                trigger OnAction()
                begin   
                    REC.CreateLines();
                end;
            }
           
 
 
        }
        // You can define actions if necessary, such as buttons to create, modify, or delete records
    }
 
}
 
 