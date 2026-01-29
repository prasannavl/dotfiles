SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help
.PHONY: help encrypt decrypt check-sops

SOPS ?= sops
SOPS_CONFIG ?= .sops.yaml

# Manually list files managed by sops.
SOPS_FILES := \
	x/shikane/.config/shikane/config.toml \
	x/gnome-shell/.config/monitors.xml

help:
	@printf '%s\n' 'Targets:' \
		'  encrypt   Encrypt all files from $(SOPS_CONFIG)' \
		'  decrypt   Decrypt all files from $(SOPS_CONFIG)'

encrypt: check-sops
	@if [ -z "$(SOPS_FILES)" ]; then echo "No files found in $(SOPS_CONFIG)."; exit 1; fi
	@for f in $(SOPS_FILES); do \
		if [ -f "$$f" ]; then \
			$(SOPS) --encrypt --in-place "$$f"; \
		else \
			echo "skip: $$f (missing)"; \
		fi; \
	done

decrypt: check-sops
	@if [ -z "$(SOPS_FILES)" ]; then echo "No files found in $(SOPS_CONFIG)."; exit 1; fi
	@for f in $(SOPS_FILES); do \
		if [ -f "$$f" ]; then \
			$(SOPS) --decrypt --in-place "$$f"; \
		else \
			echo "skip: $$f (missing)"; \
		fi; \
	done

check-sops:
	@command -v "$(SOPS)" >/dev/null 2>&1 || { echo "Missing sops; install it or set SOPS=..."; exit 1; }
