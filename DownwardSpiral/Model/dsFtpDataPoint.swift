import Foundation

final public class dsFtpDataPoint {
    // MARK: - Public properties
    public var type: String
    public var start:Double
    public var ftp: Double
    
    // MARK: - Initialiazers
    init(type: String, start: Double, ftp: Double) {
        self.type = type
        self.start = start
        self.ftp = ftp
    }
    
    init(json:[String:Any]) {
        type = json["type"] as? String ?? ""
        start = json["start"] as? Double ?? 0.0
        ftp = json["ftp"] as? Double ?? 0.0
    }
}
