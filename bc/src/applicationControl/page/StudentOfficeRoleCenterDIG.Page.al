//RoleCenter des Studienbüros
page 123456718 StudentOfficeRoleCenter_DIG
{
    ApplicationArea = All;
    Caption = 'StudentOfficeRoleCenter';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            //Widgets anzeigen
            part(StudentOfficeCues; StudentOfficeCues_DIG)
            {
                Caption = 'Informationen';
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            //Alle für das Studienbüro verfügbaren Aktionen. Actions öffnen die benötigten Pages.
            action("Validate")
            {
                Caption = 'Bewerbungsdaten validieren';
                ApplicationArea = All;
                RunObject = page ApplicationExternalData_DIG;
                ToolTip = 'Open ApplicationExternalData page';
            }
            action("Decision")
            {
                Caption = 'Entscheidung über die Bewerbung';
                ApplicationArea = All;
                RunObject = page ApplicationDecision_DIG;
                ToolTip = 'Open ApplicationDecision page';
            }
            action("Report")
            {
                Caption = 'Bericht generieren';
                ApplicationArea = All;
                RunObject = report SuccessfulApplications_DIG;
                ToolTip = 'Create SuccessfulApplications report';
            }
            action("StudyPrograms")
            {
                Caption = 'Studiengänge anzeigen';
                ApplicationArea = All;
                RunObject = page StudyPrograms_DIG;
                ToolTip = 'Show study programs';
            }
        }
    }
}
