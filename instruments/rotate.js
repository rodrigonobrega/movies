UIALogger.logDebug("Starting... Rotate");

var target = UIATarget.localTarget();

portrait();
target.delay(1);
landscapeLeft();
target.delay(1);
landscapeRight();
target.delay(1);
portrait();
target.delay(1);
portrait();
target.delay(1);
landscapeLeft();
target.delay(1);
landscapeRight();
target.delay(1);
portrait();
target.delay(1);


function portrait() {
    target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);    
}

function landscapeLeft() {
    target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_LANDSCAPELEFT);
}

function landscapeRight() {
    target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT);
}