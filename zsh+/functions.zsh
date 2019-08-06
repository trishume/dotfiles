# pro cd function
pd() {
  projDir=$(pro search $1)
  cd ${projDir}
}
