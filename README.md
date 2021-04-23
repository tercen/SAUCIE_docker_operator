# SAUCIE docker operator

### Decription

This operator leverages Python to perform a median computation. It can be used as a skeleton to develop Pathon operators in Tercen.

### install python dependencies

`py_install("pandas")`

### renv

```
VERSION=0.0.4
docker build -t agouy/saucie:$VERSION .
docker push agouy/saucie:$VERSION
git add -A && git commit -m "$VERSION" && git tag  $VERSION  && git push && git push --tags
```