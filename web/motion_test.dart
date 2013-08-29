import 'dart:html';
import 'dart:math' as Math;

void main() {
  
  double gx = 0.0;
  double gy = 0.0;
  double gz = 0.0;

  double lx = 0.0;
  double ly = 0.0;
  double lz = 0.0;
  
  double alpha = 0.8;
  double timeConstant = 500.0;
  double accelerationThresholdCalibration = 1.7;
  double accelerationAccumlation = 0.0;
  double avgAccelerationAccumlation = 0.0;
  
  int accelerationThresholdCount = 0;
  int accelerationMeasuermentCount = 0;
  
  int accelerationAverageTimeout = 1500; //Milliseconds
  int accelerationAverageTimestamp = 0;
  
  int accelerationQuickAverageTimeout = 500; //Milliseconds
  int accelerationQuickAverageTimestamp = 0;
  
  //The percentage of movement obove the threshold to be count as moving;
  double percentageOfMovementThreshold = 30.0;  
  
  double avgAccelerationAccumlationThreshold = 4.1;
  
  double percentMovement; //Percentage of time moving 
  
  int movementIntervalAccumulation = 0; 
  
  int previousTimestamp = 0;
  int boinkCount = 0;

  window.onDeviceMotion.listen((DeviceMotionEvent event) {
    
    int dTime = event.timeStamp - previousTimestamp;
    previousTimestamp = event.timeStamp;
    
    alpha = timeConstant / (timeConstant + dTime);
    
    double x = event.accelerationIncludingGravity.x;
    double y = event.accelerationIncludingGravity.y;
    double z = event.accelerationIncludingGravity.z;
    
    // Isolate the force of gravity with the low-pass filter.
    gx = (alpha * gx) + ((1-alpha) * x);
    gy = (alpha * gy) + ((1-alpha) * y);
    gz = (alpha * gz) + ((1-alpha) * z);
  
    // Remove the gravity contribution with the high-pass filter.
    lx = x - gx;
    ly = y - gy;
    lz = z - gz;
     
    double acceleration = Math.sqrt(lx*lx + ly*ly + lz*lz);
     
    accelerationMeasuermentCount++;
    
    accelerationAccumlation += acceleration;
     
    if (acceleration > accelerationThresholdCalibration) {
      accelerationThresholdCount++;
      query("#motion_acc").style.color = "#FF0000"; 
    }
    else{
      query("#motion_acc").style.color = "#FFFFFF";
    }
 
    query("#motion_x")..text   = " corrected x :"..appendText(lx.toStringAsFixed(1));
    query("#motion_y")..text   = " corrected y :"..appendText(ly.toStringAsFixed(1));
    query("#motion_z")..text   = " corrected z :"..appendText(lz.toStringAsFixed(1));
    query("#motion_acc")..text = " acceleration :"..appendText(acceleration.toStringAsFixed(2));
    
    if ((event.timeStamp - accelerationQuickAverageTimestamp) < accelerationQuickAverageTimeout) return;
    accelerationQuickAverageTimestamp = event.timeStamp;
    
    avgAccelerationAccumlation = (avgAccelerationAccumlation * 0.6) + (accelerationAccumlation * 0.4); 
    accelerationAccumlation = 0.0;
    
    if (avgAccelerationAccumlation > avgAccelerationAccumlationThreshold) {
      query("#motion_c").style.color = "#00FF00"; 
    }
    else{
      query("#motion_c").style.color = "#FFFFFF";
    }
    
    query("#motion_c")..text   = " activity level: "..appendText(avgAccelerationAccumlation.toStringAsFixed(1));

    
    if ((event.timeStamp - accelerationAverageTimestamp) < accelerationAverageTimeout) return;

    accelerationAverageTimestamp = event.timeStamp;
    percentMovement = (accelerationThresholdCount / accelerationMeasuermentCount) * 100;
     
    accelerationMeasuermentCount = 0;
    accelerationThresholdCount = 0;
  
    if (percentMovement > percentageOfMovementThreshold) {
      movementIntervalAccumulation++;
      query("#motion_a").style.color = "#00FF00"; 
    }
    else{
      query("#motion_a").style.color = "#FFFFFF"; 
    }

    query("#motion_a")..text   = " movement %: "..appendText(percentMovement.toStringAsFixed(0));
    query("#motion_b")..text   = " accumulation: "..appendText(movementIntervalAccumulation.toString());
    
    
  });


}

