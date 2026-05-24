report 50020 "Location wise Batch wise Stock"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/EDCLocationwiseBatchwiseStock.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Location/Batchwise Stock Report';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Location Code", "Posting Date", "Item No.")
                                ORDER(Ascending)
                                WHERE("Item No." = FILTER(<> ''),
                                      Quantity = FILTER(<> 0));
            RequestFilterFields = "Location Code", "Item No.";
            column(AddFilters; AddFilters)
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(Location; "Item Ledger Entry"."Location Code")
            {
            }
            column(StateCode; StateCode)
            {
            }
            column(Item; "Item Ledger Entry"."Item No.")
            {
            }
            column(ItemBrand; ItemBrand)
            {
            }
            column(UnitogMeasure; UnitogMeasure)
            {
            }
            column(MRP; MRP)
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            column(ClosingBalance; "Item Ledger Entry".Quantity)
            {
            }
            column(MfgDate; FORMAT(MfgDate))
            {
            }
            column(ExpDate; FORMAT(ExpDate))
            {
            }
            column(LotNo; "Item Ledger Entry"."Lot No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                BranchName := '';
                StateCode := '';
                IF Location.GET("Item Ledger Entry"."Location Code") THEN BEGIN
                    BranchName := Location.Name;
                    StateCode := Location."State Code";
                END;

                ItemDescription := '';
                ItemBrand := '';
                IF Item.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ItemDescription := Item.Description;
                    ItemBrand := Item."Description 2";
                    UnitogMeasure := Item."Sales Unit of Measure";
                END;

                MfgDate := 0D;
                ExpDate := 0D;
                IF LotNoInformation.GET("Item No.", "Variant Code", "Lot No.") THEN BEGIN
                    MfgDate := LotNoInformation."Kriz Manufacturing Date";
                    ExpDate := LotNoInformation."Kriz Expiry Date";
                    MRP := LotNoInformation."Kriz MRP";


                END;
            end;

            trigger OnPreDataItem()
            begin
                "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Posting Date", '..%1', dtAsonDate);

                AddFilters := "Item Ledger Entry".GETFILTERS;
                CompanyInformation.GET();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("As On Date"; dtAsonDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'As On Date';
                    ToolTip = 'Specifies the value of the As on Date field';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        dtAsonDate: Date;
        Location: Record 14;
        StateCode: Code[100];
        BranchName: Text[100];
        Item: Record 27;
        ItemDescription: Text[100];
        ItemBrand: Text[100];
        LotNoInformation: Record 6505;
        LotNo: Code[50];
        ExpDate: Date;
        UnitogMeasure: Text[20];
        MfgDate: Date;
        AddFilters: Text;
        CompanyInformation: Record 79;
        MRP: Decimal;
        AsOnDate: Date;
}

