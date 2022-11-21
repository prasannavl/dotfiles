# gcloud
gcloud_bash_path="/snap/google-cloud-sdk/current/completion.bash.inc"
if [ -f "$gcloud_bash_path" ]; then
        . "$gcloud_bash_path"
fi
unset gcloud_bash_path
