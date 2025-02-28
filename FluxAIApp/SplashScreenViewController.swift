import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var progressIndicator: UISlider!

    var progress: Float = 0
    var timer: Timer?
    var isTransitioning: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        progressIndicator.minimumTrackTintColor = .purple
        progressIndicator.maximumTrackTintColor = .white
        progressIndicator.thumbTintColor = .clear
        progressIndicator.isUserInteractionEnabled = false
        progressIndicator.setValue(0, animated: false)
        
        startLoading()
    }

    func startLoading() {
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }

    @objc func updateProgress() {
        progress += 0.01
        if progress >= 1.1 {
            progress = 1.1
            timer?.invalidate()
            timer = nil

            setProgress(progress, animated: true, duration: 0.2) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigateToNextScreen()
                }
            }

        } else {
            setProgress(progress, animated: true)
        }
    }

    func setProgress(_ progress: Float, animated: Bool, duration: TimeInterval = 0.02, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.progressIndicator.setValue(progress, animated: false)
                       },
                       completion: { _ in
                        completion?()
                       })
    }

    func navigateToNextScreen() {
        guard !isTransitioning else { return }
        isTransitioning = true

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            print("Не удалось найти ViewController с идентификатором 'ViewController'")
            isTransitioning = false
            return
        }

        viewController.modalPresentationStyle = .fullScreen

        present(viewController, animated: true, completion: {
            self.isTransitioning = false
        })
    }
}
