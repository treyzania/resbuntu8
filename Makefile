XUBU_ISO=xubuntu.iso
WORK_DIR=work

.PHONY: download package unpack clean

all:
	@echo 'Nothing!'

download:
	@if [ ! -f ${XUBU_ISO} ]; then \
		echo 'downloading ISO...' ; \
		./dl.sh ${XUBU_ISO} ; \
	else \
		echo 'ISO OK' ; \
	fi

unpack: download
	@if [ ! -f ${WORK_DIR} ]; then \
		echo 'extracting ISO...' ; \
		./unpack.sh ${XUBU_ISO} ${WORK_DIR} ; \
	else \
		echo 'unpack OK' ; \
	fi

package:
	@echo 'repacking ISO...'
	@./mkiso.sh ${WORK_DIR}

clean:
	sudo ./cleanup.sh ${WORK_DIR}
	rm ${XUBU_ISO}
