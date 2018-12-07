import Foundation

public class dsDataSimulator {
    public var delegate: dsDataDelegate?

    internal var ftpDataPoints: [dsFtpDataPoint]
    
    init() {
        ftpDataPoints = []
        loadAndParse(fileName: "dsRawData", fileType: "json")
        fillTimeGaps()
    }

    init(fileName: String, fileType: String) {
        ftpDataPoints = []
        loadAndParse(fileName: fileName, fileType: fileType)
        fillTimeGaps()
    }
    
    public func getData() -> [dsFtpDataPoint] {
        return ftpDataPoints
    }

    internal func loadAndParse(fileName: String, fileType: String) {
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
    internal func fillTimeGaps() {
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
