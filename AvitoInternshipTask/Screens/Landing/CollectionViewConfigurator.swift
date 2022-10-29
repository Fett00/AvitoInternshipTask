import UIKit

final class CollectionViewConfigurator {

    private static func rowsNumber() -> CGFloat {

        let device = UIDevice.current.userInterfaceIdiom
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation

        switch (device, orientation) {
        case (.phone, .portrait):
            return 1.0
        case (.phone, .landscapeLeft):
            return 2.0
        case (.phone, .landscapeRight):
            return 2.0
        case (.pad, .portrait):
            return 3.0
        case (.pad, .portraitUpsideDown):
            return 3.0
        case (.pad, .landscapeRight):
            return 4.0
        case (.pad, .landscapeLeft):
            return 4.0
        default:
            return 1.0
        }
    }

    static func configureCollection(
        _ collection: UICollectionView
    ) {
        collection.register(UICollectionViewCell.self)
        collection.register(LandingEmploeeCell.self)
    }

    static func configureFlowLayout(
        _ container: UIView,
        _ collection: UICollectionView,
        _ layout: UICollectionViewFlowLayout
    ) {

        let containerWidth = container.bounds.width
        let numberOfItemInRow = rowsNumber()
        let spacing = 10.0
        let inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let itemSize = CGSize(
            width: (containerWidth - inset.left - inset.right - spacing * (numberOfItemInRow - 1) - 10) / numberOfItemInRow,
            height: 200
        )

        layout.itemSize = itemSize
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        collection.contentInset = inset
        layout.scrollDirection = .vertical
    }
}
