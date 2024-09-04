FROM  python:3.10.14-alpine3.20

WORKDIR /app

COPY . /app/

RUN pip install -r requirements.txt  

# EXPOSE 8000

CMD ["gunicorn", "-w 4", "-b", "0.0.0.0:8000", "app:app"]

