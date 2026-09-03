codeunit 50003 KrizImportFALedgerEntry
{

    Permissions = tabledata "FA Ledger Entry" = RIMD;
    trigger OnRun()
    begin

    end;

    procedure ImportExcelFALedger()
    var

        TempExcelBuffer: Record "Excel Buffer" temporary;
        FALedgerEntry: Record "FA Ledger Entry";
        FileName: Text;
        InStr: InStream;
        SheetName: Text;
        EntryNo: Integer;
        NoOfDays: Integer;
        GenPostingType: Enum "General Posting Type";
    begin
        UploadIntoStream('Import Excel', '', 'Excel(.xlsx)|*.xlsx', FileName, InStr);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(InStr);
        TempExcelBuffer.OpenBookStream(InStr, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.Reset();
        TempExcelBuffer.SetFilter("Row No.", '>1');
        if TempExcelBuffer.FindSet() then
            repeat
                case TempExcelBuffer."Column No." of
                    1:
                        Evaluate(EntryNo, TempExcelBuffer."Cell Value as Text");
                    2:
                        begin
                            Evaluate(GenPostingType, TempExcelBuffer."Cell Value as Text");
                            UpdateFALedgerEntry(EntryNo, GenPostingType);
                        end;


                end;
            until TempExcelBuffer.Next() = 0;
        Message('Records updated successfully.');
    end;

    procedure UpdateFALedgerEntry(_EntryNo: Integer; _NoOfDays: Enum "General Posting Type")
    var
        FALedgerEntry: Record "FA Ledger Entry";

    begin
        FALedgerEntry.Reset();
        FALedgerEntry.SetRange(FALedgerEntry."Entry No.", _EntryNo);
        if FALedgerEntry.Find('-') then begin
            FALedgerEntry."Gen. Posting Type" := _NoOfDays;
            FALedgerEntry.Modify(true);
        end;

    end;


}