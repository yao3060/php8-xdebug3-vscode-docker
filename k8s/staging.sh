#!/bin/sh

if [ ! -f overlays/staging/secrets.txt ]; then
  cp overlays/staging/secrets.example.txt overlays/staging/secrets.txt
fi

cp overlays/staging/secrets.txt base/apps/secrets.txt
cp overlays/staging/secrets.txt base/db/secrets.txt
kubectl apply -k overlays/staging/
