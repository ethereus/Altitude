import Cocoa

class OpaqGridScroller: NSScroller {
    override func draw(_ rect: NSRect) {
        NSColor.clear.set()
        rect.fill()
        super.drawKnob()
    }

}
