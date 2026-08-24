//Tabelle zum Speichern der Daten der Module, die die Bewerber bei ihrer Bewerbung eingegeben haben.
table 123456709 Module_DIG
{
    Caption = 'Module';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; Application; Integer)
        {
            Caption = 'Application';
            TableRelation = ApplicationExternalData_DIG.ID;
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(4; CP; Decimal)
        {
            Caption = 'CP';
            DataClassification = CustomerContent;
        }
        field(5; Category; Code[3])
        {
            Caption = 'Category';
            TableRelation = ModuleCategory_DIG.Code;
            DataClassification = CustomerContent;
        }
        field(6; IT; Integer)
        {
            Caption = 'IT';
            TableRelation = ITCategories_DIG.ID;
            DataClassification = CustomerContent;
        }
        field(7; IT_Name; Text[50])
        {
            Caption = 'IT Category Caption';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
    //Beim Einfügen eines Datensatzes werden die Beschriftungen der IT-Kategorien 
    //zur Übersichtlichkeit automatisch hinzugefügt.
    trigger OnInsert()
    var
        RecCat: Record ITCategories_DIG;
    begin
        if RecCat.Get(Rec.IT) then
            Rec.IT_Name := RecCat.Name
        else
            //Wenn das Modul nicht aus dem IT-Bereich ist, wird „Non-IT“ eingefügt.
            Rec.IT_Name := 'Non-IT';
    end;

    //Prüfung vor der Änderung einer Tabellenzeile
    trigger OnModify()
    var
        RecCat: Record ITCategories_DIG;
        RecUser: Record User;
        user: Text;
        changes: Text;
    begin
        //Ein Modul kann nicht einer anderen Bewerbung zugeordnet werden.
        if Rec.Application <> xRec.Application then
            Error('NOT POSSIBLE TO CHANGE APPLICATION.');

        //Automatische Zuordnung von Beschriftungen bei der Wahl einer anderen IT-Kategorie.
        if RecCat.Get(Rec.IT) then
            Rec.IT_Name := RecCat.Name
        else
            Rec.IT_Name := 'Non-IT';
        //Sammeln von Änderungen, die in die Log-Tabelle geschrieben werden sollen.
        changes := '';
        if Rec.Name <> xRec.Name then
            changes += 'Name: ' + Format(xRec.Name) + ' -> ' + Format(Rec.Name) + '; ';
        if Rec.CP <> xRec.CP then
            changes += 'CP: ' + Format(xRec.CP) + ' -> ' + Format(Rec.CP) + '; ';
        if Rec.Category <> xRec.Category then
            changes += 'Category: ' + Format(xRec.Category) + ' -> ' + Format(Rec.Category) + '; ';
        if Rec.IT <> xRec.IT then
            changes += 'IT: ' + Format(xRec.IT) + ' -> ' + Format(Rec.IT) + '; ';
        if RecUser.Get(Rec.SystemModifiedBy) then
            user := RecUser."User Name"
        else
            Error('LOG EXCEPTION: USER NOT FOUND. NOT SAVED');
        //Wenn Änderungen gefunden werden, werden sie in die Log-Tabelle eingetragen.
        if not (changes = '') then
            WriteToLog(Rec.ID, Rec.SystemModifiedAt, user, 'Application ' + Format(Rec.Application) + ': ' + changes);
    end;

    //Funktion zur Speicherung der gesammelten Änderungen in der Log-Tabelle
    local procedure WriteToLog(RecordID: Integer; changedAt: DateTime; changedBy: Text; changes: Text)
    var
        RecLog: Record ModuleLog_DIG;
    begin
        RecLog.ModuleRecordID := RecordID;
        RecLog.ChangedAt := changedAt;
        RecLog.ChangedBy := CopyStr(changedBy, 1, 255);
        RecLog.Changes := CopyStr(changes, 1, 255);
        RecLog.Insert();
    end;
}
