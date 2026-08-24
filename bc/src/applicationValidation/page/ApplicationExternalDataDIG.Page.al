//Page für die Validierung der Bewerbungsdaten durch das Studienbüro.
page 123456710 ApplicationExternalData_DIG
{
    ApplicationArea = All;
    Caption = 'Bewerbungsdaten';
    PageType = List;
    SourceTable = ApplicationExternalData_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(ApplicationsToVerify)
            {
                Caption = 'Bewerbungen zur Validierung';
                //Eingabe der Bewerbungsnummer.
                field(filterID; filterID)
                {
                    ApplicationArea = all;
                    Caption = 'Bewerbung auswählen';
                    ToolTip = 'Application ID';
                }
                //ListPart mit zu validierenden Bewerbungen.
                part(ApplicationstoValidate; ApplicationstoValidatePart_DIG)
                {
                    Caption = 'Liste der Bewerbungen';
                    ApplicationArea = all;
                }
            }
            //Anzeige der Bewerbungstabelle.
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
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                    Caption = 'E-Mail';
                }
                field(Phone; Rec.Phone)
                {
                    ToolTip = 'Specifies the value of the Phone field.', Comment = '%';
                    Caption = 'Telefonnummer';
                }
                field(BirthDate; Rec.BirthDate)
                {
                    ToolTip = 'Specifies the value of the BirthDate field.', Comment = '%';
                    Caption = 'Geburtsdatum';
                }
                field(Nationality; Rec.Nationality)
                {
                    ToolTip = 'Specifies the value of the Nationality field.', Comment = '%';
                    Caption = 'Staatsangehörigkeit';
                }
                field(Country; Rec.EduCountry)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                    Caption = 'Land des Erststudiums';
                }
                field(University; Rec.EduUniversity)
                {
                    ToolTip = 'Specifies the value of the University field.', Comment = '%';
                    Caption = 'Universität des Erststudiums';
                }
                field(ProgramName; Rec.EduProgramName)
                {
                    ToolTip = 'Specifies the value of the ProgramName field.', Comment = '%';
                    Caption = 'Studiengang des Erststudiums';
                }
                field(Degree; Rec.EduDegree)
                {
                    ToolTip = 'Specifies the value of the Degree field.', Comment = '%';
                    Caption = 'Abschluss des Erststudiums';
                }
                field(FinalGrade; Rec.EduFinalGrade)
                {
                    ToolTip = 'Specifies the value of the FinalGrade field.', Comment = '%';
                    Caption = 'Abschlussnote';
                }
                field(StudyProgram; Rec.StudyProgram)
                {
                    ToolTip = 'Specifies the value of the Program field.', Comment = '%';
                    Caption = 'Studiengang';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Caption = 'Eingereicht am';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Caption = 'Status';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                    Caption = 'Kommentar';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                //Bewerbungsdaten nach ID öffnen.
                action("OpenApplication")
                {
                    ApplicationArea = all;
                    Caption = 'Bewerbung öffnen';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = NextRecord;
                    ToolTip = 'Bewerbung öffnen';

                    trigger OnAction()
                    begin
                        if filterID = 0 then
                            Rec.SetFilter("ID", '')
                        else
                            Rec.SetFilter("ID", '%1', filterID);
                        CurrPage.Update(false);

                    end;
                }
                //Die Bewerbung schließen.
                action("CloseApplication")
                {
                    ApplicationArea = all;
                    Caption = 'Bewerbung schließen';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = RejectFluent;
                    ToolTip = 'Bewerbung schließen';

                    trigger OnAction()
                    begin
                        filterID := 0;
                        Rec.Reset();
                        CurrPage.Update(false);
                    end;
                }
                //Persönliche Daten validieren und zur weiteren Überprüfung 
                //an die Zulassungskommission weitergeben.
                action("ValidateApplication")
                {
                    ApplicationArea = all;
                    Caption = 'Validieren';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Approve;
                    ToolTip = 'Validieren';

                    trigger OnAction()
                    begin
                        //Wenn der Benutzer zustimmt wird der Status geändert.
                        if Confirm('Status auf MODULVALIDIERUNG ändern?') then
                            if Rec.Get(filterID) then begin
                                Rec.Status := Enum::ApplicationStatus_DIG::"MODULES VERIFICATION";
                                Rec.Modify();
                                OnApplicationCheckModules(filterID); //erweiterbare Logik
                                Message('GESPEICHERT');
                            end
                            else
                                Error('BEWERBUNG NICHT GEFUNDEN');
                    end;
                }
                //Die Bewerbung ablehnen.
                action("RejectApplication")
                {
                    ApplicationArea = all;
                    Caption = 'Ablehnen';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Cancel;
                    ToolTip = 'Ablehnen';

                    trigger OnAction()
                    var
                        Msg: Codeunit "Email Message";
                        Email: Codeunit Email;
                        newLine: Char;
                    begin
                        newLine := 10;
                        //Wenn der Benutzer zustimmt wird der Status geändert.
                        if Confirm('Status auf ABGELEHNT ändern?') then
                            if Rec.Get(filterID) then begin
                                Rec.Status := Enum::ApplicationStatus_DIG::"REJECTED - ST. OFFICE";
                                Rec.Modify();
                                OnApplicationRejected(filterID); //erweiterbare Logik
                                //eine Standard-E-Mail wird erstellt
                                Msg.Create(Rec.Email, 'Application unsuccessfull',
                                    'Hello,' + newLine + 'your application was unsuccessfull.' + newLine + 'Best wishes,' + newLine + 'Team');
                                //wird im E-Mail-Editor geöffnet
                                Email.OpenInEditor(Msg, Enum::"Email Scenario"::Default);
                            end
                            else
                                Error('BEWERBUNG NICHT GEFUNDEN');
                    end;
                }
            }
        }
    }

    var
        filterID: Integer;

    //Beim Öffnen der Seite werden die zu validierenden Bewerbungen aufgelistet
    trigger OnOpenPage()
    begin
        CurrPage.ApplicationstoValidate.Page.SetStatusRange(Enum::ApplicationStatus_DIG::"DATA VERIFICATION");
    end;

    //IntegrationEvent für die Erweiterbarkeit des Codes. Es kann von EventSubscribe gefolgt werden, 
    //um einige Aktionen bei Änderungen des Status der Bewerbung durchzuführen.
    [IntegrationEvent(false, false)]
    procedure OnApplicationCheckModules(var id: Integer)
    begin
    end;

    //IntegrationEvent für die Erweiterbarkeit des Codes. Es kann von EventSubscribe gefolgt werden, 
    //um einige Aktionen bei Änderungen des Status der Bewerbung durchzuführen.
    [IntegrationEvent(false, false)]
    procedure OnApplicationRejected(var id: Integer)
    begin
    end;
}
