unit frmbuscaralumnos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DBGrids, ExtCtrls, ButtonPanel, StdCtrls, frmMaestro, sqldb, DB,
  strutils, mensajes, mvc, buscaralctrl;

type

  { TPopupSeleccionAlumnos }

  TPopupSeleccionAlumnos = class(TMaestro)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FCustomController: TBuscarAlumnosController;
    procedure SetCustomController(AValue: TBuscarAlumnosController);
  public
    constructor Create(AOwner: IFormView; AController: TBuscarAlumnosController);
      overload;
  published
    ButtonCancel: TButton;
    ButtonOK: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    Personas: TRadioGroup;
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    property CustomController: TBuscarAlumnosController
      read FCustomController write SetCustomController;

  end;

var
  PopupSeleccionAlumnos: TPopupSeleccionAlumnos;

implementation

{$R *.lfm}

{ TPopupSeleccionAlumnos }

procedure TPopupSeleccionAlumnos.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  //if Trim(LabeledEdit1.Text) = '' then
  //begin
  //  case Personas.ItemIndex of
  //    0: Accept := True;
  //    1: Accept := (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
  //        (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
  //        (DataSet.FieldByName('ESVEEDOR').AsInteger = 1);
  //    2: Accept := DataSet.FieldByName('ESALUMNO').AsInteger = 1;
  //    3: Accept := DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1;
  //  end;
  //end
  //else
  //begin
  //  case Personas.ItemIndex of
  //    0: Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
  //        LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
  //        LabeledEdit1.Text);
  //    1: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
  //        LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
  //        LabeledEdit1.Text)) and ((DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
  //        (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
  //        (DataSet.FieldByName('ESVEEDOR').AsInteger = 1));
  //    2: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
  //        LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
  //        LabeledEdit1.Text)) and (DataSet.FieldByName('ESALUMNO').AsInteger = 1);
  //    3: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
  //        LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
  //        LabeledEdit1.Text)) and (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1);
  //  end;
  //end;
end;

constructor TPopupSeleccionAlumnos.Create(AOwner: IFormView;
  AController: TBuscarAlumnosController);
var
  Cont: IController;
begin
  { Aca se chequean el controlador y se asignan las propiedades
     correspondientes. Con queryinterface sacamos una referencia al objeto que
     implementa la interfaz. Hacemos asi por si acaso AController sea un objeto
     compuesto y que hayan subojetos que implementen las interfaces. Esto nos da
     mayor flexibilidad en la implementacion. }
  (AController as IInterface).QueryInterface(IController, Cont);
  if (Cont = nil) then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    CustomController := AController;
  end;
end;

procedure TPopupSeleccionAlumnos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  inherited;
end;

procedure TPopupSeleccionAlumnos.SetCustomController(AValue: TBuscarAlumnosController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

end.
