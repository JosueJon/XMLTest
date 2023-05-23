codeunit 50781 "XMLtest2"
{
    TableNo = "Purchase Header";
    procedure XMLv4(RecordCurr: Record "Sales Header")//sd
    var
        v_DaclickparairTP: Page "Sales Invoice"; // esta variable la uso para ir a paginas tablas y ir a referencias 
        v_DaclickparairTP2: Page "Purchase Invoice"; // esta variable la uso para ir a paginas tablas y ir a referencias 
        v_salesInformSub: Page "Sales Invoice Subform"; //Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.
        v_SalesLine: Record "Sales Line"; //field(29; Amount; Decimal)  //field(30; "Amount Including VAT"; Decimal)

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

        /*INTENTO DE CREACION DE REGISTO OBTENER EL DATO ACTUAL DEL REGISTRO */
        /*SE CREA LA BVARIABLE DONDE SE VAN A VACIAR LOS DATOS ACTUALES */
        DatosActuales: Record "Sales Header";




    begin

        /*INICIO DE PARTE DE PRUEBA */
        DatosActuales := RecordCurr;
        DatosActuales.SetRecFilter();



        // CalcSalesDiscount(DatosActuales);

        /*Se inician unas variables y se crea el XML*/

        //FORMATO DE FECHA MANUAL 
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
        v_TAtt_xs := XmlAttribute.CreateNamespaceDeclaration('xs', 'http://www.w3.org/2001/XMLSchema'); //se crea namespace
        v_TAtt_catCFDI := XmlAttribute.CreateNamespaceDeclaration('catCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/catalogos'); //se crea namespace
        v_TAtt_tdCFDI := XmlAttribute.CreateNamespaceDeclaration('tdCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/tipoDatos/tdCFDI'); //se crea namespace

        v_TNameSpace.AddNamespace('cfdi', 'http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsdq'); // quise agregar el namespace con una variable xmlnamespaceManager pero no pude NOTA: investigar sobre esa variable


        v_RootNode := XmlElement.Create('comprobante', 'http://www.sat.gob.mx/cfd/4'); //CORRECTO CON NAMESPACE
        v_XMLDoc.Add(v_RootNode);

        #region Atributos de tipo COMPROBANTE COMPROBADO
        v_RootNode.Add(v_TAtt_cfdi);
        v_RootNode.Add(v_TAtt_xs);
        v_RootNode.Add(v_TAtt_catCFDI);
        v_RootNode.Add(v_TAtt_tdCFDI);
        v_RootNode.SetAttribute(versionName, versionAttribute);
        v_RootNode.SetAttribute('Serie', v_salesH."Insurer Policy Number");
        v_RootNode.SetAttribute('Folio', 'optional atributo interno');
        v_RootNode.SetAttribute('Fecha', FechaTxt); //AAAA-MM.DDThh:mm:ss
        #endregion


        #region EMISOR
        v_Emisor.Get();
        v_ParentNode := XmlElement.Create('Emisor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ParentNode.SetAttribute('Nombre', v_Emisor.Name);
        v_ParentNode.SetAttribute('Rfc', v_Emisor."RFC Number");
        v_ParentNode.SetAttribute('RegimenFiscal', v_Emisor."SAT Tax Regime Classification");

        #endregion


        #region Receptor
        v_salesH.FindSet();
        v_ParentNode := XmlElement.Create('Receptor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ParentNode.SetAttribute('Nombre', DatosActuales."Bill-to Name");
        v_ParentNode.SetAttribute('Code', DatosActuales."CFDI Export Code");
        #endregion

        #region Concpeto
        // v_salesH.FindSet();
        v_ParentNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        // v_ParentNode.SetAttribute('Testv1', Format(DatosActuales.SalesLinesEditable()));
        // v_ParentNode.SetAttribute('Testv2', Format(DatosActuales.SalesLinesExist()));
        // v_ParentNode.SetAttribute('Testv3', Format(DatosActuales.GetWarnWhenZeroQuantitySalesLinePosting()));
        // v_ParentNode.SetAttribute('Testv4', Format(DatosActuales.GetBillToNo()));
        // v_ParentNode.SetAttribute('Testv5', Format(DatosActuales.GetView()));
        // v_ParentNode.SetAttribute('Testv6', Format(DatosActuales.GetLineInvoiceDiscountResetNotificationId()));
        // v_ParentNode.SetAttribute('Testv7', Format(DatosActuales.GetView()));
        // v_ParentNode.SetAttribute('Testv8', Format(DatosActuales.Get()));
        // // v_ParentNode.SetAttribute('Testv9', Format(DatosActuales.));
        // v_ParentNode.SetAttribute('Testv10', Format(DatosActuales.GetCustomerGlobalLocationNumber()));
        // v_ParentNode.SetAttribute('Testv11', Format(DatosActuales.GetPosition()));
        // v_ParentNode.SetAttribute('Testv12', Format(DatosActuales.GetNoSeriesCode()));
        // v_ParentNode.SetAttribute('Testv13', Format(DatosActuales.GetView()));
        v_SalesLine.FindSet();
        subtotal := 0;
        total := 0;
        begin

            repeat
                if v_SalesLine."Document No." = DatosActuales."No." then begin
                    v_ChildNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
                    v_ParentNode.Add(v_ChildNode);

                    v_ChildNode.SetAttribute('ClaveProdServ', v_SalesLine."No.");
                    v_ChildNode.SetAttribute('Cantidad', Format(v_SalesLine.Quantity));

                    // v_ChildNode.SetAttribute('CalcLineAmount', Format(v_SalesLine.CalcLineAmount()));
                    v_ChildNode.SetAttribute('GetLineAmountExclVAT', Format(v_SalesLine.GetLineAmountExclVAT()));
                    // v_ChildNode.SetAttribute('GetLineAmountInclVAT', Format(v_SalesLine.GetLineAmountInclVAT()));
                    v_ChildNode.SetAttribute('Description', Format(v_SalesLine.Description));

                    // v_ChildNode.SetAttribute('Monto_incluyendo_IVA', Format(v_SalesLine."Amount Including VAT"));
                    // v_ChildNode.SetAttribute('Amount', Format(v_SalesLine.Amount));
                    // v_ChildNode.SetAttribute('testv4', Format(v_SalesLine.GetLineAmountToHandle(1))); // se multiplica por lo que pngas en la variable


                    v_ChildNode.SetAttribute('LineaAmount', Format(v_SalesLine."Line Amount"));//suma
                    v_ChildNode.SetAttribute('AmountIncVAT', Format(v_SalesLine."Amount Including VAT"));

                    // subtotal := v_SalesLine."Line Amount" + Subtotal;
                    // v_salesInformSub.GetRecord(v_SalesLine);

                    v_ChildNode.SetAttribute('ValornumeroFive', Format(DatosActuales."Invoice Discount Value"));

                    /*DATOS PRUEBA*/

                    // v_ChildNode.SetAttribute('ValornumeroFive1', Format(DatosActuales."Quote Valid Until Date"));
                    // v_ChildNode.SetAttribute('ValornumeroFive2', Format(DatosActuales."Allow Line Disc."));
                    // v_ChildNode.SetAttribute('ValornumeroFive3', Format(DatosActuales."Invoice Discount Calculation"));
                    // v_ChildNode.SetAttribute('ValornumeroFive4', Format(DatosActuales.IsTest));
                    // v_ChildNode.SetAttribute('ValornumeroFive5', Format(DatosActuales."Invoice Discount Amount"));
                    // v_ChildNode.SetAttribute('ValornumeroFive6', Format(DatosActuales."Invoice Disc. Code"));

                    /*FIN DATOS PRUEBA*/
                    subtotal := v_SalesLine."Line Amount";







                end;
                // subtotal := v_SalesLine."Line Amount";
                total := subtotal + total;
                subtotal := 0;
            until v_SalesLine.Next() = 0;

            v_ChildNode := XmlElement.Create('TOTAL', 'http://www.sat.gob.mx/cfd/4');
            v_ParentNode.Add(v_ChildNode);
            // v_ChildNode.SetAttribute('ClaveProdServ', v_SalesLine."No.");

            v_ChildNode.SetAttribute('LineaAmount2', Format(subtotal));
            v_ChildNode.SetAttribute('LineaAmount3', Format(total));
            // CalcSalesDiscount(DatosActuales);
        end;
        #endregion


        /*SE GUARDA EL ARCHIVO  */
        v_TempBlob.CreateInStream(v_Instr);
        v_TempBlob.CreateOutStream(v_OutStr);
        v_XMLDoc.WriteTo(v_OutStr);
        v_OutStr.WriteText(v_Writetxt);
        v_Instr.ReadText(v_Writetxt);
        v_ReadTxt := 'CFDIv4 ' + DatosActuales."No." + '.XML';
        DownloadFromStream(v_Instr, '', '', '', v_ReadTxt);
    end;

    #region primer intento copiado de donde se saca el reporte de test de la pagina de sales invoice "Sales Document Test 202"
    local procedure CalcSalesDiscount(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        v_ChildNode: XmlElement;
    begin
        SalesSetup.Get();
        if SalesSetup."Calc. Inv. Discount" then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            OnCalcSalesDiscOnAfterSetFilters(SalesLine, SalesHeader);
            SalesLine.FindFirst();
            OnCalcSalesDiscOnBeforeRun(SalesHeader, SalesLine);
            CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", SalesLine);
            SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
            Commit();
            //  v_ChildNode.SetAttribute('EntroAlProcedure', 'Realmente corre');

        end;

        OnAfterCalcSalesDiscount(SalesHeader, SalesLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcSalesDiscOnBeforeRun(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcSalesDiscount(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcSalesDiscOnAfterSetFilters(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header");
    begin
    end;
    #endregion


    #region segundo intento pero en proceso
    // procedure VariableLocalSubform(var SalesHeader: Record "Sales Header")
    // var
    //     myInt: Integer;
    // begin

    // end;
    #endregion

    var


}
