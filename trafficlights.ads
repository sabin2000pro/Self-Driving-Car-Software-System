with Car; use Car;
with AutoPark; use AutoPark;

package TrafficLights with SPARK_Mode is

   type TrafficLights is (Red, Amber, FlashingAmber, Green); -- Set of traffic lights
   type TrafficLightActions is (Stop, Drive);
   type Sensors is (ForwardCamera, UltraSonic, Radar, Lidar);

   type DetectedLights is (Yes, No);

    type TownTrafficLights is record
      TheTrafficLights : TrafficLights;
      Action : TrafficLightActions;
    end record;

   EastTrafficLights : TownTrafficLights := (TheTrafficLights => Green, Action => Drive);

   function lightsAreGreen return Boolean is
     (EastTrafficLights.TheTrafficLights = Green);

   function lightsTurnRed return Boolean is
     (EastTrafficLights.TheTrafficLights = Red);

   function carStopped return Boolean is
      (EastTrafficLights.Action = Stop);

   procedure detectTrafficLight with
     Global => (In_Out => (EastTrafficLights, AutoPark.ParkSpaceObject, Car.TeslaModelS, minimumChargeLevel), Output => (Car.currentSpeed, Car.currentCharge)),
     Pre => lightsAreGreen AND Car.inDriveMode AND EastTrafficLights.Action = Drive AND Car.speedIsWithinLimits,
     Post => Car.isInParkedMode AND Car.speedIsWithinLimits;


end TrafficLights;


-- General Comments
-- 1. Before detecting traffic light, the lights are on green turning to amber.. the car must be in drive mode
