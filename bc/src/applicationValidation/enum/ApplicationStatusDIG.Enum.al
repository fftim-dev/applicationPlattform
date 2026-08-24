//Werte des Bewerbungsstatus für den Validierungsprozess.
enum 123456710 ApplicationStatus_DIG
{
    Extensible = true;

    value(0; "DATA VERIFICATION")
    {
        Caption = 'DATENVERIFIZIERUNG';
    }
    // University-specific  logic omitted from the public version.
    
    value(4; "VALIDATED")
    {
        Caption = 'VALIDIERT';
    }
}