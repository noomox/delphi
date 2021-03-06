unit UBarsa;
            
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, DBCtrls, ComCtrls, Gauges, DBGrids,
  Mask, FileCtrl, Math, SHELLAPI, VARIANTS, DbiTypes, IniFiles, typinfo,
  ComObj, ToolWin, Printers, ActnMan, Winsock, DBXPress, SqlExpr, DB, dbWeb,
  XMLDoc, XMLIntf,RXDBCtrl,rxToolEdit,DBClient, rxCurrEdit;

Const
  RepHead =0;
  RepTrail=1;
  RepBoth =2;
  RepEvery=3;
  ReplaceLeft = 0;
  ReplaceRight = 1;
  ReplaceBoth = 2;
  ReplaceAll = 3;

  mdAscend = 0;
  mdDescend = 1;

  EspacoBranco = #32;
  EspacoNulo = #0;
  Condensa = #27+'x0'+#15;
  Descondensa =#18;
  ANeg=#27+'G';
  DNeg=#27+'H';
  Enfat=#27+'E';
  Denfat=#27+'F';
  ASub=#27+'-1';
  DSub=#27+'-0';
  Expande=#14;
  DExpande=#20;
  Eject=#12;

  NumArray: PChar = '0123456789';

//**********FUN��ES DA IMPRESSORA BEMATECH N�O FISCAL MP-4000 TH**************//
{function ConfiguraTaxaSerial( Taxa: integer ): integer; stdcall; far; external 'MP2032.DLL';
function IniciaPorta( Porta: string ): integer; stdcall; far; external 'MP2032.DLL';
function FechaPorta: integer; stdcall; far; external 'MP2032.DLL';
function BematechTX( BufTrans: string ): integer; stdcall; far; external 'MP2032.DLL';
function ComandoTX( BufTrans: string; TamBufTrans: integer ): integer; stdcall; far; external 'MP2032.DLL';
function CaracterGrafico( BufTrans: string; TamBufTrans: integer ): integer; stdcall; far; external 'MP2032.DLL';
function DocumentInserted: integer; stdcall; far; external 'MP2032.DLL';
function Le_Status: integer; stdcall; far; external 'MP2032.DLL';
function AutenticaDoc( texto: string; tempo: integer ): integer; stdcall; far; external 'MP2032.DLL';
function Le_Status_Gaveta: integer; stdcall; far; external 'MP2032.DLL';
function ConfiguraTamanhoExtrato( NumeroLinhas: Integer ): integer; stdcall; far; external 'MP2032.DLL';
function HabilitaExtratoLongo( Flag: Integer ): integer; stdcall; far; external 'MP2032.DLL';
function HabilitaEsperaImpressao( Flag: Integer ): integer; stdcall; far; external 'MP2032.DLL';
function EsperaImpressao: integer; stdcall; far; external 'MP2032.DLL';
function ConfiguraModeloImpressora( ModeloImpressora: integer ): integer; stdcall; far; external 'MP2032.DLL';
function AcionaGuilhotina( Modo: integer ): integer; stdcall; far; external 'MP2032.DLL';
function FormataTX (BufTras: string; TpoLtra: integer; Italic: integer; Sublin: integer; expand: integer; enfat: integer ): integer; stdcall; far; external 'MP2032.DLL';
function HabilitaPresenterRetratil( iFlag: integer ): integer; stdcall; far; external 'MP2032.DLL';
function ProgramaPresenterRetratil( iTempo: integer ): integer; stdcall; far; external 'MP2032.DLL';
function VerificaPapelPresenter: integer; stdcall; far; external 'MP2032.DLL';} 
//##############################################################################

Procedure TabEnter(XForm : TForm; key : char); // Muda o enter com tab
Function  Estado(XUF : string):Boolean;
Procedure Progresso(Contador : TGauge);
Procedure AC;
Procedure DC;
Procedure AC1;
Procedure ExecuteProgram(Nome,Parametros:String);
Function VerificaCPF(var xcpf:string):Boolean;
Function VerificaCGC(num: string): boolean;
Function Informa(mensagem:string):word;
Function Avisa(mensagem:string):word;
Function Avisando(mensagem:string):word;
Function Confirma(mensagem:string):word;
Function InformaError(mensagem:string):word;
Function Extenso(Valor : Extended): String;
Function Decimal(var Tecla : char):char;
Function Eleva(X : Real; N : Integer): Real;
Function CalculaJuros(XValor:Real; XParcela:Integer; XJuros : Real; TemEntrada : Boolean):Real;
Function ExisteArq(FileName: string): Boolean;
Function Espaco(Palavra : String; Tamanho:Integer): String;
Function SoNumeros(Valor:String): String;
Function ValorPrestacao(pN:Integer;pPV,pI:Extended;pTipo:Integer):Extended;
Function ProximaData(pData:TDateTime;pN:Integer):TDatetime;
Function VirgulaPonto(pValor:Real): String;
function Dia(data:Tdate):word;
function Mes(data:Tdate):word;
function Ano(data:Tdate):word;
function RetornaMes( data:TDate):string;
function ProximoMes( xData : TDate ):TDate;
function DiskInDrive(const Drive: char): Boolean;
Procedure AtivaBt( Form :tform; Botoes:array of TComponent; Flag:boolean);
Function Copies (Ch : Char; N : Byte) : ShortString;
Function PadLeft (S :ShortString; N : Byte; P : Char) : ShortString;
Function PadRight (S :ShortString; N : Byte; P : Char) : ShortString;
Function Middle (S : ShortString; N : SmallInt; P : Char) : ShortString;
Function ReplaceChar (SourceStr : ShortString; FromChar, ToChar : Char;
Mode : Byte) : ShortString;
Function ReplaceStr (Source, FromStr, ToStr : ShortString; Mode : Byte) : ShortString;
Function StripChar (SourceStr : ShortString; CharToStrip : Char; Mode : Byte) : ShortString;
Function StripRepeat (S, T : ShortString) : ShortString;
Function ReverseStr (S : ShortString) : ShortString;
Function CopyFrom (S, T : ShortString) : ShortString;
Function CopyUntil (S, T : ShortString) : ShortString;
Function LastPos (T, S : ShortString) : Byte;
Function NoPos (T, S : ShortString) : Byte;
Function Occurs(T, S : ShortString) : Byte;
Function OccurPos (T, S : ShortString; N : Byte) : Byte;
Function RTrim (StrX : string) : string;
Function LTrim (StrX : string) : string;
Function AllTrim (StrX : string) : string;
Function Replicate (StrX : string; IntX : Integer) : string;
Function Space (const IntX : ShortInt) : string;
Function Center (StrX : string; IntX : Integer) : string;
Function LeftStr (StrX : string; const IntX : ShortInt) : string;
Function RightStr (StrX : string; const IntX : ShortInt) : string;
Function IsDigit (c : char) : Boolean;
Function IsNumber( s : string ) : Boolean;
Function IsPar (xNumero : LongInt) : boolean;
Function StrZero( numero,numzero:integer):string;
Function Zeros(Valor:String; Tamanho : Integer): String;
Function PrinterOnLine : Boolean;
Function DiaExtenso (dData : TDateTime) : string;
Function GetFileDate(Arquivo: String): String;
procedure TextoDiagonal(NomeFonte:TFontName;TamanhoFonte,CorFonte,Linha,Coluna:integer;Texto:string; Form:TForm);
function AlinhaValor(xValor:real;Tamanho:integer):string;
function AlinhaQtde(xValor:real;Tamanho:integer):string;
function CasaDecimal(xValor:real;Tamanho:integer):string;
procedure LimpaEdit(xForm:TForm);
procedure LimpaMaxEdit(xForm:TForm);
procedure SaltaLinha( NumLinha:integer; vSaida:string);
function Cry( xPalavra:string; opc:boolean):string;
Function FormataCEP(const CEP: string): string;
Function DataValida(StrD: string): Boolean;
procedure Say(Nlin,Ncol: Integer;Var LinhaAtual: Integer; Var Arquivo: Text;Texto: Variant);
Function TotalDias(DataFim:TDateTime; DataAtual:TDateTime):String;
Function TotalMeses(DataFim:TDateTime; DataAtual:TDateTime):String;
Function TotalAnos(DataFim:TDateTime; DataAtual:TDateTime):String;
procedure GravaIniCrypt(Diretorio, Colchete, Parametro, Texto, Arquivo: String);
Function Codifica(const Str1: String): String;
Function LeIniCrypt(Diretorio, Colchete, Parametro : String; Var Texto, Arquivo: String): String;
Function DataExtenso(Data:TDateTime): String;
procedure CentralizaForm( xForm:TForm );
Function ImpresConect(Porta:Word):Boolean;//Verifica se a impressora esta conectada
function AbreviaNome(Nome: String): String;
procedure ResolucaoDoVideo( xForm:TForm );
Function VlPrestacao(C : Real; J : Real; N : Real) : Real;
Function ValidCartao(const s:string): Boolean;
procedure LimpaChecked(xForm:TForm);
procedure MarcaChecked(xForm:TForm);
Function AlinharValor(xValor:real;Tamanho:integer):string;
procedure EntraFocu(Sender: TObject);
procedure FechaFocu(Sender: TObject);
Function UF:String;
procedure ValidaData(Campo : String);
function Arredonda(Valor :Double; Casas: Byte) :Double;
procedure ChamaCalculadora;
Function Crypt(Action, Src: String): String;
function PasswordInputBox(const ACaption, APrompt:string): string;
Function GetIP : String;
Function StrToBoolean(s: string): boolean;
Function Arredondar(Valor: Double; Dec: Integer): Double;
Function AjustaQtde(xValor:real;Tamanho:integer):string;
Function SysComputerName: string;//Retorna o Nome do Computador
function PrimeiroNome (Nome : String) : String;
Function RemoveAcento(Str:String): String;
Procedure ExecutaApp(Nome,State,NomeExec,Path:Pchar;Estado:Integer);
function NewGen(GenName: String; aConexao: TSQLConnection): integer;
Function GetVersaoArq: string;
procedure ExpHTML(DataSet: TDataSet; Arq: string);
procedure ExpTXT(DataSet: TDataSet; Arq: string);
procedure ExpXLS(DataSet: TDataSet; Arq: string);
procedure ExpDOC(DataSet: TDataSet; Arq: string);
procedure ExpXML(DataSet: TDataSet; Arq: string);
Function RemoveChar(Const Texto:String):String;
Procedure CopyDir(const cFrom, cTo : string);
function Exec_File(File_Path: string): integer;
Function SerialNum(FDrive:String):String;
function ValidaEAN(CodBar: string): Boolean;
function CalculaDigEAN13(Cod:String):String;
function Repete(Caractere: char; nCaracteres: integer): string;
procedure Enabled_False_DBEdit(xForm:TForm);
procedure Enabled_True_DBEdit(xForm:TForm);
function RemoveCaractesresEspeciais(valor:string):String;
function RetiraCaracteresEspeciais(valor:string):String;
function RetiraArgumento(Retirar,Argumento:string):string;
Function RemoveInvalid(NotToRemoveStr: String; FromStr: String): ShortString;
Function NumStuff(Str: ShortString; Tamanho: Byte): ShortString;
Procedure FormatoNum(var Str: ShortString; Tamanho: Byte);
procedure ForceForegroundWindow(hwnd: THandle);
Procedure CopiaRegistroTabela(TabelaOrigem, TabelaDestino: TClientDataSet; xCod_Reducao_PDV : Integer);
function RetornaDataString(Data:string):string;
function AjustaInteiro(inteiro:String;tam:integer) : String;
function AjustaNumerico(VlrMoeda: Currency; tam: Integer) : String;
Procedure Apaga_todos_arquivos_diretorio(vMasc:String);
function GeraSenha (aQuant: integer): string ;
Function ContaLetras(Texto:String):Integer;
function AjustaStr(str: String; tam: Integer): String;
function IsImPar(TestaInteiro : Integer) : boolean;

