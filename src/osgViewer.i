%module osgViewer

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
// %include osgViewer/HelpHandler
%include osgViewer/Scene
//%include osgViewer/SimpleViewer
// %include osgViewer/StatsHandler
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

