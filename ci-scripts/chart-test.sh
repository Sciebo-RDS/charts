set -e

BLUE='\033[1;34m'
NC='\033[0m'

NR_LINT_FAILED=0
LINT_FAILED=""
NR_KUBEVAL_FAILED=0
KUBEVAL_FAILED=""


for d in charts/*/ ; do
  if [ $d != "charts/all/" ]
  then
    echo -e "${BLUE}testing $d ==========================================================${NC}"
    echo -e "${BLUE}building dependencies -----------------------------------------------${NC}"
    helm dependency update "$d"
    helm dependency build "$d"
    echo -e "${BLUE}linting -------------------------------------------------------------${NC}"
    helm lint "$d"
    
    if [ $? != 0 ] 
    then
      let NR_LINT_FAILED=$NR_LINT_FAILED+1
      LINT_FAILED="$LINT_FAILED $d"
    fi

    echo -e "${BLUE}kubeval -------------------------------------------------------------${NC}"
    helm template "$d" | kubeval --ignore-missing-schemas
    
    if [ $? != 0 ] 
    then 
      let NR_KUBEVAL_FAILED=$NR_LINT_FAILED+1
      KUBEVAL_FAILED="$KUBEVAL_FAILED $d"
    fi
  fi
done

echo
echo -e "${BLUE}LINT ALL-CHART WITH SUBCHARTS =========================================${NC}"
echo 

helm dependency update charts/all
helm dependency build charts/all
helm lint --with-subcharts charts/all
helm template "$d" | kubeval --ignore-missing-schemas

echo
echo -e "${BLUE}LINT FAILS ============================================================${NC}"
echo 
for d in $LINT_FAILED ; do
  echo $d
done

echo
echo "In total $NR_LINT_FAILED"
echo

echo
echo -e "${BLUE}KUBEVAL FAILS =========================================================${NC}"
echo 
for d in $KUBEVAL_FAILED ; do
  echo $d
done

echo
echo "In total $NR_KUBEVAL_FAILED"
echo