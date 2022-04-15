with Ada.Text_IO; use Ada.Text_IO;


package body ObjectAvoidance with SPARK_Mode is

   procedure detectRoadObject is

   begin

      if(Car.speedIsWithinLimits AND Car.inDriveMode)

      THEN

         Car.TeslaModelS.DrivingMode := Drive;

         ObjectDetection.SensorState := Active;
         ObjectDetection.ObjectFoundValue := Yes;
         ObjectDetection.DetectedAction := Avoid;

         delay 0.3;

        Put_Line("One of the Tesla sensor is - " & ObjectDetection.SensorState'Image & " - and action taken - " & ObjectDetection.DetectedAction'Image);


         end if;

      end detectRoadObject;

 end ObjectAvoidance;
