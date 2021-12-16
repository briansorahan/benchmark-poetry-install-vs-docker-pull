FROM prefecthq/prefect:0.14.21-python3.8
RUN pip install --upgrade pip poetry==1.1.3
WORKDIR /src
COPY pyproject.toml ./
RUN poetry install
