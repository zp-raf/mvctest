unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
    frmcomprobantedatamodule;

type
  TNotaCreditoDataModule = class(TComprobanteDataModule)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  NotaCreditoDataModule: TNotaCreditoDataModule;

implementation

{$R *.lfm}

end.

