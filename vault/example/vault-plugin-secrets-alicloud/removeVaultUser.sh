#!/bin/bash

accountKeyWord=$1
accountNameList=( $(aliyun ram ListUsers --region us-east-1 | jq -r '.Users.User[].UserName' |grep ${accountKeyWord}) )
for accountName in "${accountNameList[@]}"
do
  policyList=( $(aliyun ram ListPoliciesForUser --region us-east-1 --UserName ${accountName} | jq -r '.Policies.Policy[] | "\(.PolicyName)_\(.PolicyType)"') )
  for policy in "${policyList[@]}"
  do
    policyName=$(echo "${policy}" | awk -F"_" {'print $1'}) 
    policyType=$(echo "${policy}" | awk -F"_" {'print $2'}) 
    echo "detach policy ${policyName} from ${accountName}"
    aliyun ram DetachPolicyFromUser --region us-east-1 --UserName ${accountName} --PolicyName ${policyName} --PolicyType ${policyType}
    if [ "${policyType}" == "Custom" ]; then
      echo "delete custom policy ${policyName}"
      aliyun ram DeletePolicy --PolicyName ${policyName}
    fi
  done
  echo "delete account $accountName"
  aliyun ram DeleteUser --UserName ${accountName}
done
