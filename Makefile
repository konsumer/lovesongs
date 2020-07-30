NAME=lovesongs
VERSION=11.3

.PHONY: help run clean

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## run the current project
	cd $(PWD)/src && love .

clean: ## delete all output files
	rm -rf runtime dist

build: dist/$(NAME).love dist/demosong.lovesong dist/windows/$(NAME).exe dist/macos/$(NAME) ## build distributables for everyone in dist/

demo: dist/demosong.lovesong ## create a demo-song from demosong/

runtime/windows:
	rm -f /tmp/love-windows.zip
	mkdir -p $(PWD)/runtime/windows
	curl -L https://bitbucket.org/rude/love/downloads/love-$(VERSION)-win64.zip -o /tmp/love-windows.zip
	cd $(PWD)/runtime/windows && unzip /tmp/love-windows.zip
	mv $(PWD)/runtime/windows/love-$(VERSION)-win64/* $(PWD)/runtime/windows/
	rmdir $(PWD)/runtime/windows/love-$(VERSION)-win64/

runtime/macos:
	rm -f /tmp/love-macos.zip
	mkdir -p $(PWD)/runtime/macos
	curl -L https://bitbucket.org/rude/love/downloads/love-$(VERSION)-macos.zip -o /tmp/love-macos.zip
	cd $(PWD)/runtime/macos && unzip /tmp/love-macos.zip

dist/$(NAME).love: src/**/*.lua
	mkdir -p $(PWD)/dist
	cd src && zip -9 -r /tmp/$(NAME).zip .
	mv /tmp/$(NAME).zip $(PWD)/dist/$(NAME).love

dist/windows/$(NAME).exe: runtime/windows dist/$(NAME).love
	mkdir -p $(PWD)/dist/windows
	cat $(PWD)/runtime/windows/love.exe $(PWD)/dist/$(NAME).love > $(PWD)/dist/windows/$(NAME).exe
	cp $(PWD)/runtime/windows/*.dll $(PWD)/runtime/windows/*.ico $(PWD)/dist/windows/

dist/macos/$(NAME): runtime/macos dist/$(NAME).love
	mkdir -p $(PWD)/dist/macos
	cp -R $(PWD)/runtime/macos/love.app $(PWD)/dist/macos/$(NAME).app
	sed -e "s/GAME_NAME/$(NAME)/g" $(PWD)/Info.plist > $(PWD)/dist/macos/$(NAME).app/Contents/Info.plist
	cp dist/$(NAME).love $(PWD)/dist/macos/$(NAME).app/Contents/Resources/

dist/demosong.lovesong: demosong/** 
	mkdir -p dist/
	cd  demosong/ && zip -r ../dist/demosong.lovesong .

# this is sort of specific to my setup
deploy: dist/$(NAME).love
	ssh pi@gameboy.local "killall -9 love || exit 0"
	scp dist/$(NAME).love pi@gameboy.local:/home/pi/RetroPie/roms/love/$(NAME).love
