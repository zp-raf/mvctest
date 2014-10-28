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
  private
    FCobroForm: TProcesoPago;
    procedure SetCobroForm(AValue: TProcesoPago);
  protected
    function GetCustomController: TDocumentosController;
  public
    constructor Create(AOwner: IFormView; AController: TDocumentosController); overload;
  published
    ButtonAnularPago: TButton;
    ButtonAnular: TButton;
    ButtonCobrar: TButton;
    ButtonVer: TButton;
    ButtonImprimir: TButton;
    DBGrid1: TDBGrid;
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
    procedure FormDestroy(Sender: TObject);
    procedure TabSheetCobroShow(Sender: TObject);
    procedure TabSheetFacturasCobradasShow(Sender: TObject);
    procedure TabSheetFacturaShow(Sender: TObject);
    property CobroForm: TProcesoPago read FCobroForm write SetCobroForm;
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
  begin
    GetCustomController.CobrarDoc(doFactura, Self);
    case CobroForm.ShowModal of
      mrOk:
      begin
        GetController.CloseDataSets(Self);
        GetController.OpenDataSets(Self);
      end;
      mrCancel:
      begin
        GetController.CloseDataSets(Self);
        GetController.OpenDataSets(Self);
      end;
    end;
  end;
end;

procedure TProcesoDocumentos.ButtonAnularClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    GetCustomController.AnularDoc(doRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.AnularDoc(doFactura, Self);
end;

procedure TProcesoDocumentos.ButtonAnularPagoClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    GetCustomController.AnularPago(doFactura, Self);
end;

procedure TProcesoDocumentos.ButtonVerClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    GetCustomController.VerDocumento(doRecibo, '1', Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    GetCustomController.VerDocumento(doFactura, '2', Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    GetCustomController.VerDocumento(doFactura, '3', Self);
end;

procedure TProcesoDocumentos.FormDestroy(Sender: TObject);
begin
  if CobroForm <> nil then
    CobroForm.Free;
end;

procedure TProcesoDocumentos.TabSheetFacturaShow(Sender: TObject);
begin
  ButtonCobrar.Enabled := True;
  ButtonVer.Enabled := True;
  ButtonImprimir.Enabled := True;
  ButtonAnular.Enabled := True;
  ButtonAnularPago.Enabled := False;
end;

procedure TProcesoDocumentos.SetCobroForm(AValue: TProcesoPago);
begin
  if FCobroForm = AValue then
    Exit;
  FCobroForm := AValue;
end;

function TProcesoDocumentos.GetCustomController: TDocumentosController;
begin
  Result := GetController as TDocumentosController;
end;

constructor TProcesoDocumentos.Create(AOwner: IFormView;
  AController: TDocumentosController);
begin
  inherited Create(AOwner, AController);
  FCobroForm := TProcesoPago.Create(Self, GetCustomController.PagoController);
end;

end.
