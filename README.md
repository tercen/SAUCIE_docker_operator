# SAUCIE docker operator

### Decription

SAUCIE operator.

### Docker image

```
VERSION=0.0.16
sed -i "s/0.0.15/$VERSION/g" operator.json
docker build -t tercen/saucie:$VERSION .
docker push tercen/saucie:$VERSION
git add -A && git commit -m "$VERSION" && git tag  $VERSION && git push && git push --tags
```
