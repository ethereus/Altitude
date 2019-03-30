import Cocoa

class NIGGER : NSStoryboardSegue {
    override func perform() {
        if let src = self.sourceController as? NSViewController,
            let newVC = self.destinationController as? NSViewController,
            let window = src.view.window {
            window.contentViewController = newVC
        }
    }
}
