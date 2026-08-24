//Tabelle mit Daten der Module Kategorien.
table 123456705 ModuleCategory_DIG
{
    Caption = 'ModuleCategory';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[3])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
