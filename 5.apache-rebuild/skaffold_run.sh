#!/bin/bash

kubectl config set-context docker-desktop --namespace=php-720

skaffold run

