#!/bin/bash
#set -x

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

PROJECT=$1
if [ "$#" -ne 1 ]
then
    echo "Usage: yes | ./gcp-discover-assets.sh <gcp_project_name>"
    echo "NOTE: project_id is a must, otherwise the script will prompt for input"
    exit
fi

export google_api="compute.googleapis.com/Instance,compute.googleapis.com/Subnetwork,compute.googleapis.com/Network,bigtableadmin.googleapis.com/Instance,storage.googleapis.com/Bucket,bigtableadmin.googleapis.com/Instance,bigtableadmin.googleapis.com/Table,bigquery.googleapis.com/Table,cloudfunctions.googleapis.com/CloudFunction,dataflow.googleapis.com/Job,dataproc.googleapis.com/Cluster,container.googleapis.com/Cluster,redis.googleapis.com/Instance,secretmanager.googleapis.com/Secret,composer.googleapis.com/Environment,appengine.googleapis.com/Service"


function discover_resources() {
gcloud asset search-all-resources --scope=projects/$PROJECT  \
--format='table(assetType.basename(), name.basename(), createTime, location, name.scope(projects).segment(0):label=PROJECT_ID)' \
--asset-types="$google_api"
}

# call function
discover_resources || true



# Searchable instance types: https://cloud.google.com/asset-inventory/docs/supported-asset-types#searchable_asset_types




# | grep "networkIP: $C_CLASS" | wc -l
# gcloud asset search-all-resources | egrep ^name:  

# ============ RAW RESULT, FOR FIELD SELECTION ==============
#   {
#     "assetType": "rbac.authorization.k8s.io/ClusterRole",
#     "createTime": "2021-12-14T18:57:15Z",
#     "displayName": "system:discovery",
#     "labels": {
#       "kubernetes.io/bootstrapping": "rbac-defaults"
#     },
#     "location": "us-west1",
#     "name": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo/k8s/rbac.authorization.k8s.io/clusterroles/system:discovery",
#     "parentAssetType": "container.googleapis.com/Cluster",
#     "parentFullResourceName": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo",
#     "project": "projects/609379928710"
#   },
#   {
#     "assetType": "rbac.authorization.k8s.io/ClusterRole",
#     "createTime": "2021-12-14T18:57:15Z",
#     "displayName": "system:controller:node-controller",
#     "labels": {
#       "kubernetes.io/bootstrapping": "rbac-defaults"
#     },
#     "location": "us-west1",
#     "name": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo/k8s/rbac.authorization.k8s.io/clusterroles/system:controller:node-controller",
#     "parentAssetType": "container.googleapis.com/Cluster",
#     "parentFullResourceName": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo",
#     "project": "projects/609379928710"
#   },
#   {
#     "assetType": "rbac.authorization.k8s.io/ClusterRole",
#     "createTime": "2021-12-14T18:57:15Z",
#     "displayName": "system:controller:namespace-controller",
#     "labels": {
#       "kubernetes.io/bootstrapping": "rbac-defaults"
#     },
#     "location": "us-west1",
#     "name": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo/k8s/rbac.authorization.k8s.io/clusterroles/system:controller:namespace-controller",
#     "parentAssetType": "container.googleapis.com/Cluster",
#     "parentFullResourceName": "//container.googleapis.com/projects/gcp-bigdata-demo-1/locations/us-west1/clusters/gke-bigdata-demo",
#     "project": "projects/609379928710"
#   },
#   {
#     "assetType": "rbac.authorization.k8s.io/ClusterRole",
#     "createTime": "2021-12-14T18:57:15Z",
#     "displayName": "system:controller:job-controller",
#     "labels": {
#       "kubernetes.io/bootstrapping": "rbac-defaults"
#     },



