// Integrate.cpp : Defines the entry point for the console application.
//

#include <pcl/console/parse.h>
#include <pcl/common/time.h>
#include <boost/filesystem.hpp>

#include "Integrate/IntegrateApp.h"

int print_help() {
    // clang-format off
    std::cout << "\nApplication parameters:" << std::endl;
    std::cout << "    --help, -h                      : print this message" << std::endl;
    std::cout << "    --ref_traj <log_file>           : use a reference trajectory file" << std::endl;
    std::cout << "    --pose_traj <log_file>          : use a pose trajectory file to create a reference trajectory" << std::endl;
    std::cout << "    --seg_traj <log_file>           : trajectory within each fragment - must have" << std::endl;
    std::cout << "    --ctr <ctr_file>                : enables distortion, must specify the following parameters" << std::endl;
    std::cout << "    --num <number>                  : number of pieces, important parameter" << std::endl;
    std::cout << "    --resolution <resolution>       : default - 8" << std::endl;
    std::cout << "    --length <length>               : default - 3.0" << std::endl;
    std::cout << "    --interval <interval>           : default - 50" << std::endl;
    std::cout << "    --camera <param_file>           : load camera parameters" << std::endl;
    std::cout << "    --save_to <pcd_file>            : output file, default - world.pcd" << std::endl;
    std::cout << "    --start_from <frame_id>         : frames before frame_id will be skipped" << std::endl;
    std::cout << "    --end_at <frame_id>             : frames after frame_id will be skipped" << std::endl;
    std::cout << "Valid depth data sources:" << std::endl;
    std::cout << "    -dev <device> (default), -oni <oni_file>" << std::endl;
    return 0;
    // clang-format on
}

int main(int argc, char *argv[]) {
    using namespace pcl::console;

    if (argc == 1 || find_switch(argc, argv, "--help") ||
        find_switch(argc, argv, "-h")) {
        return print_help();
    }

    boost::shared_ptr<pcl::Grabber> capture;
    bool triggered_capture = false;
    bool use_device = false;
    std::string openni_device, oni_file;

    try {
        if (parse_argument(argc, argv, "-dev", openni_device) > 0) {
            capture.reset(new pcl::OpenNIGrabber(openni_device));
            use_device = true;
        } else if (parse_argument(argc, argv, "-oni", oni_file) > 0) {
            triggered_capture = true;
            bool repeat = false; // Only run ONI file once
            capture.reset(
                new pcl::ONIGrabber(oni_file, repeat, !triggered_capture));
        } else {
            capture.reset(new pcl::OpenNIGrabber());
            use_device = true;
        }
    } catch (const pcl::PCLException & /*e*/) {
        return std::cout << "Can't open depth source" << std::endl, -1;
    }

    CIntegrateApp app(*capture, use_device);

    parse_argument(argc, argv, "--ref_traj", app.traj_filename_);
    parse_argument(argc, argv, "--pose_traj", app.pose_filename_);
    parse_argument(argc, argv, "--seg_traj", app.seg_filename_);
    parse_argument(argc, argv, "--camera", app.camera_filename_);
    parse_argument(argc, argv, "--save_to", app.pcd_filename_);
    parse_argument(argc, argv, "--start_from", app.start_from_);
    parse_argument(argc, argv, "--end_at", app.end_at_);

    parse_argument(argc, argv, "--ctr", app.ctr_filename_);
    parse_argument(argc, argv, "--num", app.ctr_num_);
    parse_argument(argc, argv, "--resolution", app.ctr_resolution_);
    parse_argument(argc, argv, "--length", app.ctr_length_);
    parse_argument(argc, argv, "--interval", app.ctr_interval_);

    app.Init();

    {
        pcl::ScopeTime time("Integrate All");
        try {
            app.StartMainLoop(triggered_capture);
        } catch (const pcl::PCLException & /*e*/) {
            std::cout << "PCLException" << std::endl;
        } catch (const std::bad_alloc & /*e*/) {
            std::cout << "Bad alloc" << std::endl;
        } catch (const std::exception & /*e*/) {
            std::cout << "Exception" << std::endl;
        }
    }
    return 0;
}
