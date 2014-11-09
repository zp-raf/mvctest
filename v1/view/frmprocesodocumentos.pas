unit frmprocesodocumentos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ExtCtrls, StdCtrls, DBGrids, frmproceso,
  frmdocumentosdatamodule, mvc, documentosctrl, frmfacturadatamodule2,
  frmpagodatamodule, frmpago, sgcdtypes;

type

  { TProcesoDocumentos }

  TProcesoDocumentos = class(TProceso)
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
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
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.TabSheetFacturasCobradasShow(Sender: TObject);
begin
  ButtonCobrar.Enabled := False;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := False;
  ButtonAnularPago.Enabled := True;
end;

procedure TProcesoDocumentos.ButtonCobrarClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.CobrarDoc(dtFacturaNocobrada, Self);
end;

procedure TProcesoDocumentos.ButtonAnularClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    GetCustomController.AnularDoc(dtRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.AnularDoc(dtFacturaNocobrada, Self);
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
    GetCustomController.VerDocumento(dtFacturaCobrada, Self);
end;

procedure TProcesoDocumentos.TabSheetFacturaShow(Sender: TObject);
begin
  ButtonCobrar.Enabled := True;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.CancelButtonClick(Sender: TObject);
begin
  GetController.Rollback(Self);
end;

procedure TProcesoDocumentos.OKButtonClick(Sender: TObject);
begin
  GetController.Commit(Self);
end;

function TProcesoDocumentos.GetCustomController: TDocumentosController;
begin
  Result := GetController as TDocumentosController;
end;

end.
