limited with TrafficLights;
limited with ObjectAvoidance;
limited with AutoPark;
with Ada.Real_Time;
with Ada.Text_IO;

package Car with SPARK_Mode is
   GearVal : String (1..4);
   Last : Natural;

   AutoParkVal: String (1..2);
   LastParkVal: Natural;

   ChargeVal: String (1..2);
   LastChargeVal: Natural;

   SummonVal: String(1..2);
   SummonLastVal: Natural;

   type TeslaKey is (Present, Absent);
   type CarState is (On, Off, Charging); -- Tesla is either on or off
   type DriveMode is (Parked, Revers, Neutral, Drive); -- The car can either be parked, in reverse, neutral or drive

   type BatteryColour is (BlinkingGreen, SolidGreen, Red, Amber);
   type LowBatteryWarning is (Visible, Hidden); -- The low battery warning modal is either visible or hidden
   type SettingsMode is (Service, Diagnostic);
   type DiagnosticModeOn is (On, Off);

   type Doors is (Open, Closed, Locked); -- Doors can be open or closed
   type ChargingPort is (Open, Closed);

   type SentryMode is (On, Off); -- Tesla has a sentry mode. Records its surroundings when parked and car is off
   type AutoSummon is (On, Off);

   type SpeedLimit is range 0..30;
   type MotorwayLimit is range 0..70;
   type TeslaMaxSpeed is range 0..174;
   type BatteryCharge is range 0..100; -- The battery charge between 0 and 100%

   -- Global Variables

   currentCharge : BatteryCharge := 98; -- Car fully charged at 100%
   currentSpeed : TeslaMaxSpeed := TeslaMaxSpeed'First;
   minimumChargeLevel : BatteryCharge := 10; -- Minimum battery to drive is 10%
   townSpeedLimit : constant SpeedLimit := SpeedLimit'Last;


   type ElectricCar is record -- Tesla Car Record
      CarKey : TeslaKey;
      State : CarState;
      DrivingMode : DriveMode;
      LowBattery : LowBatteryWarning;
      CarDoors : Doors;
      Battery: BatteryColour;
      DiagnosticMode: DiagnosticModeOn;
      AutoSummonMode: AutoSummon;
      TheChargingPort: ChargingPort;
   end record;

   TeslaModelS : ElectricCar := (Battery => SolidGreen, CarKey => Present, State => Off, DrivingMode => Parked, LowBattery => Hidden, CarDoors => Closed, DiagnosticMode => Off, AutoSummonMode => Off, TheChargingPort => Closed);

   function isInParkedMode return Boolean is -- Invariant that returns true when the car is in parked mode
     (TeslaModelS.DrivingMode = Parked);

   function carIsOff return Boolean is -- Function in variant that returns true when the state is off
     (TeslaModelS.State = Off);

   function carIsOn return Boolean is
     (TeslaModelS.State = On);

   function teslaKeyPresent return Boolean is -- Invariant that determines if the key is present or not. Must return true
     (TeslaModelS.CarKey = Present);

   function speedIsWithinLimits return Boolean is -- Speed must be between 0 and to prevent the speed limit from being exceeded
     (currentSpeed >= 0 AND currentSpeed <= 30);

   function carCharging return Boolean is
     (TeslaModelS.State = Charging);

   function carIsStationary return Boolean is -- Car is stationary when the current speed is equal to tesla's odometer speed of 0
     (currentSpeed = TeslaMaxSpeed'First);

   function inDriveMode return Boolean is
     (TeslaModelS.DrivingMode = Drive);

   function inSummonMode return Boolean is
     (TeslaModelS.AutoSummonMode = On);

   function diagnosticModeOff return Boolean is
     (TeslaModelS.DiagnosticMode = Off);

   function inDiagnosticMode return Boolean is
     (TeslaModelS.DiagnosticMode = On);

   function hasMinimumCharge return Boolean is
      (currentCharge >= minimumChargeLevel);

   procedure turnCarOn with
     Global => (In_Out => (TeslaModelS, Ada.Text_IO.File_System), Input => (currentSpeed, currentCharge)),
     Pre => isInParkedMode AND carIsOff AND teslaKeyPresent AND diagnosticModeOff, -- Before procedure invocation, the car must beparked and off and key present
     Post => isInParkedMode AND carIsOn AND teslaKeyPresent AND diagnosticModeOff;

   procedure turnOffDiagnosticMode with
     Global => (In_Out => (TeslaModelS, Ada.Text_IO.File_System)),
     Pre => isInParkedMode AND inDiagnosticMode, -- Before turning off diagnostic mode, it is on
     Post => isInParkedMode AND diagnosticModeOff;

   procedure turnCarOff with -- Procdeure that turns the car off
     Global => (In_Out => (TeslaModelS, Ada.Text_IO.File_System)),
     Pre => carIsOn AND isInParkedMode, -- Before function invocation, the car must be on and MUST be parked
     Post => carIsOff AND isInParkedMode; -- Execution after, the car is turned off and in parked mode

   procedure driveCar with -- BEFORE (PRE) executing procedure, car charge must be >= 10, currentCharge <= 100, speed of car must be between 0 and 30 and in parked mode
     Global => (In_Out => (TeslaModelS, Ada.Real_Time.Clock_Time, minimumChargeLevel, currentCharge, TrafficLights.EastTrafficLights, ObjectAvoidance.ObjectDetection, AutoPark.ParkSpaceObject, AutoParkVal, LastParkVal), Output => currentSpeed),
     Pre => hasMinimumCharge AND currentCharge <= BatteryCharge'Last AND speedIsWithinLimits AND isInParkedMode,
     Post => inDriveMode AND currentCharge >= BatteryCharge'First AND currentCharge <= BatteryCharge'Last AND speedIsWithinLimits; -- AFTER Executing Procedure (POST): currentCharge >= 10, speed still must be between 0 and 30 and currentCharge <= 100

   procedure changeGear with -- Before changing gear, speed of the car must be at 0MPH
     Global => (In_Out => (TeslaModelS, GearVal, Last, Ada.Text_IO.File_System), Input => currentSpeed),
     Pre => carIsStationary,
     Post => carIsStationary;

   procedure activateDiagnosticMode with -- Procedure that is invoked which sets the car in diagnostic mode
     Global => (In_Out => (TeslaModelS, Ada.Text_IO.File_System)),
     Pre => teslaKeyPresent AND carIsOff AND isInParkedMode AND diagnosticModeOff,
     Post => teslaKeyPresent AND carIsOff AND isInParkedMode AND inDiagnosticMode;

   procedure chargeCar with -- When charging the car, the car needs to be parked and off
     Global => (In_Out => (TeslaModelS, Ada.Text_IO.File_System, currentSpeed, minimumChargeLevel, TrafficLights.EastTrafficLights), Output => currentCharge),
     Pre => carIsStationary AND currentCharge >= BatteryCharge'First AND currentCharge <= BatteryCharge'Last,
     Post => carIsStationary AND currentCharge >= BatteryCharge'First AND currentCharge <= BatteryCharge'Last;

   procedure summonCar with
     Global => (In_Out => (TeslaModelS, Ada.Real_Time.Clock_Time, SummonVal, SummonLastVal), Output => currentSpeed),
     Pre => carIsOff AND isInParkedMode AND diagnosticModeOff AND teslaKeyPresent AND TeslaModelS.AutoSummonMode = Off AND carIsStationary,
     Post => carIsOn AND inDriveMode AND diagnosticModeOff AND teslaKeyPresent AND inSummonMode AND currentSpeed >= 0 AND currentSpeed <= 5;

end Car;
