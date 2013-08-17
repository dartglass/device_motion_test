import 'dart:html';

void main() {

  window.onDeviceMotion.listen((DeviceMotionEvent event) {

    query("#motion_X")..text = event.accelerationIncludingGravity.x.toString();
    query("#motion_Y")..text = event.accelerationIncludingGravity.y.toString();
    query("#motion_Z")..text = event.accelerationIncludingGravity.z.toString();
    
  });

}

