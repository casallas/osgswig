%module(directors="1") osgViewer

#ifdef SWIGPERL
%{
#undef STATIC
#ifdef WIN32
#undef pause
#undef ERROR
#undef accept
#endif
%}
#endif

%include "globals.i"

%include osg_header.i
%include osgGA_header.i

/* import stuff from OpenSceneGraph */
%import osg.i
%import osgGA.i


%include osgViewer_header.i


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGVIEWER_EXPORT
%enddef


%feature("notabstract") osgViewer::GraphicsWindow;
%feature("notabstract") osgViewer::GraphicsWindowEmbedded;

%feature("director") osgViewer::GraphicsWindow::valid;
%feature("director") osgViewer::GraphicsWindow::realizeImplementation;
%feature("director") osgViewer::GraphicsWindow::isRealizedImplementation;
%feature("director") osgViewer::GraphicsWindow::closeImplementation;
%feature("director") osgViewer::GraphicsWindow::makeCurrentImplementation;
%feature("director") osgViewer::GraphicsWindow::releaseContextImplementation;
%feature("director") osgViewer::GraphicsWindow::swapBuffersImplementation;
%feature("director") osgViewer::GraphicsWindow::grabFocus;
%feature("director") osgViewer::GraphicsWindow::grabFocusIfPointerInWindow;

%feature("director") osgViewer::GraphicsWindowEmbedded::valid;
%feature("director") osgViewer::GraphicsWindowEmbedded::realizeImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::isRealizedImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::closeImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::makeCurrentImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::releaseContextImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::swapBuffersImplementation;
%feature("director") osgViewer::GraphicsWindowEmbedded::grabFocus;
%feature("director") osgViewer::GraphicsWindowEmbedded::grabFocusIfPointerInWindow;


%ignore osgViewer::CompositeViewer::getCameras;
%ignore osgViewer::CompositeViewer::getContexts;
%ignore osgViewer::CompositeViewer::getWindows;
%ignore osgViewer::CompositeViewer::getAllThreads;
%ignore osgViewer::CompositeViewer::getOperationThreads;
%ignore osgViewer::CompositeViewer::getScenes;
%ignore osgViewer::CompositeViewer::getViews;


/* include the actual headers */
%include osgViewer/Version
%include osgViewer/GraphicsWindow
%include osgViewer/Scene
%include osgViewer/Version
%include osgViewer/ViewerBase
%include osgViewer/View
%include osgViewer/Viewer
%include osgViewer/CompositeViewer
%include osgViewer/ViewerEventHandlers


%inline %{
osgViewer::Viewer *GUIActionAdapterToViewer(osgGA::GUIActionAdapter *aa) {
  return dynamic_cast<osgViewer::Viewer*>(aa);
}
%}

