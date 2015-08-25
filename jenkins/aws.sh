#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $0 create|update <DNSDOMAIN>"
  echo "e.g. $0 create MyAWSKey example.com"
  exit 1
else
  ENV_FILE=./environment.sh
  if [ -e $ENV_FILE ]; then
    source $ENV_FILE
  fi
  export AWS_DEFAULT_PROFILE=docker-jenkins
  STACK_NAME=`echo $2 | sed -e 's/\./\-/g'`
  # Sets your external IP
  IPADDRESS=`wget -qO- http://ipecho.net/plain ; echo -n`
  # Configures the aws-cli, requires an access key is and secret
  aws configure --profile $AWS_DEFAULT_PROFILE
  # Creates a CloudFormation stack for the ECS cluster
  if [ $1 == "update" ]; then
    COMMAND=update-stack
  else
    COMMAND=create-stack
  fi
  aws cloudformation $COMMAND \
    --stack-name jenkins-$STACK_NAME \
    --template-body file://template.json \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=SSHLocation,ParameterValue="$IPADDRESS/32" \
ParameterKey=DNSDomain,ParameterValue="$2" \
ParameterKey=DockercfgPassword,ParameterValue="$JENKINS_DOCKERCFG_PASSWORD" \
ParameterKey=DockercfgEmail,ParameterValue="$JENKINS_DOCKERCFG_EMAIL" \
ParameterKey=DockercfgUrl,ParameterValue="$JENKINS_DOCKERCFG_URL" \
ParameterKey=DockercfgUsername,ParameterValue="$JENKINS_DOCKERCFG_USERNAME" \
ParameterKey=JenkinsUserOpgcoreApikey,ParameterValue="$JENKINS_USER_OPGCORE_APIKEY" \
ParameterKey=JenkinsUserOpgcorePassword,ParameterValue="$JENKINS_USER_OPGCORE_PASSWORD" \
ParameterKey=JenkinsUserOpgcorePubkeys,ParameterValue="$JENKINS_USER_OPGCORE_PUBKEYS" \
ParameterKey=JenkinsUserTrainingApikey,ParameterValue="$JENKINS_USER_TRAINING_APIKEY" \
ParameterKey=JenkinsUserTrainingPassword,ParameterValue="$JENKINS_USER_TRAINING_PASSWORD"
fi