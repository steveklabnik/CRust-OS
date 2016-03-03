#CARGO_ARGS += --release

CARGO = cargo
CARGO_ARGS += --target $(TARGET_TRIPLE)

CARGO_DEPS += $(TARGET_FILE)
CARGO_DEPS += crust.lds
CARGO_DEPS += Cargo.toml
CARGO_DEPS += Cargo.lock

# Caching libcrust.a dependencies; see build/Utils.mk
RUST_FILES = $(shell find $(SRC) -name "*.rs")
$(DEPS)/$(TARGET)/crust.d: $(RUST_FILES)
-include $(DEPS)/$(TARGET)/crust.d

$(TARGET)/crust: $(CARGO_DEPS) $(BIN)/boot.o $(RUNTIME)
	$(MKDIR) $(@D)
	$(warning if the following fails with "error: can't find crate for `core`" or "the crate `core` has been compiled with ...", you need to `multirust update` and `make clean-runtime`.)
	$(CARGO) build $(CARGO_ARGS)
	@[ -e $@ ] && touch $@ # Cargo doesn't always update timestamp
