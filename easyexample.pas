unit EasyExample;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, V8AddIn, fpTimer, FileUtil, LazUTF8;

type

  { TTimerThread }

  TTimerThread = class (TThread)
  public
    Interval: Integer;
    OnTimer: TNotifyEvent;
    procedure Execute; override;
  end;

  { TAddInEasyExample }

  TAddInEasyExample = class (TAddIn)
  private
    FNum : DWORD;
    FIsEnabled: Boolean;
    FTimer: TTimerThread;
    procedure MyTimerProc(Sender: TObject);
  public
    function GetIsEnabled: Variant;
    procedure SetIsEnabled(AValue: Variant);
    function GetIsTimerPresent: Variant;
    procedure Enable;
    procedure Disable;
    procedure ShowInStatusLine(Text: Variant);
    procedure StartTimer;
    procedure StopTimer;
    destructor Destroy; override;
    function LoadPicture(FileName: Variant): Variant;
    function ReadNumber(Params: Variant):Variant;
    // Test nums
    procedure WriteNumber(Number: Variant);
    procedure ShowMessageBox;
    // test arrays
    //procedure mLoadArrayList(ArrayList,ArraySize : Variant);
    //function mReturnArrayList(ArraySize : Variant):Variant;
  end;

implementation

{ TTimerThread }

procedure TTimerThread.Execute;
begin
  repeat
    Sleep(Interval);
    if Terminated then
      Break
    else
      OnTimer(Self);
  until False;
end;

{ TAddInEasyExample }

procedure TAddInEasyExample.MyTimerProc(Sender: TObject);
begin
  ExternalEvent('EasyComponentNative', 'Timer', DateTimeToStr(Now));
end;

function TAddInEasyExample.GetIsEnabled: Variant;
begin
  Result := FIsEnabled;
end;

procedure TAddInEasyExample.SetIsEnabled(AValue: Variant);
begin
  FIsEnabled := AValue;
end;

function TAddInEasyExample.GetIsTimerPresent: Variant;
begin
  Result := True;
end;

procedure TAddInEasyExample.Enable;
begin
  FIsEnabled := True;
end;

procedure TAddInEasyExample.Disable;
begin
  FIsEnabled := False;
end;

procedure TAddInEasyExample.ShowInStatusLine(Text: Variant);
begin
  SetStatusLine(Text);
end;

procedure TAddInEasyExample.StartTimer;
begin
  if FTimer = nil then
    begin
      FTimer := TTimerThread.Create(True);
      FTimer.Interval := 1000;
      FTimer.OnTimer := @MyTimerProc;
      FTimer.Start;
    end;
end;

procedure TAddInEasyExample.StopTimer;
begin
  if FTimer <> nil then
    FreeAndNil(FTimer);
end;

destructor TAddInEasyExample.Destroy;
begin
  if FTimer <> nil then
    FreeAndNil(FTimer);
  inherited Destroy;
end;

function TAddInEasyExample.LoadPicture(FileName: Variant): Variant;
var
  SFileName: String;
  FileStream: TFileStream;
begin
  SFileName := UTF8ToSys(String(FileName));
  FileStream := TFileStream.Create(SFileName, fmOpenRead);
  try
    Result := StreamTo1CBinaryData(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TAddInEasyExample.ShowMessageBox;
begin
  if Confirm(AppVersion) then
    Alert('OK')
  else
    Alert('Cancel');
end;

procedure TAddInEasyExample.WriteNumber(Number: Variant);
begin
     FNum := Number;
end;

function TAddInEasyExample.ReadNumber(Params: Variant):Variant;
begin
  Result := Variant(FNum);
end;


//procedure TAddInEasyExample.mLoadArrayList(ArrayList,ArraySize : Variant);
//var i : integer;
//begin
//  for i := 0 to ArraySize-1 do
//    SetStatusLine('Тип значения '  + IntToStr(i) + ' ' + ArrayList[i]);
//end;
//
//function TAddInEasyExample.mReturnArrayList(ArraySize : Variant):Variant;
//begin
//  Result := nil;
//end;

end.

