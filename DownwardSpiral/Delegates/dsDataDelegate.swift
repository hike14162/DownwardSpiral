public protocol dsDataDelegate {
    // MARK: - Simulator event methods
    func dsSimulatorPoint(ftpPoint: dsFtpDataPoint, seconds: Double)
    func dsSimulatorMultiPoints(ftpPoints: [dsFtpDataPoint], seconds: Double)
    func dsSimulatorFullPoints(ftpFullPoint: [dsFtpDataPoint], seconds: Double)
    func dsSimulatorDone()
}
