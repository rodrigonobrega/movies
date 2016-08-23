UIALogger.logDebug("Starting... Scroll");

var target = UIATarget.localTarget();
var window = target.frontMostApp().mainWindow();

var times = 10;

var index = 4;

while (times > 0) {
    target.delay(1);
    scroll();
    index = index + 4;
    times--;
}

function scroll() {
    window.collectionViews()[0].cells()[index].dragInsideWithOptions({startOffset:{x:0.03, y:0.44}, endOffset:{x:0.81, y:0.50},duration:1});
}