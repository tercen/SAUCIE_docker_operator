# SAUCIE docker operator

### Decription

This operator leverages Python to perform a median computation. It can be used as a skeleton to develop Pathon operators in Tercen.

### install python dependencies

`py_install("pandas")`

### renv

```
VERSION=0.0.9
docker build -t tercen/saucie:$VERSION .
docker push tercen/saucie:$VERSION
git add -A && git commit -m "$VERSION" && git tag  $VERSION  && git push && git push --tags
```
