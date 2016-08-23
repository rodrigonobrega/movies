UIALogger.logDebug("Starting... Tap to detail page");

var target = UIATarget.localTarget();
var window = target.frontMostApp().mainWindow();

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_FACEUP);


var index = 0

while (index < 10) {
    execute();
    index++;
}

function execute() {
    if (index % 2 == 0) {
        scroll();
        target.delay(1);  
    }
    simpleTap();
    target.delay(1);
    backButton();
    target.delay(1);
}

function simpleTap() {
    window.collectionViews()[0].cells()[index].tap();
}

function backButton() {
    target.frontMostApp().navigationBar().leftButton().tap();
}

function scroll() {
    window.collectionViews()[0].cells()[index].scrollToVisible();
}