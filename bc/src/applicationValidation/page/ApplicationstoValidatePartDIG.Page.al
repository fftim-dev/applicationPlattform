//ListPart zur Ausgabe der Liste der zu validierenden Bewerbungen.
page 123456704 ApplicationstoValidatePart_DIG
{
    ApplicationArea = All;
    Caption = 'Applications to validate';
    PageType = ListPart;
    SourceTable = ApplicationExternalData_DIG;
    //Erlaubt keine Änderung der Tabellendaten, dient nur zur Anzeige von Bewerbungen.
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.', Comment = '%';
                    Caption = 'Bewerbungs-ID';
                }
                field(FirstName; Rec.FirstName)
                {
                    ToolTip = 'Specifies the value of the FirstName field.', Comment = '%';
                    Caption = 'Vorname';
                }
                field(LastName; Rec.LastName)
                {
                    ToolTip = 'Specifies the value of the LastName field.', Comment = '%';
                    Caption = 'Nachname';
                }
                field(StudyProgram; Rec.StudyProgram)
                {
                    ToolTip = 'Specifies the value of the Program field.', Comment = '%';
                    Caption = 'Studiengang';
                }
            }
        }
    }
    //Funktion zur Einschränkung von Zeilen der Tabelle nach Status.
    procedure SetStatusRange(status: Enum ApplicationStatus_DIG)
    begin
        Rec.SetRange(Status, status);
        CurrPage.Update();
    end;
}