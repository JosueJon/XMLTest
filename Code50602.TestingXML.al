codeunit 50602 TestingXML
{
    procedure XMLBaseTesting()
    var
        XMLDoc: XmlDocument;
        XMLDec: XmlDeclaration;
        RootNode: XmlElement;
        ParentNode: XmlElement;
        Cust: Record Customer;
        FieldCaption: Text;
        XMLTxt: XmlText;
        ChildNode: XmlElement;
        //guarar archivo (asi entendi)
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        OutStr: OutStream;
        ReadTxt: Text;
        Writetxt: Text;
        v_TAtt_xs: XmlAttribute;

    begin
        v_TAtt_xs := XmlAttribute.CreateNamespaceDeclaration('xs', 'http://www.w3.org/2001/XMLSchema');
        XMLDoc := XmlDocument.Create();
        XMLDec := XmlDeclaration.Create('1.0', 'UTF-8', '');
        XMLDoc.SetDeclaration(XMLDec);
        RootNode := XmlElement.Create('RootNode');
        XMLDoc.Add(RootNode);

        Cust.FindSet();
        repeat
            Cust.CalcFields(Balance);
            ParentNode := XmlElement.Create('Customer', 'http://www.w3.org/2001/XMLSchema'); //agrega el link URI
            RootNode.Add(ParentNode);
            ParentNode.Add(v_TAtt_xs);// agregado 14/11/2022
            FieldCaption := Cust.FieldCaption("No."); //pregunta ¿Porque este no es ChildNode
            ChildNode := XmlElement.Create('No.'); //aqui aparecia un error de la siguiente manera "ChildNode := XmlElement.Create(FieldCaption);" por lo que se tuvo que cambiar para que no agarrara el simbolo "°" como no admitido lo agarraba de "NO°"
            XmlTxt := XmlText.Create(Cust."No.");
            ChildNode.Add(XMLTxt);
            ParentNode.Add(ChildNode);

            // ParentNode := XmlElement.Create('Customer');
            // RootNode.Add(ParentNode);
            FieldCaption := Cust.FieldCaption(Name); //pregunta ¿Porque este no es ChildNode
            ChildNode := XmlElement.Create(FieldCaption);
            XmlTxt := XmlText.Create(Cust.Name); //Es es el atributo que aparece 
            ChildNode.Add(XMLTxt);
            ParentNode.Add(ChildNode);

            // ParentNode := XmlElement.Create('Customer');
            // RootNode.Add(ParentNode);
            FieldCaption := Cust.FieldCaption(Balance); //pregunta ¿Porque este no es ChildNode
            ChildNode := XmlElement.Create(FieldCaption);
            XmlTxt := XmlText.Create(Format(Cust.Balance)); // se cambio  // repasar CAlcFields
            ChildNode.Add(XMLTxt);
            ParentNode.Add(ChildNode);

        until Cust.Next() = 0;

        TempBlob.CreateInStream(Instr);
        TempBlob.CreateOutStream(OutStr);
        XMLDoc.WriteTo(OutStr);
        OutStr.WriteText(Writetxt);
        Instr.ReadText(Writetxt);
        ReadTxt := 'Customer.XML';
        DownloadFromStream(Instr, '', '', '', ReadTxt);
    end;


    procedure ImportXMLData()
    var
        FromFile: Text;
        Instr: InStream;
        Xmldoc: XmlDocument;
        Tab: XmlElement;
        NodeList: XmlNodeList;
        NodeListSec: XmlNodeList;
        Node1: XmlNode;
        Node2: XmlNode;
        Element: XmlElement;
        Customer: Record Customer;
        Variable: XmlPort "Sales Invoice - PEPPOL BIS 3.0";
    begin
        if UploadIntoStream('Upload', '', '', FromFile, Instr) then
            XmlDocument.ReadFrom(Instr, Xmldoc)
        else
            Error(' No an XML File');

        if Xmldoc.GetRoot(Tab) then
            NodeList := Tab.GetChildElements();

        foreach Node1 in NodeList do begin
            Customer.Init();
            Element := Node1.AsXmlElement();
            NodeListSec := Element.GetChildElements();
            foreach Node2 in NodeList do begin
                case Node2.AsXmlElement().Name of
                    'No.':
                        customer.Validate(Customer."No.", Node2.AsXmlElement().InnerText);
                    'Name':
                        customer.Validate(Customer."No.", Node2.AsXmlElement().InnerText);
                end;
            end;
            Customer.Insert();
        end;
        Message('Proceso Finalizado');

    end;

    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
}