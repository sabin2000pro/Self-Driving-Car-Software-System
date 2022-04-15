with Ada.Text_IO; use Ada.Text_IO;
with Car; use Car;


package body AutoPark with SPARK_Mode is

   procedure detectParkingSpace is

   begin

      ParkSpaceObject.ParkIcon := Hidden;
      Put_Line(" Car detected :" & ParkSpaceObject.ParkingSpace'Image & "parking space...");

      Put_Line("Park Detect Icon : " & ParkSpaceObject.ParkingSpace'Image);

      loop

        if(Car.inDriveMode AND Car.speedIsWithinLimits AND ParkSpaceObject.ParkIcon = Hidden AND ParkSpaceObject.ParkingSpace = Free)

         THEN

            delay 0.3;

            ParkSpaceObject.ParkIcon := Visible;

            Put_Line("Current Speed : " & Car.currentSpeed'Image & " park icon : " & ParkSpaceObject.ParkIcon'Image);

       Put_Line("A free parking space has been detected nearby. Do you wish to activate auto park mode ? ");

               Put_Line("1. Start Auto Park");
            Put_Line("2. Disable Auto Park");

            Get_Line(AutoParkVal, LastParkVal);

           Car.TeslaModelS.DrivingMode := Parked;
           ParkSpaceObject.ParkingSpace := Taken;

                case AutoParkVal(1) is

               when '1' =>

                  delay 0.4;

                  Put_Line("Started Parking..");


                     when '2' => delay 0.2; Put_Line("Auto Park Disabled"); return;

                 when others => return;
                  end case;


            delay 0.3;


            end if;

         end loop;



      end detectParkingSpace;


 end AutoPark;
