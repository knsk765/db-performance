FROM ruby:3.1

# docker-compose.ymlからWORKDIRの値を受け取る
ARG WORKDIR

# docker-composeで受け取ったWORKDIRを展開して、RailsコンテナのHOMEという環境変数を設定する（ホームディレクトリを設定）
ENV HOME=/${WORKDIR}

# HOMEを展開して、WORKDIRを設定する（作業ディレクトリをホームディレクトリと統一する）
RUN mkdir ${HOME}
WORKDIR ${HOME}
COPY ./ ${HOME}

RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client
RUN npm install -g n
RUN n 16.16.0

# ホストにあるGemfileとGemfile.lockをコンテナにコピーする
COPY Gemfile* ./


RUN bundle install
COPY . ${HOME}

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
