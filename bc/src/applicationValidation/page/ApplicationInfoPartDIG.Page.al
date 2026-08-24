//CardPart um Informationen über die Bewerbung für die Zulassungskommission anzuzeigen
page 123456716 ApplicationInfoPart_DIG
{
    ApplicationArea = All;
    Caption = 'ApplicationInfoPart';
    PageType = CardPart;
    SourceTable = ApplicationExternalData_DIG;

    layout
    {
        area(Content)
        {
            //In 3 Gruppen für eine bessere Übersichtlichkeit aufgeteilt
            group(General)
            {
                Caption = 'Persönliche Daten';

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
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                    Caption = 'E-Mail';
                }
                field(StudyProgram; Rec.StudyProgram)
                {
                    ToolTip = 'Specifies the value of the Program field.', Comment = '%';
                    Caption = 'Studiengang';
                }
            }
            group(ApplicationStatus)
            {
                Caption = 'Status der Bewerbung';
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Caption = 'Status';
                }
            }
            group(StudyData)
            {
                Caption = 'Universitätsdaten';

                field(EduCountry; Rec.EduCountry)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                    Caption = 'Land des Erststudiums';
                }
                field(EduUniversity; Rec.EduUniversity)
                {
                    ToolTip = 'Specifies the value of the University field.', Comment = '%';
                    Caption = 'Universität des Erststudiums';
                }
                field(EdurogramName; Rec.EduProgramName)
                {
                    ToolTip = 'Specifies the value of the ProgramName field.', Comment = '%';
                    Caption = 'Studiengang des Erststudiums';
                }
                field(EduDegree; Rec.EduDegree)
                {
                    ToolTip = 'Specifies the value of the Degree field.', Comment = '%';
                    Caption = 'Abschluss des Erststudiums';
                }
                field(EduFinalGrade; Rec.EduFinalGrade)
                {
                    ToolTip = 'Specifies the value of the FinalGrade field.', Comment = '%';
                    Caption = 'Abschlussnote';
                }
            }
        }
    }

    //Beim Öffnen der Page
    trigger OnOpenPage()
    begin
        //Damit vor der Auswahl einer Bewerbung keine Daten angezeigt werden
        GetData(0);
    end;

    //Funktion zur Auswahl der anzuzeigenden Bewerbung nach ID
    procedure GetData(newID: Integer)
    begin
        Rec.SetRange(Rec.ID, newID);
        CurrPage.Update(false);
    end;
}