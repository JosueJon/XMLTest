/*para agregar el xml en la parte de facturas */
pageextension 50900 PageSaleXML extends "Sales Invoice"
{
    actions
    {
        addafter(Action9)
        {
            action("XMLCFDI4.0")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50701';
                ToolTip = 'prueba de CFDI';
                trigger OnAction()
                var
                    TestCu: Codeunit "XmlTest1.0";
                begin
                    TestCu.XMLv4(); //this is a name the fuction 
                    // Message('Procesado');
                end;
            }

            action("XMLCFDI4.0v2")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50781';
                ToolTip = 'prueba de CFDIv2';
                trigger OnAction()
                var
                    v_SalesLine: Page "Sales Invoice Subform";
                    TestCu: Codeunit "XMLtest2";
                begin
                    TestCu.XMLv4(Rec); //this is a name the fuction 
                    // TestCu.VariableLocalSubform(Rec)

                    // Message('Procesado');
                end;
            }
            action("XMLCFDI4v2.1")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50782';
                ToolTip = 'prueba de CFDIv2.1';
                trigger OnAction()
                var
                    v_SalesLine: Page "Sales Invoice Subform";
                    TestCu: Codeunit "XMLtest2.1";
                begin
                    TestCu.XMLv4(Rec); //this is a name the fuction 
                    // TestCu.VariableLocalSubform(Rec)

                    // Message('Procesado');
                end;
            }





        }
    }
}
