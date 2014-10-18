unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmquerydatamodule;

type
  TNotaCreditoDataModule = class(TQueryDataModule)
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

