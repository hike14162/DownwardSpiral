import UIKit
import Charts

class dsViewController: UIViewController {
    // MARK: - View Outlets
    @IBOutlet weak var dsChartView: BarChartView!
    
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var ftpTitleLabel: UILabel!
    @IBOutlet weak var ftpLabel: UILabel!    
    
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    // MARK: - View Actions
    @IBAction func simStopTap(_ sender: Any) {
        stopButton.isEnabled = false
        startButton.isEnabled = true
        dsData.stopSimulating()
    }
    
    // MARK: - Private Properties
    // access to the simulation data
    private let dsData = dsDataSimulator()
    private var timedPoints: [dsFtpDataPoint] = []
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar style attributes
        self.navigationController?.navigationBar.titleTextAttributes = (dsHelper.getNavBarAttributes() as! [NSAttributedString.Key : Any])

        // Set chart style
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "simulateSetup" {
            // Set the setup controler delegate
            guard
                let simSetupNavController = segue.destination as? UINavigationController,
                let simSetupController = simSetupNavController.viewControllers[0] as? dsSimulaterSetupController else {
                return
            }
            simSetupController.delegate = self
        }
    }

    // MARK: - Private Methods
    private func updateLabels(seconds: Double, ftpValue: Double) {
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
        
        // Set ftpLabel color depending on value level
        if (ftpValue >= 0) && (ftpValue < 0.75) {
            ftpLabel.textColor = dsHelper.greenColor()
        } else if ((ftpValue >= 0.75) && (ftpValue < 1.25)) {
            ftpLabel.textColor = dsHelper.yellowColor()
        } else {
            ftpLabel.textColor = dsHelper.redColor()
        }
        ftpLabel.text = "\(ftpValue)"
    }
    
    private func drawChart(ftpPoints: [dsFtpDataPoint]) {
        var entries: [ChartDataEntry] = []
        for (i, point) in ftpPoints.enumerated() {
            entries.append(BarChartDataEntry(x: Double(i), y: point.ftp))
        }
        
        //Stylize the chart's bars
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.colors = [dsHelper.graphColor()]
        dataSet.barBorderColor = .clear
        dataSet.barBorderWidth = 0
        dataSet.drawValuesEnabled = false
        
        // Set data in chart and force draw
        let data = BarChartData(dataSets: [dataSet])
        data.barWidth = 1.3
        dsChartView.data = data

    }
}

// MARK: - dsDataDelegate implementations
extension dsViewController: dsDataDelegate {
    // Add a new single data point to the chart
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint, seconds: Double) {
        timedPoints.append(ftpPoint)
        drawChart(ftpPoints: timedPoints)
        updateLabels(seconds: seconds, ftpValue: ftpPoint.ftp)
    }
    
    // Add a collection of data points to the chart
    func dsSimulatorMultiPoints(ftpPoints: [dsFtpDataPoint], seconds: Double) {
        var lastFtpValue = 0.0
        for ftpPoint in ftpPoints {
            timedPoints.append(ftpPoint)
            lastFtpValue = ftpPoint.ftp
        }
        drawChart(ftpPoints: timedPoints)
        updateLabels(seconds: seconds, ftpValue: lastFtpValue)
    }
    
    // Add all points to the chart
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint], seconds: Double) {
        drawChart(ftpPoints: ftpFullPoint)
    }
    
    func dsSimulatorDone() {
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }

}

// MARK: - dsSimSetupDelegate implementation
extension dsViewController: dsSimSetupDelegate {
    // Set the speed of the simulation as set in the setup screen
    func beginSimulation(speed: dsSimulateSpeed) {
        timedPoints = []
        switch speed {
        case .speedRealTime:
            dsData.simulateData(simulationMode: .timedData, interval: 1.0, secondChunkSize: 1)
        case .speed2X:
            dsData.simulateData(simulationMode: .timedData, interval: 0.5, secondChunkSize: 1)
        case .speed5X:
            dsData.simulateData(simulationMode: .timedData, interval: 1.0, secondChunkSize: 5)
        case .speed10X:
            dsData.simulateData(simulationMode: .timedData, interval: 0.5, secondChunkSize: 5)
        }
        stopButton.isEnabled = true
        startButton.isEnabled = false        
    }
}
