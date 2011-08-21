%module osgPPU

%include "globals.i"

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

%include osg_header.i

/* import stuff from OpenSceneGraph */
%import osg.i


%{
#include <osgPPU/BarrierNode.h>
#include <osgPPU/Camera.h>
#include <osgPPU/ColorAttribute.h>
#include <osgPPU/Config.h>
#include <osgPPU/Export.h>
#include <osgPPU/Processor.h>
#include <osgPPU/ShaderAttribute.h>
#include <osgPPU/Unit.h>
#include <osgPPU/UnitBypass.h>
#include <osgPPU/UnitCamera.h>
#include <osgPPU/UnitCameraAttachmentBypass.h>
#include <osgPPU/UnitDepthbufferBypass.h>
#include <osgPPU/UnitInHistoryOut.h>
#include <osgPPU/UnitInMipmapOut.h>
#include <osgPPU/UnitInOut.h>
#include <osgPPU/UnitInOutModule.h>
#include <osgPPU/UnitInOutRepeat.h>
#include <osgPPU/UnitInResampleOut.h>
#include <osgPPU/UnitMipmapInMipmapOut.h>
#include <osgPPU/UnitOut.h>
#include <osgPPU/UnitOutCapture.h>
#include <osgPPU/UnitText.h>
#include <osgPPU/UnitTexture.h>
#include <osgPPU/Utility.h>
#include <osgPPU/Visitor.h>
using osgPPU::Unit;
%}


%define OSG_EXPORT
%enddef
%define OSGPPU_EXPORT
%enddef

%include osgPPU/BarrierNode.h
%include osgPPU/Camera.h
%include osgPPU/ColorAttribute.h
%include osgPPU/Config.h
%include osgPPU/Export.h
%include osgPPU/Processor.h
%include osgPPU/ShaderAttribute.h
%include osgPPU/Unit.h
%include osgPPU/UnitBypass.h
%include osgPPU/UnitCamera.h
%include osgPPU/UnitCameraAttachmentBypass.h
%include osgPPU/UnitDepthbufferBypass.h
%include osgPPU/UnitInHistoryOut.h
%include osgPPU/UnitInMipmapOut.h
%include osgPPU/UnitInOut.h
%include osgPPU/UnitInOutModule.h
%include osgPPU/UnitInOutRepeat.h
%include osgPPU/UnitInResampleOut.h
%include osgPPU/UnitMipmapInMipmapOut.h
%include osgPPU/UnitOut.h
%include osgPPU/UnitOutCapture.h
%include osgPPU/UnitText.h
%include osgPPU/UnitTexture.h
%include osgPPU/Utility.h
//%include osgPPU/Visitor.h

%inline %{
osgPPU::Processor *NodeToProcessor(osg::Object *p) {
  return dynamic_cast<osgPPU::Processor*>(p);
}
%}
