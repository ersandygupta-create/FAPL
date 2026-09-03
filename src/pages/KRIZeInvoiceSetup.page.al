page 50156 "KRIZ e-Invoice Setup List 2"
{
    PageType = List;
    SourceTable = "KRIZ e-Invoice Setup";
    Caption = 'e-Invoice Setup List';
    ApplicationArea = All;
    UsageCategory = Administration; // Shows up in Tell Me (Alt+Q)
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Integration Mode"; Rec."Integration Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the integration mode is Sandbox or Production.';
                }
                field("Demo GSTIN"; Rec."Demo GSTIN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GSTIN number used for demo/testing purposes.';
                }
                field("Demo City"; Rec."Demo City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the City number used for demo/testing purposes.';
                }
                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether e-Invoice integration is enabled.';
                }
                field("E-Waybill by IRN Enabled"; Rec."E-Waybill by IRN Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the e-Waybill should be generated using the IRN.';
                }
                field("Generate IRN API"; Rec."Generate IRN API")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint used to generate IRN.';
                }
                field("Cancel IRN API"; Rec."Cancel IRN API")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint used to cancel the IRN.';
                }
                field("Generate E-Waybill by IRN API"; Rec."Generate E-Waybill by IRN API")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint to generate an e-Waybill using IRN.';
                }
                field("Get Invoice by IRN API"; Rec."Get Invoice by IRN API")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint to get invoice details by IRN.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID used to authenticate API calls.';
                }

                field("Password"; Rec."Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the password used for authentication.';
                }
                field("Show Schema Message"; Rec."Show Schema Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether to display the schema message for API communication.';
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Api Key used for authentication.';
                }
                field("Generate E-Waybill"; Rec."Generate E-Waybill")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint to generate an e-Waybill';
                }
                field("Generate Token"; Rec."Generate Token")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint to generate token';
                }
                field("Is Production"; Rec."Is Production")
                {
                    ApplicationArea = All;
                    ToolTip = 'API endpoint to generate Production';
                }
            }
        }
    }
}
