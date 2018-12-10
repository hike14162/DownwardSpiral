import Foundation

public class dsDataSimulator {
    private var ftpDataPoints: [dsFtpDataPoint] = []
    private var timeCount = 0
    private var okToSimulate = false
    private var secondChunk = 1
    
    public var delegate: dsDataDelegate?

    // Init data by loading "dsRawData.json" from the bundle
    init() {
        ftpDataPoints = []
        loadAndParse(fileName: "dsRawData", fileType: "json")
        fillTimeGaps()
    }

    // Init by specifying specific file in the bundle
    init(fileName: String, fileType: String) {
        ftpDataPoints = []
        loadAndParse(fileName: fileName, fileType: fileType)
        fillTimeGaps()
    }

    // Method to being the simulation
    public func simulateData(simulationMode: dsSimulateMode, interval: Double, secondChunkSize: Int) {
        secondChunk = secondChunkSize
        okToSimulate = true
        
        // Simulate all data at one time
        if simulationMode == .fullData {
            if let dlgt = delegate {
                dlgt.dsSimulatorFullPoints(ftpFullPoint: ftpDataPoints, seconds: ftpDataPoints[ftpDataPoints.count-1].start)
            }
        } else {
            // Set time at specified interval to simulate data over time
            timeCount = 0
            let simTimer = Timer(timeInterval: interval, target: self, selector:#selector(self.onSimulatorTick(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(simTimer, forMode: .default)
        }
    }
    
    public func stopSimulating() {
        okToSimulate = false
    }
    
    public func getData() -> [dsFtpDataPoint] {
        return ftpDataPoints
    }
    
    @objc private func onSimulatorTick(_ timer: Timer) {
        if let dlgt = delegate {
            if timeCount >= ftpDataPoints.count { // stop time and simulation if out of data points
                dlgt.dsSimulatorDone()
                timer.invalidate()
            } else if !okToSimulate { // Stop timer on user request
                timer.invalidate()
            } else if secondChunk == 1 { // send single data point to delegate implementation if time chunk size is 1
                dlgt.dsSimulatorPoint(ftpPoint: ftpDataPoints[timeCount], seconds: Double(timeCount))
                timeCount += 1
            } else { // send a time chunk's worth of data points to delegate implementation
                var points: [dsFtpDataPoint] = []
                for _ in 0 ..< secondChunk {
                    if timeCount+1 < ftpDataPoints.count {
                        points.append(ftpDataPoints[timeCount])
                        timeCount += 1
                    }
                }
                dlgt.dsSimulatorMultiPoints(ftpPoints: points, seconds: Double(timeCount))
            }
        }
    }
    
    private func loadAndParse(fileName: String, fileType: String) {
        if let stubDataPath = Bundle.main.path(forResource: fileName, ofType: fileType, inDirectory: "") {
            do {
                // Read the json file from the bundle
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: stubDataPath))
                do {
                    // parse the data and fill the ftpDataPoints array
                    if let fullDoc = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                        if let jsonInputs = fullDoc["inputs"] as? [Any] {
                            for dataPoints in jsonInputs {
                                ftpDataPoints.append(dsFtpDataPoint(json: (dataPoints as! [String:Any])))
                            }
                        }
                    }
                }
                catch {
                    print("Error parsing dsRawData.json")
                }
                
            } catch {
                print("Error reading dsRawData.json from the bundle")
            }
        }

    }
    
    // Fill in time gaps between points in data file
    private func fillTimeGaps() {
        var prevDataPoint = dsFtpDataPoint(type: "target", start: 0, ftp: 0)
        var minDif = 0
        var posIndex = 0
        
        for pt in ftpDataPoints {
            minDif = Int(pt.start - prevDataPoint.start)
            if (minDif > 1) {
                for cnt in 1..<(minDif) {
                    let newPt = dsFtpDataPoint(type: prevDataPoint.type, start: prevDataPoint.start+Double(cnt),ftp: prevDataPoint.ftp)
                    ftpDataPoints.insert(newPt, at: posIndex)
                    posIndex += 1
                }
            }
            prevDataPoint = pt
            posIndex += 1
        }
    }
}
