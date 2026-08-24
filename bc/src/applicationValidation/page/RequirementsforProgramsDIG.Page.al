//Page für den Zugriff auf Anforderungen für Studiengänge aus der Tabelle RequirementsforPrograms
page 123456707 RequirementsforPrograms_DIG
{
    ApplicationArea = All;
    Caption = 'Requirements for Study Programs';
    PageType = List;
    SourceTable = RequirementsforPrograms_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Program"; Rec."Program")
                {
                    ToolTip = 'Specifies the value of the Program field.', Comment = '%';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.', Comment = '%';
                }
                field(CP; Rec.CP)
                {
                    ToolTip = 'Specifies the value of the CP field.', Comment = '%';
                }
            }
        }
    }
}
