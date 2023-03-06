unit upinst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    file1: TMenuItem;
    settings1: TMenuItem;
    info1: TMenuItem;
    openMGEmap1: TMenuItem;
    saveMGEmap1: TMenuItem;
    close1: TMenuItem;
    teme1: TMenuItem;
    properties1: TMenuItem;
    about1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



end.
