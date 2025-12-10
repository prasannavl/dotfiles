## User profile

# Keep fragments POSIX-friendly; this file is sourced by login shells.
# Load modular profile fragments from ~/.profile.d in lexical order.

for file in ~/.profile.d/*.sh; do
    [ -r "$file" ] || continue
    . "$file"
done

