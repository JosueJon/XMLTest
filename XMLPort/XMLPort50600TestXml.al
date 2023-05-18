#region INTENTO DE CREAR UN XML
// xmlport 50600 MyXmlport
// {
//     Caption = 'My XmlPort';
//     InlineSchema = true;
//     Direction = Export;
//     Format = Xml;

//     schema
//     {
//         textelement(NodeName1)
//         {
//             tableelement(NodeName2; "AAD Application")
//             {
//                 fieldattribute(NodeName3; NodeName2."App Name")
//                 {

//                 }
//             }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(GroupName)
//                 {
//                     field(Name; NodeName1)
//                     {

//                     }
//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {

//                 }
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }
#endregion

#region COPIA DEL VIDEO DE YOTUTUBE
xmlport 50600 XmlPortCAP
{
    Format = Xml;
    Caption = ' Xml Port Coy and page';
    Direction = Export;
    Encoding = UTF8;
    Namespaces = cfdi = 'http://www.w3.org/2001/XMLSchema', xs = 'http://www.w3.org/2001/XMLSchema';
    UseRequestPage = false;


    schema
    {
        textelement(RootName)
        {
            tableelement(Integer; Integer)
            {
                NamespacePrefix = 'cfdi';
                XmlName = 'ItemInicio';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(ItemNoTitle)
                {
                    trigger OnBeforePassVariable()
                    var 
                    

                    begin
                        ITEMDescription := Item.FieldCaption("No.")
                    end;

                }
                textelement(ItemDescription)
                {
                    trigger OnBeforePassVariable()
                    var

                    begin
                        ITEMDescription := Item.FieldCaption(Description)
                    end;
                }
                textelement(ItemTypeTitle)
                {
                    trigger OnBeforePassVariable()
                    var

                    begin
                        ITEMDescription := Item.FieldCaption(Type)
                    end;
                }
            }



            tableelement(Item; Item)
            {


                XmlName = 'Prueba';
                RequestFilterFields = "No.";
                fieldelement(Numero; Item."No.") { }
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
                    //Con este se abre  el asistente que te deja elejir cual producto
                    field(Name; Item.AssistEdit())
                    {

                    }
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
#endregion