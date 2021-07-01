#!/bin/sh

if [ ! -f overlays/staging/secrets.txt ]; then
  cp overlays/staging/secrets.example.txt overlays/staging/secrets.txt
fi

cp overlays/staging/secrets.txt base/apps/secrets.txt
cp overlays/staging/secrets.txt base/db/secrets.txt

FULLSHA=$(git rev-parse HEAD)
# FULLSHA="0.0.0-${GITSHA:0:8}"

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${RED}Set image tags 'MYNEWTAG' to new tag '${FULLSHA}' ${NC}\n"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "it's $OSTYPE:"
  sed -i "s/MYNEWTAG/${FULLSHA}/g" ./overlays/staging/kustomization.yaml
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "it's $OSTYPE:"
  sed -Ei '' "s/MYNEWTAG/${FULLSHA}/g" ./overlays/staging/kustomization.yaml
else
  echo "it's unsupport stytem."
  exit 1
fi

# test config file
kubectl kustomize overlays/staging/
# kubectl apply -k overlays/staging/

echo "Set image tags back to 'MYNEWTAG'"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sed -i "s/${FULLSHA}/MYNEWTAG/g" ./overlays/staging/kustomization.yaml
elif [[ "$OSTYPE" == "darwin"* ]]; then
  sed -Ei '' "s/${FULLSHA}/MYNEWTAG/g" ./overlays/staging/kustomization.yaml
fi
