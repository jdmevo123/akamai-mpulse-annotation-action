FROM akamai/shell

LABEL "com.github.actions.name"="Akamai Mpulse Annotations"
LABEL "com.github.actions.description"="Submit annotations to mPulse via the Akamai API's"
LABEL "com.github.actions.icon"="edit"
LABEL "com.github.actions.color"="orange"

LABEL version="0.1.0"
LABEL repository="https://github.com/jdmevo123/akamai-mpulse-annotation-action"
LABEL homepage=""
LABEL maintainer="Dale Lenard <dale_lenard@outlook.com>"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
