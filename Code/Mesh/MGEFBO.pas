unit MGEFBO;

interface
uses
  DglOpenGL, DGLUT, SysUtils, Variants, Dialogs, Textures;

var

  fbo,fbo2:         GluInt;
  depthbuffer,depthbuffer2: GluInt;
  tex,tex2,tex3:         GluInt;

procedure CheckFBO;
procedure InitFBO;

implementation
uses GUI, GUIunit;


procedure CheckFBO;
var
  error: GlEnum;
begin
  error := glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
  case error of
    GL_FRAMEBUFFER_COMPLETE_EXT:
      Exit;
    GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT:
      raise Exception.Create('Incomplete attachment');
    GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT:
      raise Exception.Create('Missing attachment');
    GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT:
      raise Exception.Create('Incomplete dimensions');
    GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT:
      raise Exception.Create('Incomplete formats');
    GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT:
      raise Exception.Create('Incomplete draw buffer');
    GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT:
      raise Exception.Create('Incomplete read buffer');
    GL_FRAMEBUFFER_UNSUPPORTED_EXT:
      raise Exception.Create('Framebufferobjects unsupported');
  end;
end;

procedure InitFBO;
begin
  glGenFramebuffersEXT(1, @fbo);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);
  glGenRenderbuffersEXT(1, @depthbuffer);
  glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer);
  glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT,  FMW ,  FMH);
  glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer);

  glGenTextures(1, @tex);
  glBindTexture(GL_TEXTURE_2D, tex);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB,   FMW ,  FMH, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, tex, 0);

  glGenTextures(1, @tex2);
  glBindTexture(GL_TEXTURE_2D, tex2);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,   FMW ,  FMH, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT1_EXT, GL_TEXTURE_2D, tex2, 0);

//////-----------*****************************************************

  glGenFramebuffersEXT(1, @fbo2);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo2);
  glGenRenderbuffersEXT(1, @depthbuffer2);
  glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer2);
  glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT,  FMW ,  FMH);
  glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer2);

  glGenTextures(1, @tex3);
  glBindTexture(GL_TEXTURE_2D, tex3);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB,   FMW ,  FMH, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, tex3, 0);

  CheckFBO;
end;

end.
