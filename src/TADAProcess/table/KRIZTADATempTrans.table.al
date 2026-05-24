table 50159 "Tmp Ledger Transaction"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "MainAccountId"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(2; "AmountCurDebit"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(3; "AmountCurCredit"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(4; "BalanceAccountType"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Ledger,Vendor,Customer;
        }

        field(5; "TransTxt"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; "BalanceAmount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "MainAccountId")
        {
            Clustered = true;
        }
    }
}
