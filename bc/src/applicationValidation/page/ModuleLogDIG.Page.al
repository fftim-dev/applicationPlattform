//Page für den Zugriff auf Log-Einträge aus der Tabelle ModuleLog
page 123456702 ModuleLog_DIG
{
    ApplicationArea = All;
    Caption = '[Log] Modules';
    PageType = List;
    SourceTable = ModuleLog_DIG;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(LogRecordID; Rec.LogRecordID)
                {
                    ToolTip = 'Specifies the value of the LogRecordID field.', Comment = '%';
                }
                field(ModuleRecordID; Rec.ModuleRecordID)
                {
                    ToolTip = 'Specifies the value of the ModuleRecordID field.', Comment = '%';
                }
                field(ChangedAt; Rec.ChangedAt)
                {
                    ToolTip = 'Specifies the value of the ChangedAt field.', Comment = '%';
                }
                field(ChangedBy; Rec.ChangedBy)
                {
                    ToolTip = 'Specifies the value of the ChangedBy field.', Comment = '%';
                }
                field(Changes; Rec.Changes)
                {
                    ToolTip = 'Specifies the value of the Changes field.', Comment = '%';
                }
            }
        }
    }
}
