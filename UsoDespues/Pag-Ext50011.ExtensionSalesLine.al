// pageextension 50011 ExtensionSalesLine extends "Sales Invoice Subform"
// {
//     layout
//     {
//         addafter(FilteredTypeField)
//         {
//             field("Catalogo"; Rec.catalogoTEST)
//             {

//                 ApplicationArea = All;
//             }
//         }
//     }
//     actions
//     {
//         addbefore("&Line")
//         {
//             action(NombredeXMLTestGetData)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     codXMLGETData: Codeunit XMLtestSalesInvoice;
//                 begin
//                     codXMLGETData.XMLv4(Rec);
//                 end;
//             }
//         }
//     }
// }

