helm repo add pacman https://shuguet.github.io/pacman/
helm repo update
helm pull pacman/pacman --untar

cd pacman

#create a values-override.yaml file to customize your deployment with:
cat > values-override.yaml <<'EOF'
mongodb:
  image:
    registry: docker.io
    repository: bitnamilegacy/mongodb
EOF

#check default values for mongodb in the bitnami chart:
helm template pacman . -f values-override.yaml | grep -i "bitnami"

#You should see lines like:
# image: docker.io/bitnamilegacy/mongodb:xxxx

#Install pacman with the custom values:
helm upgrade --install pacman . \
  -n pacman \
  --create-namespace \
  --set service.type=LoadBalancer \
  -f values-override.yaml
