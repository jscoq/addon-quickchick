REPO = https://github.com/QuickChick/QuickChick.git
TAG = v1.6.0
WORKDIR = workdir

.PHONY: all get

CPPO=${shell cd $(WORKDIR) && find . -name '*.cppo'}

all: $(WORKDIR) prepare
	make -C $(WORKDIR) $(CPPO:.cppo=)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	cp -r dune-files/* $(WORKDIR)/

prepare: $(WORKDIR)
	@echo '- Installing dependencies -'
	sed -i.bak '/"coq[-"]/d' workdir/coq-quickchick.opam  # don't install Coq and libs
	unset DUNE_WORKSPACE && opam install -y --deps-only $(WORKDIR)/coq-quickchick.opam
