FROM python:3.7-slim

RUN python -m venv /venv

ADD ./requirements.txt /app/requirements.txt
RUN /venv/bin/pip install -r /app/requirements.txt

ADD ./run.py /app/run.py

ENTRYPOINT [ "/venv/bin/python", "/app/run.py" ]