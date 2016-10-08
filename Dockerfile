FROM debian:jessie
MAINTAINER dsheyp

ENV RLM_PREFIX /opt
RUN mkdir -p "$RLM_PREFIX"
WORKDIR $RLM_PREFIX

ENV MAXWELL_URL http://download.nextlimit.com/linklok/download_temp.php?type=maxwell&file=maxwell_latest_linux64tgz

RUN buildDeps=' \
		curl \
	' \
	set -x \
	&& apt-get update \
	&& apt-get install -y $buildDeps \
	&& rm -r /var/lib/apt/lists/* \
	&& curl -SL "$MAXWELL_URL" -o maxwell.tar.gz \
  && tar -zxvf maxwell.tar.gz maxwell64-3.2/rlm_nl.tar.gz \
	&& rm maxwell.tar.gz* \
  && tar -zxv rlm_nl.tar.gz --strip-components=1 \
  && rm rlm_nl.tar.gz* \
	&& apt-get purge -y --auto-remove $buildDeps

VOLUME /opt/rlm/licenses
VOLUME /opt/rlm/logs


CMD ["/opt/rlm/init.d_script/rlm", "start"]
