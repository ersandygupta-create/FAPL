page 50192 KRIZTADAPostedCardPage
{
    ApplicationArea = All;
    Caption = 'Posted TADA';
    PageType = Document;
    SourceTable = KRIZTADAHeaderPost;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }

                field(ReceivingDate; Rec."Receiving Date")
                {
                }
                field(Voucher; Rec.Voucher)
                {

                }
                field(TransDate; Rec."Document Date")
                {

                }
                field(PersonnelNumber; Rec.PersonnelNumber)
                {

                }
                field(PersonnelName; Rec.Name)
                {

                }
                field("Worker Group Id"; Rec."Worker Group Id")
                {

                }
                field(TADAPeriod; Rec."TADA Period")
                {


                }

                field(KrizAutoSMSNo; Rec.KrizAutoSMSNo)
                {

                }
                field("Penalty Amount"; Rec."Penalty Amount")
                {

                }
                field("Total Amount"; Rec."Total Amount")
                {

                }
                field("Posted Voucher No"; Rec."Posted Voucher No")
                {

                }
                field(PostedVoucherDate; Rec.PostedVoucherDate)
                {
                    Caption = 'Posted Voucher Date';
                }

            }
            part("CreateLines"; KRIZTADALinePostPage)
            {
                ApplicationArea = all;
                SubPageLink = Voucher = field(Voucher);
            }

        }

    }
    actions
    {

    }

}