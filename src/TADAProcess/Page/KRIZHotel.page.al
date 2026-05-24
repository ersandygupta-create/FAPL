 
page 50184 KRIZTADAHotel
{
    ApplicationArea = All;
    Caption = 'TADA Hotel';
    PageType = List;
    SourceTable = krizHotelTable;
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
 
 
 
 
                field(NameofHotel; Rec.NameofHotel)
                {
                    ToolTip = 'Specifies the value of the Name of Hotel field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field(District; Rec.District)
                {
                    ToolTip = 'Specifies the value of the District field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field(PANNo; Rec.PANNo)
                {
                    ToolTip = 'Specifies the value of the PAN No field.', Comment = '%';
                }
                field(GST; Rec.GST)
                {
                    ToolTip = 'Specifies the value of the GST field.', Comment = '%';
                }
                field(ContactNo; Rec.ContactNo)
                {
                    ToolTip = 'Specifies the value of the ContactNo field.', Comment = '%';
                }
                field(SecondaryContactNo; Rec.SecondaryContactNo)
                {
                    ToolTip = 'Specifies the value of the Secondary Contact No field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
            }
        }
    }
}
 
 
 