unit UAlterCod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, ExtCtrls, Buttons, DB;

type
  TFrmAlterCodigo = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    EdtCodigo: TMaskEdit;
    RBBackup: TRadioButton;
    RBConsumo: TRadioButton;
    EdtNome: TEdit;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    CBxChave: TComboBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    EdtReferencia: TEdit;
    Label5: TLabel;
    procedure PreparaForm(Sender: TObject);
    procedure Cancelar (Sender: TObject);
    procedure RBBackupClick(Sender: TObject);
    procedure RBConsumoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure CBxChaveDropDown(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TabSegundaria;
  end;

var
  FrmAlterCodigo: TFrmAlterCodigo;
  uso : string;
implementation

uses UDM;

{$R *.dfm}

procedure TFrmAlterCodigo.PreparaForm(Sender: TObject);
begin
  try
   StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
   EdtCodigo.Clear;
   CBxChave.Clear;
   RBBackup.Checked := false;
   RBConsumo.Checked := False;
   uso := '';
   EdtNome.Clear;
   EdtNome.ReadOnly := false;
   EdtCodigo.ReadOnly := false;
   DMCadKit.TabChave.Open;
   DMCadKit.TabAllcode.Open;
   DMCadKit.Tab_AlterCod.Open;
   EdtReferencia.Clear;
  except
    MessageDlg('Erro ao preparar Tela!',mtError,[mbok],0);
    close
  end;
end;

procedure TFrmAlterCodigo.Cancelar (Sender: TObject);
begin
   DMCadKit.TabAllcode.Cancel;
   DMCadKit.Tab_AlterCod.Cancel;
   DMCadKit.TabAllcode1.Cancel;
   DMCadKit.Tab_AlterCod1.Cancel;
   PreparaForm(self);
end;

procedure TFrmAlterCodigo.RBBackupClick(Sender: TObject);
begin
    StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
    uso := '';
    EdtCodigo.Clear;
    EdtCodigo.EditMask:= '!99.999.99999->9B;1;_';
    EdtCodigo.Refresh;
    EdtCodigo.Enabled:= True;
    uso := 'BACKUP';
    EdtCodigo.SetFocus;
    EdtCodigo.ReadOnly := False;
end;

procedure TFrmAlterCodigo.RBConsumoClick(Sender: TObject);
begin
    StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
    uso := '';
    EdtCodigo.Clear;
    EdtCodigo.EditMask:= '!99.999.99999->9;1;_';
    EdtCodigo.Refresh;
    EdtCodigo.Enabled:= True;
    uso := 'CONSUMO';
    EdtCodigo.SetFocus;
    EdtCodigo.ReadOnly := False;
end;

procedure TFrmAlterCodigo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_ESCAPE then
    begin
      close;
    end;
end;

procedure TFrmAlterCodigo.FormShow(Sender: TObject);
begin
    PreparaForm(Self);
end;

procedure TFrmAlterCodigo.SpeedButton1Click(Sender: TObject);
begin
    StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
    if DMCadKit.TabAllcode.Locate('coditem',EdtCodigo.Text,[loCaseInsensitive]) then
    begin
       EdtNome.Text := DMCadKit.TabAllcodeDescrissaoItem.AsString;
       CBxChave.Text := DMCadKit.TabAllcodePalavrachave.AsString;
       if (EdtCodigo.Text <>'') and (EdtNome.Text <> '') then
       begin
         EdtCodigo.ReadOnly := true;
       end
       else
       begin
           EdtCodigo.ReadOnly := false;
       end;
    end
    else
    begin
        MessageDlg('Código inexistente!',mtInformation,[mbOK],0);
    end;
end;

procedure TFrmAlterCodigo.SpeedButton5Click(Sender: TObject);
begin
Cancelar(self);
close;
end;

procedure TFrmAlterCodigo.TabSegundaria;
begin
    StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
      if (EdtCodigo.Text <>'') and (EdtNome.Text <> '') then
      begin
        DMCadKit.Tab_AlterCod1.Open;
        DMCadKit.TabAllcode1.Open;
        if DMCadKit.TabAllcode1.Locate('codigo',EdtCodigo.Text,[loCaseInsensitive]) then
        begin
           StatusBar1.Panels[2].Text := 'Inserindo dados na tabela, Segundária.';
           //editando tabela de todos os códigos
           DMCadKit.TabAllcode1.Edit;
           DMCadKit.TabAllcode1descricao.AsString := EdtNome.Text;
           DMCadKit.TabAllcode1Uso.AsString := uso;
           DMCadKit.TabAllcode1Palavra_chave.AsString := CBxChave.Text;
           DMCadKit.TabAllcode1.Post;
           ShowMessage('Dados, Segundários, Salvos!');
           PreparaForm(self);
        end else
        begin
         MessageDlg('Código inexistente!',mtInformation,[mbOK],0);
        end;
      end;
end;

procedure TFrmAlterCodigo.CBxChaveDropDown(Sender: TObject);
begin
  CBxChave.Clear;
  with DMCadKit.Tabchave do
  begin
   open;
   First;
   while not DMCadKit.Tabchave.EOF do
   begin
      CBxChave.Items.Add(FieldByName('descrissao').AsString);
      Next;
   end;
  end;
end;

procedure TFrmAlterCodigo.SpeedButton2Click(Sender: TObject);
begin
    PreparaForm(self);
end;

procedure TFrmAlterCodigo.SpeedButton3Click(Sender: TObject);
begin
   StatusBar1.Panels[0].Text := FormatDateTime('HH:MM:SS',now);
   if (EdtCodigo.Text <> '') then
   begin
       if (EdtNome.Text <> '') then
       begin
           if (CBxChave.Text <> '') then
           begin
             try
               DMCadKit.Tab_AlterCod.Open;
               DMCadKit.TabAllcode.Open;
               if DMCadKit.TabAllcode.Locate('coditem',EdtCodigo.Text,[loCaseInsensitive]) then
                begin
                    StatusBar1.Panels[1].Text := 'Inserindo dados na tabela.';
                    //editando tabela de todos os códigos
                    DMCadKit.TabAllcode.Edit;
                    DMCadKit.TabAllcodeDescrissaoItem.AsString := EdtNome.Text;
                    DMCadKit.TabAllcodeUso.AsString := uso;
                    DMCadKit.TabAllcodePalavrachave.AsString := CBxChave.Text;
                    DMCadKit.TabAllcodeVlrUn.AsFloat := StrToFloat(EdtReferencia.Text);
                    DMCadKit.TabAllcode.Post;
                    TabSegundaria;
                    ShowMessage('Dados Salvos, Primária!');
                    PreparaForm(self);
                end
                else
                begin
                    MessageDlg('Não há código, Primário, cadastrado!',mtWarning,[mbok],0);
                    TabSegundaria;
                end;
              except
                  MessageDlg('Erro Ao Editar',mtError,[mbOK],0);
                  StatusBar1.Panels[1].Text := 'Erro!!!!';
                  StatusBar1.Panels[2].Text := 'Erro!!!!';
                  Cancelar(self);
              end;
            end
            else
            begin
                MessageDlg('Selecione a palavra chave',mtInformation,[mbOK],0);
                CBxChave.SetFocus;
            end;
        end
        else
        begin
            MessageDlg('Edite a Descrisão',mtInformation,[mbOK],0);
            EdtNome.SetFocus;
        end;
    end
    else
    begin
        MessageDlg('Edite o Código',mtInformation,[mbOK],0);
        EdtCodigo.SetFocus;
    end;
  end;

procedure TFrmAlterCodigo.SpeedButton4Click(Sender: TObject);
begin
    Cancelar(SELF);
end;

end.
