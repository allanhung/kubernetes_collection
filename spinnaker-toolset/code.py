import shlex, subprocess
from os import listdir
from os.path import isfile, join

def getstatusoutput(cmd):
    args = shlex.split(cmd)
    p = subprocess.run(cmd)
    return p.returncode, p.stdout

def getApplicationNames():
    spin_cmd = "spin application list | jq -r '.[].name'"
    returnValue, applications = getstatusoutput(spin_cmd)
    assert returnValue==0, "Exit Code is not zero"

    for application in applications.split("\n"):
        yield application


def generatePipeline(env, stack):
    template = open("pipeline.template.json").read()
    rendered_template = template.replace("---ENV---", env)
    rendered_template = rendered_template.replace("---STACKNAME---", stack)
    if env == "develop":
        rendered_template = rendered_template.replace("---PROVIDER---", "ali-develop")
        rendered_template = rendered_template.replace("---BRANCH---", "master")
    elif env == "dev-canary":
        rendered_template = rendered_template.replace("---PROVIDER---", "ali-dev-canary")
        rendered_template = rendered_template.replace("---BRANCH---", "master")
    else:
        rendered_template = rendered_template.replace("---PROVIDER---", env)
        rendered_template = rendered_template.replace("---BRANCH---", "tags")
    return rendered_template


def generatePipelineForAllEnv(stack):
    for env in ["develop", "dev-canary", "staging", "production"]:
        yield generatePipeline(env, stack), env


def savePiplinesToDisk(pipelines, stack):
    dir = "pipelines"
    for pipeline, env in pipelines:
        filename = stack+"_"+env+".json"
        path = dir+"/"+filename
        print("Saving "+path)
        file = open(path,"w")
        file.write(pipeline)
        file.close


def pushSavedPipeline():
    path="pipelines"
    pipelines = [f for f in listdir(path) if isfile(join(path, f))]
    for pipeline in pipelines:
        try:
            print("Pushing %s"%pipeline)
            spin_cmd = "spin pipeline save --file pipelines/%s"%pipeline
            print("Pushing cmd: %s"%spin_cmd)
        #    returnValue, output = getstatusoutput(spin_cmd)
        #    assert returnValue==0, "Exit Code is not zero %s"%output
        #    print(output)
        except Exception as ex:
            print("Exception %s"%ex)


def getExistingPipelines(stack):
    spin_cmd = "spin pipeline list --application %s | jq -r '.[].name'"%stack
    returnValue, existingPipelines = getstatusoutput(spin_cmd)
    assert returnValue==0, "Exit Code is not zero"
    return existingPipelines


def deletePipeline(stack, pipeline):
    spin_cmd = "spin pipeline delete --name %s --application %s"%(pipeline,stack)
    returnValue, output = getstatusoutput(spin_cmd)
    assert returnValue==0, "Exit Code is not zero %s"%output


def deleteIACPipelines(stack):
    for pipeline in getExistingPipelines(stack).split(chr(10)):
        if "iac-" == pipeline.strip()[:4]:
            print("Deleting Pipeline %s"%pipeline)
            deletePipeline(stack, pipeline)


def main():
    for stack in ["frontend", "theme-creation"]:
        print("Stack: ", stack)
        savePiplinesToDisk(generatePipelineForAllEnv(stack), stack)
    pushSavedPipeline()


def clean():
    '''
    Should be run when we want to remove all pipelines created by this code i.e. name starting with iac-
    '''
    for stack in getApplicationNames():
        print("Stack: ", stack)
        deleteIACPipelines(stack)


#lean()
main()
