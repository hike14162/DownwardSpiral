import UIKit

class dsViewController: UIViewController, dsDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = dsDataSimulator()
        data.delegate = self
    }


    // dsDataDelegate implementations
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint) {
        
    }
    
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint]) {
        
    }
    

}

