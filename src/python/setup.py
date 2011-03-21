from distutils.core import setup
setup(name='osgswig',
      version='0.3.0',
      description='Python OpenSceneGraph 2.8.3 Swig Bindings',
      #py_modules=['osg', 'osgAnimation', 'osgDB', 'osgFX', 'osgGA', 'osgManipulator', 'osgSim', 'osgText', 'osgUtil', 'osgViewer'],
      packages=['osgswig'],
      package_dir={'osgswig': ''},
      package_data={'osgswig': ['*.py', '*.pyd']},      
      author='http://code.google.com/p/osgswig/people/list',
      url='http://code.google.com/r/megamillerzoid-stable-osg/',      
      )
