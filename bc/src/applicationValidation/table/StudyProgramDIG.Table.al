//Tabelle für Studiengänge
table 123456703 StudyProgram_DIG
{
    Caption = 'StudyProgram';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[3])
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
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
