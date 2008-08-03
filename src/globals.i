#ifdef SWIGPYTHON
%feature("autodoc", "1");
#endif

%include "std_vector.i"
%include "std_string.i"

//#define OSGSWIGDEBUG

%runtime %{
// Runtime fix

// only for Ruby needed
#ifdef SWIGRUBY

#if defined(_MSC_VER)
#pragma warning(disable: 4312) // no warning for type casts
#endif

#undef accept
#undef bind
#undef sleep
#undef connect
#undef listen
#undef shutdown
#undef close
#undef write
#undef read
#undef allocate
#endif

%}

%header %{
   // Header Fix
%}


%wrapper %{
   // Wrapper Fix
%}

%init %{
   // Init Fix
%}
