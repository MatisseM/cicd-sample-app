#!/bin/bash
set -euo pipefail

DIR="tempdir"

if [ -d "$DIR" ]; then
    rm -rf "$DIR"
fi 

mkdir -p "$DIR"/templates
mkdir -p "$DIR"/static

cp sample_app.py "$DIR"/.
cp -r templates/* "$DIR"/templates/.
cp -r static/* "$DIR"/static/.

cat > "$DIR"/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd "$DIR" || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
