
with Ada.Text_IO;

with Radar.Targets;
with Radar.Simulation;
with Radar.Detection;
with Radar.Shared_State;
with Radar.Engine;
with Radar.Service;

procedure Ada_Radar is

   use Ada.Text_IO;

   -- Shared simulation data
   Shared : aliased Radar.Shared_State.Shared_Simulation;

   -- Engine execution status
   State : aliased Radar.Engine.Engine_State;

   -- Radar station
   Station : constant Radar.Detection.Radar_Station :=
     (X           => 0.0,
      Y           => 0.0,
      Radar_Range => 30.0);

   -- First target
   Target_1 : constant Radar.Targets.Target :=
     (ID      => 1,
      X       => 10.0,
      Y       => 0.0,
      Speed   => 1.0,
      Heading => 90.0);

   -- Second target
   Target_2 : constant Radar.Targets.Target :=
     (ID      => 2,
      X       => 40.0,
      Y       => 0.0,
      Speed   => 2.0,
      Heading => 180.0);

begin

   Put_Line ("=== ADA RADAR ===");

   -- Initialize simulation
   Shared.Initialize;

   -- Register targets
   Shared.Add_Target (Target_1);
   Shared.Add_Target (Target_2);

   -- Start and control the engine
   declare

      Engine : aliased Radar.Engine.Engine_Task
        (Shared'Access, State'Access);

      Service : Radar.Service.Radar_Service
        (Engine'Access, State'Access, Shared'Access);

      Success : Boolean;

   begin

      Put_Line
        ("[SERVICE] Initial status: "
         & Radar.Engine.Engine_Status'Image
             (Radar.Service.Get_Status (Service)));

      -- Let the simulation run
      delay 2.5;

      -- Pause
      Radar.Service.Pause (Service, Success);

      Put_Line
        ("[SERVICE] Pause: " & Success'Image);

      Put_Line
        ("[SERVICE] Current status: "
         & Radar.Engine.Engine_Status'Image
             (Radar.Service.Get_Status (Service)));

      
      --  Try pausing an already paused engine
      Radar.Service.Pause (Service, Success);

      Put_Line
      ("[SERVICE] Second pause: "
         & Success'Image);


      -- Keep the engine paused
      delay 3.0;

      -- Resume
      Radar.Service.Resume (Service, Success);

      Put_Line
        ("[SERVICE] Resume: " & Success'Image);


      --  Try resuming an already running engine
      Radar.Service.Resume (Service, Success);

      Put_Line
      ("[SERVICE] Second resume: "
         & Success'Image);

      -- Let the simulation run again
      delay 3.5;

      -- Stop
      Radar.Service.Stop (Service, Success);

      Put_Line
        ("[SERVICE] Stop: " & Success'Image);

   end;

   -- Engine task has terminated
   Put_Line
     ("[MAIN] Final engine status: "
      & Radar.Engine.Engine_Status'Image
          (State.Get_Status));

   -- Read the final simulation snapshot
   declare

      Snapshot : constant Radar.Simulation.Simulation :=
        Shared.Get_Snapshot;

   begin

      Put_Line ("=== FINAL RADAR STATE ===");

      Radar.Simulation.Print (Snapshot);

      Put_Line ("=== DETECTED TARGETS ===");

      Radar.Simulation.Scan (Snapshot, Station);

   end;

end Ada_Radar;
