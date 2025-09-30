#!/bin/bash

# Step 1: Buat struktur direktori
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Step 2: Copy file aplikasi ke tempdir
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/ 2>/dev/null || true
cp -r static/* tempdir/static/ 2>/dev/null || true

# Step 3: Buat Dockerfile
cat <<EOF > tempdir/Dockerfile
FROM python:3.9-slim
RUN pip install --no-cache-dir --progress-bar=off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python3", "/home/myapp/sample_app.py"]
EOF

# Step 4: Build Docker image
cd tempdir
docker build -t sampleapp .

# Step 5: Hentikan container lama jika ada
docker rm -f samplerunning 2>/dev/null

# Step 6: Run container baru dengan tambahan ulimit
docker run -d -p 5050:5050 \
  --name samplerunning \
  --ulimit nofile=65535:65535 \
  --ulimit nproc=65535:65535 \
  sampleapp
  
# Step 7: Tampilkan container yang sedang berjalan
docker ps -a
