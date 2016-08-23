UIALogger.logDebug("Starting... Update Vote");

var target = UIATarget.localTarget();
var window = target.frontMostApp().mainWindow();

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);

window.collectionViews()[0].cells()[0].tap();

var times = 30;

while (times > 0) {
    updateVote();
    times--;
}

function updateVote() {
    window.tableViews()[0].cells()[1].tap();
}
