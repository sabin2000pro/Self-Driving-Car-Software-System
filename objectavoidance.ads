with Car; use Car;

package ObjectAvoidance with SPARK_Mode is

   type Sensors is (ForwardCamera, UltraSonic, Radar, Lidar);
   type RoadObjects is (Bollard, StopSign, Cones, Lamp, Bins);
   type ObjectDetectAction is (Brake, Avoid, Drive);
   type FoundObject is (Yes, No);
   type SensorActive is (Active, Inactive);

   type ObjectDetectionRecord is record
      DetectedAction : ObjectDetectAction;
      ObjectFoundValue : FoundObject;
      SensorState : SensorActive;
   end record;

   ObjectDetection : ObjectDetectionRecord := (SensorState => Active, ObjectFoundValue => No, DetectedAction => Drive);

   procedure detectRoadObject with -- Procedure that will detect a road object whilst in drive mode
     Global => (In_Out => (Car.TeslaModelS, ObjectDetection), Output => currentSpeed),
     Pre => Car.inDriveMode AND Car.speedIsWithinLimits AND ObjectDetection.SensorState = Active,
     Post => Car.inDriveMode AND Car.speedIsWithinLimits AND ObjectDetection.SensorState = Active;

 end ObjectAvoidance;


-- General Comments
-- 1. Before detecting a road object (sensor)
-- 2. Car must be in drive mode, speed must be between 0 and 30, sensor stat3 is active
