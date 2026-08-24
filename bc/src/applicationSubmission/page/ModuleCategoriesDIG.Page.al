//Page für den Zugriff auf die Modulkategorien aus der Tabelle ModuleCategory
page 123456705 ModuleCategories_DIG
{
    ApplicationArea = All;
    Caption = 'Module Categories';
    PageType = List;
    SourceTable = ModuleCategory_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
