with Car; use Car;
with TrafficLights; use TrafficLights;
with ObjectAvoidance; use ObjectAvoidance;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure Main is

   InputString : String (1..8);
   Last : Natural;


   task GetUserInput;


   task body GetUserInput is

   begin

      loop
         Put_Line("Welcome to Tesla Model S. Select options below");

         Put_Line("Car State : " & Car.TeslaModelS.State'Image & " - " & "Gear : " & Car.TeslaModelS.DrivingMode'Image);

         Put_Line("***********************************************");

         Put_Line("Town Speed Limit : " & townSpeedLimit'Image & " mp /h ");
         Put_Line("Doors : " & Car.TeslaModelS.CarDoors'Image);

         Put_Line("1. Turn Tesla On");
         Put_Line("2. Turn Tesla Off");
         Put_Line("3. Drive"); -- When executed, the car will drive and will determine if there is enough charge + low of litle charge
         Put_Line("4. Diagnostic Mode");
         Put_Line("5. Change Gear");
         Put_Line("6. Charge Car");
         Put_Line("7. Activate Summon Mode");
         Put_Line("8. Turn Off Diagnostic Mode");

         Put_Line("Any other option to exit");


         Put_Line("***********************************************");


         Get_Line(InputString, Last);

         case InputString(1) is

            when '1' => turnCarOn;
            when '2' => turnCarOff;
            when '3' => driveCar;
            when '4' => activateDiagnosticMode;
            when '5' => changeGear;
            when '6' => chargeCar;
            when '7' => summonCar;
            when '8' => turnOffDiagnosticMode;

            when others => exit;

            end case;

      end loop;

      delay 0.1;

   end GetUserInput;



begin

  null;

end Main;
