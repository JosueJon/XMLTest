codeunit 50710 XMLFacturaTTBS
{
    procedure Emisor()
    var
        v_XMLDoc: XmlDocument;
        v_XMLDec: XmlDeclaration;
        v_RootNode: XmlElement;
        v_ParentNode: XmlElement;
        v_salesH: Record "Sales Header";
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

        v_TAtt_cfdi: XmlAttribute;
        v_TAtt_xs: XmlAttribute;
        v_TAtt_catCFDI: XmlAttribute;
        v_TAtt_tdCFDI: XmlAttribute;


    begin
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
        v_RootNode := XmlElement.Create('comprobante', 'http://www.sat.gob.mx/cfd/4'); //CORRECTO CON NAMESPACE
        v_XMLDoc.Add(v_RootNode);

        v_RootNode.Add(v_TAtt_cfdi);
        v_RootNode.Add(v_TAtt_xs);
        v_RootNode.Add(v_TAtt_catCFDI);
        v_RootNode.Add(v_TAtt_tdCFDI);
        v_RootNode.SetAttribute(versionName, versionAttribute);
        v_RootNode.SetAttribute('Serie', v_salesH."Insurer Policy Number");
        v_RootNode.SetAttribute('Folio', 'optional atributo interno');
        v_RootNode.SetAttribute('Fecha', FechaTxt); //AAAA-MM.DDThh:mm:ss


        v_Emisor.Get();
        v_ParentNode := XmlElement.Create('Emisor', 'http://www.sat.gob.mx/cfd/4');
        v_RootNode.Add(v_ParentNode);
        v_ChildNode := XmlElement.Create('Name');
        v_XMLTxt := XmlText.Create(v_Emisor.Name);
        v_ChildNode.Add(v_XMLTxt);
        v_ParentNode.Add(v_ChildNode);
        v_ParentNode.Add(v_Emisor.Name);
        v_ParentNode := XmlElement.Create('Receptor', 'http://www.sat.gob.mx/cfd/4');

        v_RootNode.Add(v_ParentNode);

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