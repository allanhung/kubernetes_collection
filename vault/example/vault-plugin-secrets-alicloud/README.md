## AliCloud Secrets Engine
### Setup
* Enable the secrets engine
   `vault secrets enable alicloud`
* Create custom policy in the AlibabaCloud console:
```
{
    "Statement": [
        {
            "Action": [
                "ram:CreateAccessKey",
                "ram:DeleteAccessKey",
                "ram:CreatePolicy",
                "ram:DeletePolicy",
                "ram:AttachPolicyToUser",
                "ram:DetachPolicyFromUser",
                "ram:CreateUser",
                "ram:DeleteUser"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "1"
}
```
* Create a User for Vault with the previous custom policy and get the access keypair
* Upload the access keypair to Vault configuration
* If key is set in environment variable, it will use environment instead of config.
```
vault write alicloud/config \
            access_key=<ALICLOUD_ACCESS_KEY_ID> \
            secret_key=<ALICLOUD_SECRET_ACCESS_KEY>
```
* Configure a Vault role
```
vault write alicloud/role/myrole \
    remote_policies='name:AliyunECSReadOnlyAccess,type:System' \
    remote_policies='name:AliyunRDSReadOnlyAccess,type:System' \
    inline_policies=-<<EOF
[
    {
      "Statement": [
        {
          "Action": "rds:Describe*",
          "Effect": "Allow",
          "Resource": "*"
        }
      ],
      "Version": "1"
    }
]
EOF
```
It will return error when lease if we don't specify the `inline_policies`.

* Retrieve a dynamic credential for this role

```
vault write alicloud/creds/myrole
```
* Generate a new access key by reading from the /creds
```
vault read alicloud/creds/myrole
```
* revoke
```
vault lease revoke alicloud/creds/myrole/rlFExR4RGsBkYlIUS06nh0TK
```

### Reference
* [Fixed error during revoke operation](https://github.com/hashicorp/vault-plugin-secrets-alicloud/pull/38)
* [AliCloud Secrets Engine](https://www.vaultproject.io/docs/secrets/alicloud)
