import Foundation

public protocol dsDataDelegate {
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint)
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint])
}
