TARGETS=coffee-script.js index.html


all: $(TARGETS)

clean:
	rm -f $(TARGETS)


%.html: %.html.coffee
	(sh -c "coffee $< >$@.new" && mv $@.new $@ && touch -r $< $@) || rm -f $@

%.js: %.coffee
	coffee -bc $<


lib/coffee-script.js: ../reflective-coffeescript/extras/coffee-script.js
	cp -av $< $@
