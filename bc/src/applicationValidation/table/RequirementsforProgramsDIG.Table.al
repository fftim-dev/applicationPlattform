//Tabelle für die Speicherung von Anforderungen für Studiengänge.
table 123456707 RequirementsforPrograms_DIG
{
    Caption = 'Requirements for Study Programs';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Program; Code[3])
        {
            Caption = 'Program';
            TableRelation = StudyProgram_DIG.Code;
            DataClassification = CustomerContent;
        }
        field(2; Category; Code[3])
        {
            Caption = 'Category';
            TableRelation = ModuleCategory_DIG.Code;
            DataClassification = CustomerContent;
        }
        field(3; CP; Decimal)
        {
            Caption = 'CP';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Program, Category)
        {
            Clustered = true;
        }
    }
}
