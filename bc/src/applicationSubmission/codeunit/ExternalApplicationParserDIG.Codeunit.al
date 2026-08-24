//Codeunit zur Bearbeitung von extern eingegangenen Bewerbungen.
codeunit 123456709 ExternalApplicationParser_DIG
{
    //Funktion zur Dekodierung der json-Datei mit den Modulen und zur Berechnung, 
    //ob sie die Mindestanforderungen für die Bewerbung erfüllen.
    procedure countModulesFromJson(data: Text; program: Code[3]): Text
    var
        RecCat: Record RequirementsforPrograms_DIG;
        //Variablen für JSON
        jsonArray: JsonArray;
        jsonToken: JsonToken;
        jsonObject: JsonObject;

        category: Code[3];
        cat_temp: Text;
        categoryToken: JsonToken;
        CP: Decimal;
        CPToken: JsonToken;
        IT: Integer;
        ITToken: JsonToken;
        req: Dictionary of [Code[3], Decimal];
        reqKey: Code[3];
        reqValue: Decimal;
        is: Dictionary of [Code[3], Decimal];
        isKey: Code[3];
        isValue: Decimal;
        cp_sum: Decimal;
        temp: Decimal;
        it_cp: Decimal;
        missing_cp: Decimal;
        module: Integer;
        result: Text;
    begin
        //Wenn data Format nicht JSON ist, bricht die Funktion ab.
        if not jsonArray.ReadFrom(data) then
            exit('Failed to read');

        //Anforderungssammlung, Befüllen von Dictionary
        RecCat.SetFilter("Program", program);
        if RecCat.FindSet() then
            repeat
                req.Add(RecCat.Category, RecCat.CP)
            until RecCat.Next() = 0;

        //Erstellen von der IST Dictionary
        foreach reqKey in req.Keys do begin
            req.Get(reqKey, reqValue);
            is.Add(reqKey, 0);
        end;

        cp_sum := 0;
        it_cp := 0;
        //Ablesen und spreichern aus JSON
        for module := 0 to jsonArray.Count() - 1 do begin
            jsonArray.Get(module, jsonToken);
            jsonObject := jsonToken.AsObject();

            jsonObject.Get('Category', categoryToken);
            cat_temp := categoryToken.AsValue().AsCode();
            category := CopyStr(cat_temp, 1, MaxStrLen(category));

            jsonObject.Get('CP', CPToken);
            CP := CPToken.AsValue().AsDecimal();

            jsonObject.Get('IT', ITToken);
            IT := ITToken.AsValue().AsInteger();
            //Befüllen von der IST Dictionary
            foreach isKey in is.Keys do begin
                is.Get(isKey, isValue);
                if isKey = category then begin
                    isValue += CP;
                    is.Set(isKey, isValue);
                end;
            end;
            //Berechnet die Summe allen CPs
            cp_sum += CP;
            //Berehnet IT Credit Points, wenn Kategorie IT gehört
            if IT > 0 then it_cp += CP;
        end;
        
        // University-specific calculation logic omitted from the public version.
    end;

    //Funktion zum Schreiben von Bewerbungsdaten und Modulen aus json-Dateien in Tabellen
    procedure submitApplication(data: Text; modules: Text): Text
    var
        RecApp: Record ApplicationExternalData_DIG;
        RecMod: Record Module_DIG;
        tempToken: JsonToken;
        personalDataObject: JsonObject;
        modulesArray: JsonArray;
        moduleObject: JsonObject;
        insertedID: Integer;
        module: Integer;
        temp_string: Text;
    begin
        //Wenn data Format nicht JSON ist, bricht die Funktion ab.
        if not personalDataObject.ReadFrom(data) then
            exit('Failed to read');
        if not modulesArray.ReadFrom(modules) then
            exit('Failed to read');

        //Ablesen und spreichern aus JSON
        personalDataObject.Get('FirstName', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.FirstName := CopyStr(temp_string, 1, 50); //damit die Anzahl der Zeichen nicht überschritten wird

        personalDataObject.Get('LastName', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.LastName := CopyStr(temp_string, 1, 50);

        personalDataObject.Get('Email', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.Email := CopyStr(temp_string, 1, 254);

        personalDataObject.Get('Phone', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.Phone := CopyStr(temp_string, 1, 20);

        personalDataObject.Get('BirthDate', tempToken);
        RecApp.BirthDate := tempToken.AsValue().AsDate();

        personalDataObject.Get('Nationality', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.Nationality := CopyStr(temp_string, 1, 50);

        personalDataObject.Get('EduCountry', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.EduCountry := CopyStr(temp_string, 1, 50);

        personalDataObject.Get('EduUniversity', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.EduUniversity := CopyStr(temp_string, 1, 100);

        personalDataObject.Get('EduProgramName', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.EduProgramName := CopyStr(temp_string, 1, 100);

        personalDataObject.Get('EduDegree', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.EduDegree := CopyStr(temp_string, 1, 50);

        personalDataObject.Get('EduFinalGrade', tempToken);
        RecApp.EduFinalGrade := tempToken.AsValue().AsDecimal();

        personalDataObject.Get('StudyProgram', tempToken);
        temp_string := tempToken.AsValue().AsText();
        RecApp.StudyProgram := CopyStr(temp_string, 1, 3);
        //Persöhnliche Daten speichern
        RecApp.Insert(true);
        //Speichern der zugewiesenen Bewerbungs-ID für Module
        insertedID := RecApp.ID;
        //Module aus JSON ablesen und spreichern
        for module := 0 to modulesArray.Count() - 1 do begin
            modulesArray.Get(module, tempToken);
            moduleObject := tempToken.AsObject();

            moduleObject.Get('Name', tempToken);
            temp_string := tempToken.AsValue().AsText();
            RecMod.Name := CopyStr(temp_string, 1, 50);

            moduleObject.Get('CP', tempToken);
            temp_string := tempToken.AsValue().AsText();
            RecMod.CP := tempToken.AsValue().AsDecimal();

            moduleObject.Get('Category', tempToken);
            temp_string := tempToken.AsValue().AsText();
            RecMod.Category := CopyStr(temp_string, 1, 3);

            moduleObject.Get('IT', tempToken);
            RecMod.IT := tempToken.AsValue().AsInteger();
            //Zugewiesene ID für Module
            RecMod.Application := insertedID;

            RecMod.Insert(true);
            Clear(RecMod);
        end;
        exit('Application successfully submitted');
    end;
}
