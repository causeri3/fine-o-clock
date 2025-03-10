import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({ :title => "Settings"});
        

    // Add smokeField to the menu
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.smokeField, 
            getSmokeFieldString(Application.Properties.getValue("smokeField")),
            "bli",
            {}
            )
        );

        Menu2.addItem(
            new MenuItem(
                "smokeField2", 
                "bla2", 
                "bli2",
                {}
                )
        );
    }
}

  function getSmokeFieldString(fieldId) {
    if (fieldId == 0) {
      return Rez.Strings.date;
    } else if (fieldId == 1) {
      return Rez.Strings.calories;
    }
    return "";
  }


class MenuDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    if (item.getId().equals("smokeField")) {
      var currentValue = Application.Properties.getValue("smokeField");
      var newValue = (currentValue + 1) % 2; // Toggle between 0 and 1
      Application.Properties.setValue("smokeField", newValue);
      //item.setTitle(getSmokeFieldString(newValue)); // Update the title based on new value

      // WatchUi.requestUpdate();
    }
  }
}