unit frmProcNotaCredito;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmproceso, notacreditoctrl, mvc, frmNotaCreditoDataModule,
  frmMaestro, frmbuscarpersonas, buscarpersctrl;

type

  { TProcesoNotaCredito }

  TProcesoNotaCredito = class(TProceso)
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure DateEditVenEditingDone(Sender: TObject);
    procedure DBGridDetEditingDone(Sender: TObject);
    procedure DBNavigatorDetBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure RadioCondicionChange(Sender: TObject);
  private
    FABMController: IABMController;
    FCustomController: TNotaCreditoController;
    function GetController: IABMController;
    function GetCustomController: TNotaCreditoController;
    procedure SetController(AValue: IABMController);
    procedure SetCustomController(AValue: TNotaCreditoController);

  public
    constructor Create(AOwner: IFormView; AController: TNotaCreditoController);
      overload;
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    DateEditFecha: TDateEdit;
    DateEditVen: TDateEdit;
    DBEditDireccion: TDBEdit;
    DBEditGranTotal: TDBEdit;
    DBEditIVA10: TDBEdit;
    DBEditIVA5: TDBEdit;
    DBEditIVATotal: TDBEdit;
    DBEditNombre: TDBEdit;
    DBEditNotaRem: TDBEdit;
    DBEditRuc: TDBEdit;
    DBEditSubTotal: TDBEdit;
    DBEditSubTotal10: TDBEdit;
    DBEditSubTotal5: TDBEdit;
    DBEditTelefono: TDBEdit;
    DBGridDet: TDBGrid;
    DBNavigatorDet: TDBNavigator;
    DBTextNro: TDBText;
    DBTextTimbrado: TDBText;
    Detalles: TGroupBox;
    LabelDireccion: TLabel;
    LabelFecha: TLabel;
    LabelGranTotal: TLabel;
    LabelIVA10: TLabel;
    LabelIVA5: TLabel;
    LabelIVATotal: TLabel;
    LabelNombre: TLabel;
    LabelNotaRem: TLabel;
    LabelNro: TLabel;
    LabelRuc: TLabel;
    LabelSubtotal: TLabel;
    LabelSubtotal10: TLabel;
    LabelSubtotal5: TLabel;
    LabelTelefono: TLabel;
    LabelTimbrado: TLabel;
    LabelVen: TLabel;
    PairSplitterDetSubTot: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    RadioCondicion: TDBRadioGroup;
    Totales: TGroupBox;
    procedure Edit;
    procedure Insert;
    procedure Delete;
    procedure Refresh;
    procedure ObserverUpdate(const Subject: IInterface); override;
    property ABMController: IABMController read GetController write SetController;
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    { Aca esta el controlador especifico del modulo }
    property CustomController: TNotaCreditoController
      read GetCustomController write SetCustomController;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoNotaCredito: TProcesoNotaCredito;

implementation

{$R *.lfm}

{ TProcesoNotaCredito }

procedure TProcesoNotaCredito.ButtonLimpiarClick(Sender: TObject);
begin
  Limpiar;
end;

procedure TProcesoNotaCredito.DateEditVenEditingDone(Sender: TObject);
begin
  if DateEditVen.Date < Now then
    ShowErrorMessage('Fecha no permitida')
  else
    CustomController.SetVencimiento(DateEditVen.Date);
end;

procedure TProcesoNotaCredito.DBGridDetEditingDone(Sender: TObject);
begin
  CustomController.ActualizarTotales(Self);
end;

procedure TProcesoNotaCredito.DBNavigatorDetBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin

end;

procedure TProcesoNotaCredito.FormShow(Sender: TObject);
begin
  inherited;
  Controller.Disconnect(Self);
end;

procedure TProcesoNotaCredito.RadioCondicionChange(Sender: TObject);
begin
  case RadioCondicion.ItemIndex of
    -1: DateEditVen.Enabled := False;
    0: DateEditVen.Enabled := True;
    1: DateEditVen.Enabled := False;
  end;
end;

function TProcesoNotaCredito.GetController: IABMController;
begin
  Result := FABMController;
end;

function TProcesoNotaCredito.GetCustomController: TNotaCreditoController;
begin
  Result := FCustomController;
