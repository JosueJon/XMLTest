xmlport 50603 AprendiendoXML
{
    Format = Xml;
    Caption = ' Xml Port Coy and page';
    Direction = Export;
    Encoding = UTF8;
    // DefaultFieldsValidation = true;
    // TableSeparator =  '<NewLine> <NewLine\>';
    UseRequestPage = false;


    schema
    {
        textelement(NodoPrincipal)
        {
            // tableelement(Integer; Integer)
            // {
            //     XmlName = 'NombreNodo';
            //     SourceTableView = sorting(Number) where(Number = const(1));
            //     textelement(ItemNoTitle)
            //     {
            //         trigger OnBeforePassVariable()
            //         var

            //         begin
            //             ITEMDescription := Item.FieldCaption("No.")
            //         end;
            //     }
            //     textelement(ItemDescription)
            //     {
            //         trigger OnBeforePassVariable()
            //         var

            //         begin
            //             ITEMDescription := Item.FieldCaption(Description)
            //         end;
            //     }
            //     textelement(ItemTypeTitle)
            //     {
            //         trigger OnBeforePassVariable()
            //         var

            //         begin
            //             ITEMDescription := Item.FieldCaption(Type)
            //         end;
            //     }
            // }



            tableelement(Item; Item)
            {
                XmlName = 'PruebaCFDI';
                RequestFilterFields = "No.";
                fieldelement(Numero; Item."No.")
                {
                    trigger OnAfterAssignField()
                    var
                        myInt: Integer;
                    begin

                    end;
                }
                fieldelement(Description; Item.Description) { }
                fieldelement(Inventory; Item.Inventory) { }



            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    // field(Name; Item.AssistEdit())
                    // {

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    }

    var
        myInt: Integer;
}
