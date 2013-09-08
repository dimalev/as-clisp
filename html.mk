html: app
	sed s/$$\{application}/$(NAME)/g index.template.html |\
	sed s/$$\{expressInstallSwf}/playerProductInstall.swf/g |\
	sed s/$$\{height}/$(APP_HEIGHT)/g |\
	sed s/$$\{width}/$(APP_WIDTH)/g |\
	sed s/$$\{swf}/$(NAME)/g |\
	sed s/$$\{title}/$(HTML_TITLE)/g |\
	sed s/$$\{useBrowserHistory}/false/g |\
	sed s/$$\{version_major}/11/g |\
	sed s/$$\{version_minor}/2/g |\
	sed s/$$\{version_revision}/0/g |\
  sed s/$$\{bgcolor}/$(BG_COLOR)/g > dest/index.html

