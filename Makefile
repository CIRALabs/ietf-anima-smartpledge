DRAFT:=anima-smarkaklink
VERSION:=$(shell ./getver ${DRAFT}.md )

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt anima-smarkaklink-flowchart.png
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.md smartpledge-swagger.yaml
	kramdown-rfc2629 ${DRAFT}.md | ./insert-figures >${DRAFT}.xml
	: git add ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc $? $@

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	curl -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

anima-smarkaklink-flowchart.png: anima-smarkaklink-flowchart.msc
	mscgen -T png anima-smarkaklink-flowchart.msc

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml ${CWTDATE1} ${CWTDATE2}

.PRECIOUS: ${DRAFT}.xml
