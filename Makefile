TARGETS=index.html


all: $(TARGETS)

clean:
	rm -f $(TARGETS)


%.html: %.html.coffee
	(sh -c "coffee $< >$@.new" && mv $@.new $@ && touch -r $< $@) || rm -f $@

%.js: %.coffee
	coffee -bc $<
