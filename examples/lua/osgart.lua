--
-- example implementation for an OpenSceneGraph and osgART
--

-- extend the library search path
package.cpath = '../../bin/lua/?.so;../../bin/lua/?.dll;' .. package.cpath

require 'wosg'
require 'wosgProducer'
require 'wosgDB'
require 'wosgART'

viewer = {}

viewer.init = function()

	-- create instance of a viewer
	viewer.v = wosgProducer.Viewer()


	-- set default settings
	viewer.v:setUpViewer(wosgProducer.ESCAPE_SETS_DONE)

	-- AR does not need far and near clipping
   	viewer.v:getCullSettings():setComputeNearFarMode(wosg.DO_NOT_COMPUTE_NEAR_FAR)

	-- create a root node
	viewer.root = wosg.Group()

	-- osgART, open a video feed
	viewer.video = wosgART.Video("data/WDM_camera.xml")

	-- add the video stream, please note that static members
	-- are accessible through classname_membername in lua
	wosgART.VideoManager_getInstance():addVideoStream(viewer.video)

	-- open the video feed
	viewer.video:open()

	-- tracker instance
	viewer.art = wosgART.ARToolKitTracker()

	wosgART.TrackerManager_getInstance():addTracker(viewer.art)

	viewer.art:init(viewer.video:xSize(), viewer.video:ySize())


	-- background
	viewer.background = wosgART.VideoBackground(viewer.video:getId())

	viewer.background:init()

	-- add the background
	viewer.root:addChild(viewer.background)

	-- change render mode
	viewer.background:getOrCreateStateSet():setRenderBinDetails(0, "RenderBin",	osg.OVERRIDE_RENDERBIN_DETAILS)

	-- Magic
	-- viewer.root:getOrCreateStateSet():setRenderBinDetails(2, "RenderBin", wosg.OVERRIDE_RENDERBIN_DETAILS)

	-- get the transform
	viewer.markertrans = wosgART.ARTTransform(0)

	-- get the actual marker
	viewer.marker = viewer.markertrans:getMarker()

	-- make it visible
	viewer.marker:setActive(true)

	-- note: osg.Matrix is osg.Matrixd (we are using double precision)
	viewer.projection = wosg.Projection(wosg.Matrixd(viewer.art:getProjectionMatrix()))

	-- modelview
	viewer.modelscene = wosg.MatrixTransform()

	-- viewer.modelscene:getOrCreateStateSet():setRenderBinDetails(5, "RenderBin",	wosg.OVERRIDE_RENDERBIN_DETAILS)

	-- read file
	viewer.cow = wosgDB.readNodeFile("cow.osg")


	-- add to the marker
	-- viewer.markertrans:addChild(viewer.cow)
	viewer.modelscene:addChild(viewer.markertrans)
	viewer.projection:addChild(viewer.modelscene)

   	viewer.root:addChild(viewer.projection)


	-- add the root node to the viewer
	viewer.v:setSceneData(viewer.root)

end


viewer.run = function()

	-- run now
	io.write("--\nRun Function\n")

	-- create a viewer
	viewer.v:realize()

	viewer.video:start()

	-- run until the viewer manipulator does quit (ESC)
	while viewer.v:done() ~= true do

		-- sync the viewer
		viewer.v:sync()

		-- check for new video images
		viewer.video:update()

		-- set the image (maintain pointer)
    	viewer.art:setImage(viewer.video)
    	viewer.art:update()

    	if viewer.marker:isValid() then
			io.write("Cow!\n")
			-- local matrix = osg.Matrixd(viewer.marker:getTransform())
		else
			io.write("Grass!\n")
		end

		-- update the scenegraph
		viewer.v:update()

		-- call the renderer
		viewer.v:frame()
	end
end


viewer.exit = function()

	io.write("--\nExit Function\n")

	viewer.video:stop()
	viewer.video:close()
	viewer.v:sync()
	viewer.v:cleanup_frame();
end

-- run the example
viewer.init()
viewer.run()
viewer.exit()




