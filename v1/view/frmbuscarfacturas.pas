unit frmbuscarfacturas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ExtCtrls, db;

type

  { TPopupSeleccionarFactura }

  TPopupSeleccionarFactura = class(TForm)
    ButtonAceptar: TButton;
    ButtonCancelar: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    procedure SetFacturaDataSource(ADataSource: TDataSource);
  end;

var
  PopupSeleccionarFactura: TPopupSeleccionarFactura;

implementation

{$R *.lfm}

{ TPopupSeleccionarFactura }

procedure TPopupSeleccionarFactura.SetFacturaDataSource(ADataSource: TDataSource
  );
begin
  DBGrid1.DataSource := ADataSource;
end;

end.

