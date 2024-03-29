#/*
# * Copyright (c) 1993-1997, Silicon Graphics, Inc.
# * ALL RIGHTS RESERVED 
# * Permission to use, copy, modify, and distribute this software for 
# * any purpose and without fee is hereby granted, provided that the above
# * copyright notice appear in all copies and that both the copyright notice
# * and this permission notice appear in supporting documentation, and that 
# * the name of Silicon Graphics, Inc. not be used in advertising
# * or publicity pertaining to distribution of the software without specific,
# * written prior permission. 
# *
# * THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
# * AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
# * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
# * FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
# * GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
# * SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
# * KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
# * LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
# * THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
# * ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
# * ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
# * POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
# * 
# * US Government Users Restricted Rights 
# * Use, duplication, or disclosure by the Government is subject to
# * restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
# * (c)(1)(ii) of the Rights in Technical Data and Computer Software
# * clause at DFARS 252.227-7013 and/or in similar or successor
# * clauses in the FAR or the DOD or NASA FAR Supplement.
# * Unpublished-- rights reserved under the copyright laws of the
# * United States.  Contractor/manufacturer is Silicon Graphics,
# * Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
# *
# * OpenGL(R) is a registered trademark of Silicon Graphics, Inc.
# */
#
#/*
# *  clip.c
# *  This program demonstrates arbitrary clipping planes.
# */

require "opengl"
require "glut"
require "mathn"

def init
   GL.ClearColor(0.0, 0.0, 0.0, 0.0);
   GL.ShadeModel(GL::FLAT);
end

display = Proc.new {
   eqn = [0.0, 1.0, 0.0, 0.0];
   eqn2 = [1.0, 0.0, 0.0, 0.0];

   GL.Clear(GL::COLOR_BUFFER_BIT);

   GL.Color(1.0, 1.0, 1.0);
   GL.PushMatrix();
   GL.Translate(0.0, 0.0, -5.0);

# /*    clip lower half -- y < 0          */
   GL.ClipPlane(GL::CLIP_PLANE0, eqn);
   GL.Enable(GL::CLIP_PLANE0);
# /*    clip left half -- x < 0           */
   GL.ClipPlane(GL::CLIP_PLANE1, eqn2);
   GL.Enable(GL::CLIP_PLANE1);

   GL.Rotate(90.0, 1.0, 0.0, 0.0);
   GLUT.WireSphere(1.0, 20, 16);
   GL.PopMatrix();

   GL.Flush();
}

reshape = Proc.new {|w, h|
   GL.Viewport(0, 0,  w,  h); 
   GL.MatrixMode(GL::PROJECTION);
   GL.LoadIdentity();
   GLU.Perspective(60.0,  w/ h, 1.0, 20.0);
   GL.MatrixMode(GL::MODELVIEW);
}

# /* ARGSUSED1 */
keyboard = Proc.new {|key, x, y|
   case (key)
      when 27
         exit(0);
   end
}

#int main(int argc, char** argv)
#{
   GLUT.Init
   GLUT.InitDisplayMode(GLUT::SINGLE | GLUT::RGB);
   GLUT.InitWindowSize(500, 500); 
   GLUT.InitWindowPosition(100, 100);
   GLUT.CreateWindow($0);
   init();
   GLUT.DisplayFunc(display); 
   GLUT.ReshapeFunc(reshape);
   GLUT.KeyboardFunc(keyboard);
   GLUT.MainLoop();
