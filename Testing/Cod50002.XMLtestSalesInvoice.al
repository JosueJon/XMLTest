codeunit 50002 "XMLtestSalesInvoice"
{
    TableNo = "Purchase Header";
    procedure XMLv4(RecordCurr: Record "Sales Line") //RecordCurr: Record "Sales Line"
    var
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

        v_TNameSpace: XmlNamespaceManager;

        v_TAtt_cfdi: XmlAttribute;
        v_TAtt_xs: XmlAttribute;
        v_TAtt_catCFDI: XmlAttribute;
        v_TAtt_tdCFDI: XmlAttribute;
        v_TNamespaceP: XmlAttribute;

        DatosActuales: Record "Sales Line";
        v_Emisor: Record "Company Information";
        TableSalesL: Record "Sales Line";
        v_salesInformSub: Page "Sales Invoice Subform";


    begin

        /*INICIO DE PARTE DE PRUEBA */
        DatosActuales := RecordCurr;
        DatosActuales.SetRecFilter();


        versionName := 'Version';
        versionAttribute := '4.0';
        v_XMLDoc := XmlDocument.Create();
        v_XMLDec := XmlDeclaration.Create('1.0', 'UTF-8', 'no');
        v_XMLDoc.SetDeclaration(v_XMLDec);

        v_TAtt_cfdi := XmlAttribute.CreateNamespaceDeclaration('cfdi', 'http://www.sat.gob.mx/cfd/4'); //se crea namespace
        v_TAtt_xs := XmlAttribute.CreateNamespaceDeclaration('xs', 'http://www.w3.org/2001/XMLSchema'); //se crea namespace
        v_TAtt_catCFDI := XmlAttribute.CreateNamespaceDeclaration('catCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/catalogos'); //se crea namespace
        v_TAtt_tdCFDI := XmlAttribute.CreateNamespaceDeclaration('tdCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/tipoDatos/tdCFDI'); //se crea namespace
        // v_TNameSpace.AddNamespace('cfdi', 'http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsdq'); // quise agregar el namespace con una variable xmlnamespaceManager pero no pude NOTA: investigar sobre esa variable

        v_RootNode := XmlElement.Create('comprobante', 'http://www.sat.gob.mx/cfd/4'); //CORRECTO CON NAMESPACE
        v_XMLDoc.Add(v_RootNode);
        v_RootNode.Add(v_TAtt_cfdi);
        v_RootNode.Add(v_TAtt_xs);
        v_RootNode.Add(v_TAtt_catCFDI);
        v_RootNode.Add(v_TAtt_tdCFDI);
        v_RootNode.SetAttribute(versionName, versionAttribute);

        // #region EMISOR
        // v_Emisor.Get();
        // v_ParentNode := XmlElement.Create('Emisor', 'http://www.sat.gob.mx/cfd/4');
        // v_RootNode.Add(v_ParentNode);
        // v_ParentNode.SetAttribute('Nombre', v_Emisor.Name);
        // v_ParentNode.SetAttribute('Rfc', v_Emisor."RFC No.");
        // v_ParentNode.SetAttribute('RegimenFiscal', v_Emisor."SAT Tax Regime Classification");
        // #endregion


        #region Receptor
        v_ParentNode := XmlElement.Create('Receptor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ParentNode.SetAttribute('Receptor', Format(DatosActuales.GetSalesHeader()."Bill-to Name")); // obtiene los datos del sales header
        v_ParentNode.SetAttribute('Codigo', Format(DatosActuales.GetSalesHeader()."CFDI Export Code"));
        // v_ParentNode.SetAttribute('test1', Format(DatosActuales.GetSalesHeader().Invoice));
        // v_ParentNode.SetAttribute('test2', Format(DatosActuales.GetSalesHeader().GetNoSeriesCode()));
        // v_ParentNode.SetAttribute('test3', Format(DatosActuales.GetSalesHeader().GetBillToNo()));
        // v_ParentNode.SetAttribute('test3', Format(DatosActuales.GetSalesHeader()."No."));
        // v_ParentNode.SetAttribute('test4', Format(DatosActuales.GetSalesHeader().GetView()));
        // // v_ParentNode.SetAttribute('test5', Format(DatosActuales.GetSalesHeader().GetBillToNo()));
        // // v_ParentNode.SetAttribute('test6', Format(DatosActuales.GetSalesHeader().GetBillToNo()));
        #endregion


        #region Concepto
        v_ParentNode := XmlElement.Create('Conceptos', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);

        TableSalesL.FindSet();

        // if DatosActuales.Find('-') then
        // if DatosActuales.FindSet() then
        begin
            repeat
                if TableSalesL."Document No." = DatosActuales.GetSalesHeader()."No." then begin
                    v_ChildNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
                    v_ParentNode.Add(v_ChildNode);
                    v_ChildNode.SetAttribute('ClaveProdServ', TableSalesL."No.");
                    v_ChildNode.SetAttribute('Cantidad', Format(TableSalesL.Quantity));
                    v_ChildNode.SetAttribute('TestV', Format(TableSalesL.CalcLineAmount()));
                    v_ChildNode.SetAttribute('TestV1', Format(TableSalesL.GetLineAmountExclVAT()));
                    v_ChildNode.SetAttribute('TestV2', Format(TableSalesL.GetLineAmountInclVAT()));
                    //     v_ChildNode.SetAttribute('ClaveProdServ', DatosActuales."No.");
                    //     v_ChildNode.SetAttribute('Cantidad', Format(DatosActuales.Quantity));
                    //     v_ChildNode.SetAttribute('TestV', Format(DatosActuales.CalcLineAmount()));
                    //     v_ChildNode.SetAttribute('TestV1', Format(DatosActuales.GetLineAmountExclVAT()));
                    //     v_ChildNode.SetAttribute('TestV2', Format(DatosActuales.GetLineAmountInclVAT()));
                    // // v_ParentNode.SetAttribute('TestV3', Format(DatosActuales.GetView()));
                    // // v_ParentNode.SetAttribute('TestV4', Format(DatosActuales.GetSalesHeader()."Bill-to Name")); // obtiene los datos del sales header
                    // v_salesInformSub.GetRecord(DatosActuales);
                    // v_salesInformSub.SetTableView(DatosActuales);
                    v_ChildNode.SetAttribute('PageSalesInfo', Format(v_salesInformSub));
                end;
            until TableSalesL.Next() = 0;

        end;

        // v_ParentNode := XmlElement.Create('Conceptos', 'http://www.sat.gob.mx/cfd/4');
        // v_RootNode.Add(v_ParentNode);
        // v_ChildNode := XmlElement.Create('Concepto', 'http://www.sat.gob.mx/cfd/4');
        // v_ParentNode.Add(v_ChildNode);
        // v_ChildNode.SetAttribute('ClaveProdServ', DatosActuales."No.");
        // v_ChildNode.SetAttribute('Cantidad', Format(DatosActuales.Quantity));
        // v_ChildNode.SetAttribute('RegimenFiscal', v_Emisor."SAT Tax Regime Classification");

        #endregion



        /*SE GUARDA EL ARCHIVO  */
        v_TempBlob.CreateInStream(v_Instr);
        v_TempBlob.CreateOutStream(v_OutStr);
        v_XMLDoc.WriteTo(v_OutStr);
        v_OutStr.WriteText(v_Writetxt);
        v_Instr.ReadText(v_Writetxt);
        v_ReadTxt := 'CFDI40.XML';
        DownloadFromStream(v_Instr, '', '', '', v_ReadTxt);



    end;


    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
}
