unit mensajes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, StdCtrls, Spin, EditBtn, DBCtrls;

resourcestring
  // Comprobante
  rsNoHayDeudas = 'No hay deudas para la persona seleccionada';
  rsNoSeEstaCreando = 'No se esta creando un comprobante';
  rsYaSeEstaCreando = 'Ya se esta creando un comprobante';
  rsPersonaNoEncontrada = 'Persona no encontrada';
  rsNoSeEncontroDoc = 'No se encontro el documento';
  rsNoSePuedeSetFac = 'No se puede completar la accion. Se esta editando un comprobante';
  rsTalonarioNoEncontrado = 'Talonario no encontrado';
  rsTalonarioNoSeleccionado =
    'No hay ningun talonario guardado en la configuracion. ' +
    'Seleccione uno en el menu Opciones';
  // Controller related
  rsExitQuestion = '¿Está seguro que desea salir?';
  rsExitText = 'Salir';
  rsProductCopyright = '© 2014 Rafael Aquino - Federico Pérez';
  rsProductInitials = 'SGCD';
  rsProductName = 'Sistema de Gestión de Cursos de Danza ';
  rsProductVersion = 'Versión 0.0.0.1';
  rsPendingChanges = 'Hay cambios sin guardar.';
  rsModelErr = 'El modelo no es del tipo apropiado';
  rsModelAsgnErr = 'No se asigno correctamente el modelo';
  rsCreateErrorInvalidCont =
    'Error al construir controlador. Controlador ' + 'invalido';
  // frmMaestro related
  rsError = 'Error';
  rsInformation = 'Informacion';
  rsWarning = 'Advertencia';
  rsConfirmation = 'Confimación';
  rsProvidedCont = 'Provided controller does not implements basic controller ' +
    'funcionality';
  rsDateNotAllow = 'Fecha no permitida';
  // GenerarDeuda
  rsPleaseSelFinanOpt = 'Por favor seleccione una opcion para fraccionamiento y ' +
    'vencimiento';
  rsInvalidValDate = 'Valor invalido para unidad de fecha';
  rsInvalidDateFormat = 'Formato de fecha invalido';
  // Asientos
  rsAccntInvalidSelec = 'Se ha seleccionado la misma cuenta para debe y haber';
  rsEntryNotFound = 'Asiento no encontrado';
  rsEntryRevertError = 'Error al reversar movimiento. Asiento invalido';
  rsNewEntryError = 'Creacion de asiento en proceso. Finalice el asiento ' +
    'e intente de nuevo.';
  rsNoEntryInProc = 'No hay nigun asiento en proceso.';
  rsDebCredAmountSumError =
    'Los montos debe y haber no coinciden. Por favor revise los' +
    ' datos e intente de nuevo';
  rsPaymntDiscrd = 'Se descarto el pago no guardado';
  rsPaymentRegistered = 'Pago registrado con exito';
  rsInvalidDate = 'Fecha invalida introducida';
  rsInvalidDateRange = 'El rango de fechas no es correcto';
  rsPleaseSelectAccount = 'Por favor seleccione una cuenta';
  rsGenNotDefined = 'No se definieron los generadores de cabecera o detalle';
  rsPrintReceiptConfirmation = 'Imprimir recibo';
  rsPrintReceiptQuestion = '¿Desea imprimir recibo?';
  rsRollbackPaymentEntryError =
    'Error al buscar asiento: el asiento no existe' + ' o existe una inconsisitencia';
  rsUnsupportedDocType = 'Tipo de documento no admitido';
  rsCreatingDoc = 'Comprobante en proceso de creacion, no se puede registrar ' +
    'movimiento';

type

  { TDeudaDetMsg }

  TDeudaDetMsg = record
    ArancelID: string;
    PersonaID: string;
    MatriculaID: string;
  end;

  { TDeudaMsg }

  TDeudaMsg = record
    Inserting: boolean;
    Updating: boolean;
    FraccionamientoPorDefecto: boolean;
    SinVencimiento: boolean;
    CantCuotas: integer;
    FechaVen: TDateTime;
    CantidadVen: integer;
    UnidadVen: integer;
  end;

  { TGenerarDeudaMsg }
  // en el form para generar deuda usamos este mensaje para que el controlador
  // chequee los datos, son todos referencias a los controles del form
  TGenerarDeudaMsg = record
    PanelDetail: TPanel;
    PanelList: TPanel;
    FraccionamientoPorDefecto: TCheckBox;
    SinVencimiento: TCheckBox;
    SpinEditCant: TSpinEdit;
    DateEditVen: TDateEdit;
    SpinEditVenCant: TSpinEdit;
    DBLookupComboBoxVenUnidad: TDBLookupComboBox;
  end;

  { TDBInfo }

  TDBInfo = record
    Connected: boolean;
    User: string;
    Host: string;
  end;

implementation

end.
