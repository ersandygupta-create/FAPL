pageextension 50005 KRIZCustLedgerEntriesPageExt extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = all;
                ToolTip = 'Payment Reference';
            }
        }
    }


}