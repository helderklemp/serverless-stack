workflow "Project Build" {
  on = "push"
  resolves = ["serverless deploy"]
}
action "npm install" {
  uses = "actions/npm@master"
  args = "install"
}
action "npm lint" {
  uses = "actions/npm@master"
  args = "pretest"
  needs = ["npm install"]
}
action "npm test" {
  uses = "actions/npm@master"
  needs = ["npm lint"]
  args = "test"
}



workflow "Deploy with Serverless" {
  on = "release"
  resolves = ["serverless deploy"]
}
action "npm install" {
  uses = "actions/npm@master"
  args = "install"
}

action "new releases only" {
  needs = ["npm install"]
  uses = "actions/bin/filter@master"
  args = "tag v*"
}
action "serverless deploy" {
  uses = "serverless/github-action@master"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  needs = ["new releases only"]
  args = "deploy -v"
}