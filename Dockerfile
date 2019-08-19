FROM python:3.7.4

RUN apt-key adv \
    --keyserver keys.gnupg.net \
    --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' && \
    echo 'deb https://cloud.r-project.org/bin/linux/debian buster-cran35/' >> \
    /etc/apt/sources.list && \
    echo 'deb-src https://cloud.r-project.org/bin/linux/debian buster-cran35/' >> \
    /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    libatlas3-base \
    r-recommended \
    r-base \
    r-base-dev \
    sudo

RUN useradd -ms /bin/bsash --create-home ubuntu && \
    echo "ubuntu ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    chown ubuntu --recursive /usr/local/

USER ubuntu

WORKDIR /home/ubuntu

## Standard Requirements.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt && rm requirements.txt

## Configs
COPY .bashrc .bashrc
COPY jupyter_notebook_config.py .jupyter/

CMD ["/bin/bash"]