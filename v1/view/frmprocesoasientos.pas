unit frmprocesoasientos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBCtrls, ExtCtrls, DBGrids, PairSplitter, Buttons,
  maskedit, frmproceso, frmasientosdatamodule, asientosctrl, mvc, frmMaestro, observerSubject;

resourcestring
  rsReversionDeA = 'Reversion de asiento';

type

  { TProcesoAsientos }

  TProcesoAsientos = class(TProceso)
    BitBtnCerrarAsiento: TBitBtn;
    BitBtnNuevoDetalle: TBitBtn;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGridCuenta: TDBGrid;
    RadioGroup1: TRadioGroup;
    procedure BitBtnCerrarAsientoClick(Sender: TObject);
    procedure BitBtnNuevoDetalleClick(Sender: TObject);
  private
    FABMController: IABMController;
    FCustomController: TAsientosController;
    function GetController: IABMController;
    function GetCustomController: TAsientosController;
    procedure SetController(AValue: IABMController);
    procedure SetCustomController(AValue: TAsientosController);
  public
    constructor Create(AOwner: IFormView; AController: TAsientosController);
      overload;
  published
    BitBtnNuevo: TBitBtn;
    Monto: TLabel;
    MaskEditMonto: TMaskEdit;
    BitBtnReversar: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Haber: TLabel;
    LabeledEditDesscripcion: TLabeledEdit;
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure MaskEditMontoKeyPress(Sender: TObject; var Key: char);
    procedure OKButtonClick(Sender: TObject);
    procedure BitBtnReversarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Limpiar;
    procedure ObserverUpdate(const Subject: IInterface); override;
    property ABMController: IABMController read GetController write SetController;
    { Aca esta el controlador especifico del modulo }
    property CustomController: TAsientosController
      read GetCustomController write SetCustomController;
  end;

var
  ProcesoAsientos: TProcesoAsientos;

implementation

{$R *.lfm}

{ TProcesoAsientos }

procedure TProcesoAsientos.ObserverUpdate(const Subject: IInterface);
begin
  inherited;
  case GetCustomController.GetAsientoEstado(Self) of
    asInicial:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clInactiveCaption;
      MaskEditMonto.Enabled := False;
      LabeledEditDesscripcion.Enabled := True;
      RadioGroup1.Enabled := False;
      BitBtnReversar.Enabled := True;
      BitBtnCerrarAsiento.Enabled := False;
      BitBtnNuevoDetalle.Enabled := False;
      BitBtnNuevo.Enabled := True;
    end;
    asGuardado:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clInactiveCaption;
      MaskEditMonto.Enabled := False;
      LabeledEditDesscripcion.Enabled := True;
      RadioGroup1.Enabled := False;
      BitBtnReversar.Enabled := True;
      BitBtnCerrarAsiento.Enabled := False;
      BitBtnNuevoDetalle.Enabled := False;
      BitBtnNuevo.Enabled := True;
    end;
    asEditando:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clWindow;
      MaskEditMonto.Enabled := True;
      LabeledEditDesscripcion.Enabled := False;
      RadioGroup1.Enabled := True;
      BitBtnReversar.Enabled := False;
      BitBtnCerrarAsiento.Enabled := True;
      BitBtnNuevoDetalle.Enabled := True;
      BitBtnNuevo.Enabled := False;
    end;
  end;
end;

constructor TProcesoAsientos.Create(AOwner: IFormView;
  AController: TAsientosController);
var
  Cont: IController;
  ABMCont: IABMController;
begin
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

procedure TProcesoAsientos.FormCreate(Sender: TObject);
begin
  //DBLookupComboBoxDebe.ListSource := GetCustomController.GetCuentaDebeDataSource;
  //DBLookupComboBoxDebe.KeyField := 'ID';
  //DBLookupComboBoxDebe.ListField := 'NOMBRE';
  //DBLookupComboBoxDebe.ScrollListDataset := True;

  //DBLookupComboBoxCuenta.ListSource := GetCustomController.GetCuentaHaberDataSource;
  //DBLookupComboBoxCuenta.KeyField := 'ID';
  //DBLookupComboBoxCuenta.ListField := 'NOMBRE';
  //DBLookupComboBoxDebe.ScrollListDataset := True;
end;

procedure TProcesoAsientos.Limpiar;
begin
  MaskEditMonto.Clear;
  RadioGroup1.ItemIndex := -1;
end;

procedure TProcesoAsientos.BitBtnNuevoClick(Sender: TObject);
begin
  GetCustomController.NuevoAsiento(LabeledEditDesscripcion.Text, Self as IFormView);
  Limpiar;
  LabeledEditDesscripcion.Enabled := False;
end;

procedure TProcesoAsientos.MaskEditMontoKeyPress(Sender: TObject; var Key: char);
begin
  if (Key in ['0'..'9', DecimalSeparator, #8, #9]) then
    Exit;
  key := #0;
end;

procedure TProcesoAsientos.OKButtonClick(Sender: TObject);
begin
  ABMController.Commit(Self);
  ABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Los nuevos asientos fueron guardados');
end;

procedure TProcesoAsientos.BitBtnNuevoDetalleClick(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex in [0, 1]) then
  begin
    case RadioGroup1.ItemIndex of
      0: GetCustomController.NuevoAsientoDetalle(mvDebito, MaskEditMonto.Text, Self);
      1: GetCustomController.NuevoAsientoDetalle(mvCredito, MaskEditMonto.Text, Self);
    end;
    Limpiar;
  end
  else
    ShowInfoMessage('Por favor seleccione un tipo de movimiento');
end;

procedure TProcesoAsientos.BitBtnCerrarAsientoClick(Sender: TObject);
begin
  GetCustomController.CerrarAsiento(Self);
end;

function TProcesoAsientos.GetController: IABMController;
begin
  Result := FABMController;
end;

procedure TProcesoAsientos.SetController(AValue: IABMController);
begin
  if FABMController = AValue then
    Exit;
  FABMController := AValue;
end;

procedure TProcesoAsientos.SetCustomController(AValue: TAsientosController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TProcesoAsientos.BitBtnReversarClick(Sender: TObject);
begin
  GetCustomController.ReversarAsiento(rsReversionDeA, Self);
  Limpiar;
end;

procedure TProcesoAsientos.CancelButtonClick(Sender: TObject);
begin
  //ABMController.Cancel(Self);
  ABMController.Rollback(Self);
  //ABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Los asientos no guardados fueron descartados');
end;

function TProcesoAsientos.GetCustomController: TAsientosController;
begin
  Result := FCustomController;
end;

end.
