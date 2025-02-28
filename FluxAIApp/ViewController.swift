import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var pageOnboarding: UIPageControl!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var buttinNotifications: UIButton!

    var blurEffectView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notificationsButtonTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение на уведомления получено")
            } else if let error = error {
                print("Ошибка при запросе разрешения на уведомления: \(error)")
            }
        }
        addBlurEffect()
    }
    func addBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView?.frame = self.view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView?.alpha = 0.4

        self.view.addSubview(blurEffectView!)

        presentNotificationAlert()
    }

    func presentNotificationAlert() {
        let alertController = UIAlertController(title: "Разрешить уведомления",
                                                message: "Включите уведомления, чтобы получать важные обновления.",
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            
            self.removeBlurEffect()
        }

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func removeBlurEffect() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
}
