codeunit 50701 "XmlTest1.0"
{
    procedure XMLv4()
    var
        v_DaclickparairTP2: Page "Sales Invoice";
        v_DaclickparairTP: Page "Purchase Invoice"; // esta variable la uso para ir a paginas tablas y ir a referencias 
        v_salesInformSub: Page "Sales Invoice Subform"; //Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.
        vSalesLine: Record "Sales Line"; //field(29; Amount; Decimal)  //field(30; "Amount Including VAT"; Decimal)





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




    begin
        /*Se inician unas variables y se crea el XML*/

        // Hora := 115934.444T; //'CurrentDateTime' da la fecha asi 15/11/22 12:14 p. m.
        // Fecha := Today();
        // FechaTxt := Format(Fecha);
        // Horatxt := Format(Hora);
        // v_DateTime := FechaTxt + 'T' + HoraTxt;

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


        /*prueba iba ver si se podrian usar xml schema con URI-- OBSOLETO*/

        v_TAtt_cfdi := XmlAttribute.CreateNamespaceDeclaration('cfdi', 'http://www.sat.gob.mx/cfd/4'); //se crea namespace
        v_TAtt_xs := XmlAttribute.CreateNamespaceDeclaration('xs', 'http://www.w3.org/2001/XMLSchema'); //se crea namespace
        v_TAtt_catCFDI := XmlAttribute.CreateNamespaceDeclaration('catCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/catalogos'); //se crea namespace
        v_TAtt_tdCFDI := XmlAttribute.CreateNamespaceDeclaration('tdCFDI', 'http://www.sat.gob.mx/sitio_internet/cfd/tipoDatos/tdCFDI'); //se crea namespace

        // v_TElement := XmlElement.Create('ejemplo', 'http://www.sat.gob.mx/cfd/4'); //se crea un nodo con el nombre ejemplo y namespace del link -- este fue un ejemplo con el que llegue a que se pusieran los namespace

        v_TNameSpace.AddNamespace('cfdi', 'http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsdq'); // quise agregar el namespace con una variable xmlnamespaceManager pero no pude NOTA: investigar sobre esa variable


        /*TERMINA ESPACIO DE PRUEBA */



        /*Se declara un nodo de tipo comprobante*/


        // v_RootNode := XmlElement.Create('comprobante'); //CORRECTO

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
        // v_Emisor.FindSet(); /*diferencia ar get y find set */
        v_Emisor.Get();
        v_ParentNode := XmlElement.Create('Emisor', 'http://www.sat.gob.mx/cfd/4');

        v_RootNode.Add(v_ParentNode);
        // v_FieldCaption := v_Emisor.FieldCaption(v_Emisor.Name);
        // v_ChildNode := XmlElement.Create('Name'); //para agregar un hijo a parent node no el root
        // v_XMLTxt := XmlText.Create(v_Emisor.Name);
        // v_ChildNode.Add(v_XMLTxt);
        // v_ParentNode.Add(v_ChildNode);
        v_ParentNode.SetAttribute('Nombre', v_Emisor.Name);
        v_ParentNode.SetAttribute('Rfc', v_Emisor."RFC Number");
        v_ParentNode.SetAttribute('RegimenFiscal', v_Emisor."SAT Tax Regime Classification");


        // FieldCaption := v_Emisor.FieldCaption(Name);
        // ChildNode := XmlElement.Create(FieldCaption);
        // XmlTxt := XmlText.Create(v_Emisor.Name);
        // ChildNode.Add(XMLTxt);
        // v_ParentNode.Add(ChildNode);
        #endregion

        #region Receptor
        v_salesH.FindSet();

        // repeat
        // v_customer.CalcFields("No.");
        v_ParentNode := XmlElement.Create('Receptor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ParentNode.SetAttribute('Nombre', v_salesH."Sell-to Customer No.");
        // until v_salesH.Next() = 0;
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