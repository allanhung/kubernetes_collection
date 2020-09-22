#!/bin/bash
jq --version >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }

display_usage() {
	echo -e "Usage:\n $0 [dashboard_id] [grafana_cred] [grafana_host] [folder] [input_ds] [datasource] \n"
	echo -e "example: dashboard_id: id1,id2 \n"
	echo -e "         grafana_cred: admin:admin \n"
	echo -e "         grafana_host: default is http://localhost:3000 \n"
	echo -e "         folder: Keep grafana_folder empty for adding the dashboards in General folder \n"
	echo -e "         input_ds: default is DS_PROMETHEUS \n"
	echo -e "         datasource: default is Prometheus \n"
}

if [  $# -le 0 ]
then
	display_usage
	exit 1
fi

if [[ ( $# == "--help") ||  $# == "-h" ]]
then
	display_usage
	exit 0
fi

### Please edit grafana_* variables to match your Grafana setup:
dashboard_id="${1}"
grafana_cred="${2}"
grafana_host="${3:-http://localhost:3000}"
grafana_folder="${4}"
grafana_input_ds="${5:-DS_PROMETHEUS}"
grafana_datasource="${6:-Prometheus}"
IFS=',' read -ra ds <<< "$dashboard_id"

folderId=$(curl -s -k -u "$grafana_cred" $grafana_host/api/folders | jq -r --arg grafana_folder  "$grafana_folder" '.[] | select(.title==$grafana_folder).id')
if [ -z "$grafana_folder" ]
then
  echo "argument folder is empty, adding the dashboards in General folder" 
else  
  if [ -z "$folderId" ] 
  then 
    echo "folder $grafana_folder not exists, creating" 
    payload="{\"title\":\"$grafana_folder\",\"uid\":\"$(openssl rand -hex 8)\"}"
    curl -s -k -u "$grafana_cred" -XPOST -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -d "$payload" \
      $grafana_host/api/folders; echo ""
    folderId=$(curl -s -k -u "$grafana_cred" $grafana_host/api/folders | jq -r --arg grafana_folder  "$grafana_folder" '.[] | select(.title==$grafana_folder).id')
  else 
    echo "Got folderId $folderId"
  fi
fi

for d in "${ds[@]}"; do
  echo -n "Processing $d: "
  j=$(curl -s -k -u "$grafana_cred" $grafana_host/api/gnet/dashboards/$d | jq .json)
  payload="{\"dashboard\":$j,\"overwrite\":true, \
    \"inputs\":[{\"name\":\"${grafana_input_ds}\",\"type\":\"datasource\", \
                 \"pluginId\":\"prometheus\",\"value\":\"$grafana_datasource\"}]"
  if [ ! -z "$folderId" ] ; then payload="${payload}, \"folderId\": $folderId }";  else payload="${payload} }" ; fi
  curl -s -k -u "$grafana_cred" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    $grafana_host/api/dashboards/import; echo ""
done
