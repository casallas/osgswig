/**
 * Example for a simple viewer with the Java Wrapper for OpenSceneGraph
 */

import com.hitlab.wosg.*;

public class main {

    public static void main(String argv[]) {

        try {

            System.loadLibrary("../../../bin/java/wosg");
            System.loadLibrary("../../../bin/java/wosgProducer");
            System.loadLibrary("../../../bin/java/wosgDB");
        } catch (UnsatisfiedLinkError e) {
            System.err.println("Native code library failed to load. See the chapter on Dynamic Linking Problems in the SWIG Java documentation for help.\n" + e);
            System.exit(1);
        }


        /** you need a viewer */
        Viewer viewer = new Viewer();

        /** looks weird but swigValue() is necessary */
        viewer.setUpViewer(Viewer.ViewerOptions.STANDARD_SETTINGS.swigValue());

        /** load a file */
        Node cow = wosgDB.readNodeFile("cow.osg");

        /** create a scene node */
        Group scene = new Group();

        /** add a node to the scene, basically thats the 3D model */
        scene.addChild(cow);

        /** add this to the current viewer */
        viewer.setSceneData(scene);

        /** start the viewer */
        viewer.realize();

        /** main loop until ESC is been hit */
        while (!viewer.done()) {

            /** sync states within OSG */
            viewer.sync();

            /** update the scenegraph */
            viewer.update();

            /** actual render call */
            viewer.frame();

        }


	}
}
