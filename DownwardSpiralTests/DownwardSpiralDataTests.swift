import XCTest

@testable import DownwardSpiral

class DownwardSpiralDataTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInit_DefaultDataSimulatorSetNotNil() {
        let data = dsDataSimulator()
        XCTAssertNotNil(data)
    }
    
    func testInit_DefaultDataSimulatorSetFromDefaultFile() {
        let data = dsDataSimulator(fileName: "dsRawData", fileType: "json")
        XCTAssert(data.getData().count == 3301)
    }
    
    func testInit_FirstDataPointValue() {
        let data = dsDataSimulator()
        XCTAssert(data.getData()[0].start == 0.0)
        XCTAssert(data.getData()[0].ftp == 0.5)
    }

    func testInit_LastDataPointValue() {
        let data = dsDataSimulator()
        XCTAssert(data.getData()[3300].start == 3300.0)
        XCTAssert(data.getData()[3300].ftp == 0.5)
    }
    
    // Test with alternative data file
    func testInit_SmallDataSimulatorSetFromDefaultFile() {
        let data = dsDataSimulator(fileName: "smallData", fileType: "json")
        print(data.getData().count)
        XCTAssert(data.getData().count == 325)

    }
}
