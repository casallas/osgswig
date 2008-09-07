#!/usr/bin/env python

''' Example to use osgViewer.Viewer within wxPython

	based on code from Silvano Imboden

'''

# general Python
import sys,os


# import wxWidgets stuff
import wx
import wx.glcanvas

# import OpenSceneGraph wrapper
import osg, osgDB, osgGA, osgViewer


class GraphicsWindowWX(wx.glcanvas.GLCanvas):
	def __init__(self,parent,id,x,y,width,height):
		style = wx.WANTS_CHARS | wx.FULL_REPAINT_ON_RESIZE
		wx.glcanvas.GLCanvas.__init__(self,parent,id,wx.DefaultPosition,wx.DefaultSize,style)

		width,height = self.GetClientSize()

		self.viewer = osgViewer.Viewer()

		self.viewer.setThreadingModel(osgViewer.Viewer.SingleThreaded)
		self.viewer.addEventHandler(osgViewer.StatsHandler())		
		self.viewer.setCameraManipulator(osgGA.TrackballManipulator())

		self.graphicswindow = self.viewer.setUpViewerAsEmbeddedInWindow(0,0,width,height)

		if self.graphicswindow.valid():

			self.old_cursor = wx.STANDARD_CURSOR

			self.Bind(wx.EVT_SIZE, self.OnSize)
			self.Bind(wx.EVT_PAINT, self.OnPaint)
			self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)

			self.Bind(wx.EVT_KEY_DOWN, self.OnKeyDown)
			self.Bind(wx.EVT_KEY_UP, self.OnKeyUp)
			self.Bind(wx.EVT_MOUSE_EVENTS, self.OnMouse)

	def OnPaint(self, evt):
		wx.PaintDC(self)
		
		if (not self.GetContext() or not self.graphicswindow.valid()):
			return

		self.SetCurrent()
		self.viewer.frame()
		self.SwapBuffers()
			 
		
	def OnSize(self,evt):

		w,h = self.GetClientSize()

		if self.GetParent().IsShown():
			self.SetCurrent()

		if self.graphicswindow.valid():
			self.graphicswindow.getEventQueue().windowResize(0, 0, w, h)
			self.graphicswindow.resized(0,0,w,h)

		evt.Skip()


	def OnEraseBackground(self,evt):
		pass

	def GetConvertedKeyCode(self,evt):
		"""in wxWidgets, key is always an uppercase
		   if shift is not pressed convert to lowercase
		"""
		key = evt.GetKeyCode()
		if key >=ord('A') and key <= ord('Z'):
			if not evt.ShiftDown():
				key += 32
		return key

	def OnKeyDown(self,evt):
		key = self.GetConvertedKeyCode(evt)
		self.graphicswindow.getEventQueue().keyPress(key)
		evt.Skip()

	def OnKeyUp(self,evt):		
		key = self.GetConvertedKeyCode(evt)
		self.graphicswindow.getEventQueue().keyRelease(key)
		evt.Skip()
	

	def OnMouse(self,event):
		if (event.ButtonDown()):
			button = event.GetButton()
			self.graphicswindow.getEventQueue().mouseButtonPress(event.GetX(), event.GetY(), button)
		elif (event.ButtonUp()):
			button = event.GetButton()
			self.graphicswindow.getEventQueue().mouseButtonRelease(event.GetX(), event.GetY(), button)
		elif (event.Dragging()):
			self.graphicswindow.getEventQueue().mouseMotion(event.GetX(), event.GetY())
			pass
		event.Skip()


class MainWindow(wx.Frame):
	""" We simply derive a new class of Frame. """
	def __init__(self,parent,id, title):
		wx.Frame.__init__(self,parent,wx.ID_ANY,title,size=(400,300),
				  style=wx.DEFAULT_FRAME_STYLE|wx.FULL_REPAINT_ON_RESIZE)

		filemenu = self.filemenu = wx.Menu()
		filemenu.Append(wx.ID_OPEN, '&Open\tAlt-O', 'Open a 3D file.')
		filemenu.AppendSeparator()
		filemenu.Append(wx.ID_EXIT, 'E&xit\tCtrl-Q', 'Exit this program.')

		aboutmenu = self.aboutmenu = wx.Menu()
		aboutmenu.Append(wx.ID_ABOUT, 'About\tF1', 'About this program.')

		mbar = self.menuBar = wx.MenuBar()

		mbar.Append(self.filemenu, '&File')
		mbar.Append(self.aboutmenu, 'Help')

		self.SetMenuBar(mbar)

		width,height = self.GetClientSize()

		self.canvas = GraphicsWindowWX(self,wx.ID_ANY,0,0,width,height)

		self.Bind(wx.EVT_MENU, self.OnExit, id=wx.ID_EXIT)
		self.Bind(wx.EVT_MENU, self.OnAbout, id=wx.ID_ABOUT)
		self.Bind(wx.EVT_MENU, self.OnOpen, id=wx.ID_OPEN)
		self.Bind(wx.EVT_IDLE, self.OnIdle)
		
		self.CreateStatusBar()

	def OnOpen(self, evt):
		dlg = wx.FileDialog(self, 'Open a Scene', '' , '' , 
			'OpenSceneGraph Files (*.osg,*.ive)|*.osg;*.ive|All Files (*.*)|*.*')
		if wx.ID_OK == dlg.ShowModal():
			#node = osgDB.readNodeFile(dlg.GetPath().encode())
			node = osgDB.readNodeFile('cow.osg')
			wx.LogStatus("Loading" + dlg.GetPath())
			self.canvas.viewer.setSceneData(node)
			
	def OnIdle(self, evt):
		self.canvas.Refresh()
		evt.RequestMore()
		

	def OnExit(self, evt):
		self.Close(False)

	def OnAbout(self, evt):
		title = 'About'
		text = 'Python ' + sys.version + '\nwxPython ' + wx.VERSION_STRING +  '\n' + osg.osgGetLibraryName() + ' ' + osg.osgGetVersion()
		dialog = wx.MessageDialog(self, text, title, wx.OK | wx.ICON_INFORMATION)
		dialog.ShowModal()
		dialog.Destroy()


class osgviewerWX(wx.App):

	def OnInit(self):
		self.frame = MainWindow(None,-1,'wxPython and OpenSceneGraph')

		# needed for python
		osgDB.setLibraryFilePathList(sys.path)
		
		self.frame.Show(True)
		
		

		return True


thewxOSG = osgviewerWX(0)
thewxOSG.MainLoop()




