unit frmprocesodocumentos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, StdCtrls, DBGrids, frmproceso,
  frmdocumentosdatamodule, mvc, documentosctrl, frmMaestro, frmfacturadatamodule2,
  frmpagodatamodule, frmpago;

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
    procedure TabSheetCobroShow(Sender: TObject);
    procedure TabSheetFacturasCobradasShow(Sender: TObject);
    procedure TabSheetFacturaShow(Sender: TObject);
  private
    FCustomController: TDocumentosController;
    procedure SetCustomController(AValue: TDocumentosController);
    { private declarations }
  public
    constructor Create(AOwner: IFormView; AController: TDocumentosController); overload;
    property CustomController: TDocumentosController
      read FCustomController write SetCustomController;
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
var
  x: TProcesoPago;
begin
  if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
  begin
    try
      x := TProcesoPago.Create(Self, CustomController.PagoController);
      CustomController.CobrarDoc(doFactura);
      //x.Controller.OpenDataSets(x);
      case x.ShowModal of
        mrOk:
        begin
          Controller.CloseDataSets(Self);
          Controller.OpenDataSets(Self);
        end;
        mrCancel:
        begin
          // no se que hacer :P
        end;
      end;
    finally
      x.Free;
    end;
  end;
end;

procedure TProcesoDocumentos.ButtonAnularClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    CustomController.AnularDoc(doRecibo)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    CustomController.AnularDoc(doFactura);
end;

procedure TProcesoDocumentos.ButtonAnularPagoClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    CustomController.AnularPago(doFactura);
end;

procedure TProcesoDocumentos.ButtonVerClick(Sender: TObject);
begin
  if PageControlDocs.ActivePageIndex = TabSheetCobro.PageIndex then
    CustomController.VerDocumento(doRecibo)
  else if PageControlDocs.ActivePageIndex = TabSheetFactura.PageIndex then
    CustomController.VerDocumento(doFactura)
  else if PageControlDocs.ActivePageIndex = TabSheetFacturasCobradas.PageIndex then
    CustomController.VerDocumento(doFactura);
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
  end;
end;

end.
