FROM debian:jessie
MAINTAINER dsheyp

RUN adduser --disabled-password --gecos '' maxwell

RUN buildDeps=' \
		curl \
	' \
	set -x \
	&& apt-get update \
	&& apt-get install -y $buildDeps \
	&& rm -r /var/lib/apt/lists/*

ENV RLM_PREFIX /opt
RUN mkdir -p "$RLM_PREFIX"
WORKDIR $RLM_PREFIX

ENV MAXWELL_URL http://download.nextlimit.com/linklok/download_temp.php?type=maxwell&file=maxwell_latest_linux64tgz
	
RUN curl -Lo "maxwell.tar.gz" "$MAXWELL_URL"
RUN tar -zxvf maxwell.tar.gz maxwell64-3.2/rlm_nl.tar.gz
RUN rm maxwell.tar.gz
RUN tar -zxvf maxwell64-3.2/rlm_nl.tar.gz
RUN rm -Rf maxwell64-3.2/
RUN apt-get purge -y --auto-remove $buildDeps
RUN chown -R maxwell:maxwell "$RLM_PREFIX"
USER maxwell

VOLUME /opt/rlm/licenses
VOLUME /opt/rlm/logs

CMD ["/opt/rlm/init.d_script/rlm", "start"]
