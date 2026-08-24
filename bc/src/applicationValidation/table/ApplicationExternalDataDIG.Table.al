//Tabelle mit Daten aus extern eingegangenen Bewerbungen.
table 123456710 ApplicationExternalData_DIG
{
    Caption = 'Application External Data';
    DataClassification = EndUserIdentifiableInformation;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(2; FirstName; Text[50])
        {
            Caption = 'FirstName';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; LastName; Text[50])
        {
            Caption = 'LastName';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; Email; Text[254])
        {
            Caption = 'Email';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; Phone; Text[20])
        {
            Caption = 'Phone';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; BirthDate; Date)
        {
            Caption = 'BirthDate';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; Nationality; Text[50])
        {
            Caption = 'Nationality';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; EduCountry; Text[50])
        {
            Caption = 'EduCountry';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; EduUniversity; Text[100])
        {
            Caption = 'EduUniversity';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; EduProgramName; Text[100])
        {
            Caption = 'EduProgramName';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; EduDegree; Text[50])
        {
            Caption = 'EduDegree';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; EduFinalGrade; Decimal)
        {
            Caption = 'EduFinalGrade';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "StudyProgram"; Code[3])
        {
            Caption = 'Program';
            TableRelation = StudyProgram_DIG.Code;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(14; Status; Enum ApplicationStatus_DIG)
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(15; Comment; Text[200])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
