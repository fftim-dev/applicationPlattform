//Page für den Zugriff auf die IT-Kategorien aus der Tabelle ITCategories
page 123456713 ITCategories_DIG
{
    ApplicationArea = All;
    Caption = 'ITCategories';
    PageType = List;
    SourceTable = ITCategories_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
