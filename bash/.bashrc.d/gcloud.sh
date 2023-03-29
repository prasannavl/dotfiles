# gcloud

# Let's exit if not installed.
if [[ ! $(command -v gcloud) ]]; then return 0; fi

# snap
gcloud_bash_path="/snap/google-cloud-sdk/current/completion.bash.inc"
if [ -f "$gcloud_bash_path" ]; then
    . "$gcloud_bash_path"
fi

