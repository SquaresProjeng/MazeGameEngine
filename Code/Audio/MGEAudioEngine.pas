//////////////////////////////////////////////////////////////////
/////////  This Adaptation Bass.dll for MGE Engine  //////////////
//////////////////////////////////////////////////////////////////

unit MGEAudioEngine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Math, StdCtrls, Bass, ExtCtrls;


Type
  MGEAudioFile=HSTREAM;
  MGEPoint3D=record
    x,y,z:real;
  end;
  MGEAidioObject = record
    ObjPos,CamPos,CamOrient:MGEPoint3D;
    Audiofile:MGEAudioFile;
    Play,PlayLoop:boolean;

  end;


  MGEAudio= record
      AudioBuf:array of MGEAudioFile;
      AudioObject:array of MGEAidioObject;

    Private
      NB,NO:integer;
    public
      procedure LoadAB(Put:String);
      procedure CreateAudioObject(Put:String);
      procedure Free();
      procedure Play(ID:integer; Restart:boolean; PLX,PLY,PLZ:real); overload;
      procedure Play(YouAudio:MGEAudioFile; Restart:boolean); overload;
      procedure Stop(YouAudio:MGEAudioFile); overload;
      procedure Stop(ID:integer); overload;
      procedure ResetFunc(YouAudio:MGEAudioFile;bul:boolean); overload;
      procedure ResetFunc(ID:integer;bul:boolean); overload;
      procedure Pause();
  end;

Var
  MGETestAudio:boolean = true;
  pos,orien,dop:BASS_3DVECTOR;


procedure CheckAudioEngine();
procedure OpenMyFile(My:String; var ChanBuf:HSTREAM);
procedure LoopSyncProc(handle: HSYNC; channel, data: DWORD; user: Pointer); stdcall;
procedure UnLoopSyncProc(handle: HSYNC; channel, data: DWORD; user: Pointer); stdcall;

implementation

procedure CheckAudioEngine();
begin
	// check the correct BASS was loaded
 	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,'An incorrect version of BASS.DLL was loaded', nil, MB_ICONERROR);
		MGETestAudio:=false;
	end;
end;
procedure LoopSyncProc(handle: HSYNC; channel, data: DWORD; user: Pointer);
begin
		BASS_ChannelSetPosition(channel,0,BASS_POS_BYTE); // failed, go to start of file instead
end;
procedure UnLoopSyncProc(handle: HSYNC; channel, data: DWORD; user: Pointer);
begin
		BASS_ChannelSetPosition(channel,0,BASS_POS_RESET); // failed, go to start of file instead
end;
procedure MGEAudio.Free;
begin
  BASS_Free();
end;
procedure MGEAudio.LoadAB(Put:String);
begin
  Inc(NB);
  SetLength(AudioBuf,NB);
  OpenMyFile(Put,AudioBuf[NB-1]);
end;
procedure MGEAudio.CreateAudioObject(Put:String);
begin

end;
procedure MGEAudio.Play(ID:integer; Restart:boolean; PLX,PLY,PLZ:real);
begin
  if (ID<=NB) and (NB>0) and (AudioBuf[Id]<>0) then begin 
//orien,dop
    pos.x:=PLX;
      pos.y:=PLy;
      pos.z:=PLz;

      orien.x:=0;
      orien.y:=0;
      orien.z:=1;

      dop.x:=0;
      dop.y:=1;
      dop.z:=0;

     // BASS_ChannelSet3DPosition (AudioBuf[Id], &pos, &orien, &dop);
      BASS_Set3DPosition(&pos, &orien, &dop, &dop);
      BASS_ChannelSetAttribute(AudioBuf[Id],BASS_ATTRIB_VOL,0.1);
      BASS_ChannelPlay(AudioBuf[Id],Restart);
  end;
  end;
procedure MGEAudio.Play(YouAudio:MGEAudioFile; Restart:boolean);
begin
  if (YouAudio<>0) then BASS_ChannelPlay(YouAudio,Restart);
end;

procedure MGEAudio.Stop(YouAudio:MGEAudioFile);
begin
 if (YouAudio<>0) then BASS_ChannelStop(YouAudio);
end;
procedure MGEAudio.Stop(ID:integer);
begin
  if (ID<=NB) and (NB>0) and (AudioBuf[Id]<>0) then BASS_ChannelStop(AudioBuf[Id]);
end;

procedure MGEAudio.ResetFunc(YouAudio:MGEAudioFile;bul:boolean);
begin
 if (YouAudio<>0) then begin
 if (bul=true) then  BASS_ChannelSetSync(YouAudio,BASS_SYNC_END or BASS_SYNC_MIXTIME,0,LoopSyncProc, nil); // set sync to loop at end
 if (bul=false) then  BASS_ChannelSetSync(YouAudio,BASS_SYNC_END or BASS_SYNC_MIXTIME,1,UnLoopSyncProc, nil); // set sync to loop at end
 end;
end;
procedure MGEAudio.ResetFunc(ID:integer;bul:boolean);
begin
 if (ID<=NB) and (NB>0) and (AudioBuf[Id]<>0) then begin
 if (bul=true) then  BASS_ChannelSetSync(AudioBuf[Id],BASS_SYNC_END or BASS_SYNC_MIXTIME,0,LoopSyncProc, nil); // set sync to loop at end
 if (bul=false) then  BASS_ChannelSetSync(AudioBuf[Id],BASS_SYNC_END or BASS_SYNC_MIXTIME,1,UnLoopSyncProc, nil); // set sync to loop at end
 end;
end;
procedure MGEAudio.Pause;
begin

end;
procedure OpenMyFile(My:String; var ChanBuf:HSTREAM);
var
  filename : string;
begin
    filename := My;
    //creating stream
    ChanBuf := BASS_StreamCreateFile(FALSE,pchar(filename),0,0,0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
    if ChanBuf = 0 then
    begin
      ChanBuf := BASS_MusicLoad(False, pchar(filename), 0, 0, BASS_MUSIC_RAMPS or BASS_MUSIC_POSRESET or BASS_MUSIC_PRESCAN {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF}, 1);
      if (ChanBuf = 0) then
      begin
        Exit;
      end;
    end;
end;

end.
