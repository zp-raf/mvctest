unit frmprocesodocumentos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, StdCtrls, DBGrids, frmproceso,
  frmdocumentosdatamodule, mvc, documentosctrl, frmMaestro, frmfacturadatamodule2,
  frmpagodatamodule, frmpago, sgcdtypes;

type

  { TProcesoDocumentos }

  TProcesoDocumentos = class(TProceso)
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
  private
    FCobroForm: TProcesoPago;
    FCustomController: TDocumentosController;
    function GetCustomController: TDocumentosController;
    procedure SetCobroForm(AValue: TProcesoPago);
    procedure SetCustomController(AValue: TDocumentosController);
    { private declarations }
  public
    constructor Create(AOwner: IFormView; AController: TDocumentosController); overload;
    property CustomController: TDocumentosController
      read GetCustomController write SetCustomController;
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
    CustomController.CobrarDoc(doFactura, Self);
    case CobroForm.ShowModal of
      mrOk:
      begin
        Controller.CloseDataSets(Self);
        Controller.OpenDataSets(Self);
      end;
      mrCancel:
      begin
        Controller.CloseDataSets(Self);
        Controller.OpenDataSets(Self);
      end;
    end;
  end;
end;

procedure TProcesoDocumentos.ButtonAnularClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    CustomController.AnularDoc(doRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    CustomController.AnularDoc(doFactura, Self);
end;

procedure TProcesoDocumentos.ButtonAnularPagoClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    CustomController.AnularPago(doFactura, Self);
end;

procedure TProcesoDocumentos.ButtonVerClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    CustomController.VerDocumento(doRecibo, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    CustomController.VerDocumento(doFactura, Self)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    CustomController.VerDocumento(doFactura, Self);
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

procedure TProcesoDocumentos.SetCustomController(AValue: TDocumentosController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TProcesoDocumentos.SetCobroForm(AValue: TProcesoPago);
begin
  if FCobroForm = AValue then
    Exit;
  FCobroForm := AValue;
end;

function TProcesoDocumentos.GetCustomController: TDocumentosController;
begin
  Result := Controller as TDocumentosController;
end;

constructor TProcesoDocumentos.Create(AOwner: IFormView;
  AController: TDocumentosController);
var
  Cont: IController;
begin
  (AController as IInterface).QueryInterface(IController, Cont);
  if (Cont = nil) then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    CustomController := AController;
    FCobroForm := TProcesoPago.Create(Self, CustomController.PagoController);
  end;
end;

end.
