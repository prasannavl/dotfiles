#!/usr/bin/env bash
set -euo pipefail

# Script to downgrade packages to target release
# Uses apt-cache policy to detect package sources and versions
# For packages with versions not directly in repos, picks the closest lower version
# Shows packages with no repo match as "local"

# Customize target release (default if not passed)
TARGET_RELEASE="${TARGET_RELEASE:-stable}"

# Array of regex patterns to exclude
EXCLUDE_PATTERNS=(
  # "^firmware-"
  # "^sway$"
  # "^libwlroots"
  # "^linux-"
  # "^bpftool"
)

echo "🔄 Updating package lists..."
# sudo apt update

echo "🔍 Analyzing installed packages for downgrade to [$TARGET_RELEASE]..."

# Get all installed packages (or use provided list for debugging)
INSTALLED_PKGS=${INSTALLED_PKGS:-$(dpkg-query -W -f='${Package}\n')}

DOWNGRADE_PKGS=()

for pkg in $INSTALLED_PKGS; do
  # Check against all exclude patterns
  skip=false
  for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    if [[ "$pkg" =~ $pattern ]]; then
      echo "⏩ Skipping $pkg (matched $pattern)"
      skip=true
      break
    fi
  done
  $skip && continue

  # Get policy information for the package
  policy_info=$(apt-cache policy "$pkg" 2>/dev/null || continue)
  
  # Extract installed version and available versions
  installed_version=$(echo "$policy_info" | awk '/Installed:/ {print $2}')
  
  # Skip if no version is installed or it's "(none)"
  if [[ -z "$installed_version" || "$installed_version" == "(none)" ]]; then
    continue
  fi
  
  # Parse available versions and their sources
  available_versions=$(echo "$policy_info" | awk -v target="$TARGET_RELEASE" '
  BEGIN { 
    in_version_table = 0 
    current_version = ""
  }
  /Version table:/ { in_version_table = 1; next }
  !in_version_table { next }
  
  # Version lines (*** version priority OR spaces version priority)
  /^ *\*\*\* / { 
    current_version = $2
    next
  }
  /^ *[0-9][^ ]* [0-9-]+ *$/ { 
    current_version = $1
    next
  }
  
  # Repository lines (priority followed by URL or file path)
  /^ *[0-9-]+ .*(http:\/\/|\/var\/lib\/)/ && current_version != "" {
    if ($0 ~ /\/var\/lib\/dpkg\/status/) {
      print current_version ":" "status"
    } else if ($0 ~ (" " target "/")) {
      print current_version ":" target
    } else if ($0 ~ (" " target "-security/")) {
      print current_version ":" target "-security"
    } else if ($0 ~ (" " target "-updates/")) {
      print current_version ":" target "-updates"
    } else if ($0 ~ (" " target "-backports/")) {
      print current_version ":" target "-backports"
    } else if ($0 ~ /testing/) {
      print current_version ":" "testing"
    } else if ($0 ~ /unstable/) {
      print current_version ":" "unstable"
    } else if ($0 ~ /experimental/) {
      print current_version ":" "experimental"
    } else {
      # Extract the suite/release name from the repository line
      if (match($0, /[a-zA-Z0-9-]+\/[a-zA-Z0-9-]+/)) {
        suite = substr($0, RSTART, RLENGTH)
        gsub(/.*\//, "", suite)
        print current_version ":" suite
      }
    }
  }')
  
  # Determine package source by analyzing available versions
  pkg_source=""
  target_version=""
  stable_version=""
  
  # First, collect all versions and find target release versions
  while read -r line; do
    [[ -z "$line" ]] && continue
    if [[ "$line" != *":"* ]]; then
      continue  # Skip lines without colon separator
    fi
    # Split on the last colon only (versions can contain colons)
    if [[ "$line" =~ ^(.+):([^:]+)$ ]]; then
      version="${BASH_REMATCH[1]}"
      source="${BASH_REMATCH[2]}"
    else
      continue  # Skip if we can't parse the line
    fi
    
    # Check for exact match first (use first non-status match)
    if [[ "$version" == "$installed_version" && "$source" != "status" && -z "$pkg_source" ]]; then
      pkg_source="$source"
    fi
    
    # Collect target release version for comparison (including security, updates, backports)
    if [[ "$source" =~ ^${TARGET_RELEASE}(-security|-updates)?$ ]]; then
      # Compare versions and pick the highest one from any stable suite
      if [[ -z "$stable_version" ]]; then
        stable_version="$version"
      else
        # Use dpkg to compare versions and pick the higher one
        if dpkg --compare-versions "$version" gt "$stable_version" 2>/dev/null; then
          stable_version="$version"
        fi
      fi
    fi
  done <<< "$available_versions"
  
  # If no exact match found, determine source by version comparison
  if [[ -z "$pkg_source" ]]; then
    if [[ -n "$stable_version" ]]; then
      # Compare installed version with stable version
      if dpkg --compare-versions "$installed_version" gt "$stable_version" 2>/dev/null; then
        # Installed version is newer than stable, likely from testing/unstable
        pkg_source="testing"
      elif dpkg --compare-versions "$installed_version" eq "$stable_version" 2>/dev/null; then
        # Same as stable
        pkg_source="$TARGET_RELEASE"
      else
        # Older than stable, might be backports or local
        pkg_source="local"
      fi
    else
      # No stable version available
      pkg_source="local"
    fi
  fi
  
  # Skip if package is already from target release (including security, updates, backports)
  if [[ "$pkg_source" =~ ^${TARGET_RELEASE}(-security|-updates)?$ ]]; then
    continue
  fi
  

  echo "🔍 Found package: $pkg (installed: $installed_version, source: $pkg_source)"
  
  # Find appropriate target version
  if [[ -n "$stable_version" ]]; then
    target_version="$stable_version"
  else
    echo "⚠️  No $TARGET_RELEASE version found for $pkg"
    continue
  fi

  echo "📦 $pkg → $target_version (from $pkg_source)"
  DOWNGRADE_PKGS+=("${pkg}=${target_version}")
done

# Downgrade meta packages and normal packages
if [[ ${#DOWNGRADE_PKGS[@]} -gt 0 ]]; then
  echo "⏬ Downgrading packages..."
  echo sudo apt install "${DOWNGRADE_PKGS[@]}"
fi

echo "✅ Done. Execute apt cmd above to perform the downgrades."
