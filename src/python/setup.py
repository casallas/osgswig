from setuptools import setup
setup(name='osgswig',
      version='3.0.0',
      description='Python OpenSceneGraph 3.0.0 Swig Bindings',
      packages=['osgswig'],
      package_dir={'osgswig': '.'},
      package_data={'osgswig': ['*.pyd','_*.so','./examples/*.py']},
      author='http://code.google.com/p/osgswig/people/list',
      url='http://code.google.com/p/osgswig',      
      )
