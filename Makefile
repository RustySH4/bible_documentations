all: preview

# set variable
BUNDLE	:= bundle
JEK	:= $(BUNDLE) exec jekyll



# Prepare the build by installing the modules that aren't installed to
# the local `vendor/` folder to avoid conflicts.
check-plugins:
	$(BUNDLE) check || $(BUNDLE) install --path vendor/bundle
	$(BUNDLE) update

# run a local webserver and update automatically when a change is
# made to view the modifications before pushing them to the server.
preview: check-plugins
	$(JEK) serve --drafts --watch --trace


# just build to install the thing
push: check-plugins
	$(JEK) build
	rsync -Prlt --delete --exclude=up/ _site/ yatis@creativecalc.fr:/home/yatis/bible/



.PHONY: check-plugins
.PHONY: preview build-all
