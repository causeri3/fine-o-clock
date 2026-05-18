import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

// Old devices throw "Background processes cannot modify the object store"
// Route through this module so the workaround lives in one place.
(:background)
module SafeStorage {

    function getValue(key) {
        try {
            return Storage.getValue(key);
        } catch (e) {
            System.println("SafeStorage.getValue failed for key=" + key + ": " + e.getErrorMessage());
            return null;
        }
    }

    function setValue(key, value) as Boolean {
        try {
            Storage.setValue(key, value);
            return true;
        } catch (e) {
            System.println("SafeStorage.setValue failed for key=" + key + ": " + e.getErrorMessage());
            return false;
        }
    }

    function deleteValue(key) as Boolean {
        try {
            Storage.deleteValue(key);
            return true;
        } catch (e) {
            System.println("SafeStorage.deleteValue failed for key=" + key + ": " + e.getErrorMessage());
            return false;
        }
    }
}
