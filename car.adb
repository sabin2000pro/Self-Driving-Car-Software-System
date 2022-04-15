with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with TrafficLights; use TrafficLights;
with ObjectAvoidance; use ObjectAvoidance;
with AutoPark; use AutoPark;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Command_Line; use Ada.Command_Line;

package body Car with SPARK_Mode is

   procedure turnCarOn is -- Main Body for turning the car on

   begin

      if(TeslaModelS.DiagnosticMode = On)

      THEN Put_Line("Cannot turn Tesla On. Car is in Diagnostic mode" & TeslaModelS.DiagnosticMode'Image);
         TeslaModelS.DiagnosticMode := On;

         return;
         end if;

      if(TeslaModelS.DrivingMode = Revers OR TeslaModelS.DrivingMode = Neutral OR TeslaModelS.DrivingMode = Drive) then
         Put_Line("Cannot start car. Driving mode is  " & TeslaModelS.DrivingMode'Image);

      end if;


      if(TeslaModelS.DrivingMode = Parked AND TeslaModelS.CarKey = Present AND TeslaModelS.DiagnosticMode = Off) THEN

         TeslaModelS.State := On; -- Turn the car on
         TeslaModelS.DrivingMode := Parked; -- The driving mode is in parked now
         TeslaModelS.CarKey := Present; -- Car key is present

         Put_Line("Tesla is on. Driving Mode: " & TeslaModelS.DrivingMode'Image & " Speed :  " & currentSpeed'Image & " mp/h ");
         Put_Line("Battery % - " & currentCharge'Image);


      else
         TeslaModelS.State := Off;

         end if;

   end turnCarOn;

   procedure turnOffDiagnosticMode is

   begin

      if(isInParkedMode AND TeslaModelS.DiagnosticMode = On)

      THEN TeslaModelS.DiagnosticMode := Off;

         Put_Line("Diagnostic Mode is now : " & TeslaModelS.DiagnosticMode'Image);

         end if;

      end turnOffDiagnosticMode;

   procedure turnCarOff is

   begin

      -- Check to see if car is not already OFF
      if(TeslaModelS.State = Off)

     THEN TeslaModelS.State := Off; Put_Line("Tesla is already : " & TeslaModelS.State'Image);

         end if;

      if(TeslaModelS.DrivingMode = Parked AND carIsOn)

      THEN TeslaModelS.State := Off; TeslaModelS.DrivingMode := Parked;

         Put_Line("Tesla is now " & TeslaModelS.State'Image);

         end if;

   end turnCarOff;

   procedure driveCar is

   begin

      TeslaModelS.DrivingMode := Drive;

      delay 0.5;

      if(inDiagnosticMode) THEN

         Put_Line("Car cannot be driven. Diagnostic mode is " & TeslaModelS.DiagnosticMode'Image); TeslaModelS.DiagnosticMode := On;
         return;

      end if;

      if(NOT carIsOn) -- If the car is not3 on

      THEN Put_Line("Cannot drive Tesla. The car is" & TeslaModelS.State'Image & "AND IN GEAR : " & TeslaModelS.DrivingMode'Image); -- Cannot drive the car

         return;

      end if;

      if(currentCharge <= minimumChargeLevel)

         THEN Put_Line("Tesla does not have enough charge to drive. Needs charging!");

         return;

      end if;

      loop

         TeslaModelS.DrivingMode := Drive;

         if(currentCharge > minimumChargeLevel AND inDriveMode AND speedIsWithinLimits AND currentCharge <= BatteryCharge'Last)


         THEN currentSpeed := currentSpeed + 1; currentCharge := currentCharge - 1; -- Start subtracting the current charge

            delay 0.3;

           if(inDriveMode AND currentSpeed >= 5 AND currentSpeed <= 10 AND ObjectDetection.SensorState = Active)

            THEN ObjectAvoidance.detectRoadObject; TeslaModelS.DrivingMode := Drive;

               Put_Line("Found Road Side - Object : " & ObjectAvoidance.RoadObjects'First'Image);

           end if;

            if(inDriveMode AND currentSpeed >= 10 AND currentSpeed <= 20 AND ObjectDetection.SensorState = Active)

            THEN ObjectAvoidance.detectRoadObject; TeslaModelS.DrivingMode := Drive;

               Put_Line("Found Road Side - Object : " & ObjectAvoidance.RoadObjects'Last'Image);

            end if;

       if(inDriveMode AND currentSpeed >= 21 AND currentSpeed <= 25 AND EastTrafficLights.TheTrafficLights = Green AND EastTrafficLights.Action = Drive)


            THEN TrafficLights.detectTrafficLight; TeslaModelS.DrivingMode := Drive;

               return;

            end if;


          if(currentSpeed > 30)
            THEN currentSpeed := currentSpeed - 1; TeslaModelS.DrivingMode := Drive;

               Put_Line("Speed Limit Cannot Be Exceeded." & "Now driving at : " & currentSpeed ' Image & " mp/h ");

               delay 0.5;

            end if;

         Put_Line( " Tesla Battery % -  " & currentCharge'Image & "%" & " - Battery Colour - " & TeslaModelS.Battery'Image & " driving at " & currentSpeed'Image & "mp/h" & "IN MODE : " & TeslaModelS.DrivingMode'Image);


         end if;
          end loop;


   end driveCar;


   procedure setParkedMode is -- Procedure to set the car in parked mode
   begin

      TeslaModelS.DrivingMode := Parked;
      Put_Line("Tesla now in" & TeslaModelS.DrivingMode'Image & "mode");

   end setParkedMode;

   procedure setDriveMode is

   begin

      TeslaModelS.DrivingMode := Drive;
      Put_Line("Tesla now in" & TeslaModelS.DrivingMode'Image & "mode");

   end setDriveMode;

   procedure setReverseMode is
   begin

       if(TeslaModelS.DrivingMode = Drive) THEN
         Put_Line("Cannot change gear from" & TeslaModelS.DrivingMode'Image & "to reverse mode");

      else

         TeslaModelS.DrivingMode := Revers;
         Put_Line("Tesla now in" & TeslaModelS.DrivingMode'Image & "mode");

         end if;

   end setReverseMode;

   procedure setNeutralMode is

   begin

      TeslaModelS.DrivingMode := Neutral; -- Set the car in neutral mode

      Put_Line("Tesla now in" & TeslaModelS.DrivingMode'Image & "mode");


      end setNeutralMode;

   procedure changeGear is

   begin

      if(NOT carIsOn AND inDiagnosticMode)

      THEN Put_Line("Cannot change gear. The car is currently : " & TeslaModelS.State'Image & " and in diagnostic mode");
         TeslaModelS.DiagnosticMode := On;

         return;

      end if;

      if(currentSpeed = TeslaMaxSpeed'First) -- If the vehicle is stationary and in parked mode

      THEN loop

            Put_Line("Select Gear");
            Put_Line("1. Park");
            Put_Line("2. Drive");
            Put_Line("3. Reverse");
            Put_Line("4. Neutral");
            Put_Line("Other value to return to main menu");
            Get_Line(GearVal, Last);

            -- Case statement to choose between one of the 4 gears
            case GearVal(1) is

               when '1' => setParkedMode;
               when '2' => setDriveMode;
               when '3' => setReverseMode;
               when '4' => setNeutralMode;

               when others => exit;
                  end case;

        end loop;

      else

         if(currentSpeed > 0 AND currentSpeed <= TeslaMaxSpeed'Last)

         THEN Put_Line ("Cannot change gear. The car is not stationary");


            end if;
         end if;

   end changeGear;


   procedure activateDiagnosticMode is -- Activates diagnostic mode. Car cannot drive and is now in parked mode and diagnostic mode is on

   begin

      if(TeslaModelS.CarKey = Present AND carIsOff AND isInParkedMode)

      THEN

         TeslaModelS.DrivingMode := Parked; -- Car is now in parked mode and cannot drive
         TeslaModelS.State := Off; -- The car is turned off

         if(carIsOff AND isInParkedMode)

         THEN Put_Line("Inside Diagnostic Mode. All other operations are rendered offline"); TeslaModelS.DiagnosticMode := On;
            Put_Line("Tesla now in Diagnostic Mode." & TeslaModelS.DiagnosticMode'Image);

            end if;

         end if;

   end activateDiagnosticMode;

   procedure chargeCar is

   begin
      EastTrafficLights.TheTrafficLights := Green;
        EastTrafficLights.Action := Drive;

      -- Check for diagnostic mode
      if(inDiagnosticMode)

        THEN TeslaModelS.DiagnosticMode := On;

         Put_Line("Cannot charge the car because car is diagnostic mode - " & TeslaModelS.DiagnosticMode'Image);
       return;
         end if;

      if(currentCharge = BatteryCharge'Last) -- Check to see if the battery is full

      THEN Put_Line("Tesla battery full. No need to charge");
         TeslaModelS.TheChargingPort := Closed;

         return;

         end if;


      loop

          if(NOT isInParkedMode AND carIsOff) -- If the car is not in parked mode and not turned of

         THEN Put_Line("Cannot charge the Tesla. Gear is " & TeslaModelS.DrivingMode'Image);

            TeslaModelS.State := Off; TeslaModelS.DrivingMode := Parked; TeslaModelS.TheChargingPort := Closed;

            return;

      end if;

         if(currentCharge >= minimumChargeLevel AND currentCharge < BatteryCharge'Last AND carIsOff)


         THEN currentCharge := currentCharge + 1; TeslaModelS.State := Off; TeslaModelS.DrivingMode := Parked;

            TeslaModelS.TheChargingPort := Open;


            delay 0.6;

            TeslaModelS.Battery := BlinkingGreen;
            Put_Line("Tesla is charging... % is " & currentCharge'Image & " charging port is : " & TeslaModelS.TheChargingPort'Image & " Battery Color: " & TeslaModelS.Battery'Image);

            if(currentCharge = 80)

            THEN Put_Line("To save battery health, the charging has paused. Do you wish to continue charging ?");

               Put_Line("1. Continue Charging");
               Put_Line("2. Stop Charging");


               Get_Line(ChargeVal, LastChargeVal);


               case ChargeVal(1) is

                  when '1' =>

                     currentCharge := currentCharge + 1; TeslaModelS.State := Off; TeslaModelS.DrivingMode := Parked;

                  when '2' => return;

                     when others => exit;

               end case;


            end if;

         end if;

          if(currentCharge = BatteryCharge'Last)

            THEN
                TeslaModelS.TheChargingPort := Closed;


               Put_Line("Charging finished.... " & currentCharge'Image & "%" & "CHARGING PORT NOW: " & TeslaModelS.TheChargingPort'Image);

            Put_Line("The car is now in :  " & TeslaModelS.DrivingMode'Image & " after charging ");
             return;

         end if;


         end loop;

   end chargeCar;


   procedure summonCar is


   begin

      if(inDiagnosticMode)

      THEN Put_Line("Car cannot be summoned. Diagnostic Mode is on...");

         return;

      end if;


      if(carIsOff AND isInParkedMode AND teslaKeyPresent) -- If the car is initially OFF in parked mode and the key is present with the owner

      THEN TeslaModelS.State := On; TeslaModelS.DrivingMode := Drive; TeslaModelS.CarKey := Present; --

         TeslaModelS.AutoSummonMode := On; -- Summon mode is activated

         Put_Line("Do you wish to activate summon mode ? ");

         Put_Line("1. Yes");
         Put_Line("2. No");

         Get_Line(SummonVal, SummonLastVal);

         case SummonVal(1) is

            when '1' =>
                 loop

                  if(currentSpeed >= 0 AND currentSpeed <= 5) THEN

               delay 0.9;

               currentSpeed := currentSpeed + 1;

               Put_Line("Summon Mode is : "  & TeslaModelS.AutoSummonMode'Image);
               Put_Line("Speed : " & currentSpeed'Image);

               if(currentSpeed = 5)

               THEN Put_Line("Car summoned.");

                 return;


                     end if;

              end if;

         end loop;


              when '2' => Put_Line("Summon Mode Not Activated"); return;

               when others => Put_Line("Exited!");
                  end case;

         end if;


     end summonCar;


end Car;
