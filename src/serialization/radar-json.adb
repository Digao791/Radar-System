with GNATCOLL.JSON;
with Ada.Strings.Unbounded;

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

   function To_JSON
   (Target : Radar.DTO.Targets.Target_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;

   begin
      Result.Set_Field ("id", Integer (Target.ID));
      Result.Set_Field ("x", Target.X);
      Result.Set_Field ("y", Target.Y);
      Result.Set_Field ("speed", Target.Speed);
      Result.Set_Field ("heading", Target.Heading);

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Targets.Targets_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;
      Items  : JSON_Array := Empty_Array;

   begin
      for Target of Response.Targets loop
         Append (Items, To_JSON (Target));
      end loop;

      Result.Set_Field ("targets", Items);

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Detection.Detections_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;
      Items  : JSON_Array := Empty_Array;

   begin
      for Target of Response.Detected_Targets loop
         Append (Items, To_JSON (Target));
      end loop;

      Result.Set_Field ("detected_targets", Items);

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Config.Config_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;

   begin
      Result.Set_Field ("x", Response.X);
      Result.Set_Field ("y", Response.Y);
      Result.Set_Field ("radar_range", Response.Radar_Range);

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Status.Status_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;

   begin
      Result.Set_Field
      ("status",
         Radar.DTO.Status.Radar_Status'Image (Response.Status));

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Control.Control_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;

      Result : JSON_Value := Create_Object;

   begin
      case Response.Status is
         when Radar.DTO.Control.Paused =>
            Result.Set_Field ("status", "Paused");

         when Radar.DTO.Control.Resumed =>
            Result.Set_Field ("status", "Resumed");
      end case;

      return Result;
   end To_JSON;

   function To_JSON
   (Response : Radar.DTO.Errors.Error_Response)
      return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
      use Ada.Strings.Unbounded;

      Result : JSON_Value := Create_Object;

   begin
      Result.Set_Field ("error", To_String (Response.Error));

      return Result;
   end To_JSON;
   
end Radar.JSON;