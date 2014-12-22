unit frmdevoluciondatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, XMLPropStorage, IniPropStorage, frmrecibodatamodule, DB, sqldb;

type

  { TDevolucionDataModule }

  TDevolucionDataModule = class(TReciboDataModule)
    saldos: TSQLQuery;
    saldosCREDITO: TFloatField;
    saldosCUENTAID: TLongintField;
    saldosDEBITO: TFloatField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure FetchDevolucionDetalle(APersonaID: string);
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
  end;

var
  DevolucionDataModule: TDevolucionDataModule;

implementation

{$R *.lfm}

{ TDevolucionDataModule }


procedure TDevolucionDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  AuxQryList.Add(TObject(saldos));
end;

procedure TDevolucionDataModule.FetchDevolucionDetalle(APersonaID: string);
var
  CID: string;
begin
  try
    CID := MasterDataModule.DevuelveValor('select id from cuenta where personaid = ' +
      APersonaID, 'id');
    if CID = '' then
      raise EDatabaseError.Create('Cuenta para la persona no encontrada');
    if not saldos.Locate('CUENTAID', CID, []) then
      raise EDatabaseError.Create('No hay saldos para devolver');
    if saldosCREDITO.Value < saldosDEBITO.Value then
      raise EDatabaseError.Create('No hay saldos para devolver');

    if not (qryDetalle.State in dsEditModes) then
      qryDetalle.Insert;
    qryDetalleCANTIDAD.AsInteger := 1;
    qryDetalleDETALLE.AsString := 'Devolucion de saldo excedente';
    qryDetallePRECIO_UNITARIO.AsFloat :=
      abs(saldosDEBITO.AsFloat - saldosCREDITO.AsFloat);
    qryDetalle.Post;
  except
    on e: EDatabaseError do
    begin
      DoOnErrorEvent(Self, e);
      raise;
    end;
  end;
end;

procedure TDevolucionDataModule.qryDetallePRECIO_UNITARIOChange(Sender: TField);
begin
  try
    qryDetallePRECIO_UNITARIO.OnChange := nil;
    if Sender.Value > abs(saldosDEBITO.AsFloat - saldosCREDITO.AsFloat) then
      Sender.Value := abs(saldosDEBITO.AsFloat - saldosCREDITO.AsFloat);
    qryDetalleTOTAL.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
  finally
    qryDetallePRECIO_UNITARIO.OnChange := @qryDetallePRECIO_UNITARIOChange;
  end;
end;

end.
