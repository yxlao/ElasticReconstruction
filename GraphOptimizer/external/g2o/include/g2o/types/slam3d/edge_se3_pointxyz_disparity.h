// g2o - General Graph Optimization
// Copyright (C) 2011 R. Kuemmerle, G. Grisetti, W. Burgard
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef G2O_EDGE_SE3_POINTXYZ_DISPARITY_H_
#define G2O_EDGE_SE3_POINTXYZ_DISPARITY_H_

#include "vertex_se3.h"
#include "vertex_pointxyz.h"
#include "g2o/core/hyper_graph_action.h"
#include "g2o/core/base_binary_edge.h"
#include "parameter_camera.h"

#define EDGE_PROJECT_DISPARITY_ANALYTIC_JACOBIAN
namespace g2o {

/**
 * \brief edge from a track to a depth camera node using a disparity measurement
 *
 * the disparity measurement is normalized: disparity / (focal_x * baseline)
 */
// first two args are the measurement type, second two the connection classes
class G2O_TYPES_SLAM3D_API EdgeSE3PointXYZDisparity
    : public BaseBinaryEdge<3, Vector3d, VertexSE3, VertexPointXYZ> {
  public:
    EIGEN_MAKE_ALIGNED_OPERATOR_NEW;
    EdgeSE3PointXYZDisparity();
    virtual bool read(std::istream &is);
    virtual bool write(std::ostream &os) const;

    // return the error estimate as a 3-vector
    void computeError();

#ifdef EDGE_PROJECT_DISPARITY_ANALYTIC_JACOBIAN
    virtual void linearizeOplus();
#endif

    virtual void setMeasurement(const Vector3d &m) { _measurement = m; }

    virtual bool setMeasurementData(const double *d) {
        Map<const Vector3d> v(d);
        _measurement = v;
        return true;
    }

    virtual bool getMeasurementData(double *d) const {
        Map<Vector3d> v(d);
        v = _measurement;
        return true;
    }

    virtual int measurementDimension() const { return 3; }

    virtual bool setMeasurementFromState();

    virtual double
    initialEstimatePossible(const OptimizableGraph::VertexSet &from,
                            OptimizableGraph::Vertex *to) {
        (void)to;
        return (from.count(_vertices[0]) == 1 ? 1.0 : -1.0);
    }

    virtual void initialEstimate(const OptimizableGraph::VertexSet &from,
                                 OptimizableGraph::Vertex *to);

  private:
    Eigen::Matrix<double, 3, 9> J; // jacobian before projection
    virtual bool resolveCaches();
    ParameterCamera *params;
    CacheCamera *cache;
};

#ifdef G2O_HAVE_OPENGL
class G2O_TYPES_SLAM3D_API EdgeProjectDisparityDrawAction : public DrawAction {
  public:
    EdgeProjectDisparityDrawAction();
    virtual HyperGraphElementAction *
    operator()(HyperGraph::HyperGraphElement *element,
               HyperGraphElementAction::Parameters *params_);
};
#endif

} // namespace g2o
#endif
