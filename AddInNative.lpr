library AddInNative;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX} {$IFDEF UseCThreads} cthreads, cmem, {$ENDIF} {$ENDIF}
  V8AddIn, EasyExample;

exports

  V8AddIn.GetClassNames, V8AddIn.GetClassObject, V8AddIn.DestroyObject, V8AddIn.SetPlatformCapabilities;

{$R *.res}

begin

  with TAddInEasyExample do
  begin
    RegisterAddInClass('BaseExt');
    AddFunc('LoadPicture','ЗагрузитьКартинку',@LoadPicture);
    AddProc('WriteNumber','ЗаписатьЧисло',@WriteNumber);
    AddFunc('ReadNumber','ПрочитатьЧисло',@ReadNumber);
  end;
end.

