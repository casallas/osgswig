#
# Demonstation for Ruby
#

# extend the load path for wosg
$LOAD_PATH << '../../bin/ruby'


# include all necessary libs
require 'wosg'
require 'wosgDB'
require 'wosgProducer'
require 'wosgART'

class Viewer

	def initialize()

    	# a producer
		@viewer = WosgProducer::Viewer.new

		# esc stops the viewer
		@viewer.setUpViewer(WosgProducer::Viewer::ESCAPE_SETS_DONE)

		# do not use near/far clipping
		@viewer.getCullSettings().setComputeNearFarMode(Wosg::CullSettings::DO_NOT_COMPUTE_NEAR_FAR)

		# configure the video
		cfg = WosgART::VideoConfiguration.new
		cfg.deviceconfig = "data/WDM_camera_flipv.xml"

		# create a video source
		@video = WosgART::VideoManager.createVideoFromPlugin("osgart_artoolkit",cfg)

		@video.open

		@tracker = WosgART::ARToolKitTracker.new

		WosgART::TrackerManager::getInstance().addTracker(@tracker)

		@tracker.init(@video.getWidth(),@video.getHeight())

		foreground = Wosg::Group.new
		foreground.getOrCreateStateSet().setRenderBinDetails(2, "RenderBin")

		vb = WosgART::VideoBackground.new(@video.getId())

		vb.init

		foreground.addChild(vb)

		projection = Wosg::Projection.new(Wosg::Matrixd.new(@tracker.getProjectionMatrix()))

		@marker_trans = WosgART::ARTTransform.new(0)

		@marker = @marker_trans.getMarker();

		@marker.setActive(true)

		@marker_trans.getOrCreateStateSet().setRenderBinDetails(5, "RenderBin")

		@marker_trans.addChild(WosgDB::readNodeFile("cow.osg"))

		modelview = Wosg::MatrixTransform.new

		modelview.addChild(foreground)

		foreground.addChild(@marker_trans)

		projection.addChild(modelview)

		# create a root node for the scene
		@root = Wosg::Group.new()

		@root.addChild(projection)

		@viewer.setSceneData(@root)

		@viewer.realize()

		@video.start

	end

	def run()

		while !@viewer.done()

			@viewer.sync

			@video.update

			@tracker.setImage(@video)
			@tracker.update

			@viewer.update

			@viewer.frame

		end

		@viewer.sync

		@viewer.cleanup_frame

		@video.stop

		@video.close


	end

end

v = Viewer.new
v.run
