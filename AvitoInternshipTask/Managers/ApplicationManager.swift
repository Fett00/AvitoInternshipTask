import UIKit

class ApplicationManager {

    static public let instance = ApplicationManager()
    private init() {}

    func createEntryPoint() -> UIViewController {
        let vc = LandingViewController()
        let presenter = LandingPresenter()
        return vc
    }
}
