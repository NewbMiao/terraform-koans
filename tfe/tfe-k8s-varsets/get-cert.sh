#!/bin/bash
jq -n \
    --arg client_certificate "$(kubectl config view --raw -o jsonpath='{.users[?(@.name=="docker-desktop")].user.client-certificate-data}')" \
    --arg client_key "$(kubectl config view --raw -o jsonpath='{.users[?(@.name=="docker-desktop")].user.client-key-data}')" \
    --arg cluster_ca_certificate "$(kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="docker-desktop")].cluster.certificate-authority-data}')" \
    --arg host "$(kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="docker-desktop")].cluster.server}')" \
    '{client_certificate: $client_certificate, client_key: $client_key, cluster_ca_certificate: $cluster_ca_certificate, host: $host}' |
    tee tmp_k8s_config.json
