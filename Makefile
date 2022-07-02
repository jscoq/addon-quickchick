REPO = https://github.com/QuickChick/QuickChick.git
TAG = v1.6.3
COMMIT = 30b60f5dda3df68114f450f3e094bc7a28b841e6
WORKDIR = workdir

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef
GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get

CPPO=${shell cd $(WORKDIR) && find . -name '*.cppo'}

all: $(WORKDIR) prepare
	cp -r dune-files/* $(WORKDIR)/
	make -C $(WORKDIR) $(CPPO:.cppo=)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)

prepare: $(WORKDIR)
	@echo '- Installing dependencies -'
	sed -i.bak '/"coq[-"]/d' workdir/coq-quickchick.opam  # don't install Coq and libs
	unset DUNE_WORKSPACE && opam install -y --deps-only $(WORKDIR)/coq-quickchick.opam
