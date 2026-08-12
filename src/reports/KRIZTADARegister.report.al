report 50032 "TADA Register"
{
    ProcessingOnly = true;
    Caption = 'TADA Register';
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(KRIZTADAHeaderPost; KRIZTADAHeaderPost)
        {
            DataItemTableView = SORTING("Receiving Date", Voucher);
            //   RequestFilterFields = "Receiving Date", PersonnelNumber;
            dataitem(KRIZTADALinePost; KRIZTADALinePost)
            {
                DataItemLink = Voucher = FIELD(Voucher);
                // DataItemTableView = SORTING("Document No.", "Line No.")
                //                     WHERE(Quantity = FILTER(<> 0),
                //                     "System-Created Entry" = const(false));

                trigger OnAfterGetRecord()
                begin
                    txtData[17] := Format(KRIZTADALinePost.ExpenseDate);
                    txtData[18] := KRIZTADALinePost.FromCity;
                    txtData[19] := KRIZTADALinePost.ToCity;
                    txtData[20] := Format(KRIZTADALinePost.DAFactor);
                    txtData[21] := Format(0);//Format(KRIZTADALinePost.noof);
                    txtData[22] := Format(KRIZTADALinePost.LodgingBoarding);
                    txtData[23] := Format(KRIZTADALinePost.HotelExpense);
                    txtData[24] := KRIZTADALinePost.NameofHotel;
                    txtData[25] := 'None';//KRIZTADALinePost.mode;
                    txtData[26] := Format(KRIZTADALinePost.TransportationConveyanceExp);
                    txtData[27] := Format(Employee.VehicleType);
                    txtData[28] := Employee.VehicleCode;
                    txtData[29] := Format(KRIZTADALinePost."Starting Reading");
                    txtData[30] := Format(KRIZTADALinePost."Closing Reading");
                    txtData[31] := Format(KRIZTADALinePost."Net KM Covered");
                    txtData[32] := KRIZTADALinePost.FuelCashMemoNum;
                    txtData[33] := Format(KRIZTADALinePost.FuelExpense);
                    txtData[34] := KRIZTADALinePost.MaintenanceCashMemoNum;
                    txtData[35] := Format(KRIZTADALinePost.MaintenanceExpense);
                    txtData[36] := Format(KRIZTADALinePost.CourierExpense);
                    txtData[37] := Format(KRIZTADALinePost.FoodExpense);
                    txtData[38] := Format(KRIZTADALinePost.PhoneExpenseInvoiceNum);
                    txtData[39] := Format(KRIZTADALinePost.PhoneExpense);
                    txtData[40] := Format(KRIZTADALinePost.MedicalExpense);

                    txtData[56] := Format(KRIZTADALinePost.CabExpense);
                    txtData[57] := Format(KRIZTADALinePost.TravelExpense);
                    txtData[58] := Format(KRIZTADALinePost.MeetingExpense);
                    txtData[59] := Format(KRIZTADALinePost.SalesandMarketingMonthMetting);
                    txtData[60] := '';//KRIZTADALinePost.SupervisorName;
                    txtData[61] := Format(0);
                    txtData[62] := '';//Format(KRIZTADALinePost.PaymentDate);
                                      // txtData[63] := kRIZTADALinePost.PostedBy
                    MakeExcelDataBody();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                txtData[1] := Format(KRIZTADAHeaderPost."Posting Date");
                txtData[2] := KRIZTADAHeaderPost.PersonnelNumber;
                txtData[3] := KRIZTADAHeaderPost.Name;
                txtData[4] := KRIZTADAHeaderPost.PersonnelNumber;
                Employee.Reset();
                Employee.Get(KRIZTADAHeaderPost.PersonnelNumber);
                txtData[5] := Employee.HRCode;
                txtData[6] := KRIZTADAHeaderPost."Posted Voucher No";
                txtData[7] := Format(KRIZTADAHeaderPost.PostedVoucherDate);
                txtData[8] := KRIZTADAHeaderPost.Voucher;
                txtData[9] := KRIZTADAHeaderPost."Worker Group Id";
                DefaultDimension.Reset();
                DefaultDimension.SetFilter("Dimension Code", '%1', 'BU');
                if DefaultDimension.Find('-') then
                    txtData[10] := DefaultDimension."Dimension Value Code"
                else
                    txtData[10] := '';
                DefaultDimension.Reset();
                DefaultDimension.SetFilter("Dimension Code", '%1', 'CC');
                if DefaultDimension.Find('-') then
                    txtData[11] := DefaultDimension."Dimension Value Code"
                else
                    txtData[11] := '';
                txtData[12] := Employee.City;
                recState.Get(Employee.State);
                txtData[13] := recState.Description;
                txtData[14] := KRIZTADAHeaderPost."TADA Period";
                if Employee.Closed then
                    txtData[15] := 'Yes'
                else
                    txtData[15] := 'No';
                if Employee."Privacy Blocked" then
                    txtData[16] := 'Yes'
                else
                    txtData[16] := 'No';
                txtData[41] := Format(KRIZTADAHeaderPost."Receiving Date");
                txtData[42] := Format(KRIZTADAHeaderPost."Penalty Amount");
                txtData[43] := Format(KRIZTADAHeaderPost."Total Amount");
                txtData[44] := KRIZTADALinePost.Remarks;
                txtData[45] := Format(Employee."Employment Date");
                txtData[46] := Format(Employee."Termination Date");
                txtData[47] := Employee."E-Mail";
                txtData[48] := Employee."Mobile Phone No.";
                txtData[49] := Employee.BankName;
                txtData[50] := Employee.BankBranch;
                txtData[51] := Employee."Bank Account No.";
                txtData[52] := Employee.IFSCCode;
                txtData[53] := '';//Format(KRIZTADAHeaderPost."Payment Due Date");
                txtData[54] := '';//KRIZTADAHeaderPost."Payment No.";        
                txtData[55] := '';//Format(KRIZTADAHeaderPost."Acc. Payment Date");
                txtData[63] := KRIZTADAHeaderPost.SystemCreatedBy;
                //  MakeExcelDataBody();
            end;

            trigger OnPreDataItem()
            begin
                if (FromDate <> 0D) and (ToDate <> 0D) then
                    KRIZTADAHeaderPost.SetRange("Posting Date", FromDate, ToDate)
                else if (FromDate <> 0D) and (ToDate = 0D) then
                    Error('Please enter To Date.')
                else if (FromDate = 0D) and (ToDate <> 0D) then
                    Error('Please enter From Date.');
                if (EmpNo <> '') then
                    KRIZTADAHeaderPost.SetRange(PersonnelNumber, EmpNo);
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {

                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Select From date to generate the report to an Excel file.';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Select To date to generate the report to an Excel file.';
                    }
                    field(EmpNo; EmpNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee."No.";
                        Caption = 'Employee No.';
                        ToolTip = 'Select Personnel Number to generate the report to an Excel file.';
                    }
                }
            }
        }
        trigger OnInit()
        begin
            PrintToExcel := TRUE;
        end;
    }


    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        IF PrintToExcel THEN
            MakeExcelInfo();
    end;

    var
        RecLotInfo: Record "Lot No. Information";
        Employee: Record Employee;
        recsalesinvHead: Record "Sales Invoice Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        recLocation: Record "Location";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        recCustomer: Record "Customer";
        ShipAgent: Record "Shipping Agent";
        DefaultDimension: Record "Default Dimension";
        billToCustomer: Record "Customer";
        recState: Record State;
        Item: Record "Item";
        ItemCat: Record "Item Category";
        recItemUOM: Record "Item Unit of Measure";
        DetailedGSTLedgEntry: Record "Detailed GST Ledger Entry";
        DimSetEntry: Record "Dimension Set Entry";
        BudgetType: Code[20];
        BusinessUnit: Code[20];
        CostCenter: Code[20];
        Crop: Code[20];

        txtData: array[255] of Text[200];
        PrintToExcel: Boolean;
        CGSTRate: Decimal;
        CGSTAmt: Decimal;
        SGSTRate: Decimal;
        SGSTAmt: Decimal;
        IGSTRate: Decimal;
        IGSTAmt: Decimal;
        CESSRate: Decimal;
        CESSAmt: Decimal;
        "GST %": Decimal;
        FromDate: Date;
        ToDate: Date;
        EmpNo: Code[20];
        "Total GST Amount": Decimal;
        "Amount To Customer": Decimal;


    procedure MakeExcelInfo()
    begin
        TempExcelBuffer.SetUseInfoSheet();
        TempExcelBuffer.AddInfoColumn(COMPANYNAME, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(USERID, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddInfoColumn(TODAY, false, false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.ClearNewRow();
        MakeExcelDataHeader();
    end;

    procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn('Trans Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Personnel number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Nav Resource Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('HR Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Posted Voucher No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Posted Voucher Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Voucher', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Worker Group Id', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Business Unit', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Cost Center', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Headquarter city', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('State', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('TADA period', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Closed', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Blocked', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Expense date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('From city', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('To city', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('DA Factor', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Number Of Days', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Lodging & Boarding', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Hotel Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Hotel Id', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('TravelMode', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Tranportation / Conveyance Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Vehicle Type', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Vehicle code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Starting Reading', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Closing Reading', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Net KM Covered', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Fuel cash memo num.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Fuel Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Maintenance cash memo num.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Maintenance Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Courier Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Food Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Phone Expense Invoice Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Phone Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Medical Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Receiving Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Penalty', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Total cost', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Remarks', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Employment start date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Employment end date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Auto Email ID', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Auto SMS No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Bank Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Bank Branch', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Bank Account Number', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('IFSC Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Payment Due Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Payment No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Acc. Payment Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('CAB/ TAXI Hire Charges- SIO/MKT', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Travelling Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Meeting Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('SALES/ MARKETING  MONTHLY MEETING', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Supervisor Name', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Toll Tax Expense', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn('Posted By', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]

    end;

    procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn(txtData[1], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[2], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[3], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[4], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[5], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[6], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[7], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[8], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[9], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[10], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[11], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[12], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[13], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[14], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[15], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[16], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[17], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[18], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[19], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[20], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[21], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[22], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[23], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[24], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[25], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[26], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[27], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[28], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[29], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[30], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[31], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[32], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[33], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[34], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[35], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[36], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[37], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[38], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[39], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[40], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[41], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[42], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[43], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[44], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[45], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[46], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[47], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[48], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[49], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[50], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[51], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[52], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[53], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[54], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[55], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[56], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[57], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[58], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[59], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[60], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[61], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[62], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Date);                //txtData[1]
        TempExcelBuffer.AddColumn(txtData[63], FALSE, '', false, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);                //txtData[1]




    end;

    procedure CreateExcelbook()
    var
        TxtRptLbl: Label 'TADA Register';
    begin
        TempExcelBuffer.CreateNewBook(TxtRptLbl);
        TempExcelBuffer.WriteSheet(TxtRptLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(TxtRptLbl);
        TempExcelBuffer.OpenExcel();
    end;
}