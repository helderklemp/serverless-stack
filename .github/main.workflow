workflow "Project Build" {
  on = "push"
  resolves = ["npm install"]
}
action "npm install" {
  uses = "actions/npm@master"
  args = "install"
}


