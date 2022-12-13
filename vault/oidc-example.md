# setup oidc with azure
```
export AD_VAULT_APP_ID=<app_id>
export AD_CLIENT_SECRET=<app_secret>
export AD_TENANT_ID=<tenant_id>
export VAULT_ADDR=<vault_addr>
export VAULT_LOGIN_ROLE=developer
vault write auth/oidc/config \
    oidc_client_id="${AD_VAULT_APP_ID}" \
    oidc_client_secret="${AD_CLIENT_SECRET}" \
    default_role="${VAULT_LOGIN_ROLE}" \
    oidc_discovery_url="https://login.microsoftonline.com/${AD_TENANT_ID}/v2.0"

cat > manifest.json << EOF
{
    "idToken": [
        {
            "name": "groups",
            "additionalProperties": []
        }
    ]
}
EOF
az ad app update --id ${AD_VAULT_APP_ID} \
    --set groupMembershipClaims=SecurityGroup \
    --optional-claims @manifest.json

vault write auth/oidc/role/${VAULT_LOGIN_ROLE} \
   user_claim="email" \
   allowed_redirect_uris="http://localhost:8250/oidc/callback" \
   allowed_redirect_uris="${VAULT_ADDR}/ui/vault/auth/oidc/oidc/callback"  \
   groups_claim="groups" \
   policies="default,ro" \
   oidc_scopes="https://graph.microsoft.com/.default"
```

# policy assign by group
# get canonical-id from follow command
vault write identity/group name="MyGroup" type="external" policies="operator"
OIDC_AUTH_ACCESSOR=$(vault auth list -format=json  | jq -r '."oidc/".accessor')
vault write identity/group-alias name="<group object id>" mount_accessor="${OIDC_AUTH_ACCESSOR}" canonical_id="<canonical-id>"

# Reference
[oidc-auth-azure](https://learn.hashicorp.com/tutorials/vault/oidc-auth-azure?in=vault/auth-methods)
[external-group](https://developer.hashicorp.com/vault/tutorials/auth-methods/identity#create-an-external-group)
