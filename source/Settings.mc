import Toybox.Application;

module Settings {
    var smokeSetting;

    function getProperties(){
    smokeSetting = Application.Properties.getValue("smokeField");
    }
}
