#include <iostream>
#include <string>

int main() {
    // using namespace std;
    // string color_dir = "your_color_dir/", depth_dir = "your_depth_dir/";
    // int frame_num = 100;

    // XnStatus nRetVal = XN_STATUS_OK;
    // Context context;
    // nRetVal = context.Init();
    // CHECK_RC(nRetVal, "Init");

    // Player player;
    // nRetVal = context.OpenFileRecording(
    //     "input.oni", player); // we use existence .oni file to simulate a oni
    //                           // context environment.
    // CHECK_RC(nRetVal, "Open input file");

    // DepthGenerator depth;
    // ImageGenerator color;
    // nRetVal = context.FindExistingNode(XN_NODE_TYPE_IMAGE, color);
    // CHECK_RC(nRetVal, "Find color generator");

    // nRetVal = context.FindExistingNode(XN_NODE_TYPE_DEPTH, depth);
    // CHECK_RC(nRetVal, "Find depth generator");

    // MockDepthGenerator mockDepth;
    // nRetVal = mockDepth.CreateBasedOn(depth);
    // CHECK_RC(nRetVal, "Create mock depth node");
    // MockImageGenerator mockColor;
    // mockColor.CreateBasedOn(color);
    // CHECK_RC(nRetVal, "Create mock color node");

    // Recorder recorder;
    // nRetVal = recorder.Create(context);
    // CHECK_RC(nRetVal, "Create recorder");

    // nRetVal = recorder.SetDestination(XN_RECORD_MEDIUM_FILE, "dst.oni");
    // CHECK_RC(nRetVal, "Set recorder destination file");

    // nRetVal = recorder.AddNodeToRecording(mockDepth);
    // CHECK_RC(nRetVal, "Add node to recording");
    // nRetVal = recorder.AddNodeToRecording(mockColor);
    // CHECK_RC(nRetVal, "Add node to recording");

    // for (int i = 0; i < frame_num; ++i) {
    //     std::stringstream ss;
    //     ss << depth_dir << i << ".png";
    //     std::string filepath_depth = ss.str();

    //     std::stringstream sss;
    //     sss << color_dir << i << ".png";
    //     std::string filepath_color = sss.str();

    //     cv::Mat depth_img = cv::imread(
    //         filepath_depth, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
    //     depth_img.convertTo(depth_img, CV_16U);

    //     cv::Mat color_img = cv::imread(
    //         filepath_color, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
    //     color_img.convertTo(color_img, CV_8UC3);

    //     // depth
    //     DepthMetaData depthMD;
    //     XnUInt32 &di = depthMD.FrameID();
    //     di = i; // set frame id.
    //     XnUInt64 &dt = depthMD.Timestamp();
    //     dt = i * 30000 + 1; // set a proper timestamp.

    //     depthMD.AllocateData(depth_img.cols, depth_img.rows);
    //     DepthMap &depthMap = depthMD.WritableDepthMap();
    //     for (XnUInt32 y = 0; y < depthMap.YRes(); y++) {
    //         for (XnUInt32 x = 0; x < depthMap.XRes(); x++) {
    //             depthMap(x, y) = depth_img.at<ushort>(y, x);
    //         }
    //     }
    //     nRetVal = mockDepth.SetData(depthMD);
    //     CHECK_RC(nRetVal, "Set mock node new data");

    //     // color
    //     ImageMetaData colorMD;
    //     XnUInt32 &ci = colorMD.FrameID();
    //     ci = i;
    //     XnUInt64 &ct = colorMD.Timestamp();
    //     ct = i * 30000 + 1;

    //     colorMD.AllocateData(color_img.cols, color_img.rows,
    //                          XN_PIXEL_FORMAT_RGB24);
    //     RGB24Map &imageMap = colorMD.WritableRGB24Map();
    //     for (XnUInt32 y = 0; y < imageMap.YRes(); y++) {
    //         for (XnUInt32 x = 0; x < imageMap.XRes(); x++) {
    //             cv::Vec3b intensity = color_img.at<cv::Vec3b>(y, x);
    //             imageMap(x, y).nBlue = (XnUInt8)intensity.val[0];
    //             imageMap(x, y).nGreen = (XnUInt8)intensity.val[1];
    //             imageMap(x, y).nRed = (XnUInt8)intensity.val[2];
    //         }
    //     }
    //     nRetVal = mockColor.SetData(colorMD);
    //     CHECK_RC(nRetVal, "Set mock node new data");

    //     recorder.Record();
    //     printf("Recorded: frame %u out of %u\r", depthMD.FrameID(),
    //     frame_num);
    // }
}
