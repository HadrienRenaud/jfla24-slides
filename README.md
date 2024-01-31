# jfla24-slides

## Installation

For herd7.56.3
```
export HERD_OLD_PREFIX=$(HOME)/.local/herd7.56.3
mkdir $(HERD_OLD_PREFIX)
git clone --depth 1 --branch 7.56.3 https://github.com/herd/herdtools7.git $(HERD_OLD_PREFIX)/src
make -C $(HERD_OLD_PREFIX) build install PREFIX=$(HERD_OLD_PREFIX)
```



