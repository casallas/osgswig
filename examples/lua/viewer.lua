--
-- example implementation for an OpenSceneGraph Viewer
--

-- extend the library search path
package.cpath = '../../bin/lua/?.so;../../bin/lua/?.dll;' .. package.cpath


-- load all required libraries
require 'wosg'
require 'wosgDB'
require 'wosgProducer'

-- create an empty table
viewer = {}


viewer.init = function()

	-- create instance of a viewer
	viewer.v = wosgProducer.Viewer()

	-- set default settings
	viewer.v:setUpViewer(wosgProducer.STANDARD_SETTINGS)

	-- create a root node
	viewer.r = wosg.Group()

	-- load a database file
	node = wosgDB.readNodeFile("cow.osg")

	-- add child to root
	viewer.r:addChild(node)

	-- add the root node to the viewer
	viewer.v:setSceneData(viewer.r)

end


viewer.run = function()

	-- create a viewer
	viewer.v:realize()

	-- run until the viewer manipulator does quit (ESC)
	while viewer.v:done() ~= true do

		-- sync the viewer
		viewer.v:sync()

		-- update the scenegraph
		viewer.v:update()

		-- call the renderer
		viewer.v:frame()
	end
end

-- run the example
viewer.init()
viewer.run()




