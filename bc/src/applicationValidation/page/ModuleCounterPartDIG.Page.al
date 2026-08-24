//CardPart für die Ausgabe des Ergebnisses von Berechnungen des InternalModuleCounter
page 123456715 ModuleCounterPart_DIG
{
    ApplicationArea = All;
    Caption = 'ModuleCounter';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'ModuleCounter';
                ShowCaption = false;
                field(output; output)
                {
                    Caption = 'Result';
                    ShowCaption = false;
                    ToolTip = 'Counts';
                    MultiLine = true;
                }
            }
        }
    }

    var
        output: Text;

    //Funktion zur Ausgabe des an Page übergebenen Ergebnisses.
    procedure setOutput(text: Text)
    begin
        output := text;
        CurrPage.Update(false);
    end;
}