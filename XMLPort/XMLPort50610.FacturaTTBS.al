xmlport 50610 FacturaTTBS
{
    Format = Xml;
    Caption = ' Xml Port Coy and page';
    Direction = Export;
    Encoding = UTF8;
    Namespaces = cfdi = 'http://www.sat.gob.mx/cfd/4', xs = 'http://www.w3.org/2001/XMLSchema', catCFDI = 'http://www.sat.gob.mx/sitio_internet/cfd/catalogos', tdCFDI = 'http://www.sat.gob.mx/sitio_internet/cfd/tipoDatos/tdCFDI';
    UseRequestPage = false;


    schema
    {
        textelement(Comprobante)
        {
            NamespacePrefix = 'cfdi';

            textattribute(versionc)
            {
                XmlName = 'Version';
            }
            textattribute(seriec)
            {
                XmlName = 'Serie';
            }
            textattribute(folioc)
            {
                XmlName = 'Folio';
            }
            textattribute(fechac)
            {
                XmlName = 'Fecha';
            }
            // tableelement(Integer; Integer)
            // {
            //     NamespacePrefix = 'cfdi';
            //     XmlName = 'ItemInicio';
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



            tableelement(Emisor; "Company Information")
            {


                XmlName = 'Emisor';
                // RequestFilterFields = Name;
                textattribute(NombreE)
                {
                    XmlName = 'Nombre';
                }
                textattribute(RFCE)
                {
                    XmlName = 'RFC';
                }
                textattribute(RegimenFE)
                {
                    XmlName = 'RegimenFiscal';
                }

            }
            tableelement(Receptor; "Sales Header")
            {

                textattribute(NombreR)
                {
                    XmlName = 'Nombre';
                    trigger OnBeforePassVariable()
                    var
                        Receptor: Record "Sales Header";
                        CodeUn: Codeunit RegistroActual;
                    begin

                        // Receptor.Get(1, 101001);

                        NombreR := Receptor."Bill-to Name";
                    end;
                }
                // textattribute(RFCR)
                // {
                //     XmlName = 'RFC';
                //     trigger OnAfterAssignVariable()
                //     var
                //         Receptor: Record "Sales Header";
                //     begin
                //         Receptor.FindSet();
                //         NombreR := Receptor."Bill-to Name";
                //     end;
                // }
                // textattribute(RegimenFR)
                // {
                //     XmlName = 'RegimenFiscal';
                //     trigger OnAfterAssignVariable()
                //     var
                //         Receptor: Record "Sales Header";
                //     begin
                //         Receptor.FindSet();
                //         NombreR := Receptor."Bill-to Name";
                //     end;
                // }
                trigger OnAfterGetRecord()
                var
                    Receptor: Record "Sales Header";
                begin
                end;
            }








            trigger OnBeforePassVariable()
            var
                myInt: Integer;
                v_salesH: Record "Sales Header";
                Fecha: Date;
                FechaTxt: Text;
                v_FechaDia: Integer;
                v_FechaAño: Integer;
                v_FechaMes: Integer;
                Hora: Time;
                v_Emisor: Record "Company Information";

            begin
                //attributos de comprobante
                versionc := '4.0';
                seriec := 'serieTest';
                Fecha := Today();
                v_FechaAño := Date2DMY(Fecha, 3);
                v_FechaMes := Date2DMY(Fecha, 2);
                v_FechaDia := Date2DMY(Fecha, 1);
                Hora := Time();
                FechaTxt := Format("v_FechaAño") + '-' + Format(v_FechaMes) + '-' + Format(v_FechaDia) + 'T' + Format(Hora);
                fechac := FechaTxt;
                //Emisor atributos
                v_Emisor.Get();
                NombreE := v_Emisor.Name;
                RFCE := v_Emisor."RFC number";
                RegimenFE := v_Emisor."SAT Tax Regime Classification";
            end;
        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(content)
    //         {
    //             group(GroupName)
    //             {
    //                 // field(Name; Emisor.AssistEdit())
    //                 // {

    //                 // }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {

    //             }
    //         }
    //     }
    // }

    var
        myInt: Integer;
}
