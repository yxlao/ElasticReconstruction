#include <unsupported/Eigen/Polynomials>
#include <iostream>

using namespace Eigen;
using namespace std;

int main() {
    Vector4d roots = Vector4d::Random();
    std::cout << "Roots: " << roots.transpose() << std::endl;
    Eigen::Matrix<double, 5, 1> polynomial;
    roots_to_monicPolynomial(roots, polynomial);
    std::cout << "Polynomial: ";
    for (int i = 0; i < 4; ++i) {
        std::cout << polynomial[i] << ".x^" << i << "+ ";
    }
    std::cout << polynomial[4] << ".x^4" << std::endl;
    Vector4d evaluation;
    for (int i = 0; i < 4; ++i) {
        evaluation[i] = poly_eval(polynomial, roots[i]);
    }
    std::cout << "Evaluation of the polynomial at the roots: "
              << evaluation.transpose();
}
