# User Settings
# ================================================================================
QUARTUS_DIR ?= /opt/quartus
LICENSE_FILE ?= /home/user/lic.dat
MAC_ADDR ?= 12:34:45:78:90:ab
MEMORY ?= 4g
CPUS ?= 4

# Internal Settings
# ================================================================================
CONTAINER_NAME ?= my-timing-container
X11_SUPPORT_DIR ?= /tmp/.X11-unix
REPO_NAME ?= bel_projects
WORKSPACE_DIR ?= workspace
RESOURCES_DIR ?= resources
QUARTUS_DIR_DOCKER ?= /opt/quartus

# Targets
# ================================================================================
all: build run

copy_license:
	@cp $(LICENSE_FILE) $(RESOURCES_DIR)/license.dat
	@echo "Using license file (md5sum - name):"
	@md5sum $(RESOURCES_DIR)/license.dat

create_mac:
	@echo $(MAC_ADDR) > $(RESOURCES_DIR)/mac
	@echo "Using MAC address (for licensing):"
	@cat $(RESOURCES_DIR)/mac

build:
	docker build -t $(CONTAINER_NAME) .

run:
	docker run -it -e DISPLAY=$$DISPLAY \
                 -v $(QUARTUS_DIR):$(QUARTUS_DIR_DOCKER) \
                 -v $(X11_SUPPORT_DIR):$(X11_SUPPORT_DIR) \
                 -v $(PWD)/$(WORKSPACE_DIR):/$(WORKSPACE_DIR) \
                 --memory="$(MEMORY)" \
                 --cpus="$(CPUS)" \
                 --cap-add=NET_ADMIN \
                 $(CONTAINER_NAME)

clean:
	rm -rf $(WORKSPACE_DIR)/$(REPO_NAME) || true
	rm $(RESOURCES_DIR)/*.dat || true
	rm $(RESOURCES_DIR)/mac || true
