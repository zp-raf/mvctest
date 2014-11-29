unit frmbuscarpersonas;

{$mode objfpc}{$H+}

interface

uses
  Forms, frmMaestro, personactrl, DBGrids, ExtCtrls, StdCtrls, Classes, DB,
  sgcdTypes;

const
  TODOS = 0;
  EXTERNOS = 1;
  ALUMNOS = 2;
  PROVEEDORES = 3;

type

  { TPopupSeleccionPersonas }

  TPopupSeleccionPersonas = class(TMaestro)
    procedure FormCreate(Sender: TObject);

  protected
    function GetCustomContoller: TBuscarPersonaController;
  public
    destructor Destroy; override;
  published
    ButtonCancel: TButton;
    ButtonOK: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    Personas: TRadioGroup;
    procedure FilterData(AText: string; AGroupBoxIndex: integer);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure PersonasClick(Sender: TObject);
    procedure SetDataSource(ADataSource: TDataSource);
  end;

var
  PopupSeleccionPersonas: TPopupSeleccionPersonas;

implementation

{$R *.lfm}

{ TPopupSeleccionPersonas }

//procedure TPopupSeleccionPersonas.SQLQuery1FilterRecord(DataSet: TDataSet;
//  var Accept: boolean);
//begin
//  if Trim(LabeledEdit1.Text) = '' then
//  begin
//    case Personas.ItemIndex of
//      0: Accept := True;
//      1: Accept := (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1);
//      2: Accept := DataSet.FieldByName('ESALUMNO').AsInteger = 1;
//      3: Accept := DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1;
//    end;
//  end
//  else
//  begin
//    case Personas.ItemIndex of
//      0: Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text);
//      1: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and ((DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1));
//      2: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and (DataSet.FieldByName('ESALUMNO').AsInteger = 1);
//      3: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1);
//    end;
//  end;
//end;

procedure TPopupSeleccionPersonas.LabeledEdit1Change(Sender: TObject);
begin
  FilterData(LabeledEdit1.Text, Personas.ItemIndex);
end;

procedure TPopupSeleccionPersonas.PersonasClick(Sender: TObject);
begin
  FilterData(LabeledEdit1.Text, Personas.ItemIndex);
end;

procedure TPopupSeleccionPersonas.SetDataSource(ADataSource: TDataSource);
begin
  DBGrid1.DataSource := ADataSource;
end;

procedure TPopupSeleccionPersonas.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

function TPopupSeleccionPersonas.GetCustomContoller: TBuscarPersonaController;
begin
  Result := GetController as TBuscarPersonaController;
end;

destructor TPopupSeleccionPersonas.Destroy;
begin
  ClearControllerPtr;
  inherited Destroy;
end;

procedure TPopupSeleccionPersonas.FilterData(AText: string; AGroupBoxIndex: integer);
begin
  case AGroupBoxIndex of
    TODOS:
    begin
      GetCustomContoller.FilterData(AText, roCualquiera, Self);
    end;
    EXTERNOS:
    begin
      GetCustomContoller.FilterData(AText, roExterno, Self);
    end;
    ALUMNOS:
    begin
      GetCustomContoller.FilterData(AText, roAlumno, Self);
    end;
    PROVEEDORES:
    begin
      GetCustomContoller.FilterData(AText, roProveedor, Self);
    end;
  end;
end;

end.
