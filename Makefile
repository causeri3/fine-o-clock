include properties.mk

appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`
devices = `grep 'iq:product id' manifest.xml | sed 's/.*iq:product id="\([^"]*\).*/\1/'`


define build_device
	$(SDK_HOME)/bin/monkeyc \
		--jungles ./monkey.jungle \
		--device $(1) \
		--output bin/$(appName)-$(1).prg \
		--private-key $(PRIVATE_KEY) \
		$(2)
endef

# make sure they are not read as files (in case file with that name exists in the directory)
.PHONY: build build.release buildall run run.settings clean buildrunscreenshotall runscreenshotall

build:
	$(call build_device,$(DEVICE),--debug)

build.release:
	$(call build_device,$(DEVICE),--release)

buildall:
	@for device in $(devices); do \
		echo "-----"; \
		echo "Building for" $$device; \
		$(call build_device,$$device,--release); \
	done


run: 
	-pkill -f connectiq || true
	$(SDK_HOME)/bin/connectiq &&\
	sleep 6 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-$(DEVICE).prg $(DEVICE)

run.settings: 
	-pkill -f connectiq || true
	$(SDK_HOME)/bin/connectiq &&\
	sleep 6 &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-$(DEVICE).prg $(DEVICE) -a bin/$(appName)-$(DEVICE)-settings.json:GARMIN/Settings/$(appName)-$(DEVICE)-settings.json



clean:
	rm -rf bin/*.prg
	rm -rf bin/*.iq
	rm -rf bin/*.prg.*
	rm -rf bin/*.jungle
	rm -rf .build/


runscreenshotall:
# mac issue with the dock and screenshots
	@defaults write com.apple.dock orientation -string left && killall Dock
	@mkdir -p screenshots
	@for device in $(devices); do \
		echo "Screenshot for $$device..."; \
		pkill -f connectiq || true; \
		$(SDK_HOME)/bin/connectiq & \
		sleep 4; \
		$(SDK_HOME)/bin/monkeydo bin/$(appName)-$$device.prg $$device & \
		sleep 10; \
		./screenshot.sh $$device; \
		pkill -f connectiq; \
	done
# mac issue with the dock and screenshots
	@defaults write com.apple.dock orientation -string bottom && killall Dock

runscreenshotone:
# mac issue with the dock and screenshots
	@defaults write com.apple.dock orientation -string left && killall Dock
	@mkdir -p screenshots
	echo "Screenshot for $(DEVICE)..."; \
	pkill -f connectiq || true; \
	$(SDK_HOME)/bin/connectiq & \
	sleep 4; \
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-$(DEVICE).prg $(DEVICE) & \
	sleep 10; \
	./screenshot.sh $(DEVICE); \
	pkill -f connectiq; \
# mac issue with the dock and screenshots
	@defaults write com.apple.dock orientation -string bottom && killall Dock

get.crashes:
	$(SDK_HOME)/bin/era -a $(APP_ID) -k $(PRIVATE_KEY)


# get iq file for the store
# ⌘ Shift P - Verify Installation
# ⌘ Shift P - Export Project
