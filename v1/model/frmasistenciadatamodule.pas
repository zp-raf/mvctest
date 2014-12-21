unit frmasistenciadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmquerydatamodule;

type
  TAsistenciaDataModule = class(TQueryDataModule)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AsistenciaDataModule: TAsistenciaDataModule;

implementation

{$R *.lfm}

end.