implementation

uses UEstado, Calculad;

Procedure ExecutaApp(Nome,State,NomeExec,Path:Pchar;Estado:Integer);
// Valores para Estdo: SW_SHOWNORMAL Janela em modo normal
// SW_MAXIMIZE Janela maximizada
// SW_MINIMIZE Janela minimizada
// SW_HIDE Janela Escondida
// Exemplo:
// ExecutaApp('CALCULADORA','OPEN','CALC.EXE','C:WINDOWS',8);
// Onde 'CALCULADORA' � o nome da janela do aplicativo
var
TheWindows: HWND;
begin
theWindows := FindWindow(NIL,Nome);
if TheWindows <> 0 then
begin
SetForegroundWindow(TheWindows)
end
else
begin
if (Estado > 3) or (Estado < 1) then
begin
Estado := 1;
end;
ShellExecute(Application.Handle,State,NomeExec,NIL,Path,Estado);
end;
end;

Function RemoveAcento(Str:String): String;
Const
ComAcento = '����������������������������';
SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
Var
x : Integer;
Begin
For x := 1 to Length(Str) do
if Pos(Str[x],ComAcento)<>0 Then
Str[x] := SemAcento[Pos(Str[x],ComAcento)];
Result := Str;
end;

Function SysComputerName: string;//Retorna o Nome do Computador
var
  I: DWord;
begin
  I := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, I);
  Windows.GetComputerName(PChar(Result), I);
  Result := string(PChar(Result));
end;

Function Arredondar(Valor: Double; Dec: Integer): Double;
var
  Valor1,
  Numero1,
  Numero2,
  Numero3: Double;
begin
  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);
  Numero3:=Round(Numero2);
  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

//TRANSFORMA O ENTER EM TAB
procedure TabEnter(XForm : TForm; key : char);
begin
     if key = #13
     then XForm.Perform(WM_NextDlgCtl,0,0);
end;

procedure ValidaData(Campo : String);
begin
     Try
       StrToDate(Campo);
     except
       on EConvertError
       do Informa ('Data Inv�lida!');
       end;  
end;

Function DataValida(StrD: string): Boolean;
var
  D, Data : TDateTime;
  Dia, Mes, Ano : Word;
begin
     Result := True;
     try
       StrToDate(StrD);
       Result:=True;
       except
         on EConvertError
         do Result:=False;
         end;
if Result=True
then begin
     Data:=StrToDate(StrD);
     DecodeDate(Data,Ano,Dia,Mes);
     end;
if (Ano<1900) or (Ano>5000)
then Result:=False;
end;

Function FormataCEP(const CEP: string): string;
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(CEP) do
  if CEP[I] in ['0'..'9'] then
  Result := Result + CEP[I];
  if Length(Result) <> 8 then
  raise Exception.Create('CEP inv�lido.')
  else
  Result :=
  Copy(Result, 1, 2) + '.' +
  Copy(Result, 3, 3) + '-' +
  Copy(Result, 6, 3);
end;

// VERIFICA O CPF
Function VerificaCPF(var xcpf:string):Boolean;
var
   CPF1,CPF2,Controle : String;
   Soma, Digito,i,j,ContIni,ContFim : integer;
begin
     CPF1 := copy(xcpf,1,9);
     CPF2 := copy(xcpf,10,2);
     Controle := '';
     ContIni := 2;
     ContFim := 10;
     Digito := 0;
     for j := 1 to 2
     do begin
        Soma := 0;
        for i := ContIni to ContFim
        do Soma := Soma + (StrToInt(copy(cpf1,i-j,1)) * (ContFim+1+j-i));

        if j = 2
        then Soma := Soma + (2*Digito);

        digito := (Soma * 10) mod 11;
        if digito = 10
        then digito := 0;

        Controle := Controle + inttoStr(digito);
        ContIni := 3;
        ContFim := 11
        end;

      if controle <> CPF2
      then result := false
      else result := true;
end;

//
Function Informa(mensagem:string):word;
begin
     result := MessageDlg(mensagem,MtInformation,[mbOk],0);
end;

Function Avisa(mensagem:string):word;
begin
     result := MessageDlg(mensagem,MtWarning,[mbYes,mbNo,mbCancel],0);
end;

Function Avisando(mensagem:string):word;
begin
     result := MessageDlg(mensagem,MtWarning,[mbOk],0);
end;

Function Confirma(mensagem:string):word;
begin
     result := MessageDlg(mensagem,MtConfirmation,[mbYes,mbNo],0);
end;

Function InformaError(mensagem:string):word;
begin
     result := MessageDlg(mensagem,MtError,[mbOk],0);
end;

//####################### RETORNA O EXTENSO DE UM VALOR
function Extenso(Valor : Extended): String;
var
Centavos, Centena, Milhar, Milhao, Bilhao, Texto : string;
const
Unidades: array [1..9] of string = ('um', 'dois', 'tres', 'quatro',
'cinco','seis', 'sete', 'oito','nove');
Dez : array [1..9] of string = ('onze', 'doze', 'treze',
'quatorze', 'quinze','dezesseis', 'dezessete','dezoito', 'dezenove');
Dezenas: array [1..9] of string = ('dez', 'vinte', 'trinta',
'quarenta', 'cinquenta','sessenta', 'setenta','oitenta', 'noventa');
Centenas: array [1..9] of string = ('cento', 'duzentos',
'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos','setecentos',
'oitocentos', 'novecentos');

Function ifs( Expressao: Boolean; CasoVerdadeiro, CasoFalso:
String): String;
begin
if Expressao then Result := CasoVerdadeiro else Result := CasoFalso;
end;

