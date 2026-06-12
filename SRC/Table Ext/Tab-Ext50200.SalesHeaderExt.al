tableextension 50200 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50200; "Google Drive URL"; Text[2048])
        {
            Caption = 'Google Drive URL';
            DataClassification = ToBeClassified;
        }
    }
}
