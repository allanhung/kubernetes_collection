curl --header "X-Vault-Token: ..." http://127.0.0.1:8200/v1/sys/audit
vault audit enable file file_path=/vault/audit/audit.log
vault audit disable file/

vault audit enable file file_path=stdout
/vault/audit/audit.log