function MiniExtenso( Valor: ShortString ): string;
var Unidade, Dezena, Centena: String;
begin
if (Valor[2] = '1') and (Valor[3] <> '0') then begin
Unidade := Dez[StrToInt(Valor[3])];
Dezena := '';
end else begin
if Valor[2] <> '0' then Dezena :=
Dezenas[StrToInt(Valor[2])];
if Valor[3] <> '0' then unidade :=
Unidades[StrToInt(Valor[3])];
end;
if (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
Centena := 'cem'
else
if Valor[1] <> '0' then Centena := Centenas[StrToInt(Valor[1])]
else Centena := '';
Result := Centena + ifs( (Centena <> '') and ((Dezena <> '') or (Unidade <> '')),' e ', '') + Dezena +
ifs( (Dezena <> '') and (Unidade <> ''), ' e ', '')+ Unidade;
end;

begin
if Valor = 0 then begin
Result := '';
Exit;
end;
Texto := FormatFloat( '000000000000.00', Valor );
Centavos := MiniExtenso( '0' + Copy( Texto, 14, 2 ) );
Centena := MiniExtenso( Copy( Texto, 10, 3 ) );
Milhar := MiniExtenso( Copy( Texto, 7, 3 ) );
if Milhar <> '' then
Milhar := Milhar + ' mil';
Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
if Milhao <> '' then
Milhao := Milhao + ifs( Copy( Texto, 4, 3 ) = '001', ' milh�o',
' milh�es');
Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
if Bilhao <> '' then
Bilhao := Bilhao + ifs( Copy( Texto, 1, 3 ) = '001', ' bilh�o',
' bilh�es');

if (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
Result := Bilhao + ' de reais'
else if (Milhao <> '') and (Milhar + Centena = '') then
Result := Milhao + ' de reais'
else
Result := Bilhao +
ifs( (Bilhao <> '') and (Milhao + Milhar + Centena <>
''),
ifs((Pos(' e ', Bilhao) > 0) or
(Pos( ' e ', Milhao + Milhar + Centena ) > 0
), ', ', ' e '), '')
+
Milhao +
ifs( (Milhao <> '') and (Milhar + Centena <> ''),
ifs((Pos(' e ', Milhao) > 0) or
(Pos( ' e ', Milhar + Centena ) > 0 ), ', ',
' e '), '') +
Milhar +
ifs( (Milhar <> '') and (Centena <> ''),
ifs(Pos( ' e ', Centena ) > 0, ', ', ' e '), '')
+
Centena + ifs( Int(Valor) = 1, ' real', ' reais' );
if Centavos <> '' then
Result := Result + ' e ' + Centavos + ifs( Copy( Texto, 14, 2 )= '01', ' centavo', ' centavos' );
end;

Function Estado(XUF : string):Boolean;
const
    Estados: array[1..27]of String = ('PR','SP','SC','RJ','RS','MS','AM','MG','GO','AP','PE','MA','AC','TO','BA','ES','RR','CE','PA','PB','RO','RN','MT','SE','AL','PI','DF');
var
   I : Integer;
   achou : Boolean;
begin
     Achou := False;
     for I := 1 to 27
     do if Xuf = Estados[I]
        then achou := true;

     if achou
     then Result := true
     else Result := false;
end;

Function UF:String;
var
   xUF : String;
begin
     With FEstado
     do begin
        if RGUF.ItemIndex=0
        then xUF:='MS';
        if RGUF.ItemIndex=1
        then xUF:='AC';
        if RGUF.ItemIndex=2
        then xUF:='AL';
        if RGUF.ItemIndex=3
        then xUF:='AP';
        if RGUF.ItemIndex=4
        then xUF:='AM';
        if RGUF.ItemIndex=5
        then xUF:='BA';
        if RGUF.ItemIndex=6
        then xUF:='CE';
        if RGUF.ItemIndex=7
        then xUF:='DF';
        if RGUF.ItemIndex=8
        then xUF:='ES';
        if RGUF.ItemIndex=9
        then xUF:='GO';
        if RGUF.ItemIndex=10
        then xUF:='MT';
        if RGUF.ItemIndex=11
        then xUF:='MG';
        if RGUF.ItemIndex=12
        then xUF:='PA';
        if RGUF.ItemIndex=13
        then xUF:='PB';
        if RGUF.ItemIndex=14
        then xUF:='PR';
        if RGUF.ItemIndex=15
        then xUF:='PN';
        if RGUF.ItemIndex=16
        then xUF:='PI';
        if RGUF.ItemIndex=17
        then xUF:='RJ';
        if RGUF.ItemIndex=18
        then xUF:='RN';
        if RGUF.ItemIndex=19
        then xUF:='RS';
        if RGUF.ItemIndex=20
        then xUF:='RO';
        if RGUF.ItemIndex=21
        then xUF:='RR';
        if RGUF.ItemIndex=22
        then xUF:='SC';
        if RGUF.ItemIndex=23
        then xUF:='SP';
        if RGUF.ItemIndex=24
        then xUF:='SE';
        if RGUF.ItemIndex=25
        then xUF:='TO';
             end;
Result:=xUF;
end;

function Decimal(var Tecla : char):char;
begin
     if tecla in [',','.']
     then tecla := DecimalSeparator;
end;

procedure Progresso(Contador:TGauge);
begin
     Contador.Progress := Contador.Progress +1;
end;

procedure AC;
const
    cnCursorID1 = 1;
begin
     //Screen.Cursor := crHourGlass;
     Screen.Cursor:=crSQLWait;
end;

procedure DC;
begin
     Screen.Cursor := crDefault;
end;

procedure AC1;
const
    cnCursorID1 = 1;
begin
     Screen.Cursor := crHourGlass;
end;

//Fun��o que eleva o um determinado numero a outro
function Eleva(X : Real; N : Integer): Real;
var
   i : integer;
   total : real;
begin
     Total := 1;
     for i := 1 to n
     do Total := Total * x;
     result := Total;
end;

function CalculaJuros(XValor:Real; XParcela:Integer; XJuros : Real; TemEntrada : Boolean):Real;
begin
     if XJuros = 0
     then Result := XValor / XParcela
     else if TemEntrada
          then Result := XValor * ((Eleva((1+(XJuros/100)), XParcela) * (XJuros/100))/(Eleva((1+(XJuros/100)),XParcela) -1))// sem entrada
          else Result := XValor * ((Eleva((1+(XJuros/100)),XParcela-1) * (XJuros/100))/(Eleva((1+(XJuros/100)),XParcela) -1));// com entrada
end;

function ExisteArq(FileName: string): Boolean;
var
    F: Textfile;
begin
     {$I-}
     AssignFile(F, FileName);
     FileMode := 0;  // Set file access to read only }
     Reset(F);
     CloseFile(F);
     {$I+}
     ExisteArq := (IOResult = 0) and (FileName <> '');
end;

function Espaco(Palavra : String; Tamanho:Integer): String;
begin
     while Length(Palavra) < Tamanho
     do Palavra := Palavra + ' ';
     Result := Copy(Palavra,1,tamanho);
end;

function SoNumeros(Valor:String): String;
var
   i : integer;
   Caracter,XValor : String;
begin
     I := 1;
     XValor := '';
     while I < (Length(Valor)+1)
     do begin
        Caracter := Copy(Valor,I,1);
        if (Caracter <> ',') and
           (Caracter <> '.') and
           (Caracter <> '-') and
           (Caracter <> '/') and
           (Caracter <> '(') and
           (Caracter <> ')') 
        then XValor := XValor + Caracter;
        I := I + 1;
        end;
     Result := XValor;
end;

function VerificaCGC(num: string): boolean;
var
   n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12: integer;
   d1,d2: integer;
   digitado, calculado: string;
begin
     n1:=StrToInt(num[1]);
     n2:=StrToInt(num[2]);
     n3:=StrToInt(num[3]);
     n4:=StrToInt(num[4]);
     n5:=StrToInt(num[5]);
     n6:=StrToInt(num[6]);
     n7:=StrToInt(num[7]);
     n8:=StrToInt(num[8]);
     n9:=StrToInt(num[9]);
     n10:=StrToInt(num[10]);
     n11:=StrToInt(num[11]);
     n12:=StrToInt(num[12]);
     d1:=n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
     d1:=11-(d1 mod 11);

     if d1>=10
     then d1:=0;

     d2:=d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
     d2:=11-(d2 mod 11);

     if d2>=10
     then d2:=0;

     calculado:=inttostr(d1)+inttostr(d2);
     digitado:=num[13]+num[14];

     if calculado=digitado
     then result:=true
     else result:=false;
end;

function ValorPrestacao(pN:Integer;pPV,pI:Extended;pTipo:Integer):Extended;
var
   vPagto : TPaymentTime;
//onde
//pN = N�mero de Presta��es
//pPV = Valor da Compra (Present Value)
//pI = Taxa de Juros Mensal
//pTipo = 0 sem entrada e 1 com entrada
begin
     if pTipo = 1
     then vPagto := ptEndOfPeriod
     else vPagto := ptStartOfPeriod;
     Result := (Payment((pI/100), pN, (pPV * (-1)), 0 ,vPagto));
end;

function ProximaData(pData:TDateTime;pN:Integer):TDatetime;
{ pData = Data Inicial
  pN = n�mero de presta��es}
var
   dia, mes, ano : word;
   i : integer;
begin
     DecodeDate(pData, ano, mes, dia);
     i:=1;
     while i <= pN
     do begin
        if mes = 12
        then begin
             mes := 1;
             ano := ano + 1;
             end
        else mes := Mes + 1;
        inc(i);
       end;
     result := strTodate(IntToStr(dia)+'/'+intToStr(Mes)+'/'+intToStr(Ano));
end;

//Retorma o dia
function Dia(data:Tdate):word;
var
   xDia,xMes,xAno : word;
begin
     DecodeDate(data, xAno, xMes, xDia);
     result :=xDia;
end;

//retorna o mes
function Mes(data:Tdate):word;
var
   xDia,xMes,xAno : word;
begin
     DecodeDate(data, xAno, xMes, xDia);
     result :=xMes;
end;

// retorna o ano
function Ano(data:Tdate):word;
var
   xDia,xMes,xAno : word;
begin
     DecodeDate(data, xAno, xMes, xDia);
     result :=xAno;
end;

function RetornaMes( data:TDate):string;
begin
     case Mes(data) of
          1 : result := 'JANEIRO';
          2 : result := 'FEVEREIRO';
          3 : result := 'MARCO';
          4 : result := 'ABRIL';
          5 : result := 'MAIO';
          6 : result := 'JUNHO';
          7 : result := 'JULHO';
          8 : result := 'AGOSTO';
          9 : result := 'SETEMBRO';
          10 : result := 'OUTUBRO';
          11 : result := 'NOVEMBRO';
          12 : result := 'DEZEMBRO';
     end;
end;

function VirgulaPonto(pValor:Real): String;
var
   i : integer;
   Caracter,XValor : String;
begin
     I := 1;
     XValor := '';
     while I < (Length(FloattoStr(pValor))+1)
     do begin
        Caracter := Copy(FloattoStr(pValor),I,1);
        if (Caracter = ',')
        then Caracter := '.';
        XValor := XValor + Caracter;
        I := I + 1;
        end;
     Result := XValor;
end;

// verifica se o diskete est� no drive
function DiskInDrive(const Drive: char): Boolean;
var
   DrvNum: byte;
   EMode: Word;
begin
     result := false;
     DrvNum := ord(Drive);
     if DrvNum >= ord('a') then dec(DrvNum,$20);
     EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
     try
        if DiskSize(DrvNum-$40) <> -1 then result := true else messagebeep(0);
     finally SetErrorMode(EMode);
     end;
end;

function ProximoMes( xData : TDate ):TDate;
var
   xDia, xMes, xAno : word;
begin
     xDia := Dia( xData );
     xMes := Mes( xData );
     xAno := Ano( xData );

     xMes := xMes + 1;
     if xMes > 12
     then begin
          xMes :=1;
          xAno := xAno + 1;
          end;

     if (xDia=30) and (xMes=2)
     then xDia:=28;

     if (xDia=31) and (xMes in [2,4,6,9,11])
     then if xMes=2
          then xDia:=28
          else xDia := 30;

     result := EncodeDate( xAno,xMes,xDia );
end;

{Prenche uma String de tamanho "N" com o caractere "Ch"}
Function Copies (Ch : Char; N : Byte) : ShortString;
begin
     if N < 1
     Then Result := ''
     else begin
          FillChar (Result[1], N, Ch);
          Result[0] := Char(N);
          end;
end;

{Prenche, � direita, uma string "S" com caracteres "P" at� o tamanho total "N"}
function PadLeft (S :ShortString; N : Byte; P : Char) : ShortString;
begin
     if N < 1
     then Result := ''
     else if N > Length(S)
          then Result := S + Copies (P, N - Length(S))
          else Result := Copy (S, 1, N);
end;

{Prenche, � esquerda, uma string "S" com caracteres "P" at� o tamanho total "N"}
function PadRight (S :ShortString; N : Byte; P : Char) : ShortString;
begin
     if N < 1
     then Result := ''
     else if N > Length(S)
          then Result := Copies (P, N - Length(S)) + S
          else Result := Copy (S, Length(S) - N + 1, N);
end;

{Prenche, � direita e � esquerda, uma string "S" com caracteres "P" at� o tamanho total "N"}
function Middle (S : ShortString; N : SmallInt; P : Char) : ShortString;
var
   Spare, NDiv : Byte;
begin
     if N < 1
     then Result := ''
     else begin
          Spare := Abs (N - Length (S));
          NDiv := Spare Div 2;
          if N > Length(S)
          then Result := Copies (P, NDiv) + S + Copies (P, Spare - NDiv)
          else Result := Copy (S, NDiv + 1, N);
          end;
end;

{ Substitui um caracter "FromChar" por outro "ToChar" em uma string "SourceStr" }
function ReplaceChar (SourceStr : ShortString; FromChar, ToChar : Char;
         Mode : Byte) : ShortString;
var
   I : Integer;
begin
     Result := '';
     if Mode <> ReplaceLeft
     Then For I := Length (SourceStr) DownTo 1
          Do if SourceStr[I] = FromChar
             Then SourceStr[I] := ToChar
             else Break;

     if Mode <> ReplaceRight
     Then For I := 1 To Length (SourceStr)
     Do If SourceStr[I] = FromChar
        Then SourceStr[I] := ToChar
        else if Mode <> ReplaceAll
             Then Break;

     Result := SourceStr;
end;


{Substitui uma String "FromStr" por outra "ToStr" em uma String "Source"}
Function ReplaceStr (Source, FromStr, ToStr : ShortString; Mode : Byte) : ShortString;
Var
   P : Byte;
Begin
     if Mode <> ReplaceRight
     Then if Pos (FromStr, Source) = 1
          Then Source := ToStr + Copy (Source, Length (ToStr) + 1, 255);

     if Mode <> ReplaceLeft
     Then begin
          Source := ReverseStr (Source);
          if Pos (ReverseStr (FromStr), Source) = 1
          Then Source := ReverseStr (ToStr) + Copy (Source, Length (ToStr) + 1, 255);
          Source := ReverseStr (Source);
          end;

     if Mode = ReplaceAll
     Then begin
          P := Pos (FromStr, Source);
          while P > 0
          do begin
             Source := Copy (Source, 1, P - 1) + ToStr + Copy (Source, P + Length (ToStr), 255);
             P := Pos (FromStr, Source);
             end;
          end;
     ReplaceStr := Source;
End;

{ Retira os caracteres "CharToStrip" de uma string "SourceStr" }
Function StripChar (SourceStr : ShortString; CharToStrip : Char; Mode : Byte) : ShortString;
var
   I : Integer;
begin
     Result := '';
     If SourceStr <> ''
     Then begin
          if Mode <> ReplaceLeft
          Then While (Byte (SourceStr[0]) > 0) and (SourceStr[Byte (SourceStr[0])] = CharToStrip)
          Do Dec (SourceStr[0]);
          if Mode <> ReplaceRight
          Then begin
               I := 1;
               While (I <= Byte(SourceStr[0])) and (SourceStr[I] = CharToStrip)
               Do Inc (I);
               if I > 1
               Then SourceStr := Copy (SourceStr, I, 255);
               if Mode = ReplaceAll
               Then begin
                    For I := 1 To Byte (SourceStr[0])
                    Do if SourceStr[I] <> CharToStrip
                       Then Result := Result + SourceStr[I];
                    SourceStr := Result;
                    end;
               end;
          Result := SourceStr;
          end;
end;

{Remove as duplicidades de uma substring "T" em uma string "S"}
Function StripRepeat (S, T : ShortString) : ShortString;
Var P : Byte;
Begin
     P := Pos (T + T, S);
     while P > 0
     Do begin
        Delete (S, P, Length(T));
        P := Pos(T + T, S);
        end;
     StripRepeat := S;
End;

{Inverte uma string}
Function ReverseStr (S : ShortString) : ShortString;
var I : Integer;
begin
     Result := '';
     For I := Length(S) DownTo 1
     Do Result := Result + S[I];
end;

{Retorna SubString de uma String "S" a partir da ocorr�ncia da String "T"}
Function CopyFrom (S, T : ShortString) : ShortString;
Var P : Byte;
Begin
     P := Pos (T, S);
     if P > 0
     Then CopyFrom := Copy (S, P + Length(T), 255)
     else CopyFrom := '';
End;

{Retorna SubString de uma String "S" at� a ocorr�ncia da String "T"}
Function CopyUntil (S, T : ShortString) : ShortString;
Var P : Byte;
Begin
     P := Pos (T, S);
     if P > 0
     Then CopyUntil := Copy (S, 1, Pred(P))
     else CopyUntil := S;
End;

{Retorna a �ltima ocorr�ncia de uma string "T" em uma string "S"}
Function LastPos (T, S : ShortString) : Byte;
Var P : Byte;
Begin
     P := Pos (ReverseStr (T), ReverseStr (S));
     if P > 0
     Then LastPos := Length(S) - P
     Else LastPos := 0;
End;

{Retorna a posicao do primeiro caracter ap�s a ocorr�ncia de todas strings "T" consecutivas}
Function NoPos (T, S : ShortString) : Byte;
Var Tam : Byte;
Begin
     Tam := Length(T);
     Result := 1;
     While Pos (T, S) = 1
     Do Begin
        Inc (Result, Tam);
        S := Copy (S, Tam + 1, 255);
        end;
End;

{Retorna o n�mero de ocorr�ncias de uma string "T" dentro de outra "S"}
Function Occurs(T, S : ShortString) : Byte;
Var P : Byte;
Begin
     Result := 0;
     P := Pos (T, S);
     while P > 0
     do begin
        Inc (Result);
        S := Copy (S, P + Length (T), 255);
        P := Pos (T, S);
        end;
End;

{Retorna a posi��o da en�sima ocorr�ncia da string "T" na string "S"}
Function OccurPos (T, S : ShortString; N : Byte) : Byte;
Var Op, P, I : Byte;
Begin
     I := 0;
     Op := 0;
     P := Pos (T, S);
     While P > 0
     Do Begin
        Inc (Op);
        if Op = N
        Then Begin
             OccurPos := I + P;
             Exit;
             End;
        Inc(I, P + Length(T) - 1);
        P := Pos (T, Copy (S, I + 1, 255));
        End;
        OccurPos := 0;
End;

{Retira os espa�os em branco � direita}
Function RTrim (StrX : string) : string;
begin
     RTrim := StripChar (StrX, EspacoBranco, ReplaceRight);
end;

{Retira os espa�os em branco a esquerda}
Function LTrim (StrX : string) : string;
begin
     LTrim := StripChar (StrX, EspacoBranco, ReplaceLeft);
end;

{Retira os espa�os em branco a esquerda e a direita}
Function AllTrim (StrX : string) : string;
begin
     AllTrim := StripChar (StrX, EspacoBranco, ReplaceBoth);;
end;

{Preenche variavel com "IntX" vezes uma string passada}
Function Replicate (StrX : string; IntX : Integer ) : string;
begin
     Result := '';
     while Length (Result) < IntX
     do Result := Result + StrX;
end;

{Preenche string com n espa�os}
Function Space (const IntX : ShortInt) : string;
begin
     Space := Copies (EspacoBranco, IntX);
end;

{Centraliza string}
Function Center(StrX : string; IntX : Integer) : string;
begin
     Center := Middle (StrX, IntX, EspacoBranco);
end;

{Retira os n caracteres a esquerda}
Function LeftStr (StrX : string; const IntX : ShortInt) : string;
begin
// LeftStr := Copy (StrX, IntX + 1, Length (StrX) - IntX);
   LeftStr := Copy (StrX, 1, IntX);
end;

{Retira os n caracteres a direita}
Function RightStr (StrX : string; const IntX : ShortInt ) : string;
begin
     RightStr := ReverseStr(Copy(ReverseStr(StrX), 1, Intx));
end;

{Testa se um caracter � um caracter num�rico}
Function IsDigit (c : char) : Boolean;
begin
     IsDigit := (c >= '0') and (c <= '9');
end;

Function IsNumber( s : string ) : Boolean;
var
   ok : boolean;
begin
     ok := true;
     try
        StrToFloat(s)
     except
        ok:=false;
     end;
     result := ok;
end;

{Retorna Verdadeiro se um n�mero for par}
Function IsPar (xNumero : LongInt) : boolean;
begin
     IsPar := Odd (xNumero);
end;

Function Zeros(Valor:String; Tamanho : Integer): String;
var
  i : integer;
  Caracter,XValor : String;
begin
   I := 1;
   XValor := '';
   while I < (Length(Valor)+1) do
     begin
       Caracter := Copy(Valor,I,1);
       If Caracter <> ',' then
          XValor := XValor + Caracter;
       I := I + 1;
     end;
   if length(XValor) < Tamanho then
      begin
        while Length(XValor) < Tamanho do
           XValor := '0'+ Xvalor;
      end;
   Result := XValor;
end;

Function StrZero( numero,numzero:integer):string;
var
   aux:string;
   j:integer;
begin
     aux:='';
     for j:=1 to numzero-Length( IntToStr(numero) ) do
         aux:=aux+'0';
     aux:=aux+IntToStr(numero);
     result:=aux;
end;

Procedure AtivaBT( Form :TForm; Botoes:array of TComponent; flag:boolean);
var
   i,j,TamVetor: Integer;
begin
     with Form
     do begin
        TamVetor := High(Botoes);
        if TamVetor = 0
        then begin
             for j:=0 to ComponentCount -1
             do begin
                if Components[j] is TSpeedButton
                then begin
                     TSpeedButton(Components[j]).Enabled:=flag;
                     TSpeedButton(Components[j]).Refresh;
                     end;

                if Components[j] is TButton
                then begin
                     TButton(Components[j]).Enabled:=flag;
                     TButton(Components[j]).Refresh;
                     end;

                if Components[j] is TBitBtn
                then begin
                     TBitBtn(Components[j]).Enabled:=flag;
                     TBitBtn(Components[j]).Refresh;
                     end;

                end;
             end
        else begin
             for i:=0 to TamVetor
             do begin
                for j:=0 to ComponentCount -1
                do begin
                   if Components[j] is TSPeedButton
                   then if TSpeedButton(Components[j])= Botoes[i]
                        then begin
                             TSpeedButton(Components[j]).Enabled := flag;
                             TSpeedButton(Components[j]).Refresh;
                             end;

                   if Components[j] is TBitBtn
                   then if TBitBtn(Components[j])=Botoes[i]
                        then begin
                             TBitBtn(Components[j]).Enabled:=flag;
                             TBitBtn(Components[j]).Refresh;
                              end;
                       end;
                  end;
             end;
        end;
end;

//Testar a impressora
function PrinterOnLine : Boolean;
Const
     PrnStInt : Byte = $17;
     StRq : Byte = $02;
     PrnNum : Word = 0; { 0 para LPT1, 1 para LPT2, etc. }
Var
   nResult : byte;
   vOk,vSaida : boolean;
Begin
   Try
     vSaida:=false;
     while not vSaida
     do begin
        vOk := false;
        Asm
           mov ah,StRq;
           mov dx,PrnNum;
           Int $17;
           mov nResult,ah;
        end;
        //PrinterOnLine := (nResult and $80) = $80;
        vOk := (nResult and $80) = $80;
        if not vOk
        then begin
             if Confirma('Impressora n�o ativa!!! Repetir?')=mrYes
             then vSaida:=false
             else vSaida:=true;
             end
        else vSaida:=true;
        end;
     result := vOk;
   Except
      Informa('Impressora n�o ativa!!!');
      end;  
end;

Function DiaExtenso (dData : TDateTime) : string;
var
   xDia : string;
begin
     case DayOfWeek (dData) of
          1: xDia := 'DOMINGO';
          2: xDia := 'SEGUNDA-FEIRA';
          3: xDia := 'TER�A-FEIRA';
          4: xDia := 'QUARTA-FEIRA';
          5: xDia := 'QUINTA-FEIRA';
          6: xDia := 'SEXTA-FEIRA';
          7: xDia := 'S�BADO';
     end;
     Result := xDia;
end;

function GetFileDate(Arquivo: String): String;
var
   FHandle: integer;
begin
     FHandle := FileOpen(Arquivo, 0);
     try
        Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
     finally
        FileClose(FHandle);
     end;
end;

procedure TextoDiagonal(NomeFonte:TFontName;TamanhoFonte,CorFonte,Linha,Coluna:integer;Texto:string;Form:TForm);
var
   lf : TLogFont;
   tf : TFont;
begin
     with Form.Canvas
     do begin
        Font.Name := NomeFonte;
        Font.Size := TamanhoFonte;
        Font.Color := CorFonte;
        tf := TFont.Create;
        tf.Assign(Font);
        GetObject(tf.Handle, sizeof(lf), @lf);
        lf.lfEscapement := 900;
        lf.lfOrientation := 1000;
        tf.Handle := CreateFontIndirect(lf);

        Font.Assign(tf);
        tf.Free;
        TextOut(Coluna, Linha, texto);
        end;

end;

Function AjustaQtde(xValor:real;Tamanho:integer):string;
begin
     result := PadRight(FormatFloat('#####0',xValor),tamanho,' ');
end;

Function AlinhaValor(xValor:real;Tamanho:integer):string;
begin
     result := PadRight(FormatFloat('#####0.00',xValor),tamanho,' ');
end;

Function AlinhaQtde(xValor:real;Tamanho:integer):string;
begin
     result := PadRight(FormatFloat('#####0.000',xValor),tamanho,' ');
end;

Function CasaDecimal(xValor:real;Tamanho:integer):string;
begin
     result := PadRight(FormatFloat('##,###0.00',xValor),tamanho,' ');
end;

procedure LimpaEdit(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TEdit
        then TEdit(xForm.Components[i]).clear;
end;

procedure LimpaChecked(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TCheckBox
        then TCheckBox(xForm.Components[i]).Checked:=False;
end;

procedure MarcaChecked(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TCheckBox
        then TCheckBox(xForm.Components[i]).Checked:=True;
end;

procedure LimpaMaxEdit(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TMaskEdit
        then TMaskEdit(xForm.Components[i]).clear;
end;

procedure SaltaLinha( NumLinha:integer; vSaida:string);
var
   F : TextFile;
   i : integer;
begin
     AssignFile(F,vSaida);
     Rewrite(F);
     for i:=1 to NumLinha
     do Writeln(F,'');
     CloseFile(F);
end;

function Cry( xPalavra:string; opc:boolean):string;
const
     sum = 131;
var
   i : integer;
   aux : string;
begin
     for i:=1 to Length( xPalavra )
     do if opc
        then aux := aux + Copy(xPalavra,i,1) ;
     result := aux;
end;

Procedure ExecuteProgram(Nome,Parametros:String);
var Comando : Array[0..1024] of Char;
    Parms : Array[0..1024] of Char;
begin
     StrPCopy(Comando,Nome);
     StrPCopy(Parms,Parametros);
     ShellExecute(0,nil,Comando,Parms,nil,sw_showmaximized);
end;

procedure Say(Nlin,Ncol: Integer;Var LinhaAtual: Integer; Var Arquivo: Text;Texto: Variant);
{Fun��o para impress�o de linhas em um relat�rio}
var
X: Integer;
begin
Write(Arquivo,#13);
If Nlin<>LinhaAtual then
begin
for X :=LinhaAtual to (Nlin-1) do
begin
WriteLn(Arquivo,'');
LinhaAtual:=LinhaAtual+1;
end;
end;
If Ncol>0 then
begin
For X:=0 to Ncol do
begin
Write(Arquivo,' ');
end;
end;
If LinhaAtual >=63 then { 63 � O N�MERO DA �LTIMA LINHA ANTES DO RODAP�}
begin
For X:=63 to 67 do { 67 � A QUANTIDADE DE LINHAS POR P�GINA }
begin
Writeln(Arquivo,'');
LinhaAtual:=1;
end;
end;
Write(Arquivo,Texto);
end;

//Total de Meses Entre duas Datas
Function TotalMeses(DataFim:TDateTime; DataAtual:TDateTime):String;
Var
   Mes : Real;
begin
     Mes:=0;
     Mes:=Round((DataFim - DataAtual)/30);
     Result:=FloatToStr(Mes);
end;

//Total de Dias Entre duas Datas
Function TotalDias(DataFim:TDateTime; DataAtual:TDateTime):String;
Var
   Dias : Real;
begin
     Dias:=0;
     Dias:=Round(DataFim - DataAtual);
     Result:=FloatToStr(Dias);
end;

//Total de Anos Entre duas Datas
Function TotalAnos(DataFim:TDateTime; DataAtual:TDateTime):String;
Var
   Anos : Real;
begin
     Anos:=0;
     Anos:=Round((DataFim - DataAtual)/364);
     Result:=FloatToStr(Anos);
end;

procedure GravaIniCrypt(Diretorio,Colchete, Parametro, Texto, Arquivo: String);
var
    ArqIni : TIniFile;
begin
    ArqIni := TIniFile.Create(Diretorio+Arquivo);
    try
    ArqIni.WriteString((Colchete),(Parametro),Codifica(Texto));
    finally
    ArqIni.Free;
    end;
end;
Function Codifica(const Str1: String): String;
var
 CharIndex: Integer;
 ReturnValue: string;
begin
 ReturnValue := '';
 for CharIndex := 1 to Length(Str1) do
 begin
   ReturnValue := ReturnValue + chr(NOT(ord(Str1[CharIndex])));
 end;
 Result := ReturnValue;
end;

function LeIniCrypt(Diretorio, Colchete, Parametro : String; Var Texto, Arquivo: String): String;
var
    ArqIni : TIniFile;
begin
    ArqIni := TIniFile.Create(Diretorio+Arquivo);
    Try
    Texto:= Codifica(ArqIni.ReadString((Colchete),(Parametro),Codifica(Texto)));
    Result:= Texto;
    Finally
    ArqIni.Free;
    end;
end;

Function DataExtenso(Data:TDateTime): String;
{Retorna uma data por extenso}
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of String;
  Meses : array [1..12] of String;
  Dia, Mes, Ano : Word;
begin
{ Dias da Semana }
  DiaDasemana [1]:= 'DOMINGO';
  DiaDasemana [2]:= 'SEGUNDA-FEIRA';
  DiaDasemana [3]:= 'TERCA-FEIRA';
  DiaDasemana [4]:= 'QUARTA-FEIRA';
  DiaDasemana [5]:= 'QUINTA-FEIRA';
  DiaDasemana [6]:= 'SEXTA-FEIRA';
  DiaDasemana [7]:= 'SABADO';
{ Meses do ano }
  Meses [1] := 'JANEIRO';
  Meses [2] := 'FEVEREIRO';
  Meses [3] := 'MARCO';
  Meses [4] := 'ABRIL';
  Meses [5] := 'MAIO';
  Meses [6] := 'JUNHO';
  Meses [7] := 'JULHO';
  Meses [8] := 'AGOSTO';
  Meses [9] := 'SETEMBRO';
  Meses [10]:= 'OUTUBRO';
  Meses [11]:= 'NOVEMBRO';
  Meses [12]:= 'DEZEMBRO';
  DecodeDate (Data, Ano, Mes, Dia);
  NoDia := DayOfWeek (Data);
  Result := DiaDaSemana[NoDia] + ', ' +
  IntToStr(Dia) + ' DE ' + Meses[Mes]+ ' DE ' + IntToStr(Ano);
end;

procedure CentralizaForm( xForm:TForm );
var
   r : TRect;
begin
     r := xForm.ClientRect;
     with xForm
     do begin
        Left := (width - (r.right - r.left) ) div 2;
        top := (height - (r.bottom - r.top) ) div 2;
        end;
end;

Function ImpresConect(Porta:Word):Boolean;
Const
Portas :Byte = $02;
Var
Res :Byte;
Begin Asm
mov ah,Portas;
mov dx,Porta;
Int $17;
mov Res,ah;
end;
Result := (Res and $80) = $80;
end;

function AbreviaNome(Nome: String): String;
var
  Nomes: array[1..20] of string;
  i, TotalNomes: Integer;
begin
  Nome := Trim(Nome);
  Result := Nome;
  {Insere um espa�o para garantir que todas as letras sejam testadas}
  Nome := Nome + #32;
  {Pega a posi��o do primeiro espa�o}
  i := Pos(#32, Nome);
  if i > 0 then
  begin
    TotalNomes := 0;
    {Separa todos os nomes}
    while i > 0 do
    begin
      Inc(TotalNomes);
      Nomes[TotalNomes] := Copy(Nome, 1, i - 1);
      Delete(Nome, 1, i);
      i := Pos(#32, Nome);
    end;
    if TotalNomes > 2 then
    begin
      {Abreviar a partir do segundo nome, exceto o �ltimo.}
      for i := 2 to TotalNomes - 1 do
      begin
        {Cont�m mais de 3 letras? (ignorar de, da, das, do, dos, etc.)}
        if Length(Nomes[i]) > 3 then
        {Pega apenas a primeira letra do nome e coloca um ponto ap�s.}
         Nomes[i] := Nomes[i][1] + '.';
      end;
      Result := '';
      for i := 1 to TotalNomes do
        Result := Result + Trim(Nomes[i]) + #32;
      Result := Trim(Result);
    end;
  end;
end;

procedure ExcluiTabelasTemporarias;
var
  SR: TSearchRec;
  I: integer;
begin
     I := FindFirst('C:\SIAC\TEMP\*.*', faAnyFile, SR);
     while I = 0
     do begin
        if (SR.Attr and faDirectory) <> faDirectory
        then DeleteFile('C:\SIAC\TEMP\' + SR.Name);
        I := FindNext(SR);
        end;
end;

//Adaptando o Formul�rio para resolu��o de v�deos diferentes:
//Importante: Para que todos as Fontes dos Componentes sejam alterados setar ParentFont para True.
//Colocar do OnCreate do Form
procedure ResolucaoDoVideo( xForm:TForm );
const iWidth : smallint = 800; { Resolu��o de Desemvolvimento do Form }
      iHeight : smallint = 600;
var
    I : integer;
begin
    for i := 0 to xForm.ComponentCount -1 do
    begin { Varre todos os componentes do form que possam ser redefinidos (classe TWinControl) }
    if xForm.Components[i] is TWinControl then
    begin { Redefine os componentes em propor��o ao original }
    TWinControl(xForm.Components[i]).Width := Round(TWinControl(xForm.Components[i]).Width * (Screen.Width / iWidth));
    TWinControl(xForm.Components[i]).Height := Round(TWinControl(xForm.Components[i]).Height * (Screen.Height / iHeight));
    TWinControl(xForm.Components[i]).Left := Round(TWinControl(xForm.Components[i]).Left * (Screen.Width / iWidth));
    TWinControl(xForm.Components[i]).Top := Round(TWinControl(xForm.Components[i]).Top * (Screen.Height / iHeight));
    TWinControl(xForm.Components[i]).Top := Round(TWinControl(xForm.Components[i]).Top * (Screen.Height / iHeight));
    end;
    end;
    { Redefine o Formul�rio }
    xForm.Width := Round(xForm.Width * (Screen.Width / iWidth));
    xForm.Height := Round(xForm.Height * (Screen.Height / iHeight));
    xForm.Top := Round(xForm.Top * (Screen.Height / iHeight));
    xForm.Left := Round(xForm.Left * (Screen.Width / iWidth));
    { Altera o tamanho da Fonte do Formul�rio }
    xForm.Font.Size := Round(xForm.Font.Size * (Screen.Height / iHeight));
end;

//Fun��o para Calcular Financiamento
Function VlPrestacao(C : Real; J : Real; N : Real) : Real;
begin
Result := C*((J/100)/(1-( Power(1/(1+(J/100)),N) )));
end;

Function ValidCartao(const s:string): Boolean;
Var
Valor, Soma, Multiplicador, Tamanho, i : Integer;
begin
Result := False;
Multiplicador := 2;
Soma := 0;
Tamanho := Length (AllTrim (S));
For i := 1 to Tamanho - 1 do begin
Try
Valor := StrToInt (Copy (S, i, 1)) * Multiplicador;
Except
Valor := 0;
End;
Soma := Soma + (Valor DIV 10) + (Valor mod 10);
if Multiplicador = 1 Then
Multiplicador := 2
else
Multiplicador := 1;
end;
if IntToStr ((10 - (Soma mod 10)) mod 10) = Copy (S, Tamanho, 1) Then
Result := True;
end;

Function AlinharValor(xValor:real;Tamanho:integer):string;
begin
     result := PadRight(FormatFloat('('+'###,###,##0.00'+')',xValor),tamanho,' ');
end;

procedure EntraFocu(Sender: TObject);
var
   CorEntrada : TColor;
begin
     CorEntrada:=$0080FFFF;

     if (Sender is TDBEdit) then
     TDBEdit(Sender).Color:=CorEntrada;

     if (Sender is TEdit) then
     TEdit(Sender).Color:=CorEntrada;

     if (Sender is TMemo) then
     TMemo(Sender).Color:=CorEntrada;

     if (Sender is TDBMemo) then
     TDBMemo(Sender).Color:=CorEntrada;

     if (Sender is TDateEdit) then
     TDateEdit(Sender).Color:=CorEntrada;

     if (Sender is TDBDateEdit) then
     TDBDateEdit(Sender).Color:=CorEntrada;

     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=CorEntrada;

     if (Sender is TComboBox) then
     TComboBox(Sender).Color:=CorEntrada;

     if (Sender is TMaskEdit) then
     TMaskEdit(Sender).Color:=CorEntrada;
end;
procedure FechaFocu(Sender: TObject);
var
   CorSaida : TColor;
begin
     CorSaida:=clWhite;

     if (Sender is TDBEdit) then
     TDBEdit(Sender).Color:=CorSaida;

     if (Sender is TEdit) then
     TEdit(Sender).Color:=CorSaida;

     if (Sender is TMemo) then
     TMemo(Sender).Color:=CorSaida;

     if (Sender is TDBMemo) then
     TDBMemo(Sender).Color:=CorSaida;

     if (Sender is TDateEdit) then
     TDateEdit(Sender).Color:=CorSaida;

     if (Sender is TDBDateEdit) then
     TDBDateEdit(Sender).Color:=CorSaida;

     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=CorSaida;

     if (Sender is TComboBox) then
     TComboBox(Sender).Color:=CorSaida;

     if (Sender is TMaskEdit) then
     TMaskEdit(Sender).Color:=CorSaida;
end;

function Arredonda(Valor :Double; Casas: Byte) :Double;
var
  StrFormat :String;
begin
  StrFormat := '#.';
  while Casas > 0 do
  begin
    // inicializa quantidade de zeros ref. as casas decimais desejadas
    StrFormat := StrFormat +'0';
    Dec(Casas);
  end;
  Result := StrToFloat(FormatFloat(StrFormat, Valor));
end;

procedure ChamaCalculadora;
begin
     Try
        if FCalculadora=Nil
        then application.CreateForm(TFCalculadora, FCalculadora);
        FCalculadora.ShowModal;
     Finally
        FCalculadora.Release;
        FCalculadora:=Nil;
        end;
end;


{Usa-se C para Criptografar e D para Descriptografar
Ex de Criptografia:
Edit2.text:= Crypt('C',Edit1.text);

Ex: de Descriptografia
Edit3.text:= Crypt('D',Edit2.text);}
Function Crypt(Action, Src: String): String;
Label Fim;
var KeyLen : Integer;
  KeyPos : Integer;
  OffSet : Integer;
  Dest, Key : String;
  SrcPos : Integer;
  SrcAsc : Integer;
  TmpSrcAsc : Integer;
  Range : Integer;
begin
  if (Src = '') Then
  begin
    Result:= '';
    Goto Fim;
  end;
  Key :=
'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Src,1,2));
    SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
    if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;

function PasswordInputBox(const ACaption, APrompt:string): string;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  Value: string;
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  Result := '';
  Form := TForm.Create(Application);
  with Form do
  try
    Canvas.Font := Font;
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(DialogUnits));
    DialogUnits.X := DialogUnits.X div 52;
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    ClientHeight := MulDiv(63, DialogUnits.Y, 8);
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      AutoSize := True;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Caption := APrompt;
    end;
    Edit := TEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := MulDiv(19, DialogUnits.Y, 8);
      Width := MulDiv(164, DialogUnits.X, 4);
      MaxLength := 255;
      PasswordChar := '*';
      SelectAll;
    end;
    ButtonTop := MulDiv(41, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'OK';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4),ButtonTop, ButtonWidth,ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'Cancel';
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4),ButtonTop, ButtonWidth,ButtonHeight);
    end;
    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := Value;
    end;
  finally
    Form.Free;
    Form:=nil;  
  end;
end;

Function GetIP:string;
//--> Declare a Winsock na clausula uses da unit
var
WSAData: TWSAData;
HostEnt: PHostEnt;
Name:string;
begin
WSAStartup(2, WSAData);
SetLength(Name, 255);
Gethostname(PChar(Name), 255);
SetLength(Name, StrLen(PChar(Name)));
HostEnt := gethostbyname(PChar(Name));
with HostEnt^ do
begin
Result := Format('%d.%d.%d.%d',
[Byte(h_addr^[0]),Byte(h_addr^[1]),
Byte(h_addr^[2]),Byte(h_addr^[3])]);
end;
WSACleanup;
end;

Function strToBoolean(s: string): boolean;
begin
result := ((uppercase(s) = 'TRUE') or
(uppercase(s) = 'T') or
(uppercase(s) = 'YES') or
(uppercase(s) = 'Y') or
(uppercase(s) = 'ON') or
(uppercase(s) = 'O') or
(uppercase(s) = '1'));
end;

function PrimeiroNome (Nome : String) : String;
var
PNome : String;
begin
PNome := '';
if pos (' ', Nome) <> 0 then
PNome := copy (Nome, 1, pos (' ', Nome) - 1);
Result := PNome;
end;

function NewGen(GenName: String; aConexao:TSQLConnection): integer;
var
  ResultSet: TCustomSQLDataSet;
  SQLstmt: string;
begin
  SQLStmt := 'SELECT CAST(gen_id(' + GenName + ',1)as integer) as NewValor from RDB$DATABASE;';
  ResultSet := nil;
  try
    aConexao.Execute(SQLstmt, nil, @ResultSet);
    if Assigned(ResultSet) then
    begin
      Result := ResultSet.FieldByName('NewValor').AsInteger;
    end;
  finally
    ResultSet.Free;
  end;
end; (* NewGen *)

Function GetVersaoArq: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(
    ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0,
    VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue),
    VerValueSize);                                             
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(
      dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(
      dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(
      dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

procedure ExpHTML(DataSet: TDataSet; Arq: string);
var
  sl: TStringList;
  dp: TDataSetTableProducer;
begin
  sl := TStringList.Create;
  try
    dp := TDataSetTableProducer.Create(nil);
    try
      DataSet.First;
      dp.DataSet := DataSet;
      dp.TableAttributes.Border := 1;
      sl.Text := dp.Content;
      sl.SaveToFile(Arq);
    finally
      dp.free;
    end;
  finally
    sl.free;
  end;
end;

procedure ExpTXT(DataSet: TDataSet; Arq: string);
var
  i: integer;
  sl: TStringList;
  st: string;
begin
  DataSet.First;
  sl := TStringList.Create;
  try
    st := '';
    for i := 0 to DataSet.Fields.Count - 1 do
      st := st + DataSet.Fields[i].DisplayLabel + ';';
    sl.Add(st);
    DataSet.First;
    while not DataSet.Eof do
    begin
      st := '';
      for i := 0 to DataSet.Fields.Count - 1 do
        st := st + DataSet.Fields[i].DisplayText + ';';
      sl.Add(st);
      DataSet.Next;
    end;
    sl.SaveToFile(Arq);
  finally
     sl.free;
  end;
end;

procedure ExpXLS(DataSet: TDataSet; Arq: string);
var
  ExcApp: OleVariant;
  i,l: integer;
begin
  ExcApp := CreateOleObject('Excel.Application');
  ExcApp.Visible := True;
  ExcApp.WorkBooks.Add;
  DataSet.First;
  l := 1;  
  DataSet.First;
  while not DataSet.EOF do
  begin
    for i := 0 to DataSet.Fields.Count - 1 do
      ExcApp.WorkBooks[1].Sheets[1].Cells[l,i + 1] :=
        DataSet.Fields[i].DisplayText;
    DataSet.Next;
    l := l + 1;
  end;
  ExcApp.WorkBooks[1].SaveAs(Arq);
end;

procedure ExpDOC(DataSet: TDataSet; Arq: string);
var
  WordApp,WordDoc,WordTable,WordRange: Variant;
  Row,Column: integer;
begin
  WordApp := CreateOleobject('Word.basic');
  WordApp.Appshow;
  WordDoc := CreateOleobject('Word.Document');
  WordRange := WordDoc.Range;
  WordTable := WordDoc.tables.Add(
    WordDoc.Range,1,DataSet.FieldCount);
  for Column:=0 to DataSet.FieldCount-1 do
    WordTable.cell(1,Column+1).range.text:=
      DataSet.Fields.Fields[Column].FieldName;
  Row := 2;
  DataSet.First;
  while not DataSet.Eof do
  begin
     WordTable.Rows.Add;
     for Column:=0 to DataSet.FieldCount-1 do
       WordTable.cell(Row,Column+1).range.text :=
         DataSet.Fields.Fields[Column].DisplayText;
     DataSet.next;
     Row := Row+1;
  end;
  WordDoc.SaveAs(Arq);
  WordDoc := unAssigned;
end;

procedure ExpXML(DataSet : TDataSet; Arq : string);
var
  i: integer;
  xml: TXMLDocument;
  reg, campo: IXMLNode;
begin
  xml := TXMLDocument.Create(nil);
  try
    xml.Active := True;
    DataSet.First;
    xml.DocumentElement :=
      xml.CreateElement('DataSet','');
    DataSet.First;
    while not DataSet.Eof do
    begin
      reg := xml.DocumentElement.AddChild('row');
      for i := 0 to DataSet.Fields.Count - 1 do
      begin
        campo := reg.AddChild(
          DataSet.Fields[i].DisplayLabel);
        campo.Text := DataSet.Fields[i].DisplayText;
      end;
      DataSet.Next;
    end;
    xml.SaveToFile(Arq);
  finally
    xml.free;
  end;
end;

Function RemoveChar(Const Texto:String):String;
//
// Remove caracteres de uma string deixando apenas numeros
//
var
I: integer;
S: string;
begin
  S := '';
  for I := 1 To Length(Texto) Do
  begin
    if (Texto[I] in ['0'..'9']) then
    begin
      S := S + Copy(Texto, I, 1);
    end;
  end;
  result := S;
end;

Procedure CopyDir(const cFrom, cTo : string);
var
   OpStruc : TSHFileOpStruct;
   frombuf, tobuf : array[0..128] of Char;
begin
   FillChar(frombuf, Sizeof(frombuf), 0);
   FillChar(tobuf, Sizeof(tobuf), 0);
   StrPCopy(frombuf, cFrom);
   StrPCopy(tobuf, cTo);
   with OpStruc
   do begin
      Wnd := Application.Handle;
      wFunc := FO_COPY;
      pFrom := @frombuf;
      pTo := @tobuf;
      fFlags := FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
      fAnyOperationsAborted := False;
      hNameMappings := nil;
      lpszProgressTitle := nil;
      end; // with

    ShFileOperation(OpStruc);
end; // CopyDir

//Fun��o para executar aplicativos
function Exec_File(File_Path: string): integer;
var
 retorno: integer;
 MyOpenDialog: TOpenDialog;
 Error_Msg: String;
begin
 retorno := ERROR_FILE_NOT_FOUND;

 try
   if FileExists(File_Path) then
     retorno := ShellExecute(0, nil, PChar(File_Path), nil, nil, SW_NORMAL)
   else if application.messagebox(PChar('N�o foi poss�vel encontrar o arquivo - ' +
     #13 + File_Path + #13#13 +
     'Deseja Localizar o Arquivo?'),
     'Aten��o', MB_IconInformation + MB_YESNO) = idYes then
    begin
     MyOpenDialog := TOpenDialog.Create(MyOpenDialog);
     MyOpenDialog.Title := 'Localizando Arquivo...';
     MyOpenDialog.InitialDir := Extractfiledir(application.exename);
     if MyOpenDialog.Execute then
       retorno := ShellExecute(0, nil, PChar(MyOpenDialog.filename), nil, nil, SW_NORMAL);
    end;
 except
   application.MessageBox('Erro no processo de execu��o do arquivo de Ajuda',
     'Aten��o', mb_ok + mb_iconerror);
  end;

 MyOpenDialog.Free;

 Error_Msg := '';
 case retorno of
  0:                      Error_Msg := 'Erro: N�o h� mem�ria sufiente para executar o arquivo - ' + File_Path;
  ERROR_FILE_NOT_FOUND:   Error_Msg := 'Erro: Arquivo n�o encontrado em - ' + File_Path;
  ERROR_PATH_NOT_FOUND:   Error_Msg := 'Erro: Arquivo n�o encontrado em - ' + File_Path;
  ERROR_BAD_FORMAT:       Error_Msg := 'Erro: Arquivo .EXE inv�lido (non-Win32 .EXE or error in .EXE image).';
  SE_ERR_ACCESSDENIED:    Error_Msg := 'Erro: O Sistema Operacional negou o acesso ao arquivo - ' + File_Path;
  SE_ERR_ASSOCINCOMPLETE: Error_Msg := 'Erro: Associa��o de tipo de arquivo incompat�vel ou inv�lida.';
  SE_ERR_DDEBUSY:         Error_Msg := 'Erro: Transa��o DDE n�o pode ser completada devido a execu��o de outras transa��es.';
  SE_ERR_DDEFAIL:         Error_Msg := 'Erro: A Transa��o DDE falhou.';
  SE_ERR_DDETIMEOUT:      Error_Msg := 'Erro: Time de execu��o da transa��o DDE';
  SE_ERR_DLLNOTFOUND:     Error_Msg := 'Erro: Dll especificada n�o foi encontrada.';
  SE_ERR_NOASSOC:         Error_Msg := 'Erro: N�o h� aplicativo associado ao tipo de arquivo especificado.';
  SE_ERR_OOM:             Error_Msg := 'Erro: N�o h� mem�ria sufiente para completar a opera��o.';
  SE_ERR_SHARE:           Error_Msg := 'Erro: Viola��o de Compartilhamento.';
  //else
  //showmessage('instance handle of the application that was run, or the handle of a dynamic data exchange (DDE) server application is: ' + inttostr(retorno));
 end;

 if trim(Error_Msg) <> '' then
  showmessage(Error_Msg);
end;

Function SerialNum(FDrive:String):String;
Var Serial: DWord;
    DirLen, Flags: DWord;
    DLabel : Array[0..8] of Char;
begin
    Try
     GetVolumeInformation(Pchar(FDrive+':\'),DLabel,12,@Serial, DirLen, Flags, nil, 0);
     Result := IntToHex(Serial, 8);
    Except
     Result := '';
    end;
end;

function ValidaEAN(CodBar: string): Boolean;
var
   sl_CodIni : String;
   il_SeqSom, il_Soma, il_TodNum : Integer;
begin
   // se codigo eh invalido
   IF (Length(Trim(CodBar)) = 0) THEN
    Result := TRUE

   ELSE IF ( (Length(Trim(CodBar)) <> 13) AND (Length(Trim(CodBar)) <> 8) ) THEN
    Result := FALSE

   // se codigo eh certo, entao continua
   ELSE
    BEGIN
       sl_CodIni := Copy(Trim(CodBar),1,Length(CodBar)-1);
       il_Soma   := 0;
       il_SeqSom := 1;

       // se for ean8 entao completa numeros
       IF Length(Trim(CodBar)) = 8 THEN
        sl_CodIni := '00000'+sl_CodIni;

       // continua

       FOR il_TodNum := 1 TO Length(sl_CodIni) DO
        BEGIN
           IF il_SeqSom = 1 THEN
            BEGIN
               il_Soma   := il_Soma +
                  (StrToInt(Copy(sl_CodIni, il_TodNum, 1)) * il_SeqSom);
               il_SeqSom := 3;
            END
           ELSE
            BEGIN
               il_Soma   := il_Soma + 
                  (StrToInt(Copy(sl_CodIni, il_TodNum, 1)) * il_SeqSom);
               il_SeqSom := 1;
            END

        END;

       // calcula o restante

       // para numeros que nao sao zero no final
       IF Copy(IntToStr(il_Soma),Length(IntToStr(il_Soma)),1) <> '0' THEN
        BEGIN
           IF Copy(Trim(CodBar), Length(CodBar), 1) = 
              IntToStr(10-StrToInt( Copy(IntToStr(il_Soma), 
              Length(IntToStr(il_Soma)),1) )) THEN
            Result := TRUE
           ELSE
            Result := FALSE
        END
       ELSE IF StrToInt(Copy(Trim(CodBar), Length(CodBar), 1)) = 0 THEN
        Result := TRUE
       ELSE
        Result := FALSE;
    END;
end;

function CalculaDigEAN13(Cod:String):String;
function Par(Cod:Integer):Boolean;
begin
      Result:= Cod Mod 2 = 0 ;
end;

var
    i,
    SomaPar,
    SomaImpar:Integer;
begin
     SomaPar:=0;
     SomaImpar:=0;
     for i:=1 to 12 do
       if Par(i) then
          SomaPar:=SomaPar+StrToInt(Cod[i])
       else
          SomaImpar:=SomaImpar+StrToInt(Cod[i]);
      SomaPar:=SomaPar*3;
      i:=0;
      while i < (SomaPar+SomaImpar) do
        Inc(i,10);
      Result:=IntToStr(i-(SomaPar+SomaImpar));
end;

function Repete(Caractere: char; nCaracteres: integer): string;
var n : integer; CadeiaCar : string;
begin
   CadeiaCar := '';
   for n := 1 to nCaracteres do CadeiaCar := CadeiaCar + Caractere;
   Result := CadeiaCar;
end;

procedure Enabled_False_DBEdit(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TDBEdit
        then TDBEdit(xForm.Components[i]).Enabled:=False;
end;

procedure Enabled_True_DBEdit(xForm:TForm);
var
   i : Integer;
begin
     for i := 0 to xForm.ComponentCount -1
     do if xForm.Components[i] is TDBEdit
        then TDBEdit(xForm.Components[i]).Enabled:=True;
end;

function RetiraArgumento(Retirar,Argumento:string):string;
var
  Auxarg,Aux:string;
  numero:integer;
begin
 Auxarg := Argumento;
 numero := pos(Retirar,Auxarg);
 if numero > 0 then
  begin
   aux := copy(Auxarg,0,numero -1);
   while numero > 0 do
    begin
     Auxarg := copy(Auxarg,numero + 1,255);
     numero := pos(Retirar, Auxarg);
     aux := aux+copy(Auxarg, 0, numero -1);
   end;
   aux := aux+copy(Auxarg, 0, 255);
   result := aux;
  end
  else
   result := Argumento;
end;

function RemoveCaractesresEspeciais(valor:string):String;
begin
 valor := RetiraArgumento('(',valor);
 valor := RetiraArgumento(')',valor);
 valor := RetiraArgumento(',',valor);
 valor := RetiraArgumento('.',valor);
 valor := RetiraArgumento('/',valor);
 valor := RetiraArgumento('\',valor);
 valor := RetiraArgumento('-',valor);
 valor := RetiraArgumento(' ',valor);
 Result := valor;
end;

function RetiraCaracteresEspeciais(valor:string):String;
begin
 valor := RetiraArgumento(',',valor);
 valor := RetiraArgumento('.',valor);
 valor := RetiraArgumento('-',valor);
 valor := RetiraArgumento('/',valor);
 valor := RetiraArgumento('\',valor);
 valor := RetiraArgumento('=',valor);
 Result := valor;
end;

//--- Remove caracteres invalidos de uma ShortString ---
//Usage: "NotToRemoveStr" is the Char Array NOT to be removed, "FromStr" is the ShortString to be removed from
Function RemoveInvalid(NotToRemoveStr: String; FromStr: String): ShortString; 
var
 TempStr: String;
 Res: ShortString;
 x: Byte;
begin
 TempStr := UpperCase(FromStr);
 Res := '';
 for x := 1 to Length(TempStr)  do
  begin
   if Pos(TempStr[x], NotToRemoveStr) <> 0 then
    Res := Res + FromStr[x];
  end;
 Result := Res;
end;

//------ Preenche ShortString com caracter de Enchimento at� o tamanho indicado ------
//Caracter de enchimento num�rico
Function NumStuff(Str: ShortString; Tamanho: Byte): ShortString;
const
 NumStuffChar: ShortString = '0';
begin
 Result := '';
 If (Tamanho = 0) then
  Exit;

 while length(Str) < Tamanho do
  Str := NumStuffChar + Str;
 Result := Str;
end;

//------ Tratamento de ShortString (Retira caracteres invalidos, trunca e preenche espa�os) ------
//NumArray = quais os caracteres v�lidos como num�ricos
Procedure FormatoNum(var Str: ShortString; Tamanho: Byte);
begin
 If (Tamanho = 0) then
  begin
   Str := '';
   Exit;
  end;
 Str := RemoveInvalid(NumArray, Str);
 Str := Copy(Str, 0, Tamanho);
 Str := NumStuff(Str, Tamanho);
 SetLength(Str, Tamanho);
end;

procedure ForceForegroundWindow(hwnd: THandle);
var
  hlp: TForm;
begin
  hlp := TForm.Create(nil);
  try
    hlp.BorderStyle := bsNone;
    hlp.SetBounds(0, 0, 1, 1);
    hlp.FormStyle := fsStayOnTop;
    hlp.Show;
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    SetForegroundWindow(hwnd);
  finally
    hlp.Free;
  end;
end;

Procedure CopiaRegistroTabela(TabelaOrigem, TabelaDestino: TClientDataSet; xCod_Reducao_PDV : Integer);
var
   i : Integer;
begin
     With TabelaOrigem
     do begin
        TabelaDestino.Close;
        TabelaDestino.Params[0].AsInteger:=-1;
        TabelaDestino.Open;
        TabelaDestino.Append;
        {Inicia um contador para os campos da TabelaOrig}
        for i := 0 to FieldCount -1
        do if (not Fields[i].IsNull)
        then begin
             if I > 0 //Ou seja eu n�o copio o c�digo da tabela, deixa por conta do generator
             then begin
                  TabelaDestino.Fields[i].Assign(Fields[i]);
                  TabelaDestino.FieldByName('COD_REDUCAO_PDV').Value:=xCod_Reducao_PDV;
                  end;
             end;
        TabelaDestino.ApplyUpdates(-1);
        end; {end with}
end;

function RetornaDataString(Data:string):string;
var
 Dia,Mes,Ano:string;
begin
 Dia := Copy(Data,0,2);
 Mes := Copy(Data,4,2);
 Ano := Copy(Data,7,8);
 Result := Ano+Mes+Dia;
end;

function AjustaInteiro(inteiro:String;tam:integer) : String;
begin
 Result := '';
 while length(inteiro) < tam do
  inteiro := '0'+inteiro;
  if Length(inteiro) > tam then inteiro := Copy(inteiro,1,tam);
  Result := inteiro;
end;

function AjustaNumerico(VlrMoeda: Currency; tam: Integer) : String;
var
 sVlr: String;
begin
 if Pos(',',CurrToStr(VlrMoeda)) > 0 then
  sVlr := RetiraArgumento(',', FormatFloat('000000000.00', VlrMoeda))
 else sVlr := CurrToStr(VlrMoeda) + '00';
 while Length(sVlr) < tam do sVlr := '0'+sVlr;
 if Length(sVlr) > tam then  sVlr := Copy(sVlr,1,tam);
 Result := sVlr;
end;

Procedure Apaga_todos_arquivos_diretorio(vMasc:String);
Var Dir : TsearchRec;
Erro: Integer;
Begin
  Erro := FindFirst(vMasc,faArchive,Dir);
  While Erro = 0 do Begin
    DeleteFile( ExtractFilePAth(vMasc)+Dir.Name );
    Erro := FindNext(Dir);
  End;
  FindClose(Dir);
End;

//aQuant - Significa quantos caracteres gerar
function GeraSenha (aQuant: integer): string ;
var
  i: integer;
const
  str = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
begin
  for i:= 1 to aQuant do
  begin
    Randomize;
    Result := Result + str[Random(Length(str))+1];
  end ;
end;

Function ContaLetras(Texto:String):Integer;
var
PS: PChar;
NEspaco,N,T : integer;
begin
  N    := 0;
  T    := 0;
  Texto:= Texto + #0;
  PS   := @Texto[1];
    while( #0 <> PS^ ) do begin
      while((' ' = PS^)and(#0 <> PS^)) do begin
        Inc( PS );
        Inc(T);
      end;
    NEspaco := 0;
      while((' ' <> PS^)and(#0 <> PS^))do begin
        Inc(NEspaco);
        Inc(PS);
        Inc(T);
      end;
    If ( nEspaco > 0 ) then begin
      Inc( n );
    end;
end;
Result:= T;
end;

function AjustaStr(str: String; tam: Integer): String;
//Funcao que completa a string com espacos em branco
begin
 while Length ( str ) < tam do
  str := str + ' ';
  if Length ( str ) > tam then
   str := Copy ( str, 1, tam );
   Result := str;
end;

function IsImPar(TestaInteiro : Integer) : boolean;
begin
if (TestaInteiro div 2) = (TestaInteiro/2) then
   begin
   result := False;
   end
else
   begin
   result := True;
   end;
end;


end.
