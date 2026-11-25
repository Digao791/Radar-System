with Ada.Strings.Unbounded;

package Radar.DTO.Errors is

   type Error_Response is record
      Error : Ada.Strings.Unbounded.Unbounded_String;
   end record;

end Radar.DTO.Errors;