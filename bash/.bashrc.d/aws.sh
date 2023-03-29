# aws cli

# Let's exit if not installed.
if [[ ! $(command -v aws) ]]; then return 0; fi

# snap
aws_bash_completion_path="/snap/aws-cli/current/bin/aws_completer"
if [ -f "$aws_bash_completion_path" ]; then
    complete -C "SNAP=/snap/aws-cli/current /snap/aws-cli/current/usr/bin/python3 $aws_bash_completion_path" aws
fi


