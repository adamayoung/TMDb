import Foundation

extension DispatchQueue {

    func simulateWaitForNetwork(execute work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            work()
        }
    }

}
