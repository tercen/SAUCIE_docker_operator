# SAUCIE docker operator

### Decription

SAUCIE operator.

### Docker image

```
VERSION=0.0.11
docker build -t tercen/saucie:$VERSION .
docker push tercen/saucie:$VERSION
git add -A
git commit -m "$VERSION"
git tag  $VERSION
git push
git push --tags
```
