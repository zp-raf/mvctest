unit frmbuscarfacturas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ExtCtrls;

type

  { TPopupSeleccionarFactura }

  TPopupSeleccionarFactura = class(TForm)
    ButtonAceptar: TButton;
    ButtonCancelar: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarFactura: TPopupSeleccionarFactura;

implementation

{$R *.lfm}

end.

