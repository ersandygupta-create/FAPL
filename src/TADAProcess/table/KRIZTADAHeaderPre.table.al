table 50155 KRIZTADAHeaderPre

{

    Caption = 'TADA Header';
    DataClassification = ToBeClassified;

    fields
    {

        field(63014; "Receiving Date"; Date)

        {

            Caption = 'Receiving Date';

            DataClassification = ToBeClassified;

        }
        field(63015; "Document Date"; Date)

        {

            Caption = 'Document Date';
            Editable = false;
            DataClassification = ToBeClassified;

        }
        field(63016; "Voucher"; Code[20])

        {

            Caption = 'Voucher';

            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(63007; "PersonnelNumber"; Code[25])

        {

            Caption = 'Personnel number';

            DataClassification = ToBeClassified;

            TableRelation = Employee;

            trigger OnValidate()

            Var

                EmployeeRec: Record Employee;

            begin

                if EmployeeRec.Get(Rec.PersonnelNumber) then begin
                    Rec.Name := EmployeeRec.FullName();
                    rec."Worker Group Id" := EmployeeRec."Statistics Group Code";
                    if EmployeeRec.Closed = true then
                        error('This Employee is closed.');
                    if EmployeeRec.HRCode = '' then
                        error('HR Code not defined on employee %1.', Rec.PersonnelNumber);
                    if EmployeeRec."Statistics Group Code" = '' then
                        error('Worker Group Id not defined on employee %1.', Rec.PersonnelNumber);
                    if EmployeeRec.State = '' then
                        error('State not defined on employee %1.', Rec.PersonnelNumber);
                    // if EmployeeRec.AutoEmail = '' then
                    //     error('Auto Email not defined on employee %1.', Rec.PersonnelNumber);


                end else
                    Error('Employee not found for the given ID.');

            end;

        }
        field(63006; Name; Text[100])

        {

            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(63013; "TADA Period"; Code[20])

        {

            Caption = 'TADA Period';

            DataClassification = ToBeClassified;

            TableRelation = "krizTADAPeriod";
            trigger OnValidate()
            var
                TADAperiod: Record krizTADAPeriod;
            begin
                if TADAperiod.Get(rec."TADA Period") Then
                    Rec."Document Date" := TADAperiod."To Date";
            end;

        }


        field(63008; "PostedVoucherDate"; Date)

        {

            Caption = 'Posted Voucher Date';

            DataClassification = ToBeClassified;

        }

        field(63009; "Posted Voucher No"; Code[20])

        {

            Caption = 'Posted Voucher No';

            DataClassification = ToBeClassified;

        }

        field(63023; "KrizAutoSMSNo"; Code[10])

        {

            Caption = 'Auto SMS No.';

            DataClassification = ToBeClassified;

        }
        field(63024; "Worker Group Id"; Code[10])

        {

            Caption = 'Worker Group Id';

            DataClassification = ToBeClassified;
            TableRelation = "Employee Statistics Group";
            Editable = false;

        }
        field(63025; "Total Amount"; Decimal)
        {

            Caption = 'Total Amount';

            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(63026; "Posting Date"; Date)

        {

            Caption = 'Posting Date';

            DataClassification = ToBeClassified;

        }

    }

    keys

    {
        key(PK; "Receiving Date", Voucher)

        {

            Clustered = true;

        }


    }
    trigger OnInsert()
    var
        TadaParam: Record KrizTADAParameter;
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if "Voucher" = '' then begin
            TadaParam.Reset();
            TadaParam.SetFilter(NumberSequenceSeries, '<>%1', '');
            if TadaParam.FindFirst() then begin
                if TadaParam.NumberSequenceSeries <> '' then begin
                    "Voucher" := NoSeriesMgt.GetNextNo(
                        TadaParam.NumberSequenceSeries,
                        WorkDate(),
                        true);
                    "Posting Date" := WorkDate();
                end else
                    Error('Voucher No. Series not defined in Tada Parameter.');
            end else
                Error('Tada Parameter not found.');
        end;
    end;

    trigger OnDelete()
    var
        TADALine: Record KRIZTADALinePre;
    begin
        TADALine.Reset();
        TADALine.SetRange(Voucher, rec.Voucher);
        if TADALine.FindSet() then
            TADALine.DeleteAll();
    end;


    procedure CreateLines()
    var
        TADAPeriodDate: Record krizTADAPeriod;
        TADALineRec: Record KRIZTADALinePre;
        LineDate: Date;
        LineNo: Integer;
        employee: record Employee;


    begin

        employee.get(PersonnelNumber);
        if (employee.City = '') then
            Message('City Should not be blank on Employee Card');

        TADALineRec.Reset();
        TADALineRec.SetRange(Voucher, Voucher);
        // Optional: Check if Lines already exist
        if TADALineRec.FindFirst() then begin
            Message('Lines already exist for this Header.');
            exit;
        end;

        TADAPeriodDate.Reset();
        TADALineRec.Reset();
        TADAPeriodDate.SetRange(Code, "TADA Period");
        if not TADAPeriodDate.FindFirst() then
            Error('TADA Period is not Found for this Voucher');

        LineDate := TADAPeriodDate."From Date"; // You can also add a separate field like 'Start Date' in Header if you want.
        LineNo := 10000;
        while LineDate <= TADAPeriodDate."To Date"
        do begin
            TADALineRec.Init();
            TADALineRec.Voucher := Voucher;
            TADALineRec.LineNum := LineNo;
            TADALineRec.ExpenseDate := LineDate;
            TADALineRec.employeeid := PersonnelNumber;
            TADALineRec.WorkerGroupId := "Worker Group Id";
            employee.get(PersonnelNumber);
            TADALineRec.FromCity := employee.City;
            TADALineRec.ToCity := employee.City;
            TADALineRec.Insert();
            LineDate := LineDate + 1;
            LineNo := LineNo + 10000;

        end;
    end;

    Procedure TotalAmount() _TotalAmount: Decimal
    var
        TADALinePre: Record KRIZTADALinePre;
    // CourierExpense: Decimal;
    // FuelExpense: Decimal;
    // HotelExpense: Decimal;
    // LodgingExpense: Decimal;
    // MaintinenseExpense: Decimal;
    // PhoneExpense: Decimal;
    // TransportExpense: Decimal;
    // MedicalExpense: Decimal;
    // FoodExpense: Decimal;
    // CabExpense: Decimal;
    // TravelExpense: Decimal;
    // MeetingExpense: Decimal;
    // SalesandMarExpense: Decimal;


    begin
        TADALinePre.reset();
        TADALinePre.SetRange(Voucher, Rec.Voucher);
        if TADALinePre.FindSet() then begin
            TADALinePre.CalcSums(CourierExpense);
            TADALinePre.CalcSums(FuelExpense);
            TADALinePre.CalcSums(HotelExpense);
            TADALinePre.CalcSums(LodgingBoarding);
            TADALinePre.CalcSums(MaintenanceExpense);
            TADALinePre.CalcSums(PhoneExpense);
            TADALinePre.CalcSums(TransportationConveyanceExp);
            TADALinePre.CalcSums(MedicalExpense);
            TADALinePre.CalcSums(FoodExpense);
            TADALinePre.CalcSums(CabExpense);
            TADALinePre.CalcSums(TravelExpense);
            TADALinePre.CalcSums(MeetingExpense);
            TADALinePre.CalcSums(SalesandMarketingMonthMetting);
            _TotalAmount := TADALinePre.CourierExpense + TADALinePre.FuelExpense + TADALinePre.HotelExpense
                            + TADALinePre.LodgingBoarding + TADALinePre.MaintenanceExpense + TADALinePre.PhoneExpense
                            + TADALinePre.TransportationConveyanceExp + TADALinePre.MedicalExpense + TADALinePre.FoodExpense
                            + TADALinePre.CabExpense + TADALinePre.TravelExpense + TADALinePre.MeetingExpense +
                            TADALinePre.SalesandMarketingMonthMetting;
        end;
        exit(_TotalAmount);

    end;


}

