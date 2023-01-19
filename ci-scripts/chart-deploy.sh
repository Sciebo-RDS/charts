set -e

BLUE='\033[1;34m'
NC='\033[0m'

username="jakdimi"
password=""
project="rds/charts"
endpoint="https://harbor.uni-muenster.de/api/chartrepo/${project}/charts"
repo="https://harbor.uni-muenster.de/chartrepo/${project}"

for d in charts/*/ ; do
  export version="$(cat "$d/Chart.yaml" | yq -r .version)"
  export name="$(cat "$d/Chart.yaml" | yq -r .name )"
  echo Chart 
  echo Name: $name
  echo Version $version
  test $name && test $version
  # Check for uploaded version
  helm repo add --username "$username" --password "$password" "$project" "$repo"
  test $(helm search repo "$project/$name" --version "$version" --output json | jq length) = 0
  # Package
  helm dependency build "${d}"
  helm package $d
  # Upload
  curl --fail -u "$username:$password" -H "Content-Type: multipart/form-data" -F "chart=@$name-$version.tgz" "$endpoint"
done