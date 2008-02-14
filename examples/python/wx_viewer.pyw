#!/usr/bin/env python


# import wxWidgets stuff
import wx
import wx.glcanvas


# we need to patch in our own directory
import sys,os
sys.path.append('../../bin/python')

# import OpenSceneGraph wrapper
import osg
import osgUtil
import osgDB


ID_OPENURI = wx.NewId()
ID_CLEAR = wx.NewId()

class MyCanvas(wx.glcanvas.GLCanvas):

	def __init__(self,parent,id):
		wx.glcanvas.GLCanvas.__init__(self,parent,id)

		sv = self.sceneview = osgUtil.SceneView()

		self.rootnode = osg.MatrixTransformRef(osg.MatrixTransform())
		
		sv.setSceneData(self.rootnode.get())

		x,y = self.GetClientSize()

		self.oldX = 0
		self.oldY = 0

		sv.setDefaults()

		self.Bind(wx.EVT_SIZE, self.OnSize)
		self.Bind(wx.EVT_PAINT, self.OnPaint)
		self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)
		self.Bind(wx.EVT_ENTER_WINDOW, self.OnEnterWindow)
		self.Bind(wx.EVT_MOUSE_EVENTS, self.OnMouse)

		sv.init()


	def OpenFile(self, filename):

		self.rootnode.addChild( osgDB.readNodeFile( filename.encode( 'ascii', 'replace' ) ) )

		self.Refresh(False)


	def OnMouse(self, evt):
		if ((evt.Dragging() == True) and (evt.LeftIsDown() == True)) :

			x = evt.GetX() - self.oldY
			y = evt.GetY() - self.oldY

			self.sceneview.setViewMatrixAsLookAt(osg.Vec3f(0,y,x),
				osg.Vec3f(0,0,0),
				osg.Vec3f(0,1,0))

			self.Refresh(False)

			self.oldX = evt.GetX()
			self.oldY = evt.GetY()


		if ((evt.Dragging() == True) and (evt.RightIsDown() == True)) :
			m = self.rootnode.getMatrix()

			x,y = self.GetClientSize()

			rot = osg.Matrixd()

			rot.makeRotate(self.oldX - evt.GetX(), osg.Vec3f(1,0,0))
			
			m.postMult(rot)

			self.Refresh(False)

			self.oldX = evt.GetX()
			self.oldY = evt.GetY()
			
	def Clear(self):

		self.rootnode.removeChild(0,self.rootnode.getNumChildren())

		self.Refresh(False)


	def OnEnterWindow(self, evt):
		self.SetFocus()

	def OnEraseBackground(self, evt):
		pass

	def OnSize(self, evt):

		x,y = self.GetClientSize()

		self.SetCurrent()

		self.sceneview.setViewport(0,0,x,y)		

		evt.Skip()


	def OnPaint(self, evt):

		if (0 == self.GetContext()) :
			return

		dc = wx.PaintDC(self)

		self.SetCurrent()

		self.sceneview.update()

		self.sceneview.cull()

		self.sceneview.draw()

		self.SwapBuffers()


class MainWindow(wx.Frame):
    """ We simply derive a new class of Frame. """
    def __init__(self,parent,id, title):
        wx.Frame.__init__(self,parent,wx.ID_ANY,title,size=(400,300),
                  style=wx.DEFAULT_FRAME_STYLE|wx.FULL_REPAINT_ON_RESIZE)

        filemenu = self.filemenu = wx.Menu()

        filemenu.Append(wx.ID_OPEN,'&Open\tCtrl-O', 'Open another scene file')
        filemenu.Append(ID_OPENURI,'&Open URI', 'Open a scene file from an URI')

        filemenu.AppendSeparator()

        filemenu.Append(wx.ID_EXIT,'E&xit\tCtrl-Q', 'Exit this program.')
        
        
        scenemenu = self.scenemenu = wx.Menu()
        
        scenemenu.Append(ID_CLEAR, 'Reset View', 'Reset the viewer.')

        aboutmenu = self.aboutmenu = wx.Menu()

        aboutmenu.Append(wx.ID_ABOUT, 'About\tF1', 'About this program.')

        mbar = self.menuBar = wx.MenuBar()

        mbar.Append(self.filemenu, '&File')
        mbar.Append(self.scenemenu, 'S&cene')
        mbar.Append(self.aboutmenu, 'Help')

        self.SetMenuBar(mbar)

        self.CreateStatusBar()

        self.canvas = MyCanvas(self,wx.ID_ANY)

        self.Bind(wx.EVT_MENU, self.OnExit, id=wx.ID_EXIT)
        self.Bind(wx.EVT_MENU, self.OnAbout, id=wx.ID_ABOUT)
        self.Bind(wx.EVT_MENU, self.OnOpen, id=wx.ID_OPEN)
        self.Bind(wx.EVT_MENU, self.OnOpenURI, id=ID_OPENURI)
        self.Bind(wx.EVT_MENU, self.OnClear, id=ID_CLEAR)


    def OnOpen(self, evt):
    	
    	fdiag = wx.FileDialog(self, 'Open a Scene', 
    		os.getcwd() , '' , 
    		'OpenSceneGraph Files (*.osg)|*.osg|All Files (*.*)|*.*')

    	if (wx.ID_OK == fdiag.ShowModal()):

        	self.canvas.OpenFile(fdiag.GetPath())

    def OnOpenURI(self, evt):

    	s = wx.GetTextFromUser('Open a scene from an URI', 'Open URI')
    	
    	self.canvas.OpenFile(s)
    	
    def OnClear(self, evt):
    	
    	self.canvas.Clear()
    	
    	evt.Skip()



    def OnExit(self, evt):
    	self.Close(False)

    def OnAbout(self, evt):

		title = 'About'
		text = 'Python ' + sys.version + '\nwxPython ' + wx.VERSION_STRING +  '\n' + osg.osgGetLibraryName() + ' ' + osg.osgGetVersion()
		dialog = wx.MessageDialog(self, text, title, wx.OK | wx.ICON_INFORMATION)
		dialog.ShowModal()
		dialog.Destroy()



class MyApp(wx.App):

	def OnInit(self):
		self.frame = MainWindow(None,-1,'wxWidgets and OpenSceneGraph')

		self.frame.Show(True)

		return True


myapp = MyApp(0)
myapp.MainLoop()
