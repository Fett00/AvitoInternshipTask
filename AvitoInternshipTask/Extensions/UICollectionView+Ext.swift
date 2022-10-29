import UIKit

extension UICollectionView {

    func register<Cell: UICollectionViewCell>(_ type: Cell.Type) {

        register(Cell.self, forCellWithReuseIdentifier: Cell.reuseID)
    }
}
