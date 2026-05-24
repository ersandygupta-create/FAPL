pageextension 50004 KRIZBankReceiptVoucher extends "Bank Receipt Voucher"
{
    layout
    {
        addafter("Document No.")
        {
            field("Payment Reference"; REC."Payment Reference")
            {
                ApplicationArea = ALL;
                ToolTip = 'Payment Reference /UTR No';
            }
        }
    }
}