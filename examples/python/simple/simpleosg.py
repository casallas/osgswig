import osgViewer
import osgDB

viewer = osgViewer.Viewer()
loadedModel = osgDB.readNodeFile("cow.osg")
viewer.setSceneData(loadedModel)
viewer.addEventHandler(osgViewer.StatsHandler());
viewer.run()
