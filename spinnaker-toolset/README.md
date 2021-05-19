### Build and Run
```bash
docker build -t spin .
docker run -d --rm --name spin spin
docker exec spin spin application list
```

### Usage
```
python code.py
```

### TroubleShooting
#### Error fetching new jobs from Travis
* re-login to travis-ci with account
* check with travis api
```bash
# Get github token from spinnaker configmap
export GITHUBTOKEN=$(kubectl get cm hal -o yaml|grep -i githubToken | awk -F': ' {'print $2'})
export ACCESSTOKEN=$(curl -X POST "https://api.travis-ci.com/auth/github?github_token=${GITHUBTOKEN}"| jq -r '.access_token')

curl -H 'Travis-API-Version: 3' -H "Authorization: token ${ACCESSTOKEN}" -X GET "https://api.travis-ci.com/jobs?state=passed,started,errored,failed,canceled&include=job.build,build.log_complete&limit=100&offset=0"
```

### Reference
* [Error fetching new jobs from Travis](https://github.com/spinnaker/spinnaker/issues/5459#issuecomment-592114357)
* [pipeline expressions](https://spinnaker.io/guides/user/pipeline/expressions/#what-tools-do-i-have-for-writing-pipeline-expressions)
