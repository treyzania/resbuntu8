XUBU_ISO=xubuntu.iso

.PHONY: download unpack clean

all:
	@echo 'Nothing!'

download:
	@echo 'Downloading ISO...'
	@./dl.sh ${XUBU_ISO}

unpack: download
	@echo 'Extracting ISO contents...'
	@./unpack.sh ${XUBU_ISO}

package:
	@echo 'Repacking ISO...'
	@./mkiso.sh

clean:
	sudo ./cleanup.sh
	rm ${XUBU_ISO}
