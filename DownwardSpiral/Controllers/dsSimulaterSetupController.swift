import UIKit

class dsSimulaterSetupController: UIViewController {
    // MARK: - View Outlets
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    
    // MARK: - View Actions
    @IBAction func startSimulateTap(_ sender: Any) {
        if let dlgt = delegate {
            dlgt.beginSimulation(speed: speed)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sppedSliderChange(_ sender: Any) {
        // Dtermine the simulatin speed based on the slider position
        if ((speedSlider.value >= 0) && (speedSlider.value < 0.25)) {
            speed = .speedRealTime
        } else if ((speedSlider.value >= 0.25) && (speedSlider.value < 0.5)) {
            speed = .speed2X
        } else if ((speedSlider.value >= 0.5) && (speedSlider.value < 0.75)) {
            speed = .speed5X
        } else {
            speed = .speed10X
        }
        
        // Update the speed label
        switch speed {
        case .speedRealTime:
            speedLabel.text = "Real Time"
        case .speed2X:
            speedLabel.text = "2X Speed"
        case .speed5X:
            speedLabel.text = "5X Speed"
        case .speed10X:
            speedLabel.text = "10X Speed"
        }
    }

    // MARK: - Private Properties
    private var speed: dsSimulateSpeed = .speedRealTime
    
    // MARK: - public Properties
    public var delegate: dsSimSetupDelegate?
    
    // MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = (dsHelper.getNavBarAttributes() as! [NSAttributedString.Key : Any])
    }
}
