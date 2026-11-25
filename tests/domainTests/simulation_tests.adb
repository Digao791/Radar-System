with AUnit.Assertions;
with Radar.Simulation;
with Radar.Targets;

package body Simulation_Tests is

   use AUnit.Assertions;

   Tolerance : constant Float := 0.001;

   function Create_Target
      (ID : Positive;
       X, Y, Speed, Heading : Float)
       return Radar.Targets.Target
   is
   begin
      return
        (ID      => ID,
         X       => X,
         Y       => Y,
         Speed   => Speed,
         Heading => Heading);
   end Create_Target;

   procedure Should_Initialize_Empty_Simulation
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Sim : Radar.Simulation.Simulation;
   begin
      Radar.Simulation.Initialize (Sim);
      Assert
        (Radar.Simulation.Get_Count (Sim) = 0,
         "Initialized simulation should be empty");
   end Should_Initialize_Empty_Simulation;

   procedure Should_Add_Retrieve_And_Count_Targets
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Sim : Radar.Simulation.Simulation;
      Target : constant Radar.Targets.Target :=
        Create_Target (7, 10.0, 20.0, 25.0, 90.0);
      Retrieved : Radar.Targets.Target;
      Found : Boolean;
   begin
      Radar.Simulation.Initialize (Sim);
      Radar.Simulation.Add_Target (Sim, Target);
      Radar.Simulation.Get_Target (Sim, 7, Retrieved, Found);

      Assert (Found, "Added target should be retrievable");
      Assert
        (Retrieved.ID = 7,
         "Retrieved target should preserve its identifier");
      Assert
        (Radar.Simulation.Get_Count (Sim) = 1,
         "Simulation count should include the added target");
      Assert
        (abs (Radar.Simulation.Get_Target_At (Sim, 1).X - 10.0)
           < Tolerance,
         "Target at index should preserve its position");
   end Should_Add_Retrieve_And_Count_Targets;

   procedure Should_Step_All_Targets
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Sim : Radar.Simulation.Simulation;
      Horizontal : constant Radar.Targets.Target :=
        Create_Target (1, 0.0, 0.0, 10.0, 0.0);
      Vertical : constant Radar.Targets.Target :=
        Create_Target (2, 0.0, 0.0, 10.0, 90.0);
      First, Second : Radar.Targets.Target;
   begin
      Radar.Simulation.Initialize (Sim);
      Radar.Simulation.Add_Target (Sim, Horizontal);
      Radar.Simulation.Add_Target (Sim, Vertical);
      Radar.Simulation.Step (Sim, 2.0);

      First := Radar.Simulation.Get_Target_At (Sim, 1);
      Second := Radar.Simulation.Get_Target_At (Sim, 2);

      Assert
        (abs (First.X - 20.0) < Tolerance
           and abs (First.Y) < Tolerance,
         "Step should move the first target horizontally");
      Assert
        (abs (Second.X) < Tolerance
           and abs (Second.Y - 20.0) < Tolerance,
         "Step should move the second target vertically");
   end Should_Step_All_Targets;

   procedure Should_Reject_Invalid_Target_Index
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Sim : Radar.Simulation.Simulation;
      Raised : Boolean := False;
   begin
      Radar.Simulation.Initialize (Sim);
      begin
         declare
            pragma Warnings (Off);
            Unused : constant Radar.Targets.Target :=
              Radar.Simulation.Get_Target_At (Sim, 1);
         begin
            null;
         end;
      exception
         when Constraint_Error =>
            Raised := True;
      end;

      Assert
        (Raised,
         "Requesting a target beyond the simulation count should fail");
   end Should_Reject_Invalid_Target_Index;

end Simulation_Tests;
