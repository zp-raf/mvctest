unit mensajes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, StdCtrls, Spin, EditBtn, DBCtrls;

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

  // Este es un tipo para informar el estado de conexion de la DB
  TDBInfo = record
    Connected: boolean;
    User: string;
    Host: string;
  end;

implementation

end.
