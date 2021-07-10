### Installation
```bash
brew install gopass
gopass setup
gpg -k
kubectl krew install gopass
```

### gopass
* LIST PASSWORDS
```gopass ls`
* CREATING PASSWORDS
default location ~/.password-store/
`gopass insert my-company/human@personal.com`
* SEARCH SECRETS
`gopass search @email.com`
* SHOW PASSWORD IN CONSOLE
`gopass my-company/willy@email.com`
* COPY PASSWORD TO CLIPBOARD
`gopass -c my-company/willy@email.com`

### Reference
* [gopass](https://github.com/gopasspw/kubectl-gopass)
* [gopass-presentation](https://woile.github.io/gopass-presentation/)