# sterRole         system:certificates.k8s.io:legacy-unknown-approver                      gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:certificates.k8s.io:kubelet-serving-approver                     gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:certificates.k8s.io:kube-apiserver-client-kubelet-approver       gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:certificates.k8s.io:certificatesigningrequests:selfnodeclient    gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:certificates.k8s.io:certificatesigningrequests:nodeclient        gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:basic-user                                                       gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:aggregate-to-view                                                gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:aggregate-to-edit                                                gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         system:aggregate-to-admin                                               gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         cluster-admin                                                           gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# ClusterRole         admin                                                                   gcp-bigdata-demo-1  2021-12-14T18:57:15Z
# Namespace           kube-system                                                             gcp-bigdata-demo-1  2021-12-14T18:57:14Z
# Namespace           kube-public                                                             gcp-bigdata-demo-1  2021-12-14T18:57:14Z
# Namespace           kube-node-lease                                                         gcp-bigdata-demo-1  2021-12-14T18:57:14Z
# Cluster             gke-bigdata-demo                                                        gcp-bigdata-demo-1  2021-12-14T18:55:14Z
# ServiceAccount      tf-gke-gke-bigdata-dem-hglc@gcp-bigdata-demo-1.iam.gserviceaccount.com  gcp-bigdata-demo-1
# Route               default-route-994a6829da6bc7df                                          gcp-bigdata-demo-1  2021-12-14T18:54:50Z
# Route               default-route-21119a03e5f00460                                          gcp-bigdata-demo-1  2021-12-14T18:54:43Z
# Route               default-route-81a2820c9f9f774d                                          gcp-bigdata-demo-1  2021-12-14T18:54:43Z
# Subnetwork          subnet-gke                                                              gcp-bigdata-demo-1  2021-12-14T18:54:33Z
# Route               default-route-56061b2bf71a4774                                          gcp-bigdata-demo-1  2021-12-14T18:54:22Z
# Network             vpc-gke                                                                 gcp-bigdata-demo-1  2021-12-14T18:54:19Z
# Dataset             foo                                                                     gcp-bigdata-demo-1  2021-12-14T18:54:19Z
# ServiceAccountKey   166afc2a969db63047b8af938939dba53ac2ace3                                gcp-bigdata-demo-1  2021-12-05T16:50:59Z
# ServiceAccountKey   cf3eb4c0c543ceb60c0f10c6bf2f5cdea32984e3                                gcp-bigdata-demo-1  2021-12-05T16:50:59Z
# ServiceAccount      tf-gke-gke-bigdata-dem-4j2d@gcp-bigdata-demo-1.iam.gserviceaccount.com  gcp-bigdata-demo-1
# ServiceAccount      tf-gke-gke-custer-7eh4@gcp-bigdata-demo-1.iam.gserviceaccount.com       gcp-bigdata-demo-1
# ServiceAccountKey   746c1b65b661eb5891dc568bd5ad73256b40a5bb                                gcp-bigdata-demo-1  2021-11-27T19:42:04Z
# Firewall            default-allow-ssh                                                       gcp-bigdata-demo-1  2021-11-23T19:49:33Z
# Firewall            default-allow-internal                                                  gcp-bigdata-demo-1  2021-11-23T19:49:33Z
# Firewall            default-allow-rdp                                                       gcp-bigdata-demo-1  2021-11-23T19:49:33Z
# Firewall            default-allow-icmp                                                      gcp-bigdata-demo-1  2021-11-23T19:49:33Z
# Route               default-route-00892bf39615d5fa                                          gcp-bigdata-demo-1  2021-11-23T19:49:22Z
# Route               default-route-cdaa5afe3ced6719                                          gcp-bigdata-demo-1  2021-11-23T19:49:19Z
# Route               default-route-4ce5419a4a39803f                                          gcp-bigdata-demo-1  2021-11-23T19:49:19Z
# Route               default-route-6fa966e811c8ff17                                          gcp-bigdata-demo-1  2021-11-23T19:49:19Z
# Route               default-route-37bdbd7cd4abb5c1                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-46f61d1d2da60114                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-da30884bff5f3679                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-d85229425681ea2c                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-c78f02f5f76b2bde                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-c7805ed09f6d84d1                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-58c72b11b68ce8bf                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-951819b97fef8eab                                          gcp-bigdata-demo-1  2021-11-23T19:49:18Z
# Route               default-route-32dadee422e52e09                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-2851bf353157dd37                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-a40489ed622d1897                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-a4e0e255d8cc9c10                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-7db8c46a4fe99634                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-22f4f01f4c3dd71f                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-971bb7566ff465ed                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-c87869c5301ba58f                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-a1dfe5f2da32737f                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-86bce72281f9e1f8                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-daea9d188120337f                                          gcp-bigdata-demo-1  2021-11-23T19:49:17Z
# Route               default-route-ca41936b7aa309c3                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Route               default-route-0a6ac524dde9d851                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Route               default-route-b9e22244010ccc71                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Route               default-route-dc2f9e86462d5ae6                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Route               default-route-2dfa8f0ffcc93d1e                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Route               default-route-b1020921dd7b1c68                                          gcp-bigdata-demo-1  2021-11-23T19:49:16Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Subnetwork          default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:13Z
# Route               default-route-d2e6a53cbdc56d80                                          gcp-bigdata-demo-1  2021-11-23T19:49:11Z
# Network             default                                                                 gcp-bigdata-demo-1  2021-11-23T19:49:06Z
# Project             gcp-bigdata-demo-1                                                      gcp-bigdata-demo-1  2021-11-23T19:48:59Z
# ServiceAccount      609379928710-compute@developer.gserviceaccount.com                      gcp-bigdata-demo-1
# Project             gcp-bigdata-demo-1                                                      gcp-bigdata-demo-1  2021-11-22T00:03:28Z
# Service             clouddebugger.googleapis.com                                            609379928710
# Service             storage-api.googleapis.com                                              609379928710
# Service             datastore.googleapis.com                                                609379928710
# Service             logging.googleapis.com                                                  609379928710
# Service             servicemanagement.googleapis.com                                        609379928710
# Service             compute.googleapis.com                                                  609379928710
# Service             sql-component.googleapis.com                                            609379928710
# Service             iam.googleapis.com                                                      609379928710
# Service             cloudapis.googleapis.com                                                609379928710
# Service             containerregistry.googleapis.com                                        609379928710
# Service             container.googleapis.com                                                609379928710
# Service             iamcredentials.googleapis.com                                           609379928710
# AppProfile          default                                                                 gcp-bigdata-demo-1
# Instance            bg-instance-1                                                           gcp-bigdata-demo-1
# Table               bt-table-1                                                              gcp-bigdata-demo-1
# Service             serviceusage.googleapis.com                                             609379928710
# NodePool            default-node-pool                                                       gcp-bigdata-demo-1
# ➜  scripts git:(main) ✗ 