unit frmrecibodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmcomprobantedatamodule;

type
  TReciboDataModule = class(TComprobanteDataModule)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ReciboDataModule: TReciboDataModule;

implementation

{$R *.lfm}

end.

