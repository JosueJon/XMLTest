// pageextension 50001 TestSalesLine extends "Sales Invoice Subform"
// {
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
