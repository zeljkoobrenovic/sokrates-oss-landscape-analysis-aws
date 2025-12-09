git add .
git commit -m "update"
git push

# docker build -t sokrates-landscape . --no-cache --platform linux/amd64
docker build -t sokrates-landscape . --platform linux/amd64
