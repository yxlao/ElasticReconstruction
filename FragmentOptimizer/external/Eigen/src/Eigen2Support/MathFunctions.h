// This file is part of Eigen, a lightweight C++ template library
// for linear algebra.
//
// Copyright (C) 2010 Gael Guennebaud <gael.guennebaud@inria.fr>
//
// This Source Code Form is subject to the terms of the Mozilla
// Public License v. 2.0. If a copy of the MPL was not distributed
// with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifndef EIGEN2_MATH_FUNCTIONS_H
#define EIGEN2_MATH_FUNCTIONS_H

namespace Eigen {

template <typename T> inline typename NumTraits<T>::Real ei_real(const T &x) {
    return internal::real(x);
}
template <typename T> inline typename NumTraits<T>::Real ei_imag(const T &x) {
    return internal::imag(x);
}
template <typename T> inline T ei_conj(const T &x) { return internal::conj(x); }
template <typename T> inline typename NumTraits<T>::Real ei_abs(const T &x) {
    return internal::abs(x);
}
template <typename T> inline typename NumTraits<T>::Real ei_abs2(const T &x) {
    return internal::abs2(x);
}
template <typename T> inline T ei_sqrt(const T &x) { return internal::sqrt(x); }
template <typename T> inline T ei_exp(const T &x) { return internal::exp(x); }
template <typename T> inline T ei_log(const T &x) { return internal::log(x); }
template <typename T> inline T ei_sin(const T &x) { return internal::sin(x); }
template <typename T> inline T ei_cos(const T &x) { return internal::cos(x); }
template <typename T> inline T ei_atan2(const T &x, const T &y) {
    return internal::atan2(x, y);
}
template <typename T> inline T ei_pow(const T &x, const T &y) {
    return internal::pow(x, y);
}
template <typename T> inline T ei_random() { return internal::random<T>(); }
template <typename T> inline T ei_random(const T &x, const T &y) {
    return internal::random(x, y);
}

template <typename T> inline T precision() {
    return NumTraits<T>::dummy_precision();
}
template <typename T> inline T machine_epsilon() {
    return NumTraits<T>::epsilon();
}

template <typename Scalar, typename OtherScalar>
inline bool ei_isMuchSmallerThan(const Scalar &x, const OtherScalar &y,
                                 typename NumTraits<Scalar>::Real precision =
                                     NumTraits<Scalar>::dummy_precision()) {
    return internal::isMuchSmallerThan(x, y, precision);
}

template <typename Scalar>
inline bool ei_isApprox(const Scalar &x, const Scalar &y,
                        typename NumTraits<Scalar>::Real precision =
                            NumTraits<Scalar>::dummy_precision()) {
    return internal::isApprox(x, y, precision);
}

template <typename Scalar>
inline bool ei_isApproxOrLessThan(const Scalar &x, const Scalar &y,
                                  typename NumTraits<Scalar>::Real precision =
                                      NumTraits<Scalar>::dummy_precision()) {
    return internal::isApproxOrLessThan(x, y, precision);
}

} // end namespace Eigen

#endif // EIGEN2_MATH_FUNCTIONS_H
