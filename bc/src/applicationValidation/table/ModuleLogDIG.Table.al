//Tabelle zur Speicherung des Logs von Änderungen der Modultabelle.
table 123456702 ModuleLog_DIG
{
    Caption = 'ModuleLog';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; LogRecordID; Integer)
        {
            Caption = 'LogRecordID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; ModuleRecordID; Integer)
        {
            Caption = 'ModuleRecordID';
            DataClassification = SystemMetadata;
        }
        field(3; ChangedAt; DateTime)
        {
            Caption = 'ChangedAt';
            DataClassification = SystemMetadata;
        }
        field(4; ChangedBy; Text[255])
        {
            Caption = 'ChangedBy';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(5; Changes; Text[255])
        {
            Caption = 'Changes';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; LogRecordID)
        {
            Clustered = true;
        }
    }
}
