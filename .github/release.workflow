workflow "Deploy with Serverless" {
  on = "release"
  resolves = ["serverless deploy"]
}

action "new releases only" {
  uses = "actions/bin/filter@master"
  args = "tag v*"
}

action "npm install" {
  uses = "actions/npm@master"
  args = "install"
  needs = ["new releases only"]
}

action "serverless deploy" {
  uses = "serverless/github-action@master"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  needs = ["npm install"]
  args = "deploy -v"
}