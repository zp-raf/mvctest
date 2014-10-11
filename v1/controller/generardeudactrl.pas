unit generardeudactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mvc, ctrl, frmgeneradeudadatamodule, mensajes, StdCtrls;

resourcestring
  rsPorFavorSele = 'Por favor seleccione una opcion para fraccionamiento y ' +
    'vencimiento';
  rsValorInvalid = 'Valor invalido para unidad de fecha';

type

  { TGenDeudaController }

  TGenDeudaController = class(TABMController)
  private
    FCustomModel: TGeneraDeudaDataModule;
    procedure SetCustomController(AValue: TGeneraDeudaDataModule);
  public
    constructor Create(AModel: TGeneraDeudaDataModule);
    function CheckAndSave(Sender: IView; AMsg: TDeudaMsg): boolean;
    function CheckAndSave(Sender: IView; AMsg: TDeudaMsg;
      ADetMsg: TDeudaDetMsg): boolean;
    procedure ErrorHandler(E: Exception; Sender: IABMView); overload;
    // cuotas por defecto
    procedure Save(Sender: IView); override; overload;
    // sin vencimiento
    procedure Save(Sender: IView; ACantCuotas: integer); overload;
    // una cuota con vencimiento manual
    procedure Save(Sender: IView; AVenc: string); overload;
    // con vencimiento
    procedure Save(Sender: IView; ACantCuotas: integer; AUnidadFecha: TUnidadFecha;
      ACant: integer); overload;
    property CustomModel: TGeneraDeudaDataModule
      read FCustomModel write SetCustomController;
  end;

implementation

{ TGenDeudaController }

constructor TGenDeudaController.Create(AModel: TGeneraDeudaDataModule);
var
  x: IModel;
begin
  (AModel as IInterface).QueryInterface(IModel, x);
  if x <> nil then
  begin
    inherited Create(AModel);
    FCustomModel := AModel;
  end
  else
    raise Exception.Create(rsModelErr);
end;

function TGenDeudaController.CheckAndSave(Sender: IView; AMsg: TDeudaMsg): boolean;
begin
  Result := True;
  // para cuando se acutaliza
  if AMsg.Updating and not AMsg.Inserting then
  begin
    Model.SaveChanges;
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
          Sender.ShowErrorMessage(rsValorInvalid);
          //raise Exception.Create(rsValorInvalid);
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
        Sender.ShowErrorMessage(rsValorInvalid);
        //raise Exception.Create(rsValorInvalid;
        Result := False;
      end;
    end;
  end
  else
  begin
    Sender.ShowErrorMessage(rsPorFavorSele);
    Result := False;
  end;
end;

function TGenDeudaController.CheckAndSave(Sender: IView; AMsg: TDeudaMsg;
  ADetMsg: TDeudaDetMsg): boolean;
begin
  CustomModel.SetArancel(ADetMsg.ArancelID);
  CustomModel.SetPersona(ADetMsg.PersonaID);
  CustomModel.SetMatricula(ADetMsg.MatriculaID);
  Result := CheckAndSave(Sender, AMsg);
end;

procedure TGenDeudaController.ErrorHandler(E: Exception; Sender: IABMView);
begin
  inherited ErrorHandler(E, Sender);
end;

procedure TGenDeudaController.Save(Sender: IView);
begin
  // fraccionado y venc por defecto
  CustomModel.GenerarCuotas;
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; ACantCuotas: integer);
begin
  // fraccionado personalizdo y sin vencimiento
  CustomModel.GenerarCuotas(ACantCuotas);
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; AVenc: string);
begin
  // fraccionado personalizado (una cuota) y vencimiento con fecha
  CustomModel.GenerarCuotas(AVenc);
  inherited Save(Sender);
end;

procedure TGenDeudaController.Save(Sender: IView; ACantCuotas: integer;
  AUnidadFecha: TUnidadFecha; ACant: integer);
begin
  // fraccionado personalizado y vencimiento con unidad de fecha y cantidad
  CustomModel.GenerarCuotas(ACantCuotas, AUnidadFecha, ACant);
  inherited Save(Sender);
end;

procedure TGenDeudaController.SetCustomController(AValue: TGeneraDeudaDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;

end.
