#
#Copyright (c) 1993-1997, Silicon Graphics, Inc.
#ALL RIGHTS RESERVED 
#Permission to use, copy, modify, and distribute this software for 
#any purpose and without fee is hereby granted, provided that the above
#copyright notice appear in all copies and that both the copyright notice
#and this permission notice appear in supporting documentation, and that 
#the name of Silicon Graphics, Inc. not be used in advertising
#or publicity pertaining to distribution of the software without specific,
#written prior permission. 
#
#THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
#AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
#INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
#FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
#GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
#SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
#KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
#LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
#THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
#ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
#ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
#POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
#
#US Government Users Restricted Rights 
#Use, duplication, or disclosure by the Government is subject to
#restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
#(c)(1)(ii) of the Rights in Technical Data and Computer Software
#clause at DFARS 252.227-7013 and/or in similar or successor
#clauses in the FAR or the DOD or NASA FAR Supplement.
#Unpublished-- rights reserved under the copyright laws of the
#United States.  Contractor/manufacturer is Silicon Graphics,
#Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
#
#OpenGL(R) is a registered trademark of Silicon Graphics, Inc.
#

#
#hello.c
#This is a simple, introductory OpenGL program.
#
require "opengl"
require "glut"
display = Proc.new {
   GL.Clear (GL::COLOR_BUFFER_BIT);

   GL.Color(1.0, 1.0, 1.0);
   GL.Begin(GL::POLYGON);
      GL.Vertex(0.25, 0.25, 0.0);
      GL.Vertex(0.75, 0.25, 0.0);
      GL.Vertex(0.75, 0.75, 0.0);
      GL.Vertex(0.25, 0.75, 0.0);
   GL.End();

   GL.Flush();
}

def init
   GL.ClearColor(0.0, 0.0, 0.0, 0.0);

   GL.MatrixMode(GL::PROJECTION);
   GL.LoadIdentity();
   GL.Ortho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
end

   GLUT.Init
   GLUT.InitDisplayMode(GLUT::SINGLE | GLUT::RGB);
   GLUT.InitWindowSize(250, 250); 
   GLUT.InitWindowPosition(100, 100);
   GLUT.CreateWindow("hello");
   init();
   GLUT.DisplayFunc(display); 
   GLUT.MainLoop();
