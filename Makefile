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
	  git clone https://github.com/gnustep/tools-scripts ../tools-scripts
	fi

# Define the uninstall target
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
	if [ -n "$$removed" ]; then \
	  exit 0; \
	else \
	  echo "No items needed to be removed."; \
	fi