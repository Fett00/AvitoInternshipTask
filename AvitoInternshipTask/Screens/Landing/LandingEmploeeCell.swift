import UIKit

// Ячейка колекции
class LandingEmploeeCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let skillsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        nameLabel.text = ""
        phoneLabel.text = ""
        skillsLabel.text = ""
    }

    private func setupUI() {

        backgroundColor = .secondarySystemFill
        layer.cornerCurve = .continuous
        layer.cornerRadius = 20

        [nameLabel, phoneLabel, skillsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        nameLabel.numberOfLines = 1
        phoneLabel.numberOfLines = 2
        skillsLabel.numberOfLines = 3

        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        phoneLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        skillsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        nameLabel.font = UIFont.preferredFont(forTextStyle: .title2)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            skillsLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            skillsLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15),
            skillsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            skillsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }

    func update(_ model: PresentationModel) {

        nameLabel.text = model.name
        phoneLabel.text = model.phoneNumber
        skillsLabel.text = model.skills
    }
}
