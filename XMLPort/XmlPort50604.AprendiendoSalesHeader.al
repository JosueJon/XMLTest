xmlport 50604 AprendiendoSalesHeader
{
    Format = Xml;
    Caption = ' XmlSalesHeader';
    Direction = Export;
    Encoding = UTF8;
    // UseRequestPage = false;


    schema
    {
        textelement(NodoP)
        {
            tableelement(SalHeader; "Sales Header")
            {
                XmlName = 'NodoSecundario';
                RequestFilterFields = "No.";
                fieldelement(AllowLineDisc; SalHeader."No.")
                {
                    XmlName = 'salesPersonCode';
                }

                fieldelement(VATBusPostingGroup; SalHeader."Document Type")
                {
                    XmlName = 'numeroSerie';
                }

            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
