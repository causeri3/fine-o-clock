import Toybox.System;

(:debug)
module Log {
  function debug(string) {
    System.println("| DEBUG | " + string);
  
}}

(:release)
module Log {
  function debug(string) {}
}
