BLUE='\033[1;34m'
NC='\033[0m'

for d in charts/*/ ; do
  echo -e "${BLUE}============================= testing $d =============================${NC}"
  echo -e "${BLUE}----------------------------- building dependencies -----------------------------${NC}"
  helm dependency build "$d"
  echo -e "${BLUE}----------------------------- linting -----------------------------${NC}"
  helm lint "$d" ""
  echo -e "${BLUE}----------------------------- kubeval -----------------------------${NC}"
  helm template "$d" "" | kubeval --ignore-missing-schemas
done