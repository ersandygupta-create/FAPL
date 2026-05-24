report 50016 "Import MIS Details"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileManagement: Codeunit "File Management";
        ServerFileName: Text;
        MISRec: Record "KRIZ MIS Details";
        CurrentRowNo: Integer;
        PrevRowNo: Integer;
        IsFirstRow: Boolean;

        LRDate: Date;
        DeliveryDate: Date;
        Weight: Decimal;
        LineNo: Integer;
        LRNo: Code[20];
        ShipToPin: Text;
        SheetName: Text;
        CSVInStream: InStream;
        FileInstream: InStream;
        RowCount: Integer;
        i: Integer;


    trigger OnPostReport()
    begin
        Clear(CSVInStream);
        //if not UploadIntoStream('Container Details', '', 'Excel Files (.xlsx;.xls)|.xlsx;.xls', ServerFileName, FileInstream) then
        //  exit;

        UploadIntoStream('Container Details', '', 'Excel(.xlsx)|*.xlsx', ServerFileName, FileInstream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(FileInstream);
        TempExcelBuffer.OpenBookStream(FileInstream, SheetName);
        TempExcelBuffer.ReadSheet();



        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Column No.", 1);
        if TempExcelBuffer.FindLast() then
            RowCount := TempExcelBuffer."Row No.";

        if RowCount = 1 then
            exit;

        For i := 2 to RowCount do begin
            MISRec.Init();
            MISRec."Order No" := GetCellValue(TempExcelBuffer, i, 1);
            Evaluate(MISRec."Line No", GetCellValue(TempExcelBuffer, i, 2));
            Evaluate(MISRec."LR No", GetCellValue(TempExcelBuffer, i, 3));
            Evaluate(MISRec."LR Date", GetCellValue(TempExcelBuffer, i, 4));
            MISRec.Consignor := GetCellValue(TempExcelBuffer, i, 5);
            MISRec."Pick Up" := GetCellValue(TempExcelBuffer, i, 6);
            MISRec."Pick Up GST" := GetCellValue(TempExcelBuffer, i, 7);
            MISRec."Consignee Name" := GetCellValue(TempExcelBuffer, i, 8);
            MISRec."Drop Off Location" := GetCellValue(TempExcelBuffer, i, 9);
            MISRec."Drop Off GST" := GetCellValue(TempExcelBuffer, i, 10);
            ShipToPin := GetCellValue(TempExcelBuffer, i, 11);
            if StrLen(ShipToPin) <= 6 then
                MISRec."Ship To Pin" := ShipToPin
            else
                Error('Pin code exceeds 6 characters in Row %1: %2', CurrentRowNo, ShipToPin);

            MISRec.State := GetCellValue(TempExcelBuffer, i, 12);
            MISRec."Truck Number" := GetCellValue(TempExcelBuffer, i, 13);
            MISRec."Truck Type" := GetCellValue(TempExcelBuffer, i, 14);
            Evaluate(MISRec."Weight of Shipment", GetCellValue(TempExcelBuffer, i, 15));
            Evaluate(MISRec."Delivery Date", GetCellValue(TempExcelBuffer, i, 16));
            MISRec.Insert();
        end;
        Message('MIS Report import completed successfully.');
    end;

    procedure GetCellValue(var lTempExcelBuffer: Record "Excel Buffer" temporary; rowNumber: Integer; columnNumber: Integer): Text
    begin
        if lTempExcelBuffer.Get(rowNumber, columnNumber) then
            exit(lTempExcelBuffer."Cell Value as Text");
    end;
}
