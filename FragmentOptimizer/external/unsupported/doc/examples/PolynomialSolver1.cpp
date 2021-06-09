#include <unsupported/Eigen/Polynomials>
#include <vector>
#include <iostream>

using namespace Eigen;
using namespace std;

int main() {
    typedef Matrix<double, 5, 1> Vector5d;

    Vector5d roots = Vector5d::Random();
    std::cout << "Roots: " << roots.transpose() << std::endl;
    Eigen::Matrix<double, 6, 1> polynomial;
    roots_to_monicPolynomial(roots, polynomial);

    PolynomialSolver<double, 5> psolve(polynomial);
    std::cout << "Complex roots: " << psolve.roots().transpose() << std::endl;

    std::vector<double> realRoots;
    psolve.realRoots(realRoots);
    Map<Vector5d> mapRR(&realRoots[0]);
    std::cout << "Real roots: " << mapRR.transpose() << std::endl;

    std::cout << std::endl;
    std::cout
        << "Illustration of the convergence problem with the QR algorithm: "
        << std::endl;
    std::cout
        << "---------------------------------------------------------------"
        << std::endl;
    Eigen::Matrix<float, 7, 1> hardCase_polynomial;
    hardCase_polynomial << -0.957, 0.9219, 0.3516, 0.9453, -0.4023, -0.5508,
        -0.03125;
    std::cout << "Hard case polynomial defined by floats: "
              << hardCase_polynomial.transpose() << std::endl;
    PolynomialSolver<float, 6> psolvef(hardCase_polynomial);
    std::cout << "Complex roots: " << psolvef.roots().transpose() << std::endl;
    Eigen::Matrix<float, 6, 1> evals;
    for (int i = 0; i < 6; ++i) {
        evals[i] = std::abs(poly_eval(hardCase_polynomial, psolvef.roots()[i]));
    }
    std::cout << "Norms of the evaluations of the polynomial at the roots: "
              << evals.transpose() << endl
              << std::endl;

    cout
        << "Using double's almost always solves the problem for small degrees: "
        << std::endl;
    cout
        << "-------------------------------------------------------------------"
        << std::endl;
    PolynomialSolver<double, 6> psolve6d(hardCase_polynomial.cast<double>());
    std::cout << "Complex roots: " << psolve6d.roots().transpose() << std::endl;
    for (int i = 0; i < 6; ++i) {
        std::complex<float> castedRoot(psolve6d.roots()[i].real(),
                                       psolve6d.roots()[i].imag());
        evals[i] = std::abs(poly_eval(hardCase_polynomial, castedRoot));
    }
    std::cout << "Norms of the evaluations of the polynomial at the roots: "
              << evals.transpose() << endl
              << std::endl;

    cout.precision(10);
    std::cout << "The last root in float then in double: " << psolvef.roots()[5]
              << "\t" << psolve6d.roots()[5] << std::endl;
    std::complex<float> castedRoot(psolve6d.roots()[5].real(),
                                   psolve6d.roots()[5].imag());
    std::cout << "Norm of the difference: "
              << internal::abs(psolvef.roots()[5] - castedRoot) << std::endl;
}
