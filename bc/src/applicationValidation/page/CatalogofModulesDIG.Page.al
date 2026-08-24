//Page für die Prüfung der Module durch die Zulassungskommission.
page 123456709 CatalogofModules_DIG
{
    ApplicationArea = All;
    Caption = 'Module validieren';
    PageType = List;
    SourceTable = Module_DIG;
    UsageCategory = Lists;
    PromotedActionCategories = 'New, Process, Report, Manage, NewDocument, NumOperations, TextOperations, AbsOperations, Record-ID anzeigen';

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
            //Teil für die Eingabe von Kommentaren zu der Bewerbung.
            group(Comments)
            {
                Caption = 'Interne Kommentare';
                field(comment; comment)
                {
                    ApplicationArea = all;
                    Caption = 'Kommentar:';
                    ToolTip = 'Kommentar';
                }
            }
            //Anzeige der Modultabelle.
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'ID';
                    Caption = 'Record ID';
                    Visible = visibleID;
                }
                field(Application; Rec.Application)
                {
                    ToolTip = 'Specifies the value of the Application field.', Comment = '%';
                    Caption = 'Bewerbungs-ID';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    Caption = 'Modulname';
                }
                field(CP; Rec.CP)
                {
                    ToolTip = 'Specifies the value of the CP field.', Comment = '%';
                    Caption = 'Credit Points';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.', Comment = '%';
                    Caption = 'Kategorie';
                }
                field(IT; Rec.IT)
                {
                    ToolTip = 'Specifies the value of the IT field.', Comment = '%';
                    Caption = 'IT Kategorie';
                }
                field(IT_Name; Rec.IT_Name)
                {
                    ToolTip = 'Specifies the value of the IT field.', Comment = '%';
                    Caption = 'Name der IT Kategorie';
                }
            }
        }
        //Informationsfelder auf der rechten Seite.
        area(FactBoxes)
        {
            //Ausgabe für Modulberechnungen.
            part(mc; ModuleCounterPart_DIG)
            {
                ApplicationArea = all;
                Caption = 'Resultat der Berechnung';
            }
            //Ausgabe von Informationen über die Bewerbung.
            part(ApplicationInfo; ApplicationInfoPart_DIG)
            {
                ApplicationArea = all;
                Caption = 'Bewerbungsdaten';
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
                    var
                        RecApp: Record ApplicationExternalData_DIG;
                        counter: Codeunit InternalModuleCounter_DIG;
                    begin
                        if filterID = 0 then
                            Rec.SetFilter("Application", '')
                        else
                            Rec.SetFilter("Application", '%1', filterID);
                        CurrPage.mc.Page.setOutput(counter.countModules(filterID)); //Module berechnen
                        if RecApp.Get(filterID) then comment := RecApp.Comment; //Kommentar anzeigen
                        CurrPage.ApplicationInfo.Page.GetData(filterID); //Bewerbungsinformationen anzeigen
                        CurrPage.Update(false);

                    end;
                }
                //Die Bewerbung schließen und die Felder leeren.
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
                        CurrPage.mc.Page.setOutput('BITTE BEWERBUNG AUSWÄHLEN');
                        comment := '';
                        CurrPage.ApplicationInfo.Page.GetData(0);
                        CurrPage.Update(false);
                    end;
                }
                //Kommentar zur Bewerbung speichern.
                action("SaveComment")
                {
                    ApplicationArea = all;
                    Caption = 'Kommentar speichern';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Save;
                    ToolTip = 'Kommentar speichern';

                    trigger OnAction()
                    var
                        RecApp: Record ApplicationExternalData_DIG;
                    begin
                        if RecApp.Get(filterID) then begin
                            RecApp.Comment := comment;
                            RecApp.Modify();
                            Message('Kommentar gespeichert');
                        end else
                            Error('BEWERBUNG NICHT GEFUNDEN');
                    end;
                }
                //Bewerbung als validiert markieren.
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
                    var
                        RecApp: Record ApplicationExternalData_DIG;
                    begin
                        //Wenn der Benutzer zustimmt wird der Status geändert und ein Kommentar gespeichert.
                        if Confirm('Change status to VALIDATED?') then
                            if RecApp.Get(filterID) then begin
                                RecApp.Status := Enum::ApplicationStatus_DIG::VALIDATED;
                                RecApp.Comment := comment;
                                RecApp.Modify();
                                OnApplicationAcccepted(filterID); //erweiterbare Logik
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
                        RecApp: Record ApplicationExternalData_DIG;
                        Msg: Codeunit "Email Message";
                        Email: Codeunit Email;
                        newLine: Char;
                    begin
                        newLine := 10;
                        //Wenn der Benutzer zustimmt wird der Status geändert und ein Kommentar gespeichert.
                        if Confirm('Status auf ABGELEHNT ändern?') then
                            if RecApp.Get(filterID) then begin
                                RecApp.Status := Enum::ApplicationStatus_DIG::"REJECTED - COMISSION";
                                RecApp.Comment := comment;
                                RecApp.Modify();
                                OnApplicationRejected(filterID); //erweiterbare Logik
                                //eine Standard-E-Mail wird erstellt
                                Msg.Create(RecApp.Email, 'Application unsuccessfull',
                                    'Hello,' + newLine + 'your application was unsuccessfull.' + newLine + 'Best wishes,' + newLine + 'Team');
                                //wird im E-Mail-Editor geöffnet
                                Email.OpenInEditor(Msg, Enum::"Email Scenario"::Default);
                            end
                            else begin
                                CurrPage.mc.Page.setOutput('BEWERBUNG NICHT GEFUNDEN');
                                Error('BEWERBUNG NICHT GEFUNDEN');
                            end;
                    end;
                }
            }
            group(IDFunctions)
            {
                //Zeigt die ID des Datensatzes für die Nachverfolgung in der Log-Tabelle.
                action("ShowRecordID")
                {
                    ApplicationArea = all;
                    Caption = 'Record-ID anzeigen';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category9;
                    Image = Indent;
                    ToolTip = 'Record-ID anzeigen';

                    trigger OnAction()
                    begin
                        visibleID := true;
                        CurrPage.Update();
                    end;
                }
                //Versteckt ID des Datensatzes.
                action("HideRecordID")
                {
                    ApplicationArea = all;
                    Caption = 'Record-ID ausblenden';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category9;
                    Image = Indent;
                    ToolTip = 'Record-ID ausblenden';

                    trigger OnAction()
                    begin
                        visibleID := false;
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        filterID: Integer;
        visibleID: Boolean;
        comment: Text[200];

    //Automatische Neuberechnung von Modulen nach Datensatzänderungen.
    trigger OnModifyRecord(): Boolean
    var
        counter: Codeunit InternalModuleCounter_DIG;
    begin
        Rec.Modify();
        if filterID <= 0 then
            CurrPage.mc.Page.setOutput('BITTE BEWERBUNG AUSWÄHLEN')
        else
            CurrPage.mc.Page.setOutput(counter.countModules(filterID));
    end;

    //Beim Öffnen der Seite werden die zu validierenden Bewerbungen aufgelistet
    trigger OnOpenPage()
    begin
        CurrPage.ApplicationstoValidate.Page.SetStatusRange(Enum::ApplicationStatus_DIG::"MODULES VERIFICATION");
        CurrPage.mc.Page.setOutput('BITTE BEWERBUNG AUSWÄHLEN');
    end;

    //IntegrationEvent für die Erweiterbarkeit des Codes. Es kann von EventSubscribe gefolgt werden, 
    //um einige Aktionen bei Änderungen des Status der Bewerbung durchzuführen.
    [IntegrationEvent(false, false)]
    procedure OnApplicationAcccepted(var id: Integer)
    begin

    end;

    //IntegrationEvent für die Erweiterbarkeit des Codes. Es kann von EventSubscribe gefolgt werden, 
    //um einige Aktionen bei Änderungen des Status der Bewerbung durchzuführen.
    [IntegrationEvent(false, false)]
    procedure OnApplicationRejected(var id: Integer)
    begin

    end;
}
