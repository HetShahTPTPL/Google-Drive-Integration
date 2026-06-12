pageextension 50200 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Google Drive URL"; Rec."Google Drive URL")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}