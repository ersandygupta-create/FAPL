pageextension 50009 KRIZCustomerListExt extends "Customer List"
{
    layout
    {
        addlast(Control1) // or use a specific group like "Repeater" or "Area(content)"
        {
            field("Security Deposit"; rec."Security Deposit")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
