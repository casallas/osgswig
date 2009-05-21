%module OpenThreads

%{

#include <OpenThreads\Version>
#include <OpenThreads\Exports>
#include <OpenThreads\Barrier>
#include <OpenThreads\Block>
#include <OpenThreads\Condition>

#include <OpenThreads\Thread>
#include <OpenThreads\Mutex>
#include <OpenThreads\ReadWriteMutex>
#include <OpenThreads\ReentrantMutex>
#include <OpenThreads\ScopedLock>

%}

%include OpenThreads\Version
%include OpenThreads\Exports
%include OpenThreads\Barrier
%include OpenThreads\Block
%include OpenThreads\Condition

%include OpenThreads\Thread
%include OpenThreads\Mutex
%include OpenThreads\ReadWriteMutex
%include OpenThreads\ReentrantMutex
%include OpenThreads\ScopedLock

