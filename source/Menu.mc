import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({ :title => "Settings"});
        
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.smokeField, // lable
            Settings.getFieldResource(Settings.smokeSetting), // sublabel
            "smoke", // id
            {} // option: :alignment :icon
            )
        );

    }
}



class MenuDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {

    if (item.getId().equals("smoke")) {
       pushOptionsMenu(item);
          
      //var currentValue = Application.Properties.getValue("smokeField");
      //var newValue = (currentValue + 1) % 2; // Toggle between 0 and 1
      //Application.Properties.setValue("smokeField", newValue);
      //item.setTitle(getSmokeFieldString(newValue)); // Update the title based on new value

      // WatchUi.requestUpdate();
    }
  }
  hidden function pushOptionsMenu(parent) as Void {                                            
                                                                                                
    var menuSmoke = new WatchUi.Menu2({ :title => "Fields" });                                                  
    menuSmoke.addItem(
      new MenuItem(
            Settings.getFieldString(0),
            null,
            "0",
            {}
            ));
            
    menuSmoke.addItem(
      new MenuItem(
            Settings.getFieldString(1),
            null,
            "1",
            {}
            ));

    WatchUi.pushView(menuSmoke, new OptionsMenuDelegate(), WatchUi.SLIDE_LEFT);
  }
}


 class OptionsMenuDelegate extends WatchUi.Menu2InputDelegate {                                 
                                                                                                
   function initialize() {                                                                                                                                                                
     Menu2InputDelegate.initialize();                                                                                                                                                     
   }

   function onSelect(item) {
    var chosenValue = item.getId().toNumber();
    Application.Properties.setValue("smokeField", chosenValue);
    Settings.getProperties();
    WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

   function onBack() {
    WatchUi.popView(WatchUi.SLIDE_RIGHT);                                                                                                                                    
   }                                                                                      
 }