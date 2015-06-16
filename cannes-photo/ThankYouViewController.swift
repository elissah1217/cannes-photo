import UIKit

class ThankYouViewController: UIViewController, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("timeout:"), userInfo: nil, repeats: false);
    }
    
    @objc func timeout(timer:NSTimer) {
        performSegueWithIdentifier("startOverSegue", sender: nil)
    }
}