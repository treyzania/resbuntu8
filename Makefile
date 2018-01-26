XUBU_ISO=xubuntu.iso

.PHONY: download unpack clean

all:
	@echo 'Nothing!'

download:
	@echo 'Downloading ISO...'
	@./dl.sh ${XUBU_ISO}

unpack: download
	@echo 'Extracting ISO contents...'
	@sudo ./unpack.sh ${XUBU_ISO}

clean:
	sudo ./cleanup.sh
	rm ${XUBU_ISO}
