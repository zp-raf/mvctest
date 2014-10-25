unit frmprocesorecibo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmprocesocomprobante;

type
  TProcesoRecibo = class(TProcesoComprobante)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoRecibo: TProcesoRecibo;

implementation

{$R *.lfm}

end.

