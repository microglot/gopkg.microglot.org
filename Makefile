PROJECT_PATH = $(shell pwd -L)
GOFLAGS ::= ${GOFLAGS}
BUILD_DIR = $(PROJECT_PATH)/.build
TOOLS_DIR = $(PROJECT_PATH)/internal/tools
TOOLS_FILE = $(TOOLS_DIR)/tools.go
TOOLS_MOD = $(TOOLS_DIR)/go.mod
TOOLS_SUM = $(TOOLS_DIR)/go.sum
GOTOOLS = $(shell grep '_' $(TOOLS_DIR)/tools.go | sed 's/[[:space:]]*_//g' | sed 's/\"//g')
BIN_DIR = $(PROJECT_PATH)/.bin
GOCMD = GOFLAGS=$(GOFLAGS) go
PROJECT_NAME = gopkg-microglot-org
VANGEN_CONFIG = $(PROJECT_PATH)/vangen.json
WRANGLER_CONFIG = $(PROJECT_PATH)/wrangler.toml

build: $(BUILD_DIR)
$(BUILD_DIR): $(VANGEN_CONFIG) | $(BIN_DIR)
	@ $(BIN_DIR)/vangen -out $(BUILD_DIR) -config $(VANGEN_CONFIG)

release: | $(BUILD_DIR)
	@ wrangler --config $(WRANGLER_CONFIG) pages deploy $(BUILD_DIR) --project-name=$(PROJECT_NAME)

tools: $(BIN_DIR)
$(BIN_DIR): $(TOOLS_FILE) $(TOOLS_MOD) $(TOOLS_SUM)
	@ mkdir -p $(BIN_DIR)
	@ cd $(TOOLS_DIR) && GOBIN=$(BIN_DIR) $(GOCMD) install $(GOTOOLS)

tools/update:
	@ cd $(TOOLS_DIR) && GOBIN=$(BIN_DIR) $(GOCMD) get -u
	@ cd $(TOOLS_DIR) && GOBIN=$(BIN_DIR) $(GOCMD) mod tidy

#######
# https://stackoverflow.com/a/10858332
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
#######

clean: clean/build clean/tools
clean/build:
	@:$(call check_defined,BUILD_DIR)
	@ rm -rf $(BUILD_DIR)
clean/tools:
	@:$(call check_defined,BIN_DIR)
	@ rm -rf $(BIN_DIR)
