BLUE='\033[1;34m'
NC='\033[0m'

username=$HARBOR_ROBOT_NAME
password=$HARBOR_ROBOT_TOKEN
project="rds"
endpoint="https://harbor.uni-muenster.de/api/chartrepo/${project}/charts"
repo="https://harbor.uni-muenster.de/chartrepo/${project}"

helm repo add --username "$username" --password "$password" "$project" "$repo"

charts=0
charts_uploaded=""
nr_charts_uploaded=0
charts_already_uploaded=""
nr_charts_already_uploaded=0

for d in charts/*/ ; do
  let charts=$charts+1
  echo -e "${BLUE}deploying $d ========================================================${NC}"
  export version="$(cat "$d/Chart.yaml" | yq -r .version)"
  export name="$(cat "$d/Chart.yaml" | yq -r .name )"
  if [ $name ] && [ $version ]
  then
    echo Name: $name
    echo Version $version
    
    # Check for uploaded version
    if [ $(helm search repo "$project/$name" --version "$version" --output json | jq length) == 0 ]
    then
      # Package
      helm dependency build "${d}"
      helm package $d
      # Upload
      curl -u "$username:$password" -H "Content-Type: multipart/form-data" -F "chart=@$name-$version.tgz" "$endpoint"
      if [ $? == 0 ]
      then
        charts_uploaded="$charts_already_uploaded $d"
        let nr_charts_uploaded=$nr_charts_uploaded+1
      fi
    else
      echo "Chart was already uploaded"
      charts_already_uploaded="$charts_already_uploaded $d"
      let nr_charts_already_uploaded=$nr_charts_already_upoladed+1
    fi
  else
    echo "Version or Name not provided"
  fi
done

echo -e "${BLUE}SUMMARY ===============================================================${NC}"
echo
echo "Charts uploaded:"
for chart in $charts_uploaded ; do
  echo "    $chart"
done
echo "in total $nr_charts_uploaded/$charts"
echo 
echo "Charts that were already uploaded:"
for chart in $charts_already_uploaded ; do
  echo "    $chart"
done
echo "in total $nr_charts_already_uploaded/$charts"
echo

# do not fail only if all charts were either uploaded or already uploaded
let nr_failed=$charts-$nr_charts_already_uploaded-$nr_charts_uploaded
echo "Failed on charts:"
for d in charts/*/ ; do
  if [ $charts_uploaded !~ $d ] && [ $charts_already_uploaded !~$d ]
  then
    echo "    $d"
  fi
done
echo "in total $nr_failed/$charts"
test $nr_failed = 0 || exit 1