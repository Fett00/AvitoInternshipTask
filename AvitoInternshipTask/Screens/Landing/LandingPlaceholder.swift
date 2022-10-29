import UIKit

class LandingPlaceholder: UIView {

    enum PlaceholderCause: String {

        case cantLoad
    }

    private let placeholderImage = UIImageView()
    private let placeholderLabel = UILabel()
    private let placeholderButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        addSubview(placeholderImage)
        addSubview(placeholderLabel)
        addSubview(placeholderButton)

        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderButton.translatesAutoresizingMaskIntoConstraints = false

        placeholderImage.tintColor = .gray

        placeholderLabel.numberOfLines = 2
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        placeholderLabel.textAlignment = .center
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.minimumScaleFactor = 0.3

        placeholderButton.layer.cornerCurve = .continuous
        placeholderButton.layer.cornerRadius = 20
        placeholderButton.layer.borderWidth = 0.5
        placeholderButton.setTitle("ОБНОВИТЬ", for: .normal)
        placeholderButton.setTitleColor(.label, for: .normal)
        placeholderButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            placeholderImage.widthAnchor.constraint(equalToConstant: 100),
            placeholderImage.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 15),
            placeholderLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            placeholderButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            placeholderButton.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 15),
            placeholderButton.heightAnchor.constraint(equalToConstant: 40),
            placeholderButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    func addTargetForButton(target: Any?, action: Selector, for event: UIControl.Event) {
        placeholderButton.addTarget(target, action: action, for: event)
    }

    func showWithCause(_ cause: PlaceholderCause) {

        alpha = 1.0
        switch cause {
        case .cantLoad:
            placeholderLabel.text = "НЕВОЗМОЖНО ЗАГРУЗИТЬ ДАННЫЕ \n ПОПРОБУЙТЕ ЕЩЕ РАЗ"
            placeholderImage.image = UIImage(systemName: "wifi.slash")
        }
    }

    func hide() {
        placeholderImage.image = nil
        placeholderLabel.text = ""
        alpha = 0.0
    }
}
