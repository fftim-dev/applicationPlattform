//Widgets für das RoleCenter des Studienbüros
page 123456717 StudentOfficeCues_DIG
{
    ApplicationArea = All;
    Caption = 'StudentOfficeCues';
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
                field(ToMakeDecisions; ToMakeDecisions)
                {
                    Caption = 'Bewerbungen zur Entscheidung';
                    ToolTip = 'Applications to decide';
                }
                field(Validated; Validated)
                {
                    Caption = 'Von der Kommission validierte Bewerbungen';
                    ToolTip = 'Validated applications by commission';
                }
                field(AllApplications; AllApplications)
                {
                    Caption = 'Alle Bewerbungen';
                    ToolTip = 'All applications';
                }
            }
            //Kennzeichen für endgültige Bewerbungsentscheidungen in Widgets anzeigen
            cuegroup(Decisions)
            {
                Caption = 'Finale Entscheidungen';
                field(Accepted; Accepted)
                {
                    Caption = 'Zugelassene Bewerbungen';
                    ToolTip = 'Accepted applications';
                }
                field(Reserved; Reserved)
                {
                    Caption = 'Bewerbungen in der Reserve';
                    ToolTip = 'Applications in reserve';
                }
                field(Rejected; Rejected)
                {
                    Caption = 'Abgelehnte Bewerbungen';
                    ToolTip = 'Rejected applications';
                }
            }
        }
    }

    var
        //Variablen für die Speicherung von Kennzahlen
        DataValidate: Integer;
        AllApplications: Integer;
        ToMakeDecisions: Integer;
        Accepted: Integer;
        Reserved: Integer;
        Rejected: Integer;
        Validated: Integer;

    //Berechnung von Kennzahlen beim Öffnen der Seite
    trigger OnOpenPage()
    var
        RecApp: Record ApplicationExternalData_DIG;
        RecPro: Record ApplicationProcessingData_DIG;
    begin
        //Summe der Anzahl der Zeilen aus der Tabelle ApplicationExternalData nach Status 
        AllApplications := RecApp.Count;
        RecApp.SetRange(Status, Enum::ApplicationStatus_DIG::"DATA VERIFICATION");
        DataValidate := RecApp.Count;
        RecApp.Reset();
        RecApp.SetRange(Status, Enum::ApplicationStatus_DIG::"VALIDATED");
        Validated := RecApp.Count;

        // University-specific calculation logic omitted from the public version.
    end;
}
