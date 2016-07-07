FROM ruby:2.3.1

MAINTAINER Vicky Li <vickyli.tw@gmail.com>

ENV HOME /root

# Download slunch
RUN curl -kL https://github.com/jodeci/slunch/archive/master.tar.gz | tar -xvz && \
    cd slunch-master && \
    bundle install && \
    rake db:create && \
    rake db:migrate && \

# Generate environment file
RUN touch config/application.yml && \
    echo "defaults: &defaults \
      slack: \
        token: '${SLACK_TOKEN}' \
        channels: \
          - '${CHANNEL_TOKEN}'\n\n \
    development: \
      <<: *defaults \
      neat_setting: 800\n\n \
    production: \
      <<: *defaults" >> config/application.yml

# Import Lunch List
RUN rake import_data:lunch

# Set Crontab Time
RUN whenever -i

WORKDIR /root/slunch-master

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]


# --env "ARRAY=("foo" "bar" "foobar")"
