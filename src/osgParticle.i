%module osgParticle

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

/* import stuff from OpenSceneGraph */
%import osg.i


%{

#include <osgParticle/range>
#include <osgParticle/AccelOperator>
#include <osgParticle/AngularAccelOperator>
#include <osgParticle/BoxPlacer>
#include <osgParticle/CenteredPlacer>
#include <osgParticle/ConnectedParticleSystem>
#include <osgParticle/ConstantRateCounter>
#include <osgParticle/Counter>
#include <osgParticle/Emitter>
#include <osgParticle/ExplosionDebrisEffect>
#include <osgParticle/ExplosionEffect>
#include <osgParticle/Export>
#include <osgParticle/FireEffect>
#include <osgParticle/FluidFrictionOperator>
#include <osgParticle/FluidProgram>
#include <osgParticle/ForceOperator>
#include <osgParticle/Interpolator>
#include <osgParticle/LinearInterpolator>
#include <osgParticle/ModularEmitter>
#include <osgParticle/ModularProgram>
#include <osgParticle/MultiSegmentPlacer>
#include <osgParticle/Operator>
#include <osgParticle/Particle>
#include <osgParticle/ParticleEffect>
#include <osgParticle/ParticleProcessor>
#include <osgParticle/ParticleSystem>
#include <osgParticle/ParticleSystemUpdater>
#include <osgParticle/Placer>
#include <osgParticle/PointPlacer>
#include <osgParticle/PrecipitationEffect>
#include <osgParticle/Program>
#include <osgParticle/RadialShooter>
#include <osgParticle/RandomRateCounter>
#include <osgParticle/SectorPlacer>
#include <osgParticle/SegmentPlacer>
#include <osgParticle/Shooter>
#include <osgParticle/SmokeEffect>
#include <osgParticle/SmokeTrailEffect>
#include <osgParticle/VariableRateCounter>
#include <osgParticle/Version>

// using namespace osg;
using namespace osgParticle;


%}


/* remove the linkage macros */
%define OSG_EXPORT
%enddef
%define OSGPARTICLE_EXPORT
%enddef

// ignore nested stuff

%ignore osgParticle::CenteredPlacer


/* include the actual headers */
%include osgParticle/range
%include osgParticle/Shooter
%include osgParticle/Particle
%include osgParticle/Placer

%include osgParticle/AccelOperator
%include osgParticle/AngularAccelOperator
%include osgParticle/BoxPlacer
%include osgParticle/CenteredPlacer
%include osgParticle/ConnectedParticleSystem
%include osgParticle/ConstantRateCounter
%include osgParticle/Counter
%include osgParticle/Emitter
%include osgParticle/ExplosionDebrisEffect
%include osgParticle/ExplosionEffect
%include osgParticle/Export
%include osgParticle/FireEffect
%include osgParticle/FluidFrictionOperator
%include osgParticle/FluidProgram
%include osgParticle/ForceOperator
%include osgParticle/Interpolator
%include osgParticle/LinearInterpolator
%include osgParticle/ModularEmitter
%include osgParticle/ModularProgram
%include osgParticle/MultiSegmentPlacer
%include osgParticle/Operator
%include osgParticle/ParticleEffect
%include osgParticle/ParticleProcessor
%include osgParticle/ParticleSystem
%include osgParticle/ParticleSystemUpdater
%include osgParticle/PointPlacer
%include osgParticle/PrecipitationEffect
%include osgParticle/Program
%include osgParticle/RadialShooter
%include osgParticle/RandomRateCounter
%include osgParticle/SectorPlacer
%include osgParticle/SegmentPlacer
%include osgParticle/SmokeEffect
%include osgParticle/SmokeTrailEffect
%include osgParticle/VariableRateCounter
%include osgParticle/Version

