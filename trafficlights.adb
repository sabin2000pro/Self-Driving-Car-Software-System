with Ada.Text_IO; use Ada.Text_IO;
with Car; use Car;
with AutoPark; use AutoPark;


package body TrafficLights with SPARK_Mode is

   procedure detectTrafficLight is

   begin

      -- If car is driving, speed is between 0 and 30 and the current action is drive before detecting a light
      if(Car.inDriveMode AND Car.speedIsWithinLimits AND EastTrafficLights.Action = Drive)


      THEN
           TeslaModelS.DrivingMode := Drive;

         delay 0.3;

         Put_Line("Detected traffc light.. Traffic Light - " & EastTrafficLights.TheTrafficLights'Image);


         loop

            TeslaModelS.DrivingMode := Drive;

            if(Car.currentSpeed > 0 AND currentCharge > minimumChargeLevel AND currentCharge <= BatteryCharge'Last)

            THEN -- If the current vehicle speed is > 0
               Car.currentSpeed := Car.currentSpeed - 1; -- Slow the vehicle down once red light is detected..
               TeslaModelS.DrivingMode := Drive;

               Put_Line("Slowing down..." & Car.currentSpeed'Image & "mph");
               EastTrafficLights.TheTrafficLights := Red;

               EastTrafficLights.Action := Stop; -- Stop at red lights

            delay 0.8;

               if(Car.currentSpeed = TeslaMaxSpeed'First)

               THEN Car.currentSpeed := TeslaMaxSpeed'First; -- Set the car to stationary

                  EastTrafficLights.TheTrafficLights := Red; -- Traffic light is now red

                  Put_Line("Traffic Light  - " & EastTrafficLights.TheTrafficLights'Image & " Tesla " & EastTrafficLights.Action'Image);

                  delay 2.5;

                  EastTrafficLights.TheTrafficLights := Green;

                  EastTrafficLights.Action := Drive;


                  Put_Line(" Traffic Light CHANGED TO  - " & EastTrafficLights.TheTrafficLights'Image & EastTrafficLights.Action'Image);


                  delay 0.5;
            loop

                 if(EastTrafficLights.TheTrafficLights = Green AND currentSpeed >= 0 AND currentSpeed < TeslaMaxSpeed'Last AND currentCharge > minimumChargeLevel)

                     THEN delay 0.6; Car.currentSpeed := Car.currentSpeed + 1; currentCharge := currentCharge - 1;

                        Put_Line("Tesla Charge - " & Car.currentCharge'Image & "%" & " speed : " & currentSpeed'Image & "mp/h" );
                        TeslaModelS.DrivingMode := Drive;

                     end if;

                     --
            if(Car.inDriveMode AND currentSpeed >= 23 AND currentSpeed <= 27 AND AutoPark.ParkSpaceObject.ParkingSpace = Free AND AutoPark.ParkSpaceObject.ParkIcon = Hidden)


          THEN AutoPark.detectParkingSpace;


                end if;



                 if(Car.currentSpeed > 30)

                     THEN delay 0.3;
                      Car.currentSpeed := Car.currentSpeed - 1;


            Put_Line("Speed Limit Cannot Be Exceeded." & " Current Speed :  " & currentSpeed'Image & " mp/h ");


          if(currentCharge <= 90)

                  THEN delay 0.3;
                     TeslaModelS.DrivingMode := Drive;

          end if;

            if(currentCharge >= 25 AND currentCharge <= 40) -- If charge is between 30 and 40


            THEN TeslaModelS.Battery := Amber; Put_Line("WARNING LOW CHARGE - Battery Colour " & TeslaModelS.Battery'Image);

                        TeslaModelS.DrivingMode := Drive;
               delay 0.5;

            else

               if(currentCharge >= 11 AND currentCharge <= 20)

               THEN TeslaModelS.Battery := Red; TeslaModelS.DrivingMode := Drive;

                  Put_Line("Warning - Very Low Charge - Tesla needs charging... car turning off soon - BATTERY COLOUR : " & TeslaModelS.Battery'Image);
                          TeslaModelS.DrivingMode := Drive;
                  delay 0.5;


                    else

               if(currentCharge = minimumChargeLevel) -- If thecharge is at it's mimimum charge level

                 THEN TeslaModelS.DrivingMode := Parked; TeslaModelS.State := Off; -- Car will be turned off and into parked mode
                     TeslaModelS.DrivingMode := Parked; currentSpeed := 0;

                       Put_Line("Tesla reached minimum charge. Battery -  " & currentCharge'Image & " % " & "car is now " & TeslaModelS.State'Image);


                    return;

                              end if;

                           end if;

                        end if;

                     end if;


               end loop;


               end if;

               end if;

         end loop;

      end if;

    end detectTrafficLight;


   end TrafficLights;
