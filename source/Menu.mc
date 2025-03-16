import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

  function initialize() {
    Menu2.initialize({ :title => "Settings"});
    add_items();
  }

  function add_items() {     
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.smokeField, // label
            Settings.getFieldString(Settings.smokeSetting), // sublabel
            "smokeField", // id
            {} // options
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.bubbleField,
            Settings.getFieldString(Settings.bubbleSetting),
            "bubbleField",
            {}
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.cupField, 
            Settings.getFieldString(Settings.cupSetting), 
            "cupField", 
            {} 
        )
    );
  }                                                                                                       
}

class MenuDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    var id = item.getId();
    if (id.equals("smokeField")) {
      cycleFields(Settings.smokeSetting, item, id);
    }
    else if (id.equals("bubbleField")) {
      cycleFields(Settings.bubbleSetting, item, id);
    }
    else if (id.equals("cupField")) {
      cycleFields(Settings.cupSetting, item, id);
    }
  }

  hidden function cycleFields(setting, item, fieldId){
      setting = (setting + 1) % Settings.fieldsMap.size();
      item.setSubLabel(Settings.getFieldString(setting));
      Application.Properties.setValue(fieldId, setting);
      Settings.getProperties();

  }
}
