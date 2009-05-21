%module osgVRPN

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


%{

#include <osgVRPN/Version>
#include <osgVRPN/Export>
#include <osgVRPN/Analog.h>
#include <osgVRPN/TrackerBase.h>
#include <osgVRPN/AnalogTracker.h>
#include <osgVRPN/Button.h>
#include <osgVRPN/Tracker.h>
#include <osgVRPN/TrackerManipulator.h>
#include <osgVRPN/TrackerTransform.h>

%}

%inline{
	
	
namespace osgVRPN {
	void setTrackerRaw(osgVRPN::TrackerTransform* transform,osgVRPN::Tracker* tracker) {
		transform->setTracker(tracker);
	}
};

}

%define OSG_EXPORT
%enddef
%define OSGVRPN_EXPORT
%enddef

void osgVRPN::setTrackerRaw(osgVRPN::TrackerTransform* transform,osgVRPN::Tracker* tracker);

%template(TrackerRef) osg::ref_ptr<osgVRPN::Tracker>;


%include osg/ref_ptr
%include osgVRPN/Version
%include osgVRPN/Export
%include osgVRPN/Analog.h
%include osgVRPN/TrackerBase.h
%include osgVRPN/Button.h
%include osgVRPN/Tracker.h
%include osgVRPN/TrackerManipulator.h
%include osgVRPN/TrackerTransform.h
