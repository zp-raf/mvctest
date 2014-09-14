unit facturactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mvc, ctrl, frmfacturadatamodule;

type

  { TFacturaController }

  TFacturaController = class(TController)
    procedure UpdateTotal(Sender: IView);
    procedure NewInvoice(Sender: IView);
  end;

implementation

{ TFacturaController }

procedure TFacturaController.UpdateTotal(Sender: IView);
begin
  with Model as TFacturaDataModule do
  begin
    if not (Cabecera.State in [dsEdit, dsInsert]) then
      qryCabecera.Edit;
    CabeceraSUBTOTAL_EXENTAS.AsFloat := 0.0;
    CabeceraSUBTOTAL_IVA5.AsFloat := 0.0;
    CabeceraSUBTOTAL_IVA10.AsFloat := 0.0;
    if not Detalle.IsEmpty then
    begin
      Detalle.First;
      while not Detalle.EOF do
      begin
        CabeceraSUBTOTAL_EXENTAS.AsFloat :=
          CabeceraSUBTOTAL_EXENTAS.AsFloat + DetalleEXENTA.AsFloat;
        CabeceraSUBTOTAL_IVA5.AsFloat :=
          CabeceraSUBTOTAL_IVA5.AsFloat + DetalleIVA5.AsFloat;
        CabeceraSUBTOTAL_IVA10.AsFloat :=
          CabeceraSUBTOTAL_IVA10.AsFloat + DetalleIVA10.AsFloat;
        Detalle.Next;
      end;
      CabeceraTOTAL.AsFloat :=
        round(CabeceraSUBTOTAL_EXENTAS.AsFloat + CabeceraSUBTOTAL_IVA5.AsFloat +
        CabeceraSUBTOTAL_IVA10.AsFloat);
      CabeceraIVA5.AsFloat := round(CabeceraSUBTOTAL_IVA5.AsFloat / 23.0);
      CabeceraIVA10.AsFloat := round(CabeceraSUBTOTAL_IVA10.AsFloat / 11.0);
      CabeceraIVA_TOTAL.AsFloat :=
        round(CabeceraIVA5.AsFloat + CabeceraIVA10.AsFloat);
    end;
  end;
end;

procedure TFacturaController.NewInvoice(Sender: IView);
begin
    try

    //traemos el siguiente numero de factura disponible del talonario
    qryNumero.Params[0].AsInteger := pTalonarioID;
    qryNumero.Close;
    qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}

    //sacamos un nuevo id de factura
    pFacturaID := SGCDDataModule.SiguienteValor('seq_factura');
    DateEdit1.Clear;
    DateEdit2.Clear;
    AbrirCursor;
    tal.Refresh;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pFacturaID;
    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
    qryCabeceraCONTADO.AsInteger := 1;//por defecto contado
    DateEdit2.Enabled := False;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

end.
