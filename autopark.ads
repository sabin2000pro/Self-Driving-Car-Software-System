limited with TrafficLights;
with Car; use Car;
with ObjectAvoidance; use ObjectAvoidance;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package AutoPark with SPARK_Mode is

   type ParkSpaceFree is (Free, Taken);
   type ParkSpaceDetect is (Detected, NotDetected);
   type Sensors is (ForwardCamera, UltraSonic, Radar, Lidar);
   type ParkSensorActive is (Active, Inactive);
   type ParkingIcon is (Visible, Hidden);

   type ParkDetection is record
      ParkingSpace: ParkSpaceFree;
      ActiveSensor: ParkSensorActive;
      ParkIcon: ParkingIcon;
      ParkDetected: ParkSpaceDetect;
   end record;

   ParkSpaceObject : ParkDetection := (ParkingSpace => Free, ActiveSensor => Active, ParkIcon => Hidden, ParkDetected => NotDetected);

   function parkSpaceIsFree return Boolean is
     (ParkSpaceObject.ParkingSpace = Free);

    function parkSpaceIsTaken return Boolean is
      (ParkSpaceObject.ParkingSpace = Taken);

   procedure detectParkingSpace with
     Global => (In_Out => (Car.TeslaModelS, AutoParkVal, LastParkVal, ParkSpaceObject, Ada.Text_IO.File_System), Output => currentSpeed),
     Pre => Car.inDriveMode AND Car.speedIsWithinLimits AND parkSpaceIsFree AND ParkSpaceObject.ParkIcon = Hidden,
     Post => Car.isInParkedMode AND Car.speedIsWithinLimits AND parkSpaceIsTaken AND ParkSpaceObject.ParkIcon = Visible;

 end AutoPark;
