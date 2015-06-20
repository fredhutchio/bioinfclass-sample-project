
# Sane error handling settings
set -euf -o pipefail

ls -l | column -t
# Put in a "bug":
asdfasdfasdf

echo "IT WORKED!"

