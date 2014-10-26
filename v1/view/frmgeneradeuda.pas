unit frmgeneradeuda;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, Dialogs, Menus, ExtCtrls, DBCtrls,
  StdCtrls, Spin, EditBtn, frmAbm, generardeudactrl, mensajes, variants;

type

  { TGenerarDeuda }

  TGenerarDeuda = class(TAbm)
  protected
    function GetCustomController: TGenDeudaController;
  published
    DateEditVen: TDateEdit;
    DBLookupComboBoxAran: TDBLookupComboBox;
    DBLookupComboBoxVenUnidad: TDBLookupComboBox;
    DBLookupComboBoxPers: TDBLookupComboBox;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    Fecha: TLabel;
    FraccionamientoPorDefecto: TCheckBox;
    GroupBoxVencimiento: TGroupBox;
    Label4: TLabel;
    LabelArancel: TLabel;
    LabelCantCuotas: TLabel;
    LabelPersona: TLabel;
    SinVencimiento: TCheckBox;
    SpinEditCant: TSpinEdit;
    SpinEditVenCant: TSpinEdit;
    procedure ABMInsert; override;
    procedure ABMEdit; override;
    procedure ABMDelete; override;
    procedure DateEditVenEditingDone(Sender: TObject);
    procedure DateEditVenEnter(Sender: TObject);
    procedure EditVenCantEnter(Sender: TObject);
    procedure FraccionamientoPorDefectoChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure SinVencimientoChange(Sender: TObject);
    procedure SpinEditCantChange(Sender: TObject);
  end;

var
  GenerarDeuda: TGenerarDeuda;

implementation

{$R *.lfm}

{ TGenerarDeuda }

procedure TGenerarDeuda.FraccionamientoPorDefectoChange(Sender: TObject);
begin
  if FraccionamientoPorDefecto.Checked then
  begin
    SpinEditCant.Enabled := False;
    SinVencimiento.Checked := False;
    SinVencimiento.Enabled := False;
    GroupBoxVencimiento.Enabled := False;
  end
  else
  begin
    SpinEditCant.Enabled := True;
    SinVencimiento.State := cbGrayed;
    SinVencimiento.Enabled := True;
    GroupBoxVencimiento.Enabled := True;
  end;
  // actualizamos el checkbox de vencimiento porque no se actualiza asi nomas
  //SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.EditVenCantEnter(Sender: TObject);
begin
  DateEditVen.Clear;
end;

procedure TGenerarDeuda.SpinEditCantChange(Sender: TObject);
begin
  if SpinEditCant.Value > 1 then
  begin
    DateEditVen.Enabled := False;
    DateEditVen.Clear;
  end
  else
  begin
    DateEditVen.Enabled := True;
    DateEditVen.Clear;
  end;
end;

procedure TGenerarDeuda.DateEditVenEditingDone(Sender: TObject);
begin
  if not GetController.IsValidDate(DateEditVen.Text) then
    ShowErrorMessage(rsInvalidDateFormat);
end;

procedure TGenerarDeuda.DateEditVenEnter(Sender: TObject);
begin
  SpinEditVenCant.Value := 0;
  DBLookupComboBoxVenUnidad.Clear;
end;

procedure TGenerarDeuda.OKButtonClick(Sender: TObject);
var
  msg: TDeudaMsg;
begin
  msg.Inserting := PanelDetail.Visible;
  msg.Updating := PanelList.Visible;
  msg.FraccionamientoPorDefecto := FraccionamientoPorDefecto.Checked;
  msg.SinVencimiento := SinVencimiento.Checked;
  msg.CantCuotas := SpinEditCant.Value;
  msg.FechaVen := DateEditVen.Date;
  msg.CantidadVen := SpinEditVenCant.Value;
  msg.UnidadVen := StrToInt(VarToStrDef(DBLookupComboBoxVenUnidad.KeyValue, '99'));
  if PanelDetail.Visible and ((FraccionamientoPorDefecto.State = cbGrayed) or
    (SinVencimiento.State = cbGrayed)) then
  begin
    ShowErrorMessage(rsPleaseSelFinanOpt);
    Exit;
  end;
  if GetCustomController.CheckAndSave(Self, msg) then
    GetABMController.Commit(Self)
  else
    GetABMController.Rollback(Self);
  ShowPanel(PanelList);
end;

procedure TGenerarDeuda.SinVencimientoChange(Sender: TObject);
begin
  //if SinVencimiento.State = cbChecked then
  //  GroupBoxVencimiento.Enabled := False
  //else if SinVencimiento.State = cbUnchecked then;
  //  GroupBoxVencimiento.Enabled := True;
  if SinVencimiento.Checked then
    GroupBoxVencimiento.Enabled := False
  else
    GroupBoxVencimiento.Enabled := True;
end;

function TGenerarDeuda.GetCustomController: TGenDeudaController;
begin
  Result := GetController as TGenDeudaController;
end;

procedure TGenerarDeuda.ABMInsert;
begin
  inherited ABMInsert;
  FraccionamientoPorDefectoChange(FraccionamientoPorDefecto);
  SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.ABMEdit;
begin
  // NO PERMITIDO
  //inherited ABMEdit;
  //FraccionamientoPorDefectoChange(FraccionamientoPorDefecto);
  //SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.ABMDelete;
begin
  inherited ABMDelete;
end;

end.
