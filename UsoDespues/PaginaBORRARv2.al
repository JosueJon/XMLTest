// page 50099 "SalesInvoiceSubform_1"
// {
//     AutoSplitKey = true;
//     Caption = 'Lines';
//     DelayedInsert = true;
//     LinksAllowed = false;
//     MultipleNewLines = true;
//     PageType = ListPart;
//     SourceTable = "Sales Line";
//     SourceTableView = WHERE("Document Type" = FILTER(Invoice));

//     layout
//     {
//         area(content)
//         {

//             group(Control39)
//             {
//                 ShowCaption = false;
//                 #region parte izq
//                 group(Control33)
//                 {
//                     ShowCaption = false; // esto es si se expande o se queda asi
//                     // field("TotalSalesLine"; TotalSalesLine."Line Amount")
//                     // {
//                     //     ApplicationArea = Basic, Suite;
//                     //     // AutoFormatExpression = Currency.Code;
//                     //     AutoFormatType = 1;
//                     //     // CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");

//                     //     Caption = 'Subtotal Excl. VAT IVA';
//                     //     Editable = false;
//                     //     ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
//                     // }
//                     field("Invoice Discount Amount"; InvoiceDiscountAmount)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         AutoFormatExpression = Currency.Code;
//                         AutoFormatType = 1;
//                         CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FieldCaption(Rec."Inv. Discount Amount"), Currency.Code);
//                         Caption = 'Invoice Discount Amount';
//                         Editable = InvDiscAmountEditable;
//                         ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

//                         trigger OnValidate()
//                         begin
//                             DocumentTotals.SalesDocTotalsNotUpToDate();
//                             ValidateInvoiceDiscountAmount();
//                         end;
//                     }
//                     field("Invoice Disc. Pct."; InvoiceDiscountPct)
//                     {
//                         ApplicationArea = Basic, Suite;
//                         Caption = 'Invoice Discount %';
//                         DecimalPlaces = 0 : 3;
//                         Editable = InvDiscAmountEditable;
//                         ToolTip = 'Specifies a discount percentage that is applied to the invoice, based on sales lines where the Allow Invoice Disc. field is selected. The percentage and criteria are defined in the Customer Invoice Discounts page, but you can enter or change the percentage manually.';

//                         trigger OnValidate()
//                         begin
//                             DocumentTotals.SalesDocTotalsNotUpToDate();
//                             AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
//                             InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
//                             ValidateInvoiceDiscountAmount();
//                         end;
//                     }
//                 }
//                 #endregion

//                 #region parte derecha 
//                 // group(Control15)
//                 // {
//                 //     ShowCaption = false;
//                 //     field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
//                 //     {
//                 //         ApplicationArea = Basic, Suite;
//                 //         // AutoFormatExpression = Currency.Code;
//                 //         AutoFormatType = 1;
//                 //         // CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
//                 //         Caption = 'Total Amount Excl. VAT ef';
//                 //         DrillDown = false;
//                 //         Editable = false;
//                 //         ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
//                 //     }
//                 //     field("Total VAT Amount"; VATAmount)
//                 //     {
//                 //         ApplicationArea = Basic, Suite;
//                 //         AutoFormatExpression = Currency.Code;
//                 //         AutoFormatType = 1;
//                 //         CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
//                 //         Caption = 'Total VAT';
//                 //         Editable = false;
//                 //         ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
//                 //     }
//                 //     field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
//                 //     {
//                 //         ApplicationArea = Basic, Suite;
//                 //         AutoFormatExpression = Currency.Code;
//                 //         AutoFormatType = 1;
//                 //         CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
//                 //         Caption = 'Total Amount Incl. VAT';
//                 //         Editable = false;
//                 //         ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
//                 //     }
//                 // }
//                 #endregion
//             }
//         }
//     }


//     trigger OnAfterGetCurrRecord()
//     begin
//         GetTotalSalesHeader();
//         CalculateTotals();
//         UpdateEditableOnRow();
//         UpdateTypeText();
//         SetItemChargeFieldsStyle();
//     end;



//     var
//         Currency: Record Currency;
//         SalesSetup: Record "Sales & Receivables Setup";
//         TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
//         AmountWithDiscountAllowed: Decimal;
//         DocumentTotals: Codeunit "Document Totals";
//         SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
//         CurrPageIsEditable: Boolean;
//         ItemChargeStyleExpression: Text;
//         TypeAsText: Text[30];

//     protected var
//         TotalSalesHeader: Record "Sales Header";
//         TotalSalesLine: Record "Sales Line";
//         InvDiscAmountEditable: Boolean;
//         InvoiceDiscountAmount: Decimal;
//         InvoiceDiscountPct: Decimal;
//         IsBlankNumber: Boolean;
//         // [InDataSet]
//         IsCommentLine: Boolean;
//         SuppressTotals: Boolean;
//         // [InDataSet]
//         UnitofMeasureCodeIsChangeable: Boolean;
//         VATAmount: Decimal;

//     local procedure ValidateInvoiceDiscountAmount()
//     var
//         SalesHeader: Record "Sales Header";
//     begin
//         if SuppressTotals then
//             exit;

//         SalesHeader.Get(Rec."Document Type", Rec."Document No.");
//         SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
//         DocumentTotals.SalesDocTotalsNotUpToDate();
//         CurrPage.Update(false);
//     end;

//     procedure UpdateEditableOnRow()
//     begin
//         IsCommentLine := not Rec.HasTypeToFillMandatoryFields();
//         IsBlankNumber := IsCommentLine;
//         UnitofMeasureCodeIsChangeable := not IsCommentLine;

//         CurrPageIsEditable := CurrPage.Editable();
//         InvDiscAmountEditable :=
//             CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount" and
//             (TotalSalesHeader.Status = TotalSalesHeader.Status::Open);

//         OnAfterUpdateEditableOnRow(Rec, IsCommentLine, IsBlankNumber);
//     end;

//     local procedure GetTotalSalesHeader()
//     begin
//         DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
//     end;

//     procedure CalculateTotals()
//     begin
//         OnBeforeCalculateTotals(TotalSalesLine, SuppressTotals);
//         if SuppressTotals then
//             exit;

//         DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
//         DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
//         DocumentTotals.RefreshSalesLine(Rec);
//     end;

//     procedure UpdateTypeText()
//     var
//         RecRef: RecordRef;
//     begin
//         OnBeforeUpdateTypeText(Rec);

//         RecRef.GetTable(Rec);
//         TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Rec.Type)));
//     end;

//     local procedure SetItemChargeFieldsStyle()
//     begin
//         ItemChargeStyleExpression := '';
//         if Rec.AssignedItemCharge() then
//             ItemChargeStyleExpression := 'Unfavorable';
//     end;


//     [IntegrationEvent(false, false)]
//     local procedure OnAfterUpdateEditableOnRow(SalesLine: Record "Sales Line"; var IsCommentLine: Boolean; var IsBlankNumber: Boolean);
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeUpdateTypeText(var SalesLine: Record "Sales Line")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeCalculateTotals(var TotalSalesLine: Record "Sales Line"; var SuppressTotals: Boolean)
//     begin
//     end;

// }

