unit frmtalonariodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB;

type

  { TTalonarioDataModule }

  TTalonarioDataModule = class(TQueryDataModule)
    dsTalonarioView: TDataSource;
    dsTalonario: TDataSource;
    TalonarioView: TSQLQuery;
    Talonario: TSQLQuery;
    TalonarioACTIVO: TSmallintField;
    TalonarioCAJA: TStringField;
    TalonarioCOPIAS: TLongintField;
    TalonarioDIRECCION: TStringField;
    TalonarioID: TLongintField;
    TalonarioNOMBRE: TStringField;
    TalonarioNUMERO_FIN: TLongintField;
    TalonarioNUMERO_INI: TLongintField;
    TalonarioRUBRO: TStringField;
    TalonarioRUC: TStringField;
    TalonarioSUCURSAL: TStringField;
    TalonarioTELEFONO: TStringField;
    TalonarioTIMBRADO: TStringField;
    TalonarioTIPO: TLongintField;
    TalonarioVALIDO_DESDE: TDateField;
    TalonarioVALIDO_HASTA: TDateField;
    TalonarioViewCAJA: TStringField;
    TalonarioViewCOPIAS: TLongintField;
    TalonarioViewDIRECCION: TStringField;
    TalonarioViewID: TLongintField;
    TalonarioViewNOMBRE: TStringField;
    TalonarioViewNOMBRE_TIPO: TStringField;
    TalonarioViewNUMERO_FIN: TLongintField;
    TalonarioViewNUMERO_INI: TLongintField;
    TalonarioViewRUBRO: TStringField;
    TalonarioViewRUC: TStringField;
    TalonarioViewSUCURSAL: TStringField;
    TalonarioViewTELEFONO: TStringField;
    TalonarioViewTIMBRADO: TStringField;
    TalonarioViewTIPO: TLongintField;
    TalonarioViewVALIDO_DESDE: TDateField;
    TalonarioViewVALIDO_HASTA: TDateField;
    procedure DataModuleCreate(Sender: TObject); override;
  end;

var
  TalonarioDataModule: TTalonarioDataModule;

implementation

{$R *.lfm}

{ TTalonarioDataModule }

procedure TTalonarioDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Talonario));
  AuxQryList.Add(TObject(TalonarioView));
end;

end.

