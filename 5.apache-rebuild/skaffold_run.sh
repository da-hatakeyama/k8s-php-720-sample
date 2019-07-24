#!/bin/bash

kubectl config set-context docker-for-desktop --namespace=php-720-sample

skaffold run

