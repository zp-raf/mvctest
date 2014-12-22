unit frmprocesodocumentos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ExtCtrls, StdCtrls, DBGrids, ButtonPanel, frmproceso,
  frmdocumentosdatamodule, mvc, documentosctrl, frmfacturadatamodule2,
  frmpagodatamodule, frmpago, sgcdtypes;

type

  { TProcesoDocumentos }

  TProcesoDocumentos = class(TProceso)
    DBGridReciboCompra: TDBGrid;
    DBGridNCCompra: TDBGrid;
    DBGridFactComp: TDBGrid;
    DBGridNotaCredito: TDBGrid;
    TabSheetFacturaCompra: TTabSheet;
    TabSheetNCCompra: TTabSheet;
    TabSheetReciboCompra: TTabSheet;
    TabSheetNotaCredito: TTabSheet;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TabSheetFacturaCompraShow(Sender: TObject);
    procedure TabSheetNCCompraShow(Sender: TObject);
    procedure TabSheetNotaCreditoShow(Sender: TObject);
    procedure TabSheetReciboCompraShow(Sender: TObject);
  protected
    function GetCustomController: TDocumentosController;
  published
    ButtonAnularPago: TButton;
    ButtonAnular: TButton;
    ButtonCobrar: TButton;
    ButtonVer: TButton;
    ButtonImprimir: TButton;
    DBGridFacturasCobradas: TDBGrid;
    DBGridFactura: TDBGrid;
    DBGridCobro: TDBGrid;
    PageControlDocs: TPageControl;
    PanelAcciones: TPanel;
    TabSheetFacturasCobradas: TTabSheet;
    TabSheetCobro: TTabSheet;
    TabSheetFactura: TTabSheet;
    procedure ButtonAnularClick(Sender: TObject);
    procedure ButtonAnularPagoClick(Sender: TObject);
    procedure ButtonCobrarClick(Sender: TObject);
    procedure ButtonVerClick(Sender: TObject);
    procedure TabSheetCobroShow(Sender: TObject);
    procedure TabSheetFacturasCobradasShow(Sender: TObject);
    procedure TabSheetFacturaShow(Sender: TObject);
  end;

var
  ProcesoDocumentos: TProcesoDocumentos;

implementation

{$R *.lfm}

{ TProcesoDocumentos }

procedure TProcesoDocumentos.TabSheetCobroShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridCobro, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.TabSheetFacturasCobradasShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridFacturasCobradas, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := False;
  ButtonAnularPago.Enabled := True;
end;

procedure TProcesoDocumentos.TabSheetFacturaShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridFactura, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := True;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.ButtonCobrarClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
  begin
    GetCustomController.CobrarDoc(dtFacturaNocobrada, Self);
    //GetController.Disconnect(Self);
    //GetController.Connect(Self);
  end;
end;

procedure TProcesoDocumentos.ButtonAnularClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    GetCustomController.AnularDoc(dtRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.AnularDoc(dtFacturaNocobrada, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetNotaCredito.PageIndex then
    GetCustomController.AnularDoc(dtNotaCredito, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturaCompra.PageIndex then
    GetCustomController.AnularDoc(dtFacturaCompra, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetReciboCompra.PageIndex then
    GetCustomController.AnularDoc(dtReciboCompra, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetNCCompra.PageIndex then
    GetCustomController.AnularDoc(dtNotaCredCompra, Self);
end;

procedure TProcesoDocumentos.ButtonAnularPagoClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    GetCustomController.AnularPago(dtFacturaCobrada, Self);
end;

procedure TProcesoDocumentos.ButtonVerClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    GetCustomController.VerDocumento(dtRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.VerDocumento(dtFacturaNocobrada, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    GetCustomController.VerDocumento(dtFacturaCobrada, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetNotaCredito.PageIndex then
    GetCustomController.VerDocumento(dtNotaCredito, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturaCompra.PageIndex then
    GetCustomController.VerDocumento(dtFacturaCompra, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetReciboCompra.PageIndex then
    GetCustomController.VerDocumento(dtReciboCompra, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetNCCompra.PageIndex then
    GetCustomController.VerDocumento(dtNotaCredCompra, Self);
end;

procedure TProcesoDocumentos.CancelButtonClick(Sender: TObject);
begin
  GetController.Rollback(Self);
end;

procedure TProcesoDocumentos.FormShow(Sender: TObject);
begin
  inherited;
  TabSheetFactura.Show;
  TabSheetFacturaShow(TabSheetFactura);
end;

procedure TProcesoDocumentos.OKButtonClick(Sender: TObject);
begin
  GetController.Commit(Self);
end;

procedure TProcesoDocumentos.TabSheetFacturaCompraShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridFactComp, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.TabSheetNCCompraShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridNCCompra, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.TabSheetNotaCreditoShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridNotaCredito, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.TabSheetReciboCompraShow(Sender: TObject);
begin
  if GetController.IsDBGridEmpty(DBGridReciboCompra, Self) then
    PanelAcciones.Enabled := False
  else
    PanelAcciones.Enabled := True;
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

function TProcesoDocumentos.GetCustomController: TDocumentosController;
begin
  Result := GetController as TDocumentosController;
end;

end.
