# SAUCIE Docker Operator

* Build the image

```bash
VERSION=0.0.3
docker build -t agouy/saucie_docker_operator:$VERSION .
docker push agouy/saucie_docker_operator:$VERSION
git add -A && git commit -m "$VERSION" && git tag  $VERSION  && git push && git push --tags
```
