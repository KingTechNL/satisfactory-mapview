FROM nginx

# Install cron
RUN apt-get update && \
    apt-get install -y \
        cron

# Gather environment variables.
ARG TARGETARCH
ARG USER_DOMAIN
ARG SCHEME=https
ARG SAVE_NAME=latest.sav
ENV USER_DOMAIN=$USER_DOMAIN
ENV SCHEME=$SCHEME
ENV SAVE_NAME=$SAVE_NAME

# Copy NGinx config file.
COPY nginx.conf /nginx.conf.tmpl

# Copy scripts for cron-job
COPY cronjobs /etc/cron.d/cronjobs
COPY update-save.sh /update-save.sh.tmpl

# Copy entrypoint and give it permission to run.
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Setup cron job.
RUN chmod 0644 /etc/cron.d/cronjobs
RUN crontab /etc/cron.d/cronjobs
RUN touch /var/log/cron.log

## Apply environment variables to NGinx config and start cron using entrypoint script.
ENTRYPOINT ["/entrypoint.sh"]
# Have to reset CMD since it gets cleared when we set ENTRYPOINT.
CMD ["nginx", "-g", "daemon off;"]