FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

COPY requirements/requirements-3.12.txt requirements.txt
RUN pip install -r requirements.txt

COPY media_downloader.py config_manager.py db.py ./
COPY utils ./utils

# The script keeps its config and history next to itself; point both at the volume.
RUN ln -s /data/config.yaml /app/config.yaml \
 && ln -s /data/downloads.sqlite3 /app/downloads.sqlite3

# The Telethon session file is written to the working directory.
WORKDIR /data
VOLUME /data

# The downloader saves its progress on KeyboardInterrupt, so `docker stop` sends SIGINT.
STOPSIGNAL SIGINT

CMD ["python", "/app/media_downloader.py"]
