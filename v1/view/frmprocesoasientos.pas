unit frmprocesoasientos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBCtrls, ExtCtrls, DBGrids, PairSplitter, Buttons,
  maskedit, frmproceso, frmmovimientodatamodule, frmasientosdatamodule,
  asientosctrl, mvc, frmMaestro;

resourcestring
  rsReversionDeA = 'Reversion de asiento';

type

  { TProcesoAsientos }

  TProcesoAsientos = class(TProceso)
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
    Conectado: TToggleBox;
    BitBtnReversar: TBitBtn;
    DBGrid1: TDBGrid;
    DBLookupComboBoxDebe: TDBLookupComboBox;
    DBLookupComboBoxHaber: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Debe: TLabel;
    Haber: TLabel;
    LabeledEditDesscripcion: TLabeledEdit;
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure ConectadoClick(Sender: TObject);
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
  { aca se actualiza la vista. en este caso que es para prueba nomas
    cambiamos boton connected }
  if ABMController.IsDBConnected(Self) then
    Conectado.Checked := True
  else
    Conectado.Checked := False;
end;

constructor TProcesoAsientos.Create(AOwner: IFormView;
  AController: TAsientosController);
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

procedure TProcesoAsientos.FormCreate(Sender: TObject);
begin
  //DBLookupComboBoxDebe.ListSource := GetCustomController.GetCuentaDebeDataSource;
  //DBLookupComboBoxDebe.KeyField := 'ID';
  //DBLookupComboBoxDebe.ListField := 'NOMBRE';
  //DBLookupComboBoxDebe.ScrollListDataset := True;

  //DBLookupComboBoxHaber.ListSource := GetCustomController.GetCuentaHaberDataSource;
  //DBLookupComboBoxHaber.KeyField := 'ID';
  //DBLookupComboBoxHaber.ListField := 'NOMBRE';
  //DBLookupComboBoxDebe.ScrollListDataset := True;
end;

procedure TProcesoAsientos.Limpiar;
begin
  DBLookupComboBoxDebe.ClearSelection;
  DBLookupComboBoxHaber.ClearSelection;
  MaskEditMonto.Clear;
  LabeledEditDesscripcion.Clear;
end;

procedure TProcesoAsientos.ConectadoClick(Sender: TObject);
begin
  if Conectado.Checked then
    ABMController.Connect(Self)
  else
    ABMController.Disconnect(Self);
end;

procedure TProcesoAsientos.BitBtnNuevoClick(Sender: TObject);
begin
  if (Trim(MaskEditMonto.Text) = '') or (Trim(DBLookupComboBoxDebe.Text) = '') or
    (Trim(DBLookupComboBoxHaber.Text) = '') then
    Exit;
  GetCustomController.NuevoAsiento(LabeledEditDesscripcion.Text, Self as IFormView);
  Limpiar;
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
  ABMController.Cancel(Self);
  ABMController.Rollback(Self);
  ABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Los asientos no guardados fueron descartados');
end;

function TProcesoAsientos.GetCustomController: TAsientosController;
begin
  Result := FCustomController;
end;

end.
