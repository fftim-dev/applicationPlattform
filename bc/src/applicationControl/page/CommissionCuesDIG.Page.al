//Widgets für das RoleCenter der Zulassungsskommission
page 123456719 CommissionCues_DIG
{
    ApplicationArea = All;
    Caption = 'CommissionCues';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            //Anzeige von Kennzahlen in Widgets
            cuegroup(Applications)
            {
                CuegroupLayout = Wide;
                field(DataValidate; DataValidate)
                {
                    Caption = 'Zu validierende Bewerbungen';
                    ToolTip = 'Applications to validate';
                }
                field(ToProcess; ToProcess)
                {
                    Caption = 'Zu bearbeitende Bewerbungen';
                    ToolTip = 'Applications to process';
                }
                field(Validated; Validated)
                {
                    Caption = 'Validierte Bewerbungen';
                    ToolTip = 'Validated applications';
                }
                field(AllApplications; AllApplications)
                {
                    Caption = 'Alle Bewerbungen';
                    ToolTip = 'All applications';
                }
            }
        }
    }

    var
        //Variablen für die Speicherung von Kennzahlen
        DataValidate: Integer;
        AllApplications: Integer;
        ToProcess: Integer;
        Validated: Integer;

    //Berechnung von Kennzahlen beim Öffnen der Seite
    trigger OnOpenPage()
    var
        RecApp: Record ApplicationExternalData_DIG;
        RecPro: Record ApplicationProcessingData_DIG;
    begin
        //Summe der Anzahl der Zeilen aus der Tabelle ApplicationExternalData nach Status 
        AllApplications := RecApp.Count;
        RecApp.SetRange(Status, Enum::ApplicationStatus_DIG::"MODULES VERIFICATION");
        DataValidate := RecApp.Count;
        RecApp.Reset();
        RecApp.SetRange(Status, Enum::ApplicationStatus_DIG::"VALIDATED");
        Validated := RecApp.Count;
        
        // University-specific calculation logic omitted from the public version.
    end;

}
