//Codeunit, die die Bewerbungsbearbeitung startet.
codeunit 123456701 StartApplicationProcess_DIG
{
    //Verfolgt die Statusänderungen in der Page <<Catalog of modules>> und erstellt einen Datensatz 
    //in der Tabelle ApplicationProcessingData, auf dessen Grundlage 
    //die Bewerbungsbearbeitung erfolgen wird.
    [EventSubscriber(ObjectType::Page, Page::CatalogofModules_DIG, 'OnApplicationAcccepted', '', false, false)]
    local procedure createProcessRecord(var id: Integer)
    var
        RecApp: Record ApplicationExternalData_DIG;
        RecPro: Record ApplicationProcessingData_DIG;
    begin
        //Wenn ein Datensatz in ApplicationExternalData gefunden wird, 
        //werden die für den Prozess erforderlichen Daten daraus kopiert.
        if RecApp.Get(id) then begin
            RecPro.Application := RecApp.ID;
            RecPro.FirstName := RecApp.FirstName;
            RecPro.LastName := RecApp.LastName;
            RecPro.Email := RecApp.Email;
            RecPro.StudyProgram := RecApp.StudyProgram;
            RecPro.FinalGrade := RecApp.EduFinalGrade;
            //Berechnung der Credit Points
            RecPro.CP := countCP(id);
            RecPro.IT := countIT(id);
            RecPro.MissingCP := countMissingCP(id);
            //Ausgangszustand nach Prozessbeginn - Reaktion erforderlich
            RecPro.RankingStatus := Enum::RankingStatus_DIG::"WAITING FOR REACTION";
            //Zeile wird in ApplicationProcessingData eingefügt.
            RecPro.Insert(true);
        end;
    end;

    //Funktion, die die Summe der Credit Points zurückgibt
    //berechnet wie countModules aus der Codeunit InternalModuleCounter_DIG
    local procedure countCP(id: Integer): Decimal
    begin
        // University-specific calculation logic omitted from the public version.
    end;
    //Funktion, die die Summe der IT Credit Points zurückgibt
    //berechnet wie countModules aus der Codeunit InternalModuleCounter_DIG
    local procedure countIT(id: Integer): Decimal
    var
        Rec: Record Module_DIG;
        it_cp: Decimal;
    begin
       // University-specific calculation logic omitted from the public version.
    end;
    //Funktion, die fehlende Credit Points zurückgibt
    //berechnet wie countModules aus der Codeunit InternalModuleCounter_DIG
    local procedure countMissingCP(id: Integer): Decimal
    begin
       // University-specific calculation logic omitted from the public version.
    end;
}
