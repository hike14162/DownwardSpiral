import Foundation

public protocol dsDataDelegate {
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint, seconds: Double)
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint], seconds: Double)
    func dsSimulatorDone()
}
