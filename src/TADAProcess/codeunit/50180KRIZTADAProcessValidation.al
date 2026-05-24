codeunit 50180 "KRIZ TADA Process Validator"
{
    SingleInstance = true;
    Subtype = Normal;

    procedure CheckExpense(KRIZTADALinePre: Record KRIZTADALinePre);
    var
        KRIZTADAHeaderPre: record KRIZTADAHeaderPre;
        krizTADAPeriod: Record krizTADAPeriod;
        Employee: Record Employee;
        tadaperioddate: Date;
        tadaperiodTodate: Date;
        TADAHeaderPost: record KRIZTADAHeaderPost;

    begin

        KRIZTADAHeaderPre.Reset();
        KRIZTADAHeaderPre.SetRange(Voucher, KRIZTADALinePre.Voucher);
        if KRIZTADAHeaderPre.FindFirst() then begin
            krizTADAPeriod.Reset();
            krizTADAPeriod.SetRange(Code, KRIZTADAHeaderPre."TADA Period");
            if krizTADAPeriod.FindFirst() Then begin
                tadaperioddate := krizTADAPeriod."From Date";
                tadaperiodtodate := krizTADAPeriod."To Date";
            end;



        end;

        TADAHeaderPost.Reset();
        TADAHeaderPost.SetRange(PersonnelNumber, KRIZTADAHeaderPre.PersonnelNumber);
        TADAHeaderPost.SetRange("TADA Period", KRIZTADAHeaderPre."TADA Period");
        if (TADAHeaderPost.FindFirst()) then
            Error('Entry Already posted for this Period');

        KRIZTADAHeaderPre.Reset();
        KRIZTADAHeaderPre.SetRange(Voucher, KRIZTADALinePre.Voucher);
        if KRIZTADAHeaderPre.FindFirst() then begin
            //if ((tadaperiodtodate + 45) < KRIZTADAHeaderPre."Receiving Date") then
            //  Error('Claim received after 45 days');
            if (KRIZTADAHeaderPre."Posting Date" < KRIZTADAHeaderPre."Receiving Date") then
                error('Receiving Date should not be greater than posting date');
        end;


        Employee.Get(KRIZTADAHeaderPre.PersonnelNumber);

        validateEmployeeFields(Employee);

        if (KRIZTADAHeaderPre."Posting Date" = 0D) then
            Error('Posting Date should not be blank');

        if (KRIZTADALinePre.FoodExpense <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::FoodExpense, KRIZTADALinePre.FoodExpense
            , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.CourierExpense <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::CourierExpense, KRIZTADALinePre.CourierExpense
            , tadaperioddate, tadaperiodTodate);

        if (Employee.VehicleType = VehicleType::"2W") then
            if (KRIZTADALinePre.FuelExpense <> 0) then
                ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::FuelExpense2W, KRIZTADALinePre.FuelExpense
                , tadaperioddate, tadaperiodTodate);

        if (Employee.VehicleType = VehicleType::"4W") then
            if (KRIZTADALinePre.FuelExpense <> 0) then
                ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::FuelExpense4W, KRIZTADALinePre.FuelExpense
                , tadaperioddate, tadaperiodTodate);

        if (Employee.VehicleType = VehicleType::"2W") then
            if (KRIZTADALinePre.MaintenanceExpense <> 0) then
                ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::MaintenanceExpense2W, KRIZTADALinePre.MaintenanceExpense
                , tadaperioddate, tadaperiodTodate);

        if (Employee.VehicleType = VehicleType::"4W") then
            if (KRIZTADALinePre.MaintenanceExpense <> 0) then
                ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::MaintenanceExpense4W, KRIZTADALinePre.MaintenanceExpense
                , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.HotelExpense <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::HotelExpense, KRIZTADALinePre.HotelExpense
            , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.LodgingBoarding <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::"lodging Boarding", KRIZTADALinePre.LodgingBoarding
            , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.TransportationConveyanceExp <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::TransportNConveyanceExpense, KRIZTADALinePre.TransportationConveyanceExp
            , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.PhoneExpense <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::"Phone Expense", KRIZTADALinePre.PhoneExpense
            , tadaperioddate, tadaperiodTodate);

        if (KRIZTADALinePre.MedicalExpense <> 0) then
            ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::MedicalExpense, KRIZTADALinePre.MedicalExpense
            , tadaperioddate, tadaperiodTodate);

        ValidateExpense(KRIZTADALinePre.employeeid, "KrizTA/DACostof"::DADaysLimit, KRIZTADALinePre.DADaysLimit
        , tadaperioddate, tadaperiodTodate);




    end;

    procedure ValidateExpense(EmployeeId: Code[25]; ExpenseType: Enum "KrizTA/DACostof"; NewAmount: Decimal;
                                                                     PostingDate: Date; tadaperiodTodate: Date)
    var
        KrizworkerCost: Record KrizworkerCost;
        employee: Record Employee;
        PeriodStart: Date;
        PeriodEnd: Date;
        YearStart: Date;
        UsedAmount: Decimal;
        AllowedLimit: Decimal;
        MonthCounter: Integer;
        CurrMonth: Integer;
        i: Integer;
        employeeJoiningmonth: Integer;
        employeeJoiningYear: Integer;
        Daysinmonth: Integer;
        employeeJoiningDay: Integer;
        DaysinQtr: Integer;
        YearofPostingDate: Integer;
        QuarterEndDate: Date;
        QuarterFromPostingDate: Integer;
        QuarterfromEmploymentDate: Integer;
        totalQtrDaysApplicable: Integer;
        HalfYearEndDate: date;
        totalHalfYearDaysApplicable: Integer;
        HalfYearfromEmploymentDate: Integer;
        DaysinHalfYear: Integer;
        DaysinFullYear: Integer;
        FullYearApplicableDays: integer;
        EmployeeQuarterEndDate: Date;
        YearStartDate: Date;
        YearENDDate: Date;
    begin
        AllowedLimit := 0;
        //if not KrizworkerCost.Get(ExpenseType) then
        //  Error('Setup not found for expense type %1.', ExpenseType);
        clear(employee);
        employee.Get(EmployeeId);
        if (ExpenseType = Enum::"KrizTA/DACostof"::"lodging Boarding") then begin
            KrizworkerCost.Reset();
            KrizworkerCost.SetRange(code, EmployeeId);
            KrizworkerCost.setrange("TA/DACost of", ExpenseType);
            KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
            KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
            KrizWorkerCost.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
            if KrizworkerCost.FindFirst() then begin
                AllowedLimit := KrizworkerCost.UnitCost;
                UsedAmount := GetUsedLodBord(EmployeeId, ExpenseType, PostingDate, tadaperiodtodate)
            end else
                if (AllowedLimit = 0) then begin
                    KrizworkerCost.Reset();
                    KrizworkerCost.SetRange(code, employee."Statistics Group Code");
                    KrizworkerCost.setrange("TA/DACost of", ExpenseType);
                    KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
                    KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
                    KrizWorkerCost.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Daily);
                    if KrizworkerCost.FindFirst() then
                        AllowedLimit := KrizworkerCost.UnitCost;
                    UsedAmount := GetUsedLodBord(EmployeeId, ExpenseType, PostingDate, tadaperiodtodate);
                end;

            if (UsedAmount) > AllowedLimit then
                Error('Limit exceeded for %1. Allowed: %2, Used: %3', ExpenseType, AllowedLimit, UsedAmount);

        end else if (ExpenseType = Enum::"KrizTA/DACostof"::DADaysLimit) then begin
            YearStartDate := DMY2Date(1, 1, Date2DMY(PostingDate, 3));
            YearEndDate := DMY2Date(31, 12, Date2DMY(PostingDate, 3));

            KrizworkerCost.Reset();
            KrizworkerCost.SetRange(code, EmployeeId);
            KrizworkerCost.setrange("TA/DACost of", ExpenseType);
            KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
            KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
            KrizWorkerCost.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Yearly);
            if KrizworkerCost.FindFirst() then begin
                AllowedLimit := KrizworkerCost.NumberOfDays;
                UsedAmount := GetUsed(EmployeeId, ExpenseType, YearStartDate, YearENDDate)
            end else
                if (AllowedLimit = 0) then begin
                    KrizworkerCost.Reset();
                    KrizworkerCost.SetRange(code, employee."Statistics Group Code");
                    KrizworkerCost.setrange("TA/DACost of", ExpenseType);
                    KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
                    KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
                    KrizWorkerCost.SetRange("TA/DA Period", "KrizTA/DAPeriodof"::Yearly);
                    if KrizworkerCost.FindFirst() then
                        AllowedLimit := KrizworkerCost.NumberOfDays;
                    UsedAmount := GetUsed(EmployeeId, ExpenseType, YearStartDate, YearENDDate)
                end;

            if (UsedAmount) > AllowedLimit then
                Error('Limit exceeded for %1. Allowed: %2, Used: %3', ExpenseType, AllowedLimit, UsedAmount);

        end else begin

            KrizworkerCost.Reset();
            KrizworkerCost.SetRange(code, EmployeeId);
            KrizworkerCost.setrange("TA/DACost of", ExpenseType);
            KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
            KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
            if KrizworkerCost.FindFirst() then
                AllowedLimit := KrizworkerCost.UnitCost

            else
                if (AllowedLimit = 0) then begin
                    KrizworkerCost.Reset();
                    KrizworkerCost.SetRange(code, employee."Statistics Group Code");
                    KrizworkerCost.setrange("TA/DACost of", ExpenseType);
                    KrizworkerCost.Setfilter(EffectiveDate, '<=%1', PostingDate);
                    KrizworkerCost.Setfilter(endingdate, '>=%1', PostingDate);
                    if KrizworkerCost.FindFirst() then
                        AllowedLimit := KrizworkerCost.UnitCost;

                end;

            clear(employeeJoiningmonth);
            clear(employeeJoiningYear);
            clear(employeeJoiningDay);
            clear(Daysinmonth);
            clear(YearStart);
            clear(CurrMonth);
            Clear(DaysinQtr);
            Clear(YearofPostingDate);
            Clear(QuarterEndDate);
            Clear(QuarterFromPostingDate);
            Clear(QuarterfromEmploymentDate);
            Clear(totalQtrDaysApplicable);
            Clear(HalfYearEndDate);
            Clear(totalHalfYearDaysApplicable);
            Clear(HalfYearfromEmploymentDate);
            clear(DaysinHalfYear);
            Clear(FullYearApplicableDays);
            Clear(DaysinFullYear);
            clear(EmployeeQuarterEndDate);
            Clear(YearStartDate);
            Clear(YearEndDate);
            YearStart := DMY2Date(1, 1, Date2DMY(PostingDate, 3));
            CurrMonth := Date2DMY(PostingDate, 2);
            employeeJoiningDay := Date2DMY(employee."Employment Date", 1);
            employeeJoiningmonth := Date2DMY(employee."Employment Date", 2);
            employeeJoiningYear := Date2DMY(employee."Employment Date", 3);
            YearofPostingDate := Date2DMY(PostingDate, 3);
            Daysinmonth := GetDaysInMonth(employeeJoiningmonth, employeeJoiningYear);

            //for Quarter

            QuarterEndDate := CALCDATE('<CM+1D-1D>', DMY2DATE(1, ((DATE2DMY(PostingDate, 2) - 1) DIV 3 + 1) * 3, DATE2DMY(PostingDate, 3)));
            EmployeeQuarterEndDate := CALCDATE('<CM+1D-1D>', DMY2DATE(1, ((DATE2DMY(employee."Employment Date", 2) - 1) DIV 3 + 1) * 3, DATE2DMY(employee."Employment Date", 3)));

            QuarterfromEmploymentDate := (DATE2DMY(employee."Employment Date", 2) - 1) DIV 3 + 1;
            QuarterfromPostingDate := (DATE2DMY(PostingDate, 2) - 1) DIV 3 + 1;
            DaysinQtr := GetDaysInQuarter(QuarterfromEmploymentDate, employeeJoiningYear);
            totalQtrDaysApplicable := (QuarterEndDate - employee."Employment Date");

            //for half year

            HalfYearEndDate := CALCDATE('<CM+1D-1D>', DMY2DATE(1, (((DATE2DMY(PostingDate, 2) - 1) DIV 6) + 1) * 6, DATE2DMY(PostingDate, 3)));
            HalfYearfromEmploymentDate := ((DATE2DMY(employee."Employment Date", 2) - 1) DIV 6) + 1;
            totalHalfYearDaysApplicable := (HalfYearEndDate - employee."Employment Date");
            DaysinHalfYear := GetDaysInHalfYear(HalfYearfromEmploymentDate, employeeJoiningYear);

            // Yearly
            DaysinFullYear := DMY2DATE(31, 12, DATE2DMY(PostingDate, 3)) - DMY2DATE(1, 1, DATE2DMY(PostingDate, 3)) + 1;
            FullYearApplicableDays := ((DMY2DATE(31, 12, DATE2DMY(PostingDate, 3))) - employee."Employment Date");
            YearStartDate := DMY2Date(1, 1, Date2DMY(PostingDate, 3));
            YearEndDate := DMY2Date(31, 12, Date2DMY(PostingDate, 3));
            //QuarterFromPostingDate := 
            case KrizworkerCost."TA/DA Period" of
                KrizworkerCost."TA/DA Period"::Monthly:
                    if KrizworkerCost."carry Forward" then begin
                        AllowedLimit := 0;
                        for i := 1 to CurrMonth do begin
                            PeriodStart := DMY2Date(1, i, Date2DMY(PostingDate, 3));
                            PeriodEnd := CALCDATE('<CM>', PeriodStart);
                            UsedAmount += GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);
                            if ((employeeJoiningMonth > i) and (employeeJoiningYear = YearofPostingDate)) then
                                AllowedLimit := 0
                            else if ((employeeJoiningMonth = i) and (employeeJoiningYear = YearofPostingDate)) then
                                AllowedLimit += round((KrizworkerCost.UnitCost / Daysinmonth) * ((Daysinmonth - employeeJoiningDay) + 1), 2)
                            else
                                AllowedLimit += KrizworkerCost.UnitCost
                        end
                    end else begin
                        PeriodStart := DMY2Date(1, CurrMonth, Date2DMY(PostingDate, 3));
                        PeriodEnd := CALCDATE('<CM>', PeriodStart);
                        UsedAmount := GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);
                        if ((employeeJoiningMonth = CurrMonth) and (employeeJoiningYear = YearofPostingDate)) then begin
                            AllowedLimit := 0;
                            AllowedLimit += round((KrizworkerCost.UnitCost / Daysinmonth) * ((Daysinmonth - employeeJoiningDay) + 1), 2)
                        end
                        else begin
                            AllowedLimit := 0;
                            AllowedLimit += KrizworkerCost.UnitCost
                        end;
                    end;



                KrizworkerCost."TA/DA Period"::Quarterly:
                    begin
                        i := (CurrMonth - 1) DIV 3 + 1; // 1=Q1, 2=Q2 etc.
                        if KrizworkerCost."Carry Forward" then begin
                            AllowedLimit := 0;
                            for MonthCounter := 1 to i do begin
                                PeriodStart := DMY2Date(1, ((MonthCounter - 1) * 3) + 1, Date2DMY(PostingDate, 3));
                                PeriodEnd := CALCDATE('<+3M>', PeriodStart) - 1;
                                UsedAmount += GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);
                                if ((QuarterfromEmploymentDate > MonthCounter) and (employeeJoiningYear = YearofPostingDate)) then
                                    AllowedLimit := 0
                                else if ((QuarterfromEmploymentDate = MonthCounter) and (employeeJoiningYear = YearofPostingDate)) then begin
                                    clear(DaysinQtr);
                                    Clear(totalQtrDaysApplicable);
                                    DaysinQtr := GetDaysInQuarter(QuarterfromEmploymentDate, employeeJoiningYear);
                                    totalQtrDaysApplicable := (EmployeeQuarterEndDate - employee."Employment Date");
                                    AllowedLimit += round((KrizworkerCost.UnitCost / DaysinQtr) * ((totalQtrDaysApplicable) + 1), 2)
                                end
                                else if ((QuarterfromEmploymentDate < MonthCounter) and (employeeJoiningYear = YearofPostingDate)) then
                                    AllowedLimit += KrizworkerCost.UnitCost

                                else
                                    AllowedLimit += KrizworkerCost.UnitCost;
                            end
                        end else begin
                            PeriodStart := DMY2Date(1, ((i - 1) * 3) + 1, Date2DMY(PostingDate, 3));
                            PeriodEnd := CALCDATE('<+3M>', PeriodStart) - 1;
                            UsedAmount := GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);

                            if ((QuarterfromEmploymentDate = i) and (employeeJoiningYear = YearofPostingDate)) then begin
                                AllowedLimit := 0;
                                DaysinQtr := GetDaysInQuarter(QuarterfromEmploymentDate, employeeJoiningYear);
                                totalQtrDaysApplicable := (EmployeeQuarterEndDate - employee."Employment Date");
                                AllowedLimit += round((KrizworkerCost.UnitCost / DaysinQtr) * ((totalQtrDaysApplicable) + 1), 2);
                            end else begin
                                AllowedLimit := 0;
                                AllowedLimit := KrizworkerCost.UnitCost
                            end;
                        end;
                    end;
                KrizworkerCost."TA/DA Period"::HalfYearly:
                    begin
                        if CurrMonth <= 6 then
                            i := 1
                        else
                            i := 2;

                        if KrizworkerCost."Carry Forward" then begin
                            AllowedLimit := 0;
                            for MonthCounter := 1 to i do begin
                                PeriodStart := DMY2Date(1, (MonthCounter - 1) * 6 + 1, Date2DMY(PostingDate, 3));
                                PeriodEnd := CALCDATE('<+6M>', PeriodStart) - 1;
                                UsedAmount += GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);
                                if ((HalfYearfromEmploymentDate > i) and (employeeJoiningYear = YearofPostingDate)) then
                                    AllowedLimit := 0
                                else if ((HalfYearfromEmploymentDate = i) and (employeeJoiningYear = YearofPostingDate)) then
                                    AllowedLimit += round((KrizworkerCost.UnitCost / DaysinHalfYear) * ((totalHalfYearDaysApplicable) + 1), 2)
                                else
                                    AllowedLimit += KrizworkerCost.UnitCost
                            end
                        end else begin
                            AllowedLimit := 0;
                            PeriodStart := DMY2Date(1, (i - 1) * 6 + 1, Date2DMY(PostingDate, 3));
                            PeriodEnd := CALCDATE('<+6M>', PeriodStart) - 1;
                            UsedAmount := GetUsed(EmployeeId, ExpenseType, PeriodStart, PeriodEnd);
                            if ((HalfYearfromEmploymentDate = i) and (employeeJoiningYear = YearofPostingDate)) then
                                AllowedLimit += round((KrizworkerCost.UnitCost / DaysinHalfYear) * ((totalHalfYearDaysApplicable) + 1), 2)
                            else
                                AllowedLimit += KrizworkerCost.UnitCost
                        end;
                    end;
                KrizworkerCost."TA/DA Period"::Yearly:
                    if (ExpenseType = Enum::"KrizTA/DACostof"::DADaysLimit) then begin
                        AllowedLimit := KrizworkerCost.UnitCost;
                        UsedAmount := GetUsed(EmployeeId, ExpenseType, YearStartDate, YearENDDate)

                    end else begin
                        UsedAmount := GetUsed(EmployeeId, ExpenseType, YearStart, PostingDate);
                        if (employeeJoiningYear = YearofPostingDate) then
                            AllowedLimit := (KrizworkerCost.UnitCost / DaysinFullYear) * FullYearApplicableDays
                        else
                            AllowedLimit := KrizworkerCost.UnitCost;
                    end;
            end;

            // if (UsedAmount + NewAmount) > AllowedLimit then
            if (UsedAmount) > AllowedLimit then
                Error('Limit exceeded for %1. Allowed: %2, Used: %3, New: %4', ExpenseType, AllowedLimit, UsedAmount, NewAmount);
        end;
    end;

    local procedure GetUsed(EmployeeId: Code[20]; ExpenseType: Enum "KrizTA/DACostof"; StartDate: Date;
                                                                   EndDate: Date): Decimal
    var
        KRIZTADALinePre: Record "KRIZTADALinePre";
        KRIZTADALinePost: Record "KRIZTADALinePost";
        Amount: Decimal;
    begin
        // Pre Table
        KRIZTADALinePre.Reset();
        KRIZTADALinePre.SetRange(EmployeeId, EmployeeId);
        KRIZTADALinePre.SetRange("ExpenseDate", StartDate, EndDate);
        if KRIZTADALinePre.FindSet() then
            repeat
                case ExpenseType of
                    enum::"KrizTA/DACostof"::"Phone Expense":
                        Amount += KRIZTADALinePre.PhoneExpense;
                    enum::"KrizTA/DACostof"::CourierExpense:
                        Amount += KRIZTADALinePre.CourierExpense;
                    enum::"KrizTA/DACostof"::FoodExpense:
                        Amount += KRIZTADALinePre.FoodExpense;
                    enum::"KrizTA/DACostof"::FuelExpense2W:
                        Amount += KRIZTADALinePre.FuelExpense;
                    enum::"KrizTA/DACostof"::FuelExpense4W:
                        Amount += KRIZTADALinePre.FuelExpense;
                    enum::"KrizTA/DACostof"::HotelExpense:
                        Amount += KRIZTADALinePre.HotelExpense;
                    enum::"KrizTA/DACostof"::"lodging Boarding":
                        Amount += KRIZTADALinePre.LodgingBoarding;
                    enum::"KrizTA/DACostof"::MaintenanceExpense2W:
                        Amount += KRIZTADALinePre.MaintenanceExpense;
                    enum::"KrizTA/DACostof"::MaintenanceExpense4W:
                        Amount += KRIZTADALinePre.MaintenanceExpense;
                    enum::"KrizTA/DACostof"::MedicalExpense:
                        Amount += KRIZTADALinePre.MedicalExpense;
                    enum::"KrizTA/DACostof"::TransportNConveyanceExpense:
                        Amount += KRIZTADALinePre.TransportationConveyanceExp;
                    enum::"KrizTA/DACostof"::DADaysLimit:
                        Amount += KRIZTADALinePre.DADaysLimit;

                end;
            until KRIZTADALinePre.Next() = 0;

        // Post Table
        KRIZTADALinePost.Reset();
        KRIZTADALinePost.SetRange(EmployeeId, EmployeeId);
        KRIZTADALinePost.SetFilter(ExpenseDate, '%1..%2', StartDate, EndDate);
        if KRIZTADALinePost.FindSet() then
            repeat
                case ExpenseType of
                    enum::"KrizTA/DACostof"::"Phone Expense":
                        Amount += KRIZTADALinePost.PhoneExpense;
                    enum::"KrizTA/DACostof"::CourierExpense:
                        Amount += KRIZTADALinePost.CourierExpense;
                    enum::"KrizTA/DACostof"::FoodExpense:
                        Amount += KRIZTADALinePost.FoodExpense;
                    enum::"KrizTA/DACostof"::FuelExpense2W:
                        Amount += KRIZTADALinePost.FuelExpense;
                    enum::"KrizTA/DACostof"::FuelExpense4W:
                        Amount += KRIZTADALinePost.FuelExpense;
                    enum::"KrizTA/DACostof"::HotelExpense:
                        Amount += KRIZTADALinePost.HotelExpense;
                    enum::"KrizTA/DACostof"::"lodging Boarding":
                        Amount += KRIZTADALinePost.LodgingBoarding;
                    enum::"KrizTA/DACostof"::MaintenanceExpense2W:
                        Amount += KRIZTADALinePost.MaintenanceExpense;
                    enum::"KrizTA/DACostof"::MaintenanceExpense4W:
                        Amount += KRIZTADALinePost.MaintenanceExpense;
                    enum::"KrizTA/DACostof"::MedicalExpense:
                        Amount += KRIZTADALinePost.MedicalExpense;
                    enum::"KrizTA/DACostof"::TransportNConveyanceExpense:
                        Amount += KRIZTADALinePost.TransportationConveyanceExp;
                    enum::"KrizTA/DACostof"::DADaysLimit:
                        Amount += KRIZTADALinePost.DADaysLimit;

                end;
            until KRIZTADALinePost.Next() = 0;

        exit(Amount);
    end;

    local procedure GetUsedLodBord(EmployeeId: Code[25]; ExpenseType: Enum "KrizTA/DACostof"; StartDate: Date;
                                                                   EndDate: Date): Decimal
    var
        KRIZTADALinePre: Record "KRIZTADALinePre";
        Amount: Decimal;
        DimMgt: Codeunit DimensionManagement;
        DimVal: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        NewDimSetID: Integer;
    begin
        // Pre Table
        KRIZTADALinePre.Reset();
        KRIZTADALinePre.SetRange(EmployeeId, EmployeeId);
        KRIZTADALinePre.SetFilter(ExpenseDate, '%1..%2', StartDate, EndDate);
        KRIZTADALinePre.SetFilter(KRIZTADALinePre.LodgingBoarding, '<>%1', 0);
        if KRIZTADALinePre.FindSet() then
            repeat
                case ExpenseType of
                    enum::"KrizTA/DACostof"::"lodging Boarding":
                        Amount := KRIZTADALinePre.LodgingBoarding;

                end;
            until KRIZTADALinePre.Next() = 0;


        exit(Amount);
    end;


    procedure GenerateTmpVoucher(TADATable: Record KRIZTADAHeaderPre)
    var
        TADALine: Record KRIZTADALinePre;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLineRec: Record "Gen. Journal Line";
        //GenJnlTemplate: Record "Gen. Journal Template";
        // GenJnlBatch: Record "Gen. Journal Batch";
        TADAParams: Record KrizTADAParameter;
        Period: Record "KrizTADAPeriod";
        GenJlnPost: Codeunit "Gen. Jnl.-Post Line";
        TmpLedger: Record "Tmp Ledger Transaction" temporary;
        totalBalance: Decimal;
        RoundOff: Decimal;
        ArrAmt: array[20] of Decimal;
        ArrLedger: array[20] of Code[20]; // adjust size as per your MainAccountId field
        x: Integer;
        LineNum: Integer;
        NextNo: Code[20];
        NoSeries: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        DimVal: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        NewDimSetID: Integer;
        KRIZTADAHeaderPostUpdate: Record KRIZTADAHeaderPost;

    begin
        totalBalance := 0;
        clear(TmpLedger);
        TmpLedger.DeleteAll();
        TADAParams.Reset();
        TADAParams.SetFilter(NumberSequenceSeries, '<>%1', '');
        if TADAParams.FindFirst() then;
        Clear(ArrLedger);
        // Fill ledger accounts from parameters
        ArrLedger[1] := TADAParams.TransportConveyanceAccount;
        ArrLedger[2] := TADAParams.LodgingAccount;
        ArrLedger[3] := TADAParams.CourierAccount;
        ArrLedger[4] := TADAParams.MedicalExpenseAccount;
        ArrLedger[5] := TADAParams.FoodAccount;
        ArrLedger[6] := TADAParams.FuelAccount;
        ArrLedger[7] := TADAParams.MainTainceAccount;
        ArrLedger[8] := TADAParams.PhoneAccount;
        ArrLedger[9] := TADAParams.CabExpenseAccount;
        ArrLedger[10] := TADAParams.MeetingExpenseAccount;
        ArrLedger[11] := TADAParams.TravelExpenseAccount;
        ArrLedger[12] := TADAParams.SalesMarketingAccount;
        ArrLedger[13] := TADAParams.HotelAccount;
        ArrLedger[14] := TADAParams.CNIOAccount;
        ArrLedger[15] := TADAParams.HiredVehicleAccount;
        ArrLedger[16] := TADAParams.HelmetAccount;
        ArrLedger[17] := TADAParams.RoundOffAccount;
        ArrLedger[18] := TADAParams.PenaltyAccount;
        ArrLedger[19] := TADAParams.BalanceAccount;

        TADALine.Reset();
        TADALine.SetRange(TADALine.Voucher, TADATable.Voucher);
        if TADALine.FindSet() then
            repeat
                Clear(ArrAmt);
                ArrAmt[1] := TADALine.TransportationConveyanceExp;
                ArrAmt[2] := TADALine.LodgingBoarding;
                ArrAmt[3] := TADALine.CourierExpense;
                ArrAmt[4] := TADALine.MedicalExpense;
                ArrAmt[5] := TADALine.FoodExpense;
                ArrAmt[6] := TADALine.FuelExpense;
                ArrAmt[7] := TADALine.MaintenanceExpense;
                ArrAmt[8] := TADALine.PhoneExpense;
                ArrAmt[9] := TADALine.CabExpense;
                ArrAmt[10] := TADALine.MeetingExpense;
                ArrAmt[11] := TADALine.TravelExpense;
                ArrAmt[12] := TADALine.SalesandMarketingMonthMetting;
                ArrAmt[13] := TADALine.HotelExpense;
                ArrAmt[14] := TADALine.CNIO;
                ArrAmt[15] := TADALine.HiredVehicle;
                ArrAmt[16] := TADALine.Helmet;
                for x := 1 to 17 do
                    if not TmpLedger.Get(ArrLedger[x]) then begin
                        if ArrAmt[x] <> 0 then begin
                            TmpLedger.Init();
                            TmpLedger.MainAccountId := ArrLedger[x];

                            if ArrAmt[x] >= 0 then begin
                                TmpLedger.AmountCurDebit += ArrAmt[x];
                                totalBalance += TmpLedger.AmountCurDebit;
                            end else begin
                                TmpLedger.AmountCurCredit += -ArrAmt[x];
                                totalBalance += -TmpLedger.AmountCurCredit;
                            end;
                            TmpLedger.insert();
                        end;

                    end else begin
                        if ArrAmt[x] >= 0 then begin
                            TmpLedger.AmountCurDebit += ArrAmt[x];
                            totalBalance += ArrAmt[x];
                        end
                        else begin
                            TmpLedger.AmountCurCredit += -ArrAmt[x];
                            totalBalance += -ArrAmt[x];
                        end;
                        TmpLedger.Modify();
                    end;

            until TADALine.Next() = 0;

        if Period.Get(TADATable."TADA Period") then
            if (Period.PenaltyDate < TADATable."Receiving Date")
            and (Period.PenaltyAmount <> 0) and (not Period."Negative Only") then begin
                TmpLedger.Reset();
                TmpLedger.SetRange(MainAccountId, TADAParams.PenaltyAccount);
                IF TmpLedger.FindSet() then begin
                    TmpLedger.AmountCurDebit += -Period.PenaltyAmount;
                    totalBalance += -Period.PenaltyAmount;
                    TmpLedger.Modify();
                end else begin
                    TmpLedger.Init();
                    TmpLedger.MainAccountId := TADAParams.PenaltyAccount;
                    TmpLedger.AmountCurCredit := -Period.PenaltyAmount;
                    totalBalance += -Period.PenaltyAmount;
                    TmpLedger.Insert();
                end;
            end;
        if totalBalance <> ROUND(totalBalance, 1) then begin
            RoundOff := ROUND(totalBalance, 1) - totalBalance;
            TmpLedger.Init();
            TmpLedger.MainAccountId := TADAParams.RoundOffAccount;
            if RoundOff < 0 then
                TmpLedger.AmountCurCredit := -RoundOff
            else
                TmpLedger.AmountCurDebit := RoundOff;
            TmpLedger.Insert();

            totalBalance := ROUND(totalBalance, 1);
        end;

        if not TmpLedger.Get(ArrLedger[19]) then begin
            TmpLedger.Init();
            TmpLedger.MainAccountId := ArrLedger[19];
            TmpLedger.BalanceAmount := -totalBalance;
            TmpLedger.insert();
        end
        else begin
            TmpLedger.BalanceAmount := -totalBalance;
            TmpLedger.Modify();
        end;
        LineNum := 10000;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
        GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJnlLine.FindLast() then
            LineNum := GenJnlLine."Line No." + 10000;

        NextNo := NoSeries.GetNextNo(TADAParams.JournalName);
        TmpLedger.Reset(); // Always reset before looping
        TmpLedger.SetFilter(BalanceAmount, '%1', 0);
        // TmpLedger.SetFilter(AmountCurCredit);
        if TmpLedger.FindSet() then
            repeat
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", 'GENERAL');
                GenJnlLine.validate("Journal Batch Name", 'DEFAULT');
                GenJnlLine."Line No." := LineNum;
                GenJnlLine.Validate("Document No.", NextNo);
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", TmpLedger.MainAccountId);
                if (TmpLedger.AmountCurDebit <> 0) then
                    GenJnlLine.validate(Amount, TmpLedger.AmountCurDebit)
                else
                    GenJnlLine.Validate(Amount, TmpLedger.AmountCurCredit);
                // GenJnlLine.Amount := TmpLedger.AmountCurDebit;
                GenJnlLine."Document Date" := TADATable."Document Date";
                GenJnlLine."Posting Date" := TADATable."Posting Date";
                GenJnlLine.Description := TADATable.PersonnelNumber;
                Clear(TempDimSetEntry);
                TempDimSetEntry.DeleteAll();
                DefaultDim.Reset();
                DefaultDim.SetRange("Table ID", DATABASE::Employee);
                DefaultDim.SetRange("No.", TADATable.PersonnelNumber);
                if DefaultDim.FindSet() then begin
                    repeat
                        TempDimSetEntry.Init();
                        TempDimSetEntry."Dimension Code" := DefaultDim."Dimension Code";
                        TempDimSetEntry.validate("Dimension Value Code", DefaultDim."Dimension Value Code");
                        TempDimSetEntry.Insert();
                    until DefaultDim.Next() = 0;

                    // Create Dimension Set ID from TempDimSetEntry
                    Clear(NewDimSetID);
                    NewDimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
                    GenJnlLine."Dimension Set ID" := NewDimSetID;
                end;

                if (GenJnlLine.Amount <> 0) then begin
                    if (TADAParams.TADAPosting = true) then
                        GenJlnPost.RunWithCheck(GenJnlLine)
                    else
                        GenJnlLine.Insert();
                    LineNum += 10000;
                end;

            until TmpLedger.Next() = 0;
        // Credit Line
        TmpLedger.Reset(); // Always reset before looping
        TmpLedger.SetFilter(BalanceAmount, '<>%1', 0);
        if TmpLedger.FindSet() then
            repeat
                GenJnlLine.Init();
                GenJnlLine.Validate("Journal Template Name", 'GENERAL');
                GenJnlLine.Validate("Journal Batch Name", 'DEFAULT');
                GenJnlLine.Validate("Document No.", NextNo);
                GenJnlLine."Line No." := LineNum;
                //GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                //GenJnlLine.validate("Account No.", TmpLedger.MainAccountId);
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
                GenJnlLine.validate("Account No.", TADATable.PersonnelNumber);
                GenJnlLine.Validate(Amount, TmpLedger.BalanceAmount);
                GenJnlLine."Document Date" := TADATable."Document Date";
                GenJnlLine."Posting Date" := TADATable."Posting Date";
                GenJnlLine.Description := TADATable.PersonnelNumber;
                Clear(TempDimSetEntry);
                TempDimSetEntry.DeleteAll();
                DefaultDim.Reset();
                DefaultDim.SetRange("Table ID", DATABASE::Employee);
                DefaultDim.SetRange("No.", TADATable.PersonnelNumber);
                if DefaultDim.FindSet() then begin
                    repeat
                        TempDimSetEntry.Init();
                        TempDimSetEntry."Dimension Code" := DefaultDim."Dimension Code";
                        TempDimSetEntry.validate("Dimension Value Code", DefaultDim."Dimension Value Code");
                        TempDimSetEntry.Insert();
                    until DefaultDim.Next() = 0;

                    // Create Dimension Set ID from TempDimSetEntry
                    Clear(NewDimSetID);
                    NewDimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
                    GenJnlLine."Dimension Set ID" := NewDimSetID;
                end;

                if (TADAParams.TADAPosting = true) then
                    GenJlnPost.RunWithCheck(GenJnlLine)
                else
                    GenJnlLine.Insert();
            until TmpLedger.Next() = 0;
        GenJnlLineRec.Reset();
        GenJnlLineRec.SetRange("Document No.", GenJnlLine."Document No.");
        GenJnlLineRec.SetFilter(Amount, '%1', 0);
        if GenJnlLineRec.FindSet() then
            GenJnlLineRec.DeleteAll();

        // if (TADAParams.TADAPosting = true) then
        //     GenJlnPost.RunWithCheck(GenJnlLine);

        TransferVoucherToPost(TADATable, NextNo);
    end;

    procedure TransferVoucherToPost(TADATable: Record KRIZTADAHeaderPre; voucher: text[20])
    var
        HeaderPre: Record KRIZTADAHeaderPre;
        LinePre: Record KRIZTADALinePre;
        TADALinePretotal: Record KRIZTADALinePre;
        HeaderPost: Record KRIZTADAHeaderPost;
        LinePost: Record KRIZTADALinePost;
        Period: Record krizTADAPeriod;
        totalamount: Decimal;
    begin
        Clear(Period);
        if Period.Get(TADATable."TADA Period") then
            HeaderPre.Reset();
        HeaderPre.SetRange(Voucher, TADATable.Voucher);
        if HeaderPre.FindFirst() then begin
            // Transfer Header
            HeaderPost.Init();
            HeaderPost.TransferFields(HeaderPre);
            HeaderPost.Insert();

            HeaderPost."Posted Voucher No" := voucher;
            HeaderPost.PostedVoucherDate := TADATable."Posting Date";

            totalamount := 0;
            TADALinePretotal.Reset();
            TADALinePretotal.SetRange(Voucher, TADATable.Voucher);
            if TADALinePretotal.FindSet() then
                repeat
                    totalamount += TADALinePretotal.TotalCost;
                until TADALinePretotal.Next() = 0;

            if (Period.PenaltyAmount <> 0) then begin
                if (Period.PenaltyDate < TADATable."Receiving Date")
                     and (Period.PenaltyAmount <> 0) and (not Period."Negative Only") then begin
                    HeaderPost."Total Amount" := 0;
                    HeaderPost."Total Amount" := totalamount - Period.PenaltyAmount;
                    HeaderPost."Penalty Amount" := Period.PenaltyAmount;
                end else begin
                    HeaderPost."Total Amount" := 0;
                    HeaderPost."Total Amount" := totalamount;
                end
            end else begin
                HeaderPost."Total Amount" := 0;
                HeaderPost."Total Amount" := totalamount;

            end;
            HeaderPost.Modify();
            // Transfer Lines
            LinePre.SetRange(voucher, TADATable.Voucher);
            if LinePre.FindSet() then
                repeat
                    LinePost.Init();
                    LinePost.TransferFields(LinePre);
                    LinePost.Insert();
                until LinePre.Next() = 0;


            // Delete original data
            LinePre.DeleteAll();
            HeaderPre.Delete();

            Message('Voucher %1 successfully Posted', TADATable.Voucher);

        end else
            Error('Voucher Not Found');
    end;

    procedure GetDaysInMonth(CurrMonth: Integer; Year: Integer): Integer
    var
        FirstDate: Date;
        LastDate: Date;
        DaysInMonth: Integer;
    begin
        // Get current year (you can replace with specific year if needed)
        Year := DATE2DMY(TODAY, 3);

        // Create the first date of the month
        FirstDate := DMY2DATE(1, CurrMonth, Year);

        // Get the last date of the month using CALCDATE
        LastDate := CALCDATE('<CM+1D-1D>', FirstDate);

        // Extract day from last date to get number of days
        DaysInMonth := DATE2DMY(LastDate, 1);

        exit(DaysInMonth);
    end;

    procedure GetDaysInQuarter(Quarter: Integer; Year: Integer): Integer
    var
        StartMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        DaysInQuarter: Integer;
    begin
        // Determine the starting month of the quarter
        StartMonth := (Quarter - 1) * 3 + 1;

        // First day of the quarter
        StartDate := DMY2DATE(1, StartMonth, Year);

        // Last day of the quarter = end of 3rd month of the quarter
        //EndDate := CALCDATE('<EOM>', DMY2DATE(1, StartMonth + 2, Year));
        EndDate := CALCDATE('<CM+1D-1D>', DMY2DATE(1, StartMonth + 2, Year));

        // Calculate total days in the quarter (inclusive)
        DaysInQuarter := EndDate - StartDate + 1;

        exit(DaysInQuarter);
    end;

    procedure GetDaysInHalfYear(HalfYear: Integer; Year: Integer): Integer
    var
        StartMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        DaysInHalfYear: Integer;
    begin
        // Determine the starting month of the half-year (1 = Jan, 2 = Jul)
        StartMonth := (HalfYear - 1) * 6 + 1;

        // First day of the half-year
        StartDate := DMY2DATE(1, StartMonth, Year);

        // Last day of the half-year = end of 6th month of the half-year
        EndDate := CALCDATE('<CM+1D-1D>', DMY2DATE(1, StartMonth + 5, Year));

        // Calculate total days in the half-year (inclusive)
        DaysInHalfYear := EndDate - StartDate + 1;

        exit(DaysInHalfYear);
    end;

    procedure validateEmployeeFields(Employee: record Employee)
    begin

        if (Employee.Closed = true) then
            Error('Employee is Closed');


        if (Employee."Statistics Group Code" = '') then
            Error('Worker Group Id not defined on employee');
        if (Employee.HRCode = '') then
            error('HR Code not defined on employee');

    end;
}
