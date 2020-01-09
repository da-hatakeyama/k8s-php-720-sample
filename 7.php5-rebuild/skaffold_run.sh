#!/bin/bash

kubectl config set-context docker-for-desktop --namespace=php-720

skaffold run