end;

procedure TProcesoNotaCredito.SetController(AValue: IABMController);
begin
  if FABMController = AValue then
    Exit;
  FABMController := AValue;
end;

procedure TProcesoNotaCredito.SetCustomController(AValue: TNotaCreditoController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

constructor TProcesoNotaCredito.Create(AOwner: IFormView;
  AController: TNotaCreditoController);
var
  Cont: IController;
  ABMCont: IABMController;
begin
    { Aca se chequean el controlador y se asignan las propiedades
       correspondientes. Con queryinterface sacamos una referencia al objeto que
       implementa la interfaz. Hacemos asi por si acaso AController sea un objeto
       compuesto y que hayan subojetos que implementen las interfaces. Esto nos da
       mayor flexibilidad en la implementacion. }
  (AController as IInterface).QueryInterface(IController, Cont);
  (AController as IInterface).QueryInterface(IABMController, ABMCont);
  if (Cont = nil) or (ABMCont = nil) then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    ABMController := ABMCont;
    CustomController := AController;
  end;
end;

procedure TProcesoNotaCredito.Edit;
begin

end;

procedure TProcesoNotaCredito.Insert;
begin

end;

procedure TProcesoNotaCredito.Delete;
begin

end;

procedure TProcesoNotaCredito.Refresh;
begin

end;

procedure TProcesoNotaCredito.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetFacturaEstado(Self) of
    asInicial:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      //btSeleccionar.Visible := False;
      //ButtonLimpiar.Enabled := False;
    end;
    asGuardado:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      //btSeleccionar.Visible := False;
      //ButtonLimpiar.Enabled := False;
    end;
    asEditando:
    begin
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      DBGridDet.Color := clWindow;
      //btSeleccionar.Visible := False;
      //ButtonLimpiar.Enabled := False;
      DBGridDet.AutoSizeColumns;
      DateEditVen.Date := now; // no me gusta esto pero bue...
    end;
  end;

end;

procedure TProcesoNotaCredito.Limpiar;
begin
  DBEditDireccion.Clear;
  DBEditRuc.Clear;
  DBEditTelefono.Clear;
  DBEditNotaRem.Clear;
  DBEditSubTotal.Clear;
  DBEditGranTotal.Clear;
  DBEditIVA5.Clear;
  DBEditIVA10.Clear;
  DBEditIVATotal.Clear;
  DBEditSubTotal5.Clear;
  DBEditSubTotal10.Clear;
  DBEditNombre.Clear;
  DateEditFecha.Clear;
  DateEditVen.Clear;
  RadioCondicion.ItemIndex := -1;
end;

procedure TProcesoNotaCredito.OKButtonClick(Sender: TObject);
begin
  if RadioCondicion.ItemIndex = -1 then
  begin
    ShowErrorMessage('Por favor seleccione una condicion de venta');
    Exit;
  end
  else if (RadioCondicion.ItemIndex = 0) and
    (not Controller.IsValidDate(DateEditVen.Text) or (DateEditVen.Date < Now)) then
  begin
    ShowErrorMessage('Fecha de vencimiento no valida');
    Exit;
  end;
  if not (CustomController.GetFacturaEstado(Self) in [asEditando]) then
  begin
    ShowInfoMessage('No se esta procesando ninguna nota de crédito');
    Exit;
  end;
  CustomController.CerrarFactura(Self);
  ShowInfoMessage('Nota de crédito ingresada correctamente');
  Limpiar;
end;

procedure TProcesoNotaCredito.CancelButtonClick(Sender: TObject);
begin
  ABMController.Cancel(Self);
  ABMController.Rollback(Self);
  ShowInfoMessage('Nota de crédito descartada');
  Limpiar;
end;

procedure TProcesoNotaCredito.btSeleccionarClick(Sender: TObject);
var
  PopUp: TPopupSeleccionPersonas;
begin
  try
    PopUp := TPopupSeleccionPersonas.Create(Self);
    case PopUp.ShowModal of
      mrOk:
      begin
        Controller.Connect(Self);
        // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
        CustomController.NuevaFactura(Self);
      end
      else
      begin
        Exit;
      end;
    end;
  finally
    PopUp.Free;
  end;
end;

end.
