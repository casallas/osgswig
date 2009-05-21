/**
 * Example for a simple viewer with the Java Wrapper for OpenSceneGraph
 */
import com.hitlab.wosg.*;

public class main {

    public static void main(String argv[]) {

        try {
			/** try to load JNI library */
            System.loadLibrary("../../../bin/java/wosg");
            System.loadLibrary("../../../bin/java/wosgProducer");
            System.loadLibrary("../../../bin/java/wosgDB");
            System.loadLibrary("../../../bin/java/wosgART");
            

        } catch (UnsatisfiedLinkError e) {

			/** An error occured while loading */
            System.err.println("Native code library failed to load. See the chapter on Dynamic Linking Problems in the SWIG Java documentation for help.\n" + e);
            System.exit(1);
        }

        Viewer viewer = new Viewer();
        viewer.setUpViewer(Viewer.ViewerOptions.ESCAPE_SETS_DONE.swigValue());

        viewer.getCullSettings().setComputeNearFarMode(CullSettings.ComputeNearFarMode.DO_NOT_COMPUTE_NEAR_FAR);

        Video video = new Video("data/WDM_camera.xml");
        VideoManager.getInstance().addVideoStream(video);

        video.open();

        Group foreground = new Group();

        ARToolKitTracker tracker = new ARToolKitTracker();

		TrackerManager.getInstance().addTracker(tracker);

		tracker.init(video.xSize(),video.ySize());

        VideoBackground background = new VideoBackground(video.getId());

		// foreground.getOrCreateStateSet().setRenderBinDetails(2, "RenderBin", StateSet.RenderBinMode.OVERRIDE_RENDERBIN_DETAILS);

		foreground.addChild(background);

        Projection projection = new Projection(new Matrixd(tracker.getProjectionMatrix()));

        projection.addChild(foreground);

		ARTTransform markerTrans = new ARTTransform(0);

		Marker marker = markerTrans.getMarker();

		marker.setActive(true);

        viewer.setSceneData(projection);

        Node cow = wosgDB.readNodeFile("cow.osg");

        // markerTrans.addChild(cow);

        // markerTrans.getOrCreateStateSet().setRenderBinDetails(5, "RenderBin", StateSet.RenderBinMode.OVERRIDE_RENDERBIN_DETAILS);

        // projection.addChild(markerTrans);

		video.start();

        viewer.realize();

        while (!viewer.done()) {

            viewer.sync();

            video.update();

            tracker.setImage(video);
            tracker.update();

            viewer.update();

            viewer.frame();

        }


	}
}
