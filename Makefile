include properties.mk

appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`
devices = `grep 'iq:product id' manifest.xml | sed 's/.*iq:product id="\([^"]*\).*/\1/'`


BUILD_PARAMS = \
	--jungles ./monkey.jungle \
	--device $(DEVICE) \
	--output bin/$(appName).prg \
	--private-key $(PRIVATE_KEY)


build:
	$(SDK_HOME)/bin/monkeyc \
	$(BUILD_PARAMS) \
	--debug

build.release:
	$(SDK_HOME)/bin/monkeyc \
	$(BUILD_PARAMS) \
	--release

buildall:
	@for device in $(devices); do \
		echo "-----"; \
		echo "Building for" $$device; \
    $(SDK_HOME)/bin/monkeyc \
		--jungles ./monkey.jungle \
		--device $$device \
		--output bin/$(appName)-$$device.prg \
		--private-key $(PRIVATE_KEY) \
		--release; \
	done

run: 
	-pkill -f connectiq || true
	$(SDK_HOME)/bin/connectiq &&\
	sleep 6 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

run.settings: 
	-pkill -f connectiq || true
	$(SDK_HOME)/bin/connectiq &&\
	sleep 6 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE) -a bin/$(appName)-settings.json:GARMIN/Settings/$(appName)-settings.json


clean:
	rm -rf bin/*.prg
	rm -rf bin/*.iq
	rm -rf bin/*.prg.*
	rm -rf bin/*.jungle
	rm -rf .build/
