import UIKit
import Charts

class dsViewController: UIViewController, dsDataDelegate, dsSimSetupDelegate {
    @IBOutlet weak var dsChartView: BarChartView!
    
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var ftpTitleLabel: UILabel!
    @IBOutlet weak var ftpLabel: UILabel!    
    
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    @IBAction func simStopTap(_ sender: Any) {
        stopButton.isEnabled = false
        startButton.isEnabled = true
        dsData.stopSimulating()
    }
    
    
//    internal let dsData = dsDataSimulator(fileName: "smallData", fileType: "json")
    internal let dsData = dsDataSimulator() // full data
    internal var timedPoints: [dsFtpDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = (dsHelper.getNavBarAttributes() as! [NSAttributedString.Key : Any])

        // style chart
        dsChartView.xAxis.drawLabelsEnabled = false
        dsChartView.xAxis.drawGridLinesEnabled = false
        dsChartView.scaleXEnabled = false
        dsChartView.doubleTapToZoomEnabled = false
        dsChartView.highlighter = nil
        dsChartView.legend.enabled = false
        dsChartView.noDataText = ""
        
        // set data delegate
        dsData.delegate = self
    }


    // dsDataDelegate implementations
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint, seconds: Double) {
        timedPoints.append(ftpPoint)
        drawChart(ftpPoints: timedPoints)
        updateLabels(seconds: seconds, ftpValue: ftpPoint.ftp)
    }
    
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint], seconds: Double) {
        drawChart(ftpPoints: ftpFullPoint)
    }
    
    func dsSimulatorDone() {
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }

    internal func updateLabels(seconds: Double, ftpValue: Double) {
        // for first run show progress labels
        if durationTitleLabel.isHidden {
            durationTitleLabel.isHidden = false
            durationLabel.isHidden = false
            ftpTitleLabel.isHidden = false
            ftpLabel.isHidden = false
        }
        
        let min = (seconds / 60).rounded(.towardZero)
        let sec = (Int(seconds) % 60)
        
        if sec == 0 {
            durationLabel.text = "\(Int(min)) min"
        } else if min == 0 {
            durationLabel.text = "\(Int(sec)) sec"
        } else {
            durationLabel.text = "\(Int(min)) min \(Int(sec)) sec"
        }
        
        if (ftpValue >= 0) && (ftpValue < 0.75) {
            ftpLabel.textColor = dsHelper.greenColor()
        } else if ((ftpValue >= 0.75) && (ftpValue < 1.25)) {
            ftpLabel.textColor = dsHelper.yellowColor()
        } else {
            ftpLabel.textColor = dsHelper.redColor()
        }
        ftpLabel.text = "\(ftpValue)"
    }
    
    internal func drawChart(ftpPoints: [dsFtpDataPoint]) {
        var entries: [ChartDataEntry] = []
        for (i, point) in ftpPoints.enumerated() {
            entries.append(BarChartDataEntry(x: Double(i), y: point.ftp))
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "ftp")
        dataSet.colors = [dsHelper.purpleColor()]
        dataSet.barBorderColor = .clear
        dataSet.barBorderWidth = 0
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [dataSet])
        data.barWidth = 1.3
        dsChartView.data = data

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "simulateSetup" {
            let simSetupNavController = segue.destination as! UINavigationController
            let simSetupController = simSetupNavController.viewControllers[0] as! dsSimulaterSetupController
            simSetupController.delegate = self
        }
    }
    
    // dsSimSetupDelegate implementation
    func beginSimulation(speed: dsSimulateSpeed) {
        timedPoints = []
        switch speed {
        case .speedRealTime:
            dsData.simulateData(simulationMode: .timedData, interval: 1.0)
        case .speed2X:
            dsData.simulateData(simulationMode: .timedData, interval: 0.5)
        case .speed5X:
            dsData.simulateData(simulationMode: .timedData, interval: 0.2)
        case .speed10X:
            dsData.simulateData(simulationMode: .timedData, interval: 0.1)
        }
        stopButton.isEnabled = true
        startButton.isEnabled = false
        
    }

}

