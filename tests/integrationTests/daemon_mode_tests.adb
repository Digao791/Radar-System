with Interfaces.C;
with Interfaces.C.Strings;
with System;
with AUnit.Assertions;

package body Daemon_Mode_Tests is

   use Interfaces.C;
   use Interfaces.C.Strings;
   use AUnit.Assertions;

   function Fork return int
   with Import => True,
        Convention => C,
        External_Name => "fork";

   function Execv
     (File_Name : chars_ptr;
      Arguments : System.Address)
      return int
   with Import => True,
        Convention => C,
        External_Name => "execv";

   function System (Command : chars_ptr) return int
   with Import => True,
        Convention => C,
        External_Name => "system";

   function Kill (Process : int; Signal : int) return int
   with Import => True,
        Convention => C,
        External_Name => "kill";

   function Waitpid
     (Process : int;
      Status : access int;
      Options : int)
      return int
   with Import => True,
        Convention => C,
        External_Name => "waitpid";

   procedure C_Exit (Status : int)
   with Import => True,
        Convention => C,
        External_Name => "_exit";

   function Process_Is_Alive (Process : int) return Boolean is
      Status : aliased int;
      Wait_Result : constant int :=
        Waitpid (Process, Status'Access, 1);
   begin
      return Wait_Result = 0;
   end Process_Is_Alive;

   procedure Stop_Process (Process : int) is
      Status : aliased int;
   begin
      if Kill (Process, 15) = 0 then
         for Attempt in 1 .. 20 loop
            if Waitpid (Process, Status'Access, 1) /= 0 then
               exit;
            end if;
            delay 0.05;
         end loop;
      end if;
   end Stop_Process;

   procedure Should_Serve_HTTP_In_Daemon_Mode
     (T : in out Test)
   is
      pragma Unreferenced (T);
      Server_PID : constant int := Fork;
      Arguments : chars_ptr_array (0 .. 2);
      Curl_Status : int;
      Server_Responded : Boolean := False;
   begin
      Assert (Server_PID >= 0, "Should be able to fork the daemon process");

      if Server_PID = 0 then
         Arguments (0) := New_String ("../bin/radar_http");
         Arguments (1) := New_String ("--daemon");
         Arguments (2) := Null_Ptr;

         if Execv
              (Arguments (0),
               Arguments'Address) = -1
         then
            C_Exit (127);
         end if;
      end if;

      for Attempt in 1 .. 40 loop
         Curl_Status :=
           System
             (New_String
                ("curl --fail --silent --output /dev/null " &
                 "--max-time 1 http://127.0.0.1:8080/api/radar/status " &
                 "> /dev/null 2>&1"));

         if Curl_Status = 0 then
            Server_Responded := True;
            exit;
         end if;

         if not Process_Is_Alive (Server_PID) then
            exit;
         end if;

         delay 0.25;
      end loop;

      Assert
        (Server_Responded,
         "Daemon mode should start and serve the status endpoint");
      Assert
        (Process_Is_Alive (Server_PID),
         "Daemon mode should remain alive until explicitly stopped");

      Stop_Process (Server_PID);
   end Should_Serve_HTTP_In_Daemon_Mode;

end Daemon_Mode_Tests;
