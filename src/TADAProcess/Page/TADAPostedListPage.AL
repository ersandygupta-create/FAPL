page 50191 TADAPostedListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = KRIZTADAHeaderPost;
    CardPageId = 50192;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    DelayedInsert = false;
    Caption = 'Posted TADA List Page';
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
                field("Worker Group Id"; Rec."Worker Group Id")
                {
                    ToolTip = 'Worker Group Id';
                }
                field("TADA Period"; Rec."TADA Period")
                {
                    ToolTip = 'TADA Period';
                }

                field("Penalty Amount"; Rec."Penalty Amount")
                {

                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Total Amount';
                }
                field("Posted Voucher No"; Rec."Posted Voucher No")
                {

                }
                field(PostedVoucherDate; Rec.PostedVoucherDate)
                {
                    Caption = 'Posted Voucher Date';
                }

            }
        }
    }




}