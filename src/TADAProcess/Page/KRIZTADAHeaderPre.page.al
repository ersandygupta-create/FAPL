page 50187 KRIZTADAHeaderPrePage
{
    ApplicationArea = All;
    Caption = 'TADA Page';
    PageType = Document;
    SourceTable = KRIZTADAHeaderPre;

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
                field(TADAPeriod; Rec."TADA Period")
                {


                }

                field(KrizAutoSMSNo; Rec.KrizAutoSMSNo)
                {

                }
                field("Total Amount"; Rec."Total Amount")
                {

                }

            }
            part("CreateLines"; KRIZTADALinePrePage)
            {
                ApplicationArea = all;
                SubPageLink = Voucher = field(Voucher);
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
                ToolTip = 'Create Lines';
                Image = Create;

                trigger OnAction()
                var
                    TADAHeaderPost: Record KRIZTADAHeaderPost;
                    kriztadaperiod: Record krizTADAPeriod;
                begin

                    TADAHeaderPost.Reset();
                    TADAHeaderPost.SetRange(PersonnelNumber, rec.PersonnelNumber);
                    TADAHeaderPost.SetRange("TADA Period", rec."TADA Period");
                    if (TADAHeaderPost.FindFirst()) then
                        Error('Entry already posted for this Period');

                    REC.CreateLines();
                    krizTADAPeriod.Reset();
                    krizTADAPeriod.setrange(krizTADAPeriod.Code, rec."TADA Period");
                    if krizTADAPeriod.FindFirst() then begin
                        if ((krizTADAPeriod."To Date" + 45) < rec."Receiving Date") then
                            Message('Claim received after 45 days');
                    end;
                end;

            }
            action("Total")
            {
                ApplicationArea = all;
                ToolTip = 'Total';
                Image = Statistics;
                trigger OnAction()
                var
                    TADALinePre: Record KRIZTADALinePre;
                    KRIZTADAProcessValidator: Codeunit "KRIZ TADA Process Validator";
                    totalamount: Decimal;
                begin
                    totalamount := 0;
                    TADALinePre.Reset();
                    TADALinePre.SetRange(Voucher, rec.Voucher);
                    if TADALinePre.FindSet() then
                        repeat
                            totalamount += TADALinePre.TotalCost;
                        until TADALinePre.Next() = 0;

                    rec."Total Amount" := totalamount;

                end;
            }

            action("Post")
            {
                ApplicationArea = all;
                ToolTip = 'Post Document';
                Image = Post;
                trigger OnAction()
                var
                    TADALinePre: Record KRIZTADALinePre;
                    TADALinePretotal: Record KRIZTADALinePre;
                    KRIZTADAProcessValidator: Codeunit "KRIZ TADA Process Validator";
                    totalamount: Decimal;
                begin


                    TADALinePre.Reset();
                    TADALinePre.SetRange(Voucher, Rec.Voucher);
                    if TADALinePre.FindFirst() then
                        repeat
                            KRIZTADAProcessValidator.CheckExpense(TADALinePre);
                        until TADALinePre.Next() = 0;
                    KRIZTADAProcessValidator.GenerateTmpVoucher(rec);
                    // TADAParams.Reset();
                    // TADAParams.SetFilter(NumberSequenceSeries, '<>%1', '');
                    // if TADAParams.FindFirst() then;
                    // if (TADAParams.TADAPosting = true) then
                    //     GenJlnPost.Run(GenJnlLine);
                end;
            }


        }

    }

}