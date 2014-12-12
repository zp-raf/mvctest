unit frmprocesonotacreditocompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesonotacredito, sgcdTypes, LCLType, frmbuscarpersonas, frmprocesocomprobante;

type

  { TProcesoNotaCreditoCompra }

  TProcesoNotaCreditoCompra = class(TProcesoNotaCredito)
    DBEditNro: TDBEdit;
    DBEditTimbrado: TDBEdit;
    LabelNumeroComp: TLabel;
    LabelTimbradoCompra: TLabel;
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure ButtonSeleccionarPersClick(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OnPopupOk; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoNotaCreditoCompra: TProcesoNotaCreditoCompra;

implementation

{$R *.lfm}

{ TProcesoNotaCreditoCompra }

procedure TProcesoNotaCreditoCompra.OKButtonClick(Sender: TObject);
begin
    if not GetController.IsValidDate(DateEditFecha.Date) or
    (DateEditFecha.Date > Now) then
  begin
    ShowErrorMessage('Fecha de emision invalida');
    Exit;
  end;
  inherited;
end;

procedure TProcesoNotaCreditoCompra.ButtonLimpiarClick(Sender: TObject);
begin
  inherited;
  GetController.OpenDataSets(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
end;

procedure TProcesoNotaCreditoCompra.ButtonSeleccionarPersClick(Sender: TObject);
begin
  Popup := TPopupSeleccionPersonas.Create(Self,
    GetComprobanteController.BuscarPersonaController);
  Popup.SetDataSource(GetCustomController.GetPersonasDataSource);
  inherited;
end;

procedure TProcesoNotaCreditoCompra.DBGridDetKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and ((DBGridDet.SelectedField.FieldName = 'EXENTA') or
    (DBGridDet.SelectedField.FieldName = 'IVA5') or
    (DBGridDet.SelectedField.FieldName = 'IVA10')) then
    GetCustomController.SetPrecioTotal(DBGridDet.SelectedField.FieldName, Self);
  DBGridDet.AutoSizeColumns;
end;

procedure TProcesoNotaCreditoCompra.FormCreate(Sender: TObject);
begin
  GetCustomController.SetCompra(True);
  GetCustomController.FiltrarFacturas(cvCompra, Self);
end;

procedure TProcesoNotaCreditoCompra.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    csInicial:
    begin
      DateEditFecha.Enabled := False;
      ButtonSeleccionarPers.Enabled := False;
    end;
    csEditando:
    begin
      DateEditFecha.Enabled := True;
      ButtonSeleccionarPers.Enabled := True;
    end;
    csGuardado:
    begin
      DateEditFecha.Enabled := False;
      ButtonSeleccionarPers.Enabled := False;
    end;
  end;
  ButtonLimpiar.Enabled := True;
  ButtonSeleccionarPers.Enabled := True;
end;

procedure TProcesoNotaCreditoCompra.OnPopupOk;
begin
  //if GetCustomController.GetEstadoComprobante(Self) = csEditando then
  //begin
  //  GetCustomController.FetchCabeceraPersona(Self);
  //end
  //else
  //begin
  GetController.Connect(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
  //GetCustomController.FetchCabeceraPersona(Self);
  //end;
end;

end.

