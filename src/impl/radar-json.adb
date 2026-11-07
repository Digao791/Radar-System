with GNATCOLL.JSON;

package body Radar.JSON is
   function To_JSON (Target : Radar.Targets.Target) return GNATCOLL.JSON.JSON_Value is
      use GNATCOLL.JSON;
      Result : Json_Value := Create_Object;
   begin
      Result.Set_Field ("id", Integer (Target.ID));
      Result.Set_Field ("x", Float (Target.X));
      Result.Set_Field ("y", Float (Target.Y));
      Result.Set_Field ("speed", Float (Target.Speed));
      Result.Set_Field ("heading", Float (Target.Heading));
      return Result;
   end To_JSON;

   function To_JSON (Sim : Radar.Simulation.Simulation) return GNATCOLL.JSON.JSON_Value is
      use GNATCOLL.JSON;
      Result : JSON_Value := Create_Object;
      Items  : JSON_Array := Empty_Array;
      Count  : constant Natural    := Radar.Simulation.Get_Count (Sim);
   begin

      for I in 1 .. Count loop
         Append (Items, To_JSON (Radar.Simulation.Get_Target_At (Sim, I)));
      end loop;

      Result.Set_Field ("targets", Items);
      return Result;
   end To_JSON;

end Radar.JSON;