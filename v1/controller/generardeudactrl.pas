unit generardeudactrl;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, mvc, ctrl, frmgeneradeudadatamodule, mensajes;

type

  { TGenDeudaController }

  TGenDeudaController = class(TABMController)
  protected
    function GetCustomModel: TGeneraDeudaDataModule;
  public
    function CheckAndSave(Sender: IView; AMsg: TDeudaMsg): boolean;
    function CheckAndSave(Sender: IView; AMsg: TDeudaMsg;
      ADetMsg: TDeudaDetMsg): boolean;
    procedure EliminarDeuda;
    procedure EliminarDeuda(AID: string);
    // cuotas por defecto
    procedure Save(Sender: IView); override; overload;
    // sin vencimiento
    procedure Save(Sender: IView; ACantCuotas: integer); overload;
    // una cuota con vencimiento manual
    procedure Save(Sender: IView; AVenc: string); overload;
    // con vencimiento
    procedure Save(Sender: IView; ACantCuotas: integer; AUnidadFecha: TUnidadFecha;
      ACant: integer); overload;
  end;

implementation

{ TGenDeudaController }

function TGenDeudaController.GetCustomModel: TGeneraDeudaDataModule;
begin
  Result := GetModel as TGeneraDeudaDataModule;
end;

function TGenDeudaController.CheckAndSave(Sender: IView; AMsg: TDeudaMsg): boolean;
begin
  Result := True;
  // para cuando se acutaliza
  if AMsg.Updating and not AMsg.Inserting then
  begin
    GetModel.SaveChanges;
    Exit;
  end;
  // para cuando se añade un nuevo registro
  if AMsg.FraccionamientoPorDefecto then
    Save(Sender)
  else if not AMsg.FraccionamientoPorDefecto and AMsg.SinVencimiento then
    Save(Sender, AMsg.CantCuotas)
  else if not AMsg.FraccionamientoPorDefecto and not AMsg.SinVencimiento and
    (AMsg.CantCuotas = 1) then
  begin
    if (AMsg.FechaVen > StrToDate('01/01/1900')) and (AMsg.CantidadVen = 0) then
      Save(Sender, DateToStr(AMsg.FechaVen))
    else if AMsg.CantidadVen <> 0 then
      case AMsg.UnidadVen of
        DIAS: Save(Sender, AMsg.CantCuotas,
            ufDias, AMsg.CantidadVen);
        MESES: Save(Sender, AMsg.CantCuotas,
            ufMeses, AMsg.CantidadVen);
        ANHOS: Save(Sender, AMsg.CantCuotas,
            ufAnhos, AMsg.CantidadVen);
        else
        begin
          Sender.ShowErrorMessage(rsInvalidValDate);
          //raise Exception.Create(rsInvalidValDate);
          Result := False;
        end
      end;
  end
  else if not AMsg.FraccionamientoPorDefecto and not AMsg.SinVencimiento and
    (AMsg.CantCuotas <> 1) then
  begin
    case AMsg.UnidadVen of
      DIAS: Save(Sender, AMsg.CantCuotas,
          ufDias, AMsg.CantidadVen);
      MESES: Save(Sender, AMsg.CantCuotas,
          ufMeses, AMsg.CantidadVen);
      ANHOS: Save(Sender, AMsg.CantCuotas,
          ufAnhos, AMsg.CantidadVen);
      else
      begin
        Sender.ShowErrorMessage(rsInvalidValDate);
        //raise Exception.Create(rsInvalidValDate;
        Result := False;
      end;
    end;
  end
  else
  begin
    Sender.ShowErrorMessage(rsPleaseSelFinanOpt);
    Result := False;
  end;
end;

function TGenDeudaController.CheckAndSave(Sender: IView; AMsg: TDeudaMsg;
  ADetMsg: TDeudaDetMsg): boolean;
begin
  GetCustomModel.SetArancel(ADetMsg.ArancelID);
  GetCustomModel.SetPersona(ADetMsg.PersonaID);
  GetCustomModel.SetMatricula(ADetMsg.MatriculaID);
  Result := CheckAndSave(Sender, AMsg);
end;

procedure TGenDeudaController.EliminarDeuda;
begin
  EliminarDeuda(GetCustomModel.DeudaID.AsString);
end;

procedure TGenDeudaController.EliminarDeuda(AID: string);
begin
  GetCustomModel.EliminarDeuda(AID);
  GetModel.SaveChanges;
end;

procedure TGenDeudaController.Save(Sender: IView);
begin
  // fraccionado y venc por defecto
  GetCustomModel.GenerarCuotas;
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; ACantCuotas: integer);
begin
  // fraccionado personalizdo y sin vencimiento
  GetCustomModel.GenerarCuotas(ACantCuotas);
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; AVenc: string);
begin
  // fraccionado personalizado (una cuota) y vencimiento con fecha
  GetCustomModel.GenerarCuotas(AVenc);
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; ACantCuotas: integer;
  AUnidadFecha: TUnidadFecha; ACant: integer);
begin
  // fraccionado personalizado y vencimiento con unidad de fecha y cantidad
  GetCustomModel.GenerarCuotas(ACantCuotas, AUnidadFecha, ACant);
  inherited Save(Sender);
end;

end.
