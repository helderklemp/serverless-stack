workflow "Deploy with Serverless" {
  on = "push"
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