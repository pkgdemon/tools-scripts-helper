# Check if running as root
check_root:
	@if [ $$(id -u) -ne 0 ]; then \
	  echo "This Makefile must be run as root or with sudo."; \
	  exit 1; \
	fi

# Define the install target
install: check_root
	@if [ -d "/usr/GNUstep" ]; then \
	  echo "GNUstep is already installed"; \
	  exit 0; \
	else \
	  WORKDIR=`pwd`; \
	  rm /tmp/GNUstep >/dev/null 2>&1 || true; \
	  rm -rf /tmp/libdispatch 2>&1 || true; \
	  rm -rf /tmp/libobjc2 2>&1 || true; \
	  mkdir /tmp/GNUstep; \
	  git clone https://github.com/gnustep/tools-scripts /tmp/GNUstep/tools-scripts/; \
	fi

uninstall: check_root
	@removed=""; \
	if [ -L "/etc/profile.d/GNUstep.sh" ]; then \
	  rm -f /etc/profile.d/GNUstep.sh; \
	  removed="$$removed /etc/profile.d/GNUstep.sh"; \
	  echo "Removed symlink /etc/profile.d/GNUstep.sh"; \
	fi; \
	if [ -d "/usr/GNUstep" ]; then \
	  rm -rf /usr/GNUstep; \
	  removed="$$removed /usr/GNUstep"; \
	  echo "Removed /usr/GNUstep"; \
	fi; \
	if [ -f "/etc/GNUstep/GNUstep.conf" ]; then \
	  rm -f /etc/GNUstep/GNUstep.conf; \
	  removed="$$removed /etc/GNUstep/GNUstep.conf"; \
	  echo "Removed /etc/GNUstep/GNUstep.conf"; \
	fi; \
	if [ -f "/usr/local/bin/gnustep-wmaker" ]; then \
	  rm -f /usr/local/bin/gnustep-wmaker; \
	  removed="$$removed /usr/local/bin/gnustep-wmaker"; \
	  echo "Removed /usr/local/bin/gnustep-wmaker"; \
	fi; \
	if [ -f "/usr/share/xsessions/gnustep-wmaker.desktop" ]; then \
	  rm -f /usr/share/xsessions/gnustep-wmaker.desktop; \
	  removed="$$removed /usr/share/xsessions/gnustep-wmaker.desktop"; \
	  echo "Removed /usr/share/xsessions/gnustep-wmaker.desktop"; \
	fi; \
	if [ -n "$$removed" ]; then \
	  exit 0; \
	else \
	  echo "No items needed to be removed."; \
	fi

clean: check_root
	@echo "Cleaning main project..."
	@WORKDIR=`pwd`; \
	if [ -d "$$WORKDIR" ]; then \
	  echo "Cleaning the main project directory"; \
	  git clean -fdx; \
	  git reset --hard; \
	fi
	@echo "Removing GNUstep git repos..."
	@if [ -d "/tmp/GNUstep" ]; then \
	  echo "Removing /tmp/GNUstep..."; \
	  rm -rf /tmp/GNUstep; \
	fi
	@if [ -d "/tmp/libobjc2" ]; then \
	  echo "Removing /tmp/libobjc2..."; \
	  rm -rf /tmp/libobjc2; \
	fi
	@if [ -d "/tmp/libdispatch" ]; then \
	  echo "Removing /tmp/libdispatch..."; \
	  rm -rf /tmp/libdispatch; \
	fi
	@echo "Clean complete."