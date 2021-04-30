REPO = https://github.com/QuickChick/QuickChick.git
TAG = v1.5.0
WORKDIR = workdir

.PHONY: all get

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	( cd $(WORKDIR) && git apply ../quickchick.patch )
	cp -r dune-files/* $(WORKDIR)/

