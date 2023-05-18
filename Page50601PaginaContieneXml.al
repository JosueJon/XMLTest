page 50601 MyPageText
{
    PageType = List;
    ApplicationArea = Basic;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            Description = ' This is a description';

            group(GroupName)
            {
                field(Name; false)
                {
                    ApplicationArea = Basic;
                    Editable = true;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrintXMLPorts)
            {
                ApplicationArea = Basic;
                Caption = '50600 XmlPortCAP_Port';
                Image = Export;

                trigger OnAction()
                begin
                    Xmlport.Run(50600, true, false);
                end;
            }
            action("XMLCust")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50602';
                ToolTip = 'Este boton fue sacado en un video de youtube How to create and download the XML file using AL Language| Dynamics 365 Business Central';
                trigger OnAction()
                var
                    TestCu: Codeunit TestingXML;
                begin
                    TestCu.XMLBaseTesting(); //this is a name the fuction 
                    // Message('Procesado');
                end;
            }

            action(ModificandoVal)
            {
                ApplicationArea = Basic;
                Caption = 'XML port 50603 o 50604';


                trigger OnAction()
                begin
                    Xmlport.Run(50603, true, false); //modificando entre el 50603 y 50604
                end;
            }

            action("XMLCFDI4.0")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50700';
                ToolTip = 'TEST hasta aqui todo va bien podemos ver un ejemplo de root comprobante un hijo llamado emisor y dentro de en uno llamado name';
                trigger OnAction()
                var
                    TestCu: Codeunit ClassXML;
                begin
                    TestCu.Emisor(); //this is a name the fuction 
                    // Message('Procesado');
                end;
            }
            action("XMLCFDI4.0v1")
            {
                ApplicationArea = all;
                Caption = 'ExportCustXMl 50701';
                ToolTip = 'Modificacion del 50700';
                trigger OnAction()
                var
                    TestCu: Codeunit "XmlTest1.0";
                begin
                    TestCu.XMLv4(); //this is a name the fuction 
                    // Message('Procesado');
                end;
            }

            action("TestDeREport")
            {
                ApplicationArea = all;
                Caption = 'TestReport';
                ToolTip = 'Saber como se hace un procedimiento de otra pagina';


            }
            action(FacturaTTBS)
            {
                ApplicationArea = Basic;
                Caption = 'XMLPort 50610';


                trigger OnAction()
                begin
                    Xmlport.Run(50610, false, false);
                end;
            }

        }
    }

    var
        myInt: Integer;
}