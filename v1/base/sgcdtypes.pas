unit sgcdTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, contnrs;

const
  //CREDITO = 'C';
  //DEBITO = 'D';
  FACTURA = '1';
  RECIBO = '2';
  NOTA_CREDITO = '3';
  EFECTIVO = '1';
  CHEQUE = '2';
  TARJETA_DEBITO = '3';
  TARJETA_CREDITO = '4';

  {
   TipoMovimiento: array[Credito..Debito] of shortstring = (
     'Credito',
     'Debito');
   TipoComprobante: array[Factura..NotaCredito] of shortstring = (
     'Factura',
     'Recibo',
     'NotaCredito');
   TipoPago: array[Efectivo..TarjetaCredito] of shortstring = (
     'Efectivo',
     'Cheque',
     'TarjetaDebito',
     'TarjetaCredito');
  }

  //mientras tanto pongo aca los codigos de los impuestos
  IVA10 = '3';
  IVA5 = '4';

  //tipo boolean de base de datos
  DB_TRUE = '1';
  DB_FALSE = '0';

  EQUALITY_OPERATOR = '=';
  AND_OPERATOR = 'AND';
  OR_OPERATOR = 'OR';

type

  { TDatosCurso }

  TDatosCurso = record
    ruc: string;
    nombre: string;
    direccion: string;
    telefono: string;
  end;

  TCompraVenta = (cvCompra, cvVenta, cvCualquiera);

  // Tipos de talonarios
  TTipoTalonario = (taFactura = FACTURA, taRecibo = RECIBO, taNotaCredito =
    NOTA_CREDITO);

  // Los roles
  TRolPersona = (roCualquiera, roExterno, roVeedor, roInterventor, roEncargado,
    roProveedor, roAlumno, roEmpleado, roAdministrativo, roProfesor, roCoordinador);

  TRoles = array of TRolPersona;

  // para las ventanas que manejen un estado de edicion
  TEdicionEstado = (edInicial, edEditando, edGuardado);

  // Para la ventana de documentos
  TDocViewerDocType = (dtFacturaNocobrada = 1, dtFacturaCobrada = 2,
    dtRecibo = 3, dtNotaCredito = 4, dtFacturaCompra, dtReciboCompra, dtNotaCredCompra);

  // Para querydatamodule
  TErrorEvent = procedure(Sender: TObject; E: EDatabaseError) of object;

  TDataSetErrorHandler = procedure(ADataSet: TDataSet; E: Exception) of object;

  TEstadoComprobante = (csInicial, csEditando, csGuardado, csLeyendo);

  TFormaPago = (paCheque, paEfectivo, paTarjetaDebito, paTarjetaCredito);

  { TQryList }

  TQryList = class(TFPObjectList)
  end;

  { TSearchFieldList }

  TSearchFieldList = class(TStringList)
  end;

  TTipoDocumento = (doFactura, doRecibo, doNotaCredito);

var
  TipoDoc: set of TTipoDocumento;

implementation

end.
