//RoleCenter der Zulassungsskommission
page 123456720 CommissionRoleCenter_DIG
{
    ApplicationArea = All;
    Caption = 'CommissionRoleCenter';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            //Widgets anzeigen
            part(CommissionCues; CommissionCues_DIG)
            {
                Caption = 'Informationen';
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            //Alle für die Kommission verfügbaren Aktionen. Actions öffnen die benötigten Pages.
            action("Validate")
            {
                Caption = 'Module validieren';
                ApplicationArea = All;
                RunObject = page CatalogofModules_DIG;
                ToolTip = 'Open CatalogofModules page';
            }
            action("Process")
            {
                Caption = 'Bearbeitung der Bewerbungen';
                ApplicationArea = All;
                RunObject = page ApplicationProcessing_DIG;
                ToolTip = 'Open ApplicationProcessing page';
            }
            action("Requirements")
            {
                Caption = 'Anforderungen für Studiengänge ändern';
                ApplicationArea = All;
                RunObject = page RequirementsforPrograms_DIG;
                ToolTip = 'Open RequirementsforPrograms page';
            }
            action("ModuleCategories")
            {
                Caption = 'Modulkategorien anzeigen';
                ApplicationArea = All;
                RunObject = page ModuleCategories_DIG;
                ToolTip = 'Open Module Categories page';
            }
            action("ITCategories")
            {
                Caption = 'IT-Kategorien anzeigen';
                ApplicationArea = All;
                RunObject = page ITCategories_DIG;
                ToolTip = 'Open ITCategories page';
            }
            action("ModuleLog")
            {
                Caption = 'Log der Modultabelle anzeigen';
                ApplicationArea = All;
                RunObject = page ModuleLog_DIG;
                ToolTip = 'Open ModuleLog page';
            }
        }
    }
}
