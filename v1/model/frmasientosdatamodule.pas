unit frmasientosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmmovimientodatamodule;

type

  { TAsientosDataModule }

  TAsientosDataModule = class(TMovimientoDataModule)
    procedure DataModuleCreate(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AsientosDataModule: TAsientosDataModule;

implementation

{$R *.lfm}

{ TAsientosDataModule }

procedure TAsientosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Movimiento));
  QryList.Add(TObject(MovimientoDet));
end;

end.

