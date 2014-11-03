unit sgcdTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  //CREDITO = '1';
  //DEBITO = '2';
  FACTURA = '1';
  RECIBO = '2';
  NOTA_CREDITO = '3';
  EFECTIVO = '1';
  CHEQUE = '2';
  TARJETA_DEBITO = '3';
  TARJETA_CREDITO = '4';

  //TipoMovimiento: array[Credito..Debito] of shortstring = (
  //  'Credito',
  //  'Debito');
  //TipoComprobante: array[Factura..NotaCredito] of shortstring = (
  //  'Factura',
  //  'Recibo',
  //  'NotaCredito');
  //TipoPago: array[Efectivo..TarjetaCredito] of shortstring = (
  //  'Efectivo',
  //  'Cheque',
  //  'TarjetaDebito',
  //  'TarjetaCredito');

  //mientras tanto pongo aca los codigos de los impuestos
  IVA10 = '3';
  IVA5 = '4';

type

  TTipoDocumento = (doFactura, doRecibo, doNotaCredito);

  TFormaPago = (paCheque, paEfectivo, paTarjetaDebito, paTarjetaCredito);

  // Para la ventana de documentos
  TDocViewerDocType = (dtFacturaNocobrada = 1, dtFacturaCobrada = 2, dtRecibo = 3);

implementation

end.
