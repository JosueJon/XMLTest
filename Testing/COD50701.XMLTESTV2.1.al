codeunit 50782 "XMLtest2.1"
{
    TableNo = "Purchase Header";
    procedure XMLv4(RecordCurr: Record "Sales Header")
    var
        v_DaclickparairTP: Page "Sales Invoice"; // esta variable la uso para ir a paginas tablas y ir a referencias 
        v_DaclickparairTP33: Report "Sales Document - Test"; //variable para poder hacer el reporte en el reporte tambien se hacen funciones adicionales 
        v_DaclickparairTP2: Page "Purchase Invoice"; // esta variable la uso para ir a paginas tablas y ir a referencias 
        v_salesInformSub: Page "Sales Invoice Subform"; //Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.
        v_SalesLine: Record "Sales Line"; //field(29; Amount; Decimal)  //field(30; "Amount Including VAT"; Decimal)

        v_Testv1: Report "Standard Sales - Draft Invoice"; //field(29; Amount; Decimal)  //field(30; "Amount Including VAT"; Decimal)

        subtotal: Decimal;
        total: Decimal;
        GuardarDecimal: Decimal;


        v_AtrribTest: XmlAttribute;

        v_XMLDoc: XmlDocument;
        v_XMLDec: XmlDeclaration;
        v_RootNode: XmlElement;
        v_ParentNode: XmlElement;



        v_FieldCaption: Text;
        v_XMLTxt: XmlText;
        v_ChildNode: XmlElement;


        v_TempBlob: Codeunit "Temp Blob";
        v_Instr: InStream;
        v_OutStr: OutStream;
        v_ReadTxt: Text;
        v_Writetxt: Text;
        seeFiles_AL: HttpClient;
        versionName: Text;
        versionAttribute: Text;

        Fecha: Date;
        FechaTxt: Text;
        v_FechaDia: Integer;
        v_FechaAño: Integer;
        v_FechaMes: Integer;
        Hora: Time;

        /*EMISOR*/
        v_Emisor: Record "Company Information";

        /*RECEPTOR*/
        v_customer: Record Customer;
        v_salesH: Record "Sales Header";

        /*Variables de prueba para ver si se puede ocupar el uri y crear el shema creare una variable de cada tipo por si se ocupa*/
        v_TDeclaration: XmlDeclaration;
        v_TElement: XmlElement;
        v_TDocumement: XmlDocument;
        v_TDocumentType: XmlDocumentType;
        v_TAttribute: XmlAttribute;
        v_TNameSpace: XmlNamespaceManager;
        v_TNameSpace2: XmlNamespaceManager;


        v_TAtt_cfdi: XmlAttribute;
        v_TAtt_xs: XmlAttribute;
        v_TAtt_catCFDI: XmlAttribute;
        v_TAtt_tdCFDI: XmlAttribute;
        v_TNamespaceP: XmlAttribute;
        v_schemaLocation: XmlAttribute;

        /*INTENTO DE CREACION DE REGISTO OBTENER EL DATO ACTUAL DEL REGISTRO */
        /*SE CREA LA BVARIABLE DONDE SE VAN A VACIAR LOS DATOS ACTUALES */
        DatosActuales: Record "Sales Header";

        /*VARIABLES DE CATAGOLOGOS*/
        v_catc_FormaPagp: Record "Payment Method";




    begin

        /*INICIO DE PARTE DE PRUEBA */
        DatosActuales := RecordCurr;
        DatosActuales.SetRecFilter();




        Fecha := Today();
        "v_FechaAño" := Date2DMY(Fecha, 3);
        v_FechaMes := Date2DMY(Fecha, 2);
        v_FechaDia := Date2DMY(Fecha, 1);
        Hora := Time();
        FechaTxt := Format("v_FechaAño") + '-' + Format(v_FechaMes) + '-' + Format(v_FechaDia) + 'T' + Format(Hora);



        versionName := 'Version';
        versionAttribute := '4.0';
        v_XMLDoc := XmlDocument.Create();
        v_XMLDec := XmlDeclaration.Create('1.0', 'UTF-8', 'no');
        v_XMLDoc.SetDeclaration(v_XMLDec);

        v_TAtt_cfdi := XmlAttribute.CreateNamespaceDeclaration('cfdi', 'http://www.sat.gob.mx/cfd/4'); //se crea namespace
        v_TAtt_xs := XmlAttribute.CreateNamespaceDeclaration('xsi', 'http://www.w3.org/2001/XMLSchema-instance'); //se crea namespace
        v_TAtt_catCFDI := XmlAttribute.CreateNamespaceDeclaration('catCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/catalogos'); //se crea namespace
        v_TAtt_tdCFDI := XmlAttribute.CreateNamespaceDeclaration('tdCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/tipoDatos/tdCFDI'); //se crea namespace
        // v_schemaLocation := XmlAttribute.CreateNamespaceDeclaration('schemaLocation', 'http://www.sat.gob.mx/cfd/4 http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsd'); //se crea namespace

        v_RootNode := XmlElement.Create('comprobante', 'http://www.sat.gob.mx/cfd/4'); //CORRECTO CON NAMESPACE
        v_XMLDoc.Add(v_RootNode);

        #region Atributos de tipo COMPROBANTE
        v_RootNode.Add(v_TAtt_cfdi);
        v_RootNode.Add(v_TAtt_xs);
        v_RootNode.Add(v_TAtt_catCFDI);
        v_RootNode.Add(v_TAtt_tdCFDI);
        // v_RootNode.Add(v_schemaLocation);
        v_RootNode.SetAttribute(versionName, versionAttribute);
        v_RootNode.SetAttribute('Serie', v_salesH."Insurer Policy Number");
        v_RootNode.SetAttribute('Folio', 'optional atributo interno');
        v_RootNode.SetAttribute('Fecha', FechaTxt); //AAAA-MM.DDThh:mm:ss
        v_RootNode.SetAttribute('Sello', 'Se genera con texto formato Base64');
        //TODO
        v_RootNode.SetAttribute('FormaPago', Format(v_catc_FormaPagp)); //TODO //catCFDIc_FormaPAgo
        v_RootNode.SetAttribute('NoCertificado', 'Se numero de serie del certificado de sello digital REQUERIDO'); //XS:String
        v_RootNode.SetAttribute('Certificado', 'Se genera con texto formato Base64 REQUERIDO');//xs:String
        v_RootNode.SetAttribute('CondicionesDePago', ' OPTIONAL');//xs:String
        v_RootNode.SetAttribute('Subtotal', ' REQUERIDO');//tdCFDI:t_importe
        v_RootNode.SetAttribute('Descuento', ' optional');//tdCFDI:t_importe
        v_RootNode.SetAttribute('Moneda', ' REQUERIDO');//catCFDI:c_Moneda
        v_RootNode.SetAttribute('TipoCambio', ' optional'); // xs:Decimal
        v_RootNode.SetAttribute('Total', ' requerido'); // cfdi:t_importe
        v_RootNode.SetAttribute('TipoDecomprobante', ' requerido'); // catCFDI:c_TipoDeComprobante
        v_RootNode.SetAttribute('Exportacion', ' requerido'); // catCFDI:c_Exportacion
        v_RootNode.SetAttribute('MetodoDePago', ' optional'); // catCFDI:c_MetodoDePago
        v_RootNode.SetAttribute('LugarExpedicion', ' requerido'); // catCFDI:c_CodigoPostal
        v_RootNode.SetAttribute('Confirmacion', ' optional'); // xs:String

        #endregion

        #region InformacionGlobal
        #endregion

        #region CFDI relacionado
        #endregion

        #region EMISOR
        v_Emisor.Get();
        v_ParentNode := XmlElement.Create('Emisor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ParentNode.SetAttribute('Rfc', v_Emisor."RFC Number");
        v_ParentNode.SetAttribute('Nombre', v_Emisor.Name);
        v_ParentNode.SetAttribute('RegimenFiscal', v_Emisor."SAT Tax Regime Classification");
        v_ParentNode.SetAttribute('FacAtrAdquirente', v_Emisor."SAT Tax Regime Classification" + 'opcional'); //proporcionado por el SAT un comprobante PCECFDI PCGCFDISP

        #endregion


        #region Receptor
        //TODO/*encontrar hacer comparacion para encontrar los datos del customer*/
        // v_salesH.FindSet();
        v_customer.FindSet();
        begin

            repeat

                if v_customer.Name.Trim() = DatosActuales."Bill-to Name".Trim() then begin

                    v_ParentNode := XmlElement.Create('Receptor', 'http://www.sat.gob.mx/cfd/4');
                    v_RootNode.Add(v_ParentNode);
                    v_ParentNode.SetAttribute('Rfc', v_customer."VAT Registration No.");
                    v_ParentNode.SetAttribute('Nombre', v_customer.Name);
                    v_ParentNode.SetAttribute('DomicilioFiscalReceptor', v_customer.Address);
                    v_ParentNode.SetAttribute('ResidenciaFiscal', v_customer."CFDI Export Code");//c_Pais TODO extranjero optional
                    v_ParentNode.SetAttribute('NumRegIdTrib', v_customer."CFDI Export Code"); // (residente extranjero) optional
                    v_ParentNode.SetAttribute('RegimenFiscalReceptor', v_customer."SAT Tax Regime Classification"); //c_RegimenFiscal
                    v_ParentNode.SetAttribute('UsoCFDI', v_customer."CFDI Purpose");
                    break
                    /*EJEMPLOS*/
                    /*
                    v_ParentNode.SetAttribute('customerPurpose', Format(v_customer."CFDI Purpose"));
                    v_ParentNode.SetAttribute('cfdiExport', v_customer."CFDI Export Code");
                    v_ParentNode.SetAttribute('cfdiPeriod', Format(v_customer."CFDI Period"));
                    v_ParentNode.SetAttribute('customerNo', v_customer."No.");
                    v_ParentNode.SetAttribute('customerRFC', v_customer."VAT Registration No.");
                    v_ParentNode.SetAttribute('customerName', v_customer.Name.Trim());
                    */

                end;
            until v_customer.Next() = 0;
        end;


        #endregion

        #region Concepto

        v_ParentNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);


        subtotal := 0;
        total := 0;
        begin

            repeat
                if v_SalesLine."Document No." = DatosActuales."No." then begin
                    v_ChildNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
                    v_ParentNode.Add(v_ChildNode);

                    v_ChildNode.SetAttribute('ClaveProdServ', v_SalesLine."No."); //c_ClaveProdServ TODO
                    v_ChildNode.SetAttribute('NoIdentificacion', v_SalesLine."No."); //TODO opcional
                    v_ChildNode.SetAttribute('Cantidad', Format(v_SalesLine.Quantity)); //c_ClaveUnidad
                    v_ChildNode.SetAttribute('ClaveUnidad', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('Unidad', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('Descripcion', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('ValorUnitario', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('Importe', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('Descuento', Format(v_SalesLine.Quantity));
                    v_ChildNode.SetAttribute('ObjetoImp', Format(v_SalesLine.Quantity));



                    /*
                    v_ChildNode.SetAttribute('GetLineAmountExclVAT', Format(v_SalesLine.GetLineAmountExclVAT()));
                    v_ChildNode.SetAttribute('Description', Format(v_SalesLine.Description));
                    v_ChildNode.SetAttribute('LineaAmount', Format(v_SalesLine."Line Amount"));//suma
                    v_ChildNode.SetAttribute('AmountIncVAT', Format(v_SalesLine."Amount Including VAT"));
                    v_ChildNode.SetAttribute('ValornumeroFive', Format(DatosActuales."Invoice Discount Value"));
                    */
                    subtotal := v_SalesLine."Line Amount";

                end;

                total := subtotal + total;
                subtotal := 0;
            until v_SalesLine.Next() = 0;

            v_ChildNode := XmlElement.Create('TOTAL', 'http://www.sat.gob.mx/cfd/4');
            v_ParentNode.Add(v_ChildNode);
            v_ChildNode.SetAttribute('LineaAmount2', Format(subtotal));
            v_ChildNode.SetAttribute('LineaAmount3', Format(total));
        end;

        #region Impuestos
        #endregion

        #region AcuentaTerceros
        #endregion

        #region InformacionAduanera
        #endregion

        #region CuentaPredial
        #endregion

        #region ComplementoConcepto
        #endregion

        #region Parte
        #endregion


        #endregion

        #region impuestos
        #endregion

        #region Complemento
        #endregion

        #region addenda
        #endregion

        #region 
        #endregion

        /*SE GUARDA EL ARCHIVO  */
        v_TempBlob.CreateInStream(v_Instr);
        v_TempBlob.CreateOutStream(v_OutStr);
        v_XMLDoc.WriteTo(v_OutStr);
        v_OutStr.WriteText(v_Writetxt);
        v_Instr.ReadText(v_Writetxt);
        v_ReadTxt := 'CFDIv4 ' + DatosActuales."No." + '.XML'; //SE LE AGREGEA EL NOMBRE 
        DownloadFromStream(v_Instr, '', '', '', v_ReadTxt);
    end;


    var


}
