FROM python:3.8

COPY entrypoint.sh /entrypoint.sh
COPY download.py /main.py
COPY sherlock.c /sherlock.c
COPY parser.py /parser.py
COPY requirements.txt /requirements.txt

RUN chmod 755 entrypoint.sh
RUN pip install -r requirements.txt

ENTRYPOINT ["/entrypoint.sh"]
