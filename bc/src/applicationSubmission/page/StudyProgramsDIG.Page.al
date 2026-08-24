//Page für den Zugriff auf die Studiengänge aus der Tabelle StudyProgram
page 123456703 StudyPrograms_DIG
{
    ApplicationArea = All;
    Caption = 'Study Programs';
    PageType = List;
    SourceTable = StudyProgram_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
